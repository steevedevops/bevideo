import 'package:better_player/better_player.dart';

import 'package:bevideo/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:bevideo/src/controllers/videos-controller.dart';

import 'info-detalhe.dart';

class VideoDetalhes extends StatefulWidget {
  double playerMinHeight;
  double height;
  VideoDetalhes({this.playerMinHeight, this.height});
  @override
  _VideoDetalhesState createState() => _VideoDetalhesState();
}

class _VideoDetalhesState extends State<VideoDetalhes> {
  ScrollController _scrollController;
  bool isPlaying = false;
  Map<String, dynamic> progressInfo;

  @override
  void initState() {
    super.initState();
    context.read(betterPlayerControllerProvider).state.addEventsListener(_handleEvent);
  }

  void _handleEvent(BetterPlayerEvent event){
    if(event.betterPlayerEventType == BetterPlayerEventType.play){
      setState(() => isPlaying = true);
    }else if(event.betterPlayerEventType == BetterPlayerEventType.pause){
      setState(() => isPlaying = false);
    } else if(event.betterPlayerEventType == BetterPlayerEventType.finished){
      setState(() => isPlaying = false);
    }else if(event.betterPlayerEventType == BetterPlayerEventType.progress){
      setState(() => progressInfo = event.parameters);
    }
    // if(event.betterPlayerEventType == BetterPlayerEventType.finished){
    // }
  }
  // if pause tem que aparecer o icone de play

  @override
  void dispose() {
    _scrollController?.dispose();
    context.read(betterPlayerControllerProvider).state.removeEventsListener(_handleEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read(miniPlayerControllerProvider).state.animateToHeight(state: PanelState.MAX),
      child: Container(
        child: Consumer(
          builder: (context, watch, _) {
            final betterPlayerController = watch(betterPlayerControllerProvider).state;
            final selectedVideo = watch(selectedVideoProvider).state;
            // final miniPlayerController = watch(miniPlayerControllerProvider).state;
            return Scaffold(
              body: Stack(
              children: [
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Opacity(
                    opacity: !(widget.height <= widget.playerMinHeight + 50) ? 1.0 : 0.0,
                    // opacity: 0.0, 
                    child: SafeArea(
                      child: Column(
                        children: [
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: BetterPlayer(controller: betterPlayerController),
                          ),
                          // Container(height: 50,
                          //   child: Text('${widget.playerMinHeight.toString()}')
                          // ),
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 100.0,
                              child: SingleChildScrollView(
                                child: VideoInfo()
                              ),
                            )
                          )
                        ],
                      ),
                    )
                  )
                ),
                Opacity(
                  opacity: (widget.height <= widget.playerMinHeight + 60) ? 1.0 : 0.0, 
                  child: Container(
                    height: 65,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.network(
                              '${Config.BASE_URL}${selectedVideo.capa}',
                              height: widget.playerMinHeight - 0.0,
                              width: 120.0,
                              fit: BoxFit.cover,
                            ),
                            // Container(
                            //   width: 120,
                            //   height: 120,
                            //   child: AspectRatio(
                            //     aspectRatio: 16 / 9,
                            //     child: BetterPlayer(controller: betterPlayerController),
                            //   ),
                            // ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      child: Text(
                                        selectedVideo.nome,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                        )
                                      )
                                    ),
                                    Container(
                                      child: Text(
                                        selectedVideo.canal.user.getFullName,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .copyWith(fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Flexible(
                                      child: RichText(
                                        text: TextSpan(
                                          // text: '32:12 ${progressInfo['progress']}',
                                          text: progressInfo != null && progressInfo['progress'] != null ? BetterPlayerUtils.formatDuration(progressInfo['progress']) : '--:--',
                                          style: TextStyle(
                                            fontSize: 11.0,
                                            color: Theme.of(context).primaryColor,
                                            decoration: TextDecoration.none,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: ' / ${progressInfo != null && progressInfo['duration'] != null ? BetterPlayerUtils.formatDuration(progressInfo['duration']): '--:--'}',
                                              style: const TextStyle(
                                                fontSize: 11.0,
                                                color: Colors.grey,
                                                decoration: TextDecoration.none,
                                              ),
                                            )
                                          ]
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            isPlaying ?
                            IconButton(
                              icon: const Icon(Icons.pause),
                              onPressed: () async {
                                context.read(betterPlayerControllerProvider).state.pause();
                              },
                            ) : IconButton(
                              icon: const Icon(Icons.play_arrow),
                              onPressed: () async {
                                context.read(betterPlayerControllerProvider).state.play();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => context.read(selectedVideoProvider).state = null
                            ),
                          ],
                        ),
                        // LinearProgressIndicator(
                        //   value: 1.0,
                        //   valueColor: AlwaysStoppedAnimation<Color>(
                        //     Colors.grey
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ))
    );
  }
  // Widget videoContent(){  
  //   return Container(
  //     child: Consumer(
  //       builder: (context, watch, _) {
  //         final betterPlayerController = watch(betterPlayerControllerProvider).state;
  //         return AspectRatio(
  //           aspectRatio: 16 / 9,
  //           child: BetterPlayer(controller: betterPlayerController),
  //         );
  //       }
  //     )
  //   );
  //   // return BeVideoPlayer();
  // }
}