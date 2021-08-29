
import 'package:bevideo/src/screens/video-player/video-controls.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:video_player/video_player.dart';

import 'data-manager.dart';

class VideoPlayerView extends StatefulWidget {
  final String urlVideo;
  VideoPlayerView({Key key, this.urlVideo}) : super(key: key);

  @override
  _VideoPlayerViewState createState() =>
      _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  FlickManager flickManager;
  DataManager dataManager;
  // List<String> urls = (mockData["items"] as List)
  //     .map<String>((item) => item["trailer_url"])
  //     .toList();

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(
        widget.urlVideo,
      ),
      onVideoEnd: () {
        dataManager.skipToNextVideo(Duration(seconds: 5));
        print('Proximo video ===========>');
      });
      dataManager = DataManager(flickManager: flickManager, urls: []);
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  skipToVideo(String url) {
    flickManager.handleChangeVideo(VideoPlayerController.network(url));
  }

  @override
  Widget build(BuildContext context) {
    return  VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 0 && this.mounted) {
          flickManager.flickControlManager?.autoPause();
        } else if (visibility.visibleFraction == 1) {
          flickManager.flickControlManager?.autoResume();
        }
      },
      child: Container(
        child: FlickVideoPlayer(
          flickManager: flickManager,
          flickVideoWithControls: FlickVideoWithControls(
            controls: CustomOrientationControls(dataManager: dataManager),
          ),
          flickVideoWithControlsFullscreen: FlickVideoWithControls(
            controls: CustomOrientationControls(dataManager: dataManager),
          ),
        ),
      ),
    );
  }
}