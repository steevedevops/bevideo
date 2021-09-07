import 'package:bestapp_package/bestapp_package.dart';
import 'package:bevideo/config.dart';
import 'package:bevideo/src/screens/video-player/video-player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:bevideo/src/controllers/videos-controller.dart';

import 'video_info.dart';

class VideoDetalhes extends StatefulWidget {
  @override
  _VideoDetalhesState createState() => _VideoDetalhesState();
}

class _VideoDetalhesState extends State<VideoDetalhes> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read(miniPlayerControllerProvider).state.animateToHeight(state: PanelState.MAX),
      child: Scaffold(
        body: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Consumer(
              builder: (context, watch, _) {
                final selectedVideo = watch(selectedVideoProvider).state;
                final futureVideodetaileinfo = watch(selectedVideoProviderFuture);
                return SafeArea(
                  child: Column(
                    children: [
                      futureVideodetaileinfo.when(
                        data: (videosDetailModel)=> Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              color: Colors.blue,
                              child: VideoPlayerView(urlVideo: '${Config.BASE_URL}${videosDetailModel.video}')
                            ),
                            IconButton(
                              iconSize: 30.0,
                              icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
                              onPressed: () => context
                                  .read(miniPlayerControllerProvider)
                                  .state
                                  .animateToHeight(state: PanelState.MIN),
                            ),
                          ],
                        ), 
                        loading: () => Container(
                          color: Colors.black,
                          height: 240,
                          child: beloadCircular()
                        ), 
                        error: (e, stack) => Text('$e')
                      ),
                      // Text('${selectedVideo.toJson()}'),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 100.0,
                          child: SingleChildScrollView(child: VideoInfo(video: selectedVideo)),
                        )
                      )
                    ],
                  ),
                );
              },
            )
        ),
      ),
    );
  }
}