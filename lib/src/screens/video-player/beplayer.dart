import 'package:better_player/better_player.dart';
import 'package:bevideo/src/controllers/videos-controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationPlayerPage extends StatefulWidget {
  final String urlVideo;
  final String thumbNail;
  NotificationPlayerPage({this.urlVideo, this.thumbNail});
  @override
  _NotificationPlayerPageState createState() => _NotificationPlayerPageState();
}

class _NotificationPlayerPageState extends State<NotificationPlayerPage> {
  // static BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    //   BetterPlayerConfiguration betterPlayerConfiguration =
    //       BetterPlayerConfiguration(
    //     aspectRatio: 16 / 9,
    //     fit: BoxFit.contain,
    //     handleLifecycle: true,
    //   );
    // _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    // _setupDataSource();
    super.initState();
  }
  // context.read(selectedVideoProvider).state = video;
  //       context.read(miniPlayerControllerProvider).state.animateToHeight(state: PanelState.MAX);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, _) {
        // final selectedVideo = watch(selectedVideoProvider).state;
        final betterPlayerController = watch(betterPlayerControllerProvider).state;
        return AspectRatio(
          aspectRatio: 16 / 9,
          child: BetterPlayer(controller: betterPlayerController),
        );
      }
    );
  }
}
