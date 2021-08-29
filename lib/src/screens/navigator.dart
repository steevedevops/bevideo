import 'package:bestapp_package/bestapp_package.dart';
import 'package:bevideo/config.dart';
import 'package:bevideo/src/screens/canais.dart';
import 'package:bevideo/src/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:miniplayer/miniplayer.dart';
import 'video-detalhes/video-detalhe.dart';
import 'package:bevideo/src/controllers/videos-controller.dart';

class NavigatorBar extends StatefulWidget {
  final int defineScreen;
  NavigatorBar({@required this.defineScreen});

  @override
  _NavigatorBarState createState() => _NavigatorBarState();
}

class _NavigatorBarState extends State<NavigatorBar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static const double _playerMinHeight = 60.0;
  int _selectedIndex = 0;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size =  MediaQuery.of(context).size;
    List<Widget> _screens = <Widget>[
      HomeScreen(),
      // IncricaoScreen(),
      HomeScreen(),
      HomeScreen(),
      CanaisScreen(),
      Container(
        width: 300,
        height: 100,
      )
        // child: VideoPlayerView(urlVideo: 'https://video.besoft.com.br/media/videos/Bras%C3%ADlia_foi_TOMADA_pelos_militares-uzo0q9uMet8.mp4',))
    ];

    return WillPopScope(
      onWillPop: ()async {
        return Future.value(false);
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize:Size.fromHeight(0.0), // here the desired height
          child: AppBar(
            elevation: 0.0
          )
        ),
        bottomNavigationBar: SizedBox(
          child: BottomNavigationBar(
            backgroundColor: Theme.of(context).backgroundColor,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedFontSize: 0,
            elevation: 2.0,
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(FeatherIcons.home),
                activeIcon: Icon(FeatherIcons.home, color: Theme.of(context).primaryColor),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: Icon(FeatherIcons.checkSquare),
                activeIcon: Icon(FeatherIcons.checkSquare, color: Theme.of(context).primaryColor),
                label: 'Incrições',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  padding: EdgeInsets.all(7),
                  child: Icon(FeatherIcons.uploadCloud, color: Colors.white)
                ),
                label: 'Upload video',
              ),
              BottomNavigationBarItem(
                icon: Icon(FeatherIcons.tv),
                activeIcon: Icon(FeatherIcons.tv, color: Theme.of(context).primaryColor),
                label: 'Canais',
              ),
              BottomNavigationBarItem(
                icon: Icon(FeatherIcons.user),
                activeIcon: Icon(FeatherIcons.user, color: Theme.of(context).primaryColor),
                label: 'Profile',
              ),            
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
        body: Consumer(
          builder: (context, watch, _) {
            final selectedVideo = watch(selectedVideoProvider).state;
            final miniPlayerController = watch(miniPlayerControllerProvider).state;

            return Stack(
              children: _screens
              .asMap()
              .map((i, screen) => MapEntry(i, Offstage(
                offstage: _selectedIndex != i,
                child: screen,
              ))).values.toList()..add(
                Offstage(
                  offstage: selectedVideo == null,
                  child: Miniplayer(
                    controller: miniPlayerController,
                    minHeight: _playerMinHeight,
                    maxHeight: double.parse(size.height.toStringAsFixed(1)),
                    builder: (height, percentage) {
                      if (selectedVideo == null){
                        return const SizedBox.shrink();
                      }
                      if(height <= _playerMinHeight + 50){
                        return Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Image.network(
                                    '${Config.BASE_URL}${selectedVideo.capa}',
                                    height: _playerMinHeight - 4.0,
                                    width: 120.0,
                                    fit: BoxFit.cover,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              selectedVideo.nome,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .copyWith(
                                                // color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              )
                                            )
                                          ),
                                          Flexible(
                                            child: Text(
                                              selectedVideo.canal.user.getFullName,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .copyWith(fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.play_arrow),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () => context.read(selectedVideoProvider).state = null
                                  ),
                                ],
                              ),
                              const LinearProgressIndicator(
                                value: 0.4,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.red,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return VideoDetalhes();
                    },
                  )
                )
              )
            );
          }
        )
      )
    );
  }

  void _onItemTapped(int index)async{
    setState(() {
      _selectedIndex = index;
    });
  }
}