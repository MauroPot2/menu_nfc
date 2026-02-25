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
    // Inizializza il controller. Assicurati di avere il video negli assets!
    _controller = VideoPlayerController.asset('assets/videos/lounge_bg.mp4')
      ..initialize().then((_) {
        _controller.setVolume(0.0); // Mettilo in muto per non disturbare
        _controller.play(); // Avvia in automatico
        setState(() {}); // Aggiorna la UI una volta caricato il primo frame
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
    _controller.dispose(); // Libera la memoria quando la card viene distrutta
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip
          .antiAlias, // Taglia il video facendogli seguire i bordi arrotondati
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity, // Altezza desiderata per la card
        child: Stack(
          fit: StackFit.expand,
          children: [
            // --- LIVELLO 1: Il Video di Sfondo ---
            if (_controller.value.isInitialized)
              FittedBox(
                fit: BoxFit
                    .cover, // Assicura che il video riempia tutta la card senza deformarsi
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              )
            else
              Container(
                color: Colors.black87,
              ), // Placeholder mentre il video carica
            // --- LIVELLO 2: Overlay scuro ---
            // Utile per creare contrasto e rendere il testo sempre leggibile
            Container(color: Colors.black.withValues(alpha: 0.4)),

            // --- LIVELLO 3: Contenuto della Card ---
          ],
        ),
      ),
    );
  }
}
