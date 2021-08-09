import 'package:bestapp_package/bestapp_package.dart';
import 'package:bevideo/assets/styles/style.dart';
import 'package:bevideo/config.dart';
import 'package:bevideo/src/controllers/canais-controller.dart';
import 'package:bevideo/src/controllers/videos-controller.dart';
import 'package:bevideo/src/models/filter-model.dart';
import 'package:bevideo/src/widgets/video-card-shimmer.dart';
import 'package:bevideo/src/widgets/video-card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key key }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController _sc = new ScrollController();

  bool loadingCanais = false;
  bool loadingvideos = false;

  List<TypeFilterModel> typeFilter = [
    TypeFilterModel(
      name: 'Com mais relevância',
      icon: FeatherIcons.trendingUp,
      isActive: false
    ),
    TypeFilterModel(
      name: 'Videos recentes',
      icon: FeatherIcons.calendar,
      isActive: false
    ),
    TypeFilterModel(
      name: 'Com mais Views',
      icon: FeatherIcons.barChart2,
      isActive: false
    )
  ];

  @override
  void initState() {
    super.initState();
    final CanaisController canaisController = Provider.of<CanaisController>(context, listen: false);
    final VideosController videosController = Provider.of<VideosController>(context, listen: false);
    setState(() {
      loadingCanais = true;
      loadingvideos = true;
    });
    canaisController.getCanaisMaisPopular(context: context).then((result){
      setState(() {
        loadingCanais = false;
      });
    });

    videosController.listarVideos(context: context, initial: true).then((result){
      setState(() {
        loadingvideos = false;
      });
    });

    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        videosController.listarVideos(context: context, initial: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _sc,
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            floating: true,
            snap: false,
            forceElevated: false,
            expandedHeight: 106,
            leading: Container(
              padding: EdgeInsets.only(left:17.0),
              child: SvgPicture.asset(
                'lib/assets/logos/logo.svg',
              ),
            ),
            title: Text('YouBe',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: AppStyle.fontFamily,
                color: Theme.of(context).accentColor
              ),
            ),
            flexibleSpace: Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          )
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left:1.0),
                              child: SvgPicture.asset(
                                'lib/assets/icons/heart.svg',
                                color: Theme.of(context).accentColor,
                                width: 24,
                              ),
                            ),
                            Text(
                              ' Vídeos curtidos',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).accentColor,
                                fontSize: 13
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left:1.0),
                              child: SvgPicture.asset(
                                'lib/assets/icons/hourglass_bottom.svg',
                                color: Theme.of(context).accentColor,
                                width: 24,
                              ),
                            ),
                            Text(
                              ' Historico',
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          )
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left:1.0),
                              child: SvgPicture.asset(
                                'lib/assets/icons/clock.svg',
                                color: Theme.of(context).accentColor,
                                width: 22,
                              ),
                            ),
                            Text(
                              ' Assistir depois',
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  FeatherIcons.search,
                  color: Theme.of(context).accentColor,
                ),
                tooltip: 'Add new entry',
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  FeatherIcons.bell,
                  color: Theme.of(context).accentColor,
                ),
                tooltip: 'Add new entry',
                onPressed: () {},
              ),
            ]
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 30,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, top: 10),
                child: Text('Canais mais populares',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Consumer<CanaisController>(
              builder: (context, _, child){
                return Container(
                  height: 75,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: BeShimmer(
                    linearGradient: ShimmerGradient,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: loadingCanais ? const NeverScrollableScrollPhysics() : null,
                      itemCount: loadingCanais ? 5 : _.canaisList.length,
                      itemBuilder: (context, index){
                        return BeShimmerLoading(
                          isLoading: loadingCanais,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Theme.of(context).accentColor,
                                image: _.canaisList[index].capa != null ?
                                DecorationImage(
                                  image: NetworkImage("${Config.BASE_URL}${_.canaisList[index].capa}"),
                                  fit: BoxFit.cover
                                ) : null
                              ),
                              child: Text(''),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            )
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 20,
              color: Theme.of(context).backgroundColor,
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, top: 5),
                child: Text('Mostreme somente os videos',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Consumer<CanaisController>(
              builder: (context, _, child){
                return Container(
                  height: 50,
                  color: Theme.of(context).backgroundColor,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: typeFilter.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              for (var i = 0; i < typeFilter.length; i++) {
                                if(typeFilter[index].name != typeFilter[i].name){
                                  typeFilter[i].isActive = false;
                                }
                              }
                              typeFilter[index].isActive = !typeFilter[index].isActive;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.only(left:10, right: 10, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              color: typeFilter[index].isActive ? Theme.of(context).primaryColor:   Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(typeFilter[index].icon, size: 16, 
                                  color: typeFilter[index].isActive ? 
                                  Theme.of(context).backgroundColor
                                  :Theme.of(context).accentColor
                                ),
                                Container(
                                  child: Text(' ${typeFilter[index].name}',
                                    style: TextStyle(
                                      color: typeFilter[index].isActive ? 
                                      Theme.of(context).backgroundColor:
                                      Theme.of(context).accentColor,
                                    ),
                                  )
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            )
          ),
          loadingvideos ?
          SliverToBoxAdapter(
            child: BeShimmer(
              linearGradient: ShimmerGradient,
              child: Container(
                height: 715,
                padding: const EdgeInsets.only(left:15.0, right: 15.0, top: 15.0),
                color: Theme.of(context).backgroundColor,
                child: Column(
                  children: [
                    BeShimmerLoading(
                      isLoading: loadingvideos,
                      child: VideoCardShimmer(),
                    ),
                    SizedBox(height: 20),
                    BeShimmerLoading(
                      isLoading: loadingvideos,
                      child: VideoCardShimmer(),
                    ),
                    SizedBox(height: 20),
                    BeShimmerLoading(
                      isLoading: loadingvideos,
                      child: VideoCardShimmer(),
                    ),
                    SizedBox(height: 20),
                  ],
                )
              ),
            ) 
          ) : Consumer<VideosController>(
            builder: (context, _, child) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(left:15.0, right: 15.0, top: 15.0),
                      child: VideoCard(
                        video: _.videosList[index],
                      ),
                    );
                  },
                  childCount: _.videosList.length
                )
              );
            }
          )
        ],
      ),
    );
  }
}