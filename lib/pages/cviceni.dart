import 'package:flutter/material.dart';
import 'package:a_dysfagie/models/cvik.dart';
import 'package:video_player/video_player.dart';
import 'package:a_dysfagie/data/stats_service.dart';
import 'dart:async';

class Cviceni extends StatefulWidget {
  final List<Cvik> vybraneCviky;
  const Cviceni({super.key,required this.vybraneCviky});

  @override
  State<Cviceni> createState() => _CviceniState();
}

class _CviceniState extends State<Cviceni> {
  int currentIndex = 0;
  VideoPlayerController? _videoController;
  final Stopwatch _stopwatch = Stopwatch();

  bool _showControls = true;
  Timer? _hideTimer;

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

    _videoController!.addListener(() {
      if (_videoController!.value.isPlaying && !_stopwatch.isRunning) {
        _stopwatch.start();
      } else if (!_videoController!.value.isPlaying && _stopwatch.isRunning) {
        _stopwatch.stop();
      }
    });
    if (mounted) {
      setState(() {});
      _spustitCasovacNaSchovani();
    };
  }

  void _spustitCasovacNaSchovani() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
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

  Future<void> _ulozWatchtimeAKonci() async {
    if (_stopwatch.isRunning) _stopwatch.stop();
    final ubehlyCasVSekundach = _stopwatch.elapsed.inSeconds;
    await StatsService.pridejSekundy(ubehlyCasVSekundach);
    _stopwatch.reset();
  }
  void _posunNaDalsi() async {
    await _ulozWatchtimeAKonci();

   if (currentIndex < widget.vybraneCviky.length - 1) {
     setState(() {
       currentIndex++;
     });
     await _inicializujVideo();
   }
   else {
     if (mounted) {
       Navigator.pop(context);
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('Vse dokonceno a ulozeno do statistik!')),
       );
     }
   }
  }

  @override
  void dispose() {
    _ulozWatchtimeAKonci();
    _videoController?.dispose();
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final aktualnicvik = widget.vybraneCviky[currentIndex];

    return Scaffold(
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        backgroundColor: Colors.teal[700],
        title: Text(
          'Cvik ${currentIndex+1} z ${widget.vybraneCviky.length}',
          style: TextStyle(color: Colors.white, fontSize: 28),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              aktualnicvik.nazev,
              style: TextStyle(
                  fontSize: 28,
                  color: Colors.teal[900]
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15,),

            Container(
              height: 250,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: _videoController != null && _videoController!.value.isInitialized
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GestureDetector(
                  onTap: _onVideoTap,
                  behavior: HitTestBehavior.opaque,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: VideoPlayer(_videoController!),
                      ),
                      AnimatedOpacity(
                        opacity: _showControls ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: IgnorePointer(
                          ignoring: !_showControls,
                          child: Container(
                            color: Colors.black26,
                            child: Center(
                              child: IconButton(
                                iconSize: 64,
                                color: Colors.white,
                                icon: Icon(
                                  _videoController!.value.isPlaying
                                      ? Icons.pause_circle_outline
                                      : Icons.play_circle_outline,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _videoController!.value.isPlaying
                                        ? _videoController!.pause()
                                        : _videoController!.play();
                                  });
                                  _spustitCasovacNaSchovani();
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  : const Center(
                child: CircularProgressIndicator(color: Colors.white),
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
    );
  }
}