import 'package:bestapp_package/bestapp_package.dart';
import 'package:bevideo/config.dart';
import 'package:bevideo/src/controllers/videos-controller.dart';
import 'package:bevideo/src/models/canais-model.dart';
import 'package:bevideo/src/models/videos-model.dart';
import 'package:bevideo/src/widgets/video-card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

class VideoInfo extends ConsumerWidget {
  final VideosModel video;

  const VideoInfo({
    Key key,
    @required this.video,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, watch) {
    final futureVideodetaileinfo = watch(videoDetaileProvider);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: futureVideodetaileinfo.when(
        data: (videosDetailModel) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    videosDetailModel.video.nome,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15.0),
                  ),
                ),
                InkWell(
                  onTap: (){},
                  child: Icon(FeatherIcons.alertCircle, color: Colors.grey[600])
                )
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(FeatherIcons.eye, color: Colors.grey, size: 18),
                    Text(
                      ' ${NumberFormat.compact(locale: 'pt-br').format(videosDetailModel.video.visualizacao)} views • ',
                      style: Theme.of(context).textTheme.caption.copyWith(fontSize: 13.0),
                    ),
                    Container(
                      child: Padding(
                        padding: EdgeInsets.all(0.0),
                          child: new LinearPercentIndicator(
                            width: 140.0,
                            lineHeight: 8.0,
                            leading: Text(
                              '${videosDetailModel.video.relevancia}%',
                              style: Theme.of(context).textTheme.caption.copyWith(fontSize: 13.0),
                            ),
                            percent: videosDetailModel.video.relevancia/100,
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            backgroundColor: Colors.grey[300],
                            progressColor: Colors.green[500],
                          ),
                        ),
                    ),
                  ],
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '${timeago.format(DateTime.parse(videosDetailModel.video.datacadastro))}',
                    maxLines: 1,
                    textAlign: TextAlign.end,
                    style:
                        Theme.of(context).textTheme.caption.copyWith(fontSize: 13.0),
                  ),
                ),
              ],
            ),
            const Divider(),
            _ActionsRow(video: videosDetailModel.video),
            const Divider(),
            _AuthorInfo(canal: videosDetailModel.video.canal),
            const Divider(),
            _ComentarioInfo(),
            const Divider(),
            _VideosRelacionados(videos: videosDetailModel.videosSimilares),
            const Divider(),
            _OutrosVideos(videos: videosDetailModel.videosOutros),
          ],
        ), 
        loading: ()=> beloadCircular(), 
        error: (e, stack) => Text('$e')
      ),
    );
  }
}

class _ActionsRow extends StatelessWidget {
  final VideosModel video;

  const _ActionsRow({
    Key key,
    @required this.video,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildAction(context, FeatherIcons.thumbsUp, video.curtidas.toString()),
          _buildAction(context, FeatherIcons.thumbsDown, video.descurtidas.toString()),
          _buildAction(context, Icons.schedule_outlined, 'Ver depois'),
          _buildAction(context, Icons.pending_actions_outlined, 'Timer'),
          _buildAction(context, Icons.reply_outlined, 'Compartilhar')
        ],
      ),
    );
  }

  Widget _buildAction(BuildContext context, IconData icon, String label) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 82,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.grey[800]),
            const SizedBox(height: 6.0),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthorInfo extends StatelessWidget {
  final CanaisModel canal;

  const _AuthorInfo({
    Key key,
    @required this.canal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print('Navigate to profile'),
      child: Row(
        children: [
          CircleAvatar(
            foregroundImage: NetworkImage('${Config.BASE_URL}${canal.capa}'),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    canal.user.getFullName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: 15.0),
                  ),
                ),
                Flexible(
                  child: Text(
                    '${canal.inscritos} subscribers',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(fontSize: 14.0),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
            ),
            onPressed: () {},
            child: Text(
              'SUBSCRIBE',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

class _ComentarioInfo extends StatelessWidget {
  const _ComentarioInfo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print('Navigate to profile'),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                Icon(FeatherIcons.messageCircle, color: Colors.grey[600]),
                const SizedBox(width: 8.0),
                Container(
                  child: Text(
                    'Comentários • ',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(
                          fontSize: 14.0,
                          color: Colors.grey[500]
                        )
                  ),
                ),
                Container(
                  child: Text(
                    '10',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: 15.0),
                  ),
                ),
              ],
            ),
          ),
          Icon(FeatherIcons.chevronDown, color: Colors.grey[600])
        ],
      ),
    );
  }
}

class _VideosRelacionados extends StatelessWidget {
  final List<VideosModel> videos;
  const _VideosRelacionados({
    Key key,
    @required this.videos
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print('Navigate to profile'),
      child: Container(
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Container(
              child: Text(
                'Vídeos similares',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(
                      fontSize: 14.0,
                      color: Colors.grey[600]
                    )
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              flex: 2,
              child: Container(
                child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: videos.length,
                  controller: PageController(viewportFraction: 0.9),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(left:5.0, right: 5),
                      child: VideoCard(
                        video: videos[index]
                      )
                    );
                  }
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class _OutrosVideos extends StatelessWidget {
  final List<VideosModel> videos;
  const _OutrosVideos({
    Key key,
    @required this.videos
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print('Navigate to profile'),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
            Container(
              child: Text(
                'Outros vídeos',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(
                      fontSize: 14.0,
                      color: Colors.grey[600]
                    )
              ),
            ),
            SizedBox(height: 10),
            Container(
              child: ListView.separated(
                itemCount: videos.length,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 15.0,
                  );
                },
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(left:5.0, right: 5),
                    child: VideoCard(
                      video: videos[index]
                    )
                  );
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}