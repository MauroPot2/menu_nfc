import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoBackgroundCard extends StatefulWidget {
  const VideoBackgroundCard({Key? key}) : super(key: key);

  @override
  State<VideoBackgroundCard> createState() => _VideoBackgroundCardState();
}

class _VideoBackgroundCardState extends State<VideoBackgroundCard> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    final videoUrl = Uri.parse(
      'https://res.cloudinary.com/dr0q2frm4/video/upload/v1772032008/lounge_bg.mp4',
    );
    
    _controller = VideoPlayerController.networkUrl(videoUrl)
      ..initialize().then((_) {
        _controller.setVolume(0.0);
        _controller.play();
        setState(() {}); 
      }).catchError((errore){
        debugPrint('Errore: $errore');
      });


    _controller.addListener(() {
      final position = _controller.value.position;
      final duration = _controller.value.duration;

      if (duration != Duration.zero &&
          position >= duration - Duration(milliseconds: 500)) {
        _controller.seekTo(Duration.zero);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Sfondo nero di sicurezza
          Container(color: Colors.black),

          // --- LIVELLO 1: Il Video di Sfondo ---
          if (_controller.value.isInitialized)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            )
          else
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ), 
          Container(color: Colors.black.withValues(alpha: 0.4)),
        ],
      ),
    );
  }
}
