import 'package:better_player/better_player.dart';
import 'package:bevideo/src/controllers/videos-controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BeVideoPlayer extends StatefulWidget {
  const BeVideoPlayer({ Key key }) : super(key: key);

  @override
  _BeVideoPlayerState createState() => _BeVideoPlayerState();
}

class _BeVideoPlayerState extends State<BeVideoPlayer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer(
        builder: (context, watch, _) {
          final betterPlayerController = watch(betterPlayerControllerProvider).state;
          return BetterPlayerMultipleGestureDetector(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(controller: betterPlayerController),
            )
          );
        }
      )
    );
  }
}
