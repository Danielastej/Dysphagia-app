import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:a_dysfagie/models/cvik.dart';
import 'package:a_dysfagie/models/exercise_telemetry.dart';
import 'package:a_dysfagie/models/daily_session.dart';
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

  late final DateTime _sessionStartTime;
  final List<ExerciseTelemetry> _dokonceneCviky = [];

  // --- TELEMETRICKÉ PROMĚNNÉ ---
  final Stopwatch _watchStopwatch = Stopwatch();   // Měří čas, kdy video reálně hraje
  final Stopwatch _screenStopwatch = Stopwatch();  // Měří celkový pobyt na obrazovce
  int _seekForwardCount = 0;
  int _seekBackwardCount = 0;
  int _replayCount = 0;
  int _seekForwardTotalSec = 0;   // Celkem přeskočeno dopředu v sekundách
  int _seekBackwardTotalSec = 0;  // Celkem vráceno zpět v sekundách
  Duration _dragStartPosition = Duration.zero;     // Pro detekci směru posunu
  final List<SeekEvent> _seekEvents = [];
  // -----------------------------

  bool _showControls = true;
  Timer? _hideTimer;
  bool _isDragging = false;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _sessionStartTime = DateTime.now();
    _screenStopwatch.start();
    _inicializujVideo();
  }

  Future<void> _inicializujVideo() async {
    final cvik = widget.vybraneCviky[currentIndex];

    await _videoController?.dispose();

    // Reset telemetrie pro nový cvik
    _watchStopwatch.reset();
    _screenStopwatch.reset();
    _screenStopwatch.start();
    _seekForwardCount = 0;
    _seekBackwardCount = 0;
    _seekForwardTotalSec = 0;
    _seekBackwardTotalSec = 0;
    _replayCount = 0;
    _seekForwardCount = 0;
    _seekBackwardCount = 0;
    _replayCount = 0;
    _seekEvents.clear(); // <-- Vynuluje seznam skoků pro nový cvik


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

    // Sledování watchtime: stopky běží pouze při aktivním přehrávání
    if (_videoController!.value.isPlaying && !_watchStopwatch.isRunning) {
      _watchStopwatch.start();
    } else if (!_videoController!.value.isPlaying && _watchStopwatch.isRunning) {
      _watchStopwatch.stop();
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
      _replayCount++;
      await _videoController!.seekTo(Duration.zero);
      await _videoController!.play();
    } else if (_videoController!.value.isPlaying) {
      await _videoController!.pause();
    } else {
      await _videoController!.play();
    }
    _spustitCasovacNaSchovani();
  }

  Future<void> _toggleFullScreen() async {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });

    if (_isFullScreen) {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
    _spustitCasovacNaSchovani();
  }

  /// Sestaví telemetrický objekt pro aktuálně otevřený cvik
  ExerciseTelemetry _vytvorTelemetriiAktualnihoCviku() {
    if (_watchStopwatch.isRunning) _watchStopwatch.stop();
    if (_screenStopwatch.isRunning) _screenStopwatch.stop();

    final targetSec = _videoController?.value.duration.inSeconds ?? 0;
    final aktualniCvik = widget.vybraneCviky[currentIndex];

    final telemetry = ExerciseTelemetry(
      exerciseName: aktualniCvik.nazev,
      targetDurationSec: targetSec > 0 ? targetSec : 30, // Fallback hodnota pro testování
      actualWatchtimeSec: _watchStopwatch.elapsed.inSeconds,
      screenTimeSec: _screenStopwatch.elapsed.inSeconds,
      seekForwardCount: _seekForwardCount,
      seekBackwardCount: _seekBackwardCount,
      replayCount: _replayCount,
        seekForwardTotalSec: _seekForwardTotalSec,   // <-- CHYBĚJÍCÍ ARGUMENT
        seekBackwardTotalSec: _seekBackwardTotalSec, // <-- CHYBĚJÍCÍ ARGUMENT
      seekEvents: List.from(_seekEvents)
    );

    debugPrint("=== TELEMETRIE PRO CVIK: ${telemetry.exerciseName} ===");
    debugPrint("Reálný Watchtime: ${telemetry.actualWatchtimeSec} s / Cíl: ${telemetry.targetDurationSec} s");
    debugPrint("Čas na obrazovce: ${telemetry.screenTimeSec} s (Ošetřený: ${telemetry.sanitizedScreenTimeSec} s)");
    debugPrint("Přetočení: +${telemetry.seekForwardCount}x / -${telemetry.seekBackwardCount}x | Replay: ${telemetry.replayCount}x");
    debugPrint("Adherence poměr: ${(telemetry.adherenceRatio * 100).toStringAsFixed(1)} %");
    debugPrint("Klinický status: ${telemetry.status.name}");
    debugPrint("=====================================================");

    return telemetry;
  }

  Future<void> _posunNaDalsi() async {
    if (_isFullScreen) {
      await _toggleFullScreen();
    }

    // Zaznamenání dat z právě ukončeného cviku
    final telemetry = _vytvorTelemetriiAktualnihoCviku();
    _dokonceneCviky.add(telemetry);

    if (currentIndex < widget.vybraneCviky.length - 1) {
      setState(() {
        currentIndex++;
      });
      await _inicializujVideo();
    } else {
      // Poslední cvik byl dokončen -> vytvoření a uložení celého sezení
      final session = DailySession.fromExercises(
        patientId: 'pacient_001',
        startTime: _sessionStartTime,
        endTime: DateTime.now(),
        totalPrescribed: widget.vybraneCviky.length,
        exercises: _dokonceneCviky,

      );

      await StatsService.ulozRelaci(session);

      debugPrint("=== SOUHRNNÁ RELACE ULOŽENA ===");
      debugPrint(session.toJson().toString());
      debugPrint("===============================");

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cvičení dokončeno! Splněno ${session.overallAdherencePercent.toStringAsFixed(1)}%. Gratuluji!'),
            backgroundColor: Colors.teal[800],
          ),
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
    _videoController?.removeListener(_videoListener);
    _videoController?.dispose();
    _hideTimer?.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  Widget _buildVideoPlayer(bool isInitialized, Duration position, Duration duration, bool isFinished) {
    if (!isInitialized) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
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
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
                              activeTrackColor: Colors.redAccent,
                              inactiveTrackColor: Colors.white30,
                              thumbColor: Colors.redAccent,
                              overlayColor: Colors.redAccent.withAlpha(50),
                            ),
                            child: Slider(
                              value: position.inMilliseconds.clamp(0, duration.inMilliseconds).toDouble(),
                              min: 0.0,
                              max: duration.inMilliseconds.toDouble() > 0 ? duration.inMilliseconds.toDouble() : 1.0,
                              onChangeStart: (value) {
                                _isDragging = true;
                                _dragStartPosition = Duration(milliseconds: value.toInt());
                                _hideTimer?.cancel();
                              },
                              onChanged: (value) {
                                setState(() {
                                  _videoController?.seekTo(Duration(milliseconds: value.toInt()));
                                });
                              },

                              onChangeEnd: (value) {
                                _isDragging = false;
                                final startSec = _dragStartPosition.inSeconds;
                                final endSec = Duration(milliseconds: value.toInt()).inSeconds;
                                final diff = endSec - startSec;

                                if (diff.abs() > 2) {
                                  if (diff > 0) {
                                    _seekForwardCount++;
                                    _seekForwardTotalSec += diff; // <-- PŘIČTE SEKUNDY DOPŘEDU
                                  } else {
                                    _seekBackwardCount++;
                                    _seekBackwardTotalSec += diff.abs(); // <-- PŘIČTE SEKUNDY DOZADU
                                  }

                                  _seekEvents.add(
                                    SeekEvent(
                                      fromSec: startSec,
                                      toSec: endSec,
                                      diffSec: diff,
                                    ),
                                  );
                                }

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

    return PopScope(
      canPop: !_isFullScreen,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_isFullScreen) _toggleFullScreen();
      },
      child: Scaffold(
        backgroundColor: _isFullScreen ? Colors.black : Colors.teal[100],
        appBar: _isFullScreen
            ? null
            : AppBar(
          backgroundColor: Colors.teal[700],
          title: Text(
            'Cvik ${currentIndex + 1} z ${widget.vybraneCviky.length}',
            style: const TextStyle(color: Colors.white, fontSize: 28),
          ),
          centerTitle: true,
        ),
        body: _isFullScreen
            ? Container(
          color: Colors.black,
          width: double.infinity,
          height: double.infinity,
          child: _buildVideoPlayer(isInitialized, position, duration, isFinished),
        )
            : Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                aktualnicvik.nazev,
                style: TextStyle(fontSize: 28, color: Colors.teal[900]),
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
                  currentIndex == widget.vybraneCviky.length - 1 ? 'Dokončit cvičení' : 'Další cvik',
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