import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:a_dysfagie/models/cvik.dart';
import 'package:a_dysfagie/data/stats_service.dart';

class Cviceni extends StatefulWidget {
  final List<Cvik> vybraneCviky;
  const Cviceni({super.key, required this.vybraneCviky});

  @override
  State<Cviceni> createState() => _CviceniState();
}

class _CviceniState extends State<Cviceni> {
  int currentIndex = 0;
  VideoPlayerController? _videoController;
  final Stopwatch _stopwatch = Stopwatch();

  bool _showControls = true;
  Timer? _hideTimer;
  bool _isDragging = false;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _inicializujVideo();
  }

  Future<void> _inicializujVideo() async {
    final cvik = widget.vybraneCviky[currentIndex];

    await _videoController?.dispose();
    _stopwatch.reset();

    _showControls = true;
    _hideTimer?.cancel();

    _videoController = VideoPlayerController.asset(cvik.videoPath);
    await _videoController!.initialize();

    _videoController!.addListener(_videoListener);

    if (mounted) {
      setState(() {});
      _spustitCasovacNaSchovani();
    }
  }

  void _videoListener() {
    if (!mounted || _videoController == null) return;

    if (_videoController!.value.isPlaying && !_stopwatch.isRunning) {
      _stopwatch.start();
    } else if (!_videoController!.value.isPlaying && _stopwatch.isRunning) {
      _stopwatch.stop();
    }

    final isFinished = _videoController!.value.position >= _videoController!.value.duration &&
        _videoController!.value.duration > Duration.zero;

    if (isFinished && !_showControls) {
      _hideTimer?.cancel();
      setState(() {
        _showControls = true;
      });
    } else {
      setState(() {});
    }
  }

  void _spustitCasovacNaSchovani() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(milliseconds: 2500), () {
      if (mounted && !_isDragging) {
        final isFinished = _videoController != null &&
            _videoController!.value.position >= _videoController!.value.duration;
        if (!isFinished && (_videoController?.value.isPlaying ?? false)) {
          setState(() {
            _showControls = false;
          });
        }
      }
    });
  }

  void _onVideoTap() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _spustitCasovacNaSchovani();
    }
  }

  Future<void> _togglePlayPause() async {
    if (_videoController == null) return;

    if (_videoController!.value.position >= _videoController!.value.duration) {
      await _videoController!.seekTo(Duration.zero);
      await _videoController!.play();
    } else if (_videoController!.value.isPlaying) {
      await _videoController!.pause();
    } else {
      await _videoController!.play();
    }
    _spustitCasovacNaSchovani();
  }

  // Přepínání Fullscreenu
  Future<void> _toggleFullScreen() async {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });

    if (_isFullScreen) {
      // Skryje stavovou a navigační lištu systému a otočí na šířku
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      // Vrátí systémové lišty a otočí zpět na výšku
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
    _spustitCasovacNaSchovani();
  }

  Future<void> _ulozWatchtimeAKonci() async {
    if (_stopwatch.isRunning) _stopwatch.stop();
    final ubehlyCasVSekundach = _stopwatch.elapsed.inSeconds;
    await StatsService.pridejSekundy(ubehlyCasVSekundach);
    _stopwatch.reset();
  }

  Future<void> _posunNaDalsi() async {
    // Pokud jsme ve fullscreenu, vrátíme zobrazení na výšku
    if (_isFullScreen) {
      await _toggleFullScreen();
    }

    await _ulozWatchtimeAKonci();

    if (currentIndex < widget.vybraneCviky.length - 1) {
      setState(() {
        currentIndex++;
      });
      await _inicializujVideo();
    } else {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vše dokončeno a uloženo do statistik!')),
        );
      }
    }
  }

  String _formatujDobu(Duration duration) {
    String dvaCifry(int n) => n.toString().padLeft(2, '0');
    final minuty = dvaCifry(duration.inMinutes.remainder(60));
    final sekundy = dvaCifry(duration.inSeconds.remainder(60));
    return '$minuty:$sekundy';
  }

  @override
  void dispose() {
    _ulozWatchtimeAKonci();
    _videoController?.removeListener(_videoListener);
    _videoController?.dispose();
    _hideTimer?.cancel();
    // Bezpečné obnovení orientace a lišt při opuštění obrazovky
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  // Samostatný widget přehrávače
  Widget _buildVideoPlayer(bool isInitialized, Duration position, Duration duration, bool isFinished) {
    if (!isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return GestureDetector(
      onTap: _onVideoTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            ),
          ),
          AnimatedOpacity(
            opacity: _showControls ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: IgnorePointer(
              ignoring: !_showControls,
              child: Container(
                color: Colors.black38,
                child: Stack(
                  children: [
                    // Středové tlačítko Play / Pause / Replay
                    Center(
                      child: IconButton(
                        iconSize: 64,
                        color: Colors.white,
                        icon: Icon(
                          isFinished
                              ? Icons.replay_rounded
                              : (_videoController!.value.isPlaying
                              ? Icons.pause_circle_outline
                              : Icons.play_circle_outline),
                        ),
                        onPressed: _togglePlayPause,
                      ),
                    ),

                    // Spodní YouTube lišta
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${_formatujDobu(position)} / ${_formatujDobu(duration)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Tlačítko Fullscreen
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: Icon(
                                    _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                  onPressed: _toggleFullScreen,
                                ),
                              ],
                            ),
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 3.0,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6.0,
                              ),
                              overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 14.0,
                              ),
                              activeTrackColor: Colors.redAccent,
                              inactiveTrackColor: Colors.white30,
                              thumbColor: Colors.redAccent,
                              overlayColor: Colors.redAccent.withAlpha(50),
                            ),
                            child: Slider(
                              value: position.inMilliseconds
                                  .clamp(0, duration.inMilliseconds)
                                  .toDouble(),
                              min: 0.0,
                              max: duration.inMilliseconds.toDouble() > 0
                                  ? duration.inMilliseconds.toDouble()
                                  : 1.0,
                              onChangeStart: (value) {
                                _isDragging = true;
                                _hideTimer?.cancel();
                              },
                              onChanged: (value) {
                                setState(() {
                                  _videoController?.seekTo(
                                    Duration(milliseconds: value.toInt()),
                                  );
                                });
                              },
                              onChangeEnd: (value) {
                                _isDragging = false;
                                _spustitCasovacNaSchovani();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final aktualnicvik = widget.vybraneCviky[currentIndex];
    final isInitialized = _videoController != null && _videoController!.value.isInitialized;
    final position = isInitialized ? _videoController!.value.position : Duration.zero;
    final duration = isInitialized ? _videoController!.value.duration : Duration.zero;
    final isFinished = isInitialized && position >= duration && duration > Duration.zero;

    // PopScope ošetřuje systémové gesto/tlačítko zpět, když je uživatel ve fullscreenu
    return PopScope(
      canPop: !_isFullScreen,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_isFullScreen) {
          _toggleFullScreen();
        }
      },
      child: Scaffold(
        backgroundColor: _isFullScreen ? Colors.black : Colors.teal[100],
        appBar: _isFullScreen
            ? null // Ve fullscreenu schováme horní AppBar
            : AppBar(
          backgroundColor: Colors.teal[700],
          title: Text(
            'Cvik ${currentIndex + 1} z ${widget.vybraneCviky.length}',
            style: const TextStyle(color: Colors.white, fontSize: 28),
          ),
          centerTitle: true,
        ),
        body: _isFullScreen
        // 1. REŽIM CELÉ OBRAZOVKY (Landscape na celý displej)
            ? Container(
          color: Colors.black,
          width: double.infinity,
          height: double.infinity,
          child: _buildVideoPlayer(isInitialized, position, duration, isFinished),
        )
        // 2. STANDARDNÍ REŽIM NA VÝŠKU
            : Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                aktualnicvik.nazev,
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.teal[900],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),

              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildVideoPlayer(isInitialized, position, duration, isFinished),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _posunNaDalsi,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[700],
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  currentIndex == widget.vybraneCviky.length - 1
                      ? 'Dokončit cvičení'
                      : 'Další cvik',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}