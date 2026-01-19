import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoNow extends StatefulWidget {
  const VideoNow({super.key});

  @override
  State<VideoNow> createState() => _VideoNowState();
}

class _VideoNowState extends State<VideoNow> {

  final videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'));


  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }


  late final chewieController = ChewieController(
    videoPlayerController: videoPlayerController,
    autoPlay: true,
    looping: true,
  );



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: videoPlayerController.initialize(),
      builder: (_, snapshot){
        if(snapshot.connectionState==ConnectionState.done || snapshot.connectionState ==ConnectionState.active){
          return Chewie(
            controller: chewieController,
          );
        }else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
