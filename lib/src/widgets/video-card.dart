import 'package:bestapp_package/bestapp_package.dart';
import 'package:bevideo/assets/styles/style.dart';
import 'package:bevideo/config.dart';
import 'package:bevideo/src/models/videos-model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:bevideo/src/controllers/videos-controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class VideoCard extends StatelessWidget {

  final VideosModel video;
  const VideoCard({ Key key, this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read(selectedVideoProvider).state = video;
        // VideoPlayerController.setupDataSource(context:  context, thumbNail: video.capa, urlVideo: '${Config.BASE_URL}${video.video}');
        context.read(miniPlayerControllerProvider).state.animateToHeight(state: PanelState.MAX);
      },
      child: Container(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 190,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey[300],
              ),
              child: BeImageCached(
                url: "${Config.BASE_URL}${video.capa}",
                placeholder: beloadCircular(color: Theme.of(context).accentColor),
              )
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  child: BeAvatar(
                    spacer: 2,
                    shape: BeAvatarShape.circle,
                    backgroundImage: video.canal.user.perfil.avatar != null ?
                    NetworkImage('${Config.BASE_URL}${video.canal.user.perfil.avatar}') : null,
                    child: Text('${video.canal.user.firstName[0]}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30
                      ),
                    ),
                  )
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text('${video.nome}',
                          maxLines: 2,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: AppStyle.fontFamily,
                            color: Theme.of(context).accentColor,
                            fontSize: 15,
                          )
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            child: Text('${video.canal.nome}',
                              maxLines: 2,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: AppStyle.fontFamily,
                                color: Colors.grey,
                                fontSize: 12,
                              )
                            ),
                          ),
                          Expanded(
                            child: Text(' - ${NumberFormat.compact(locale: 'pt-br').format(video.visualizacao)} views - ${timeago.format(DateTime.parse(video.datacadastro))} ${DateFormat.Hm().format(DateTime.parse(video.datacadastro))}',
                            // ${DateFormat.yMEd().format(DateTime.parse(video.datacadastro))}
                              maxLines: 1,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: AppStyle.fontFamily,
                                color: Colors.grey,
                                fontSize: 12,
                              )
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}