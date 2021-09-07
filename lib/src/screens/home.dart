import 'package:bestapp_package/bestapp_package.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bevideo/config.dart';
import 'package:bevideo/src/controllers/canais-controller.dart';
import 'package:bevideo/src/controllers/videos-controller.dart';
import 'package:bevideo/src/models/filter-model.dart';
import 'package:bevideo/src/widgets/sliver-appbar.dart';
import 'package:bevideo/src/widgets/video-card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key key }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
    setState(() {
      loadingCanais = true;
    });
    context.read(canaisControllerNotifier).getCanaisMaisPopular(context: context).then((value){
      setState(() {
        loadingCanais = false;
      });
    });

    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
    //     videosController.listarVideos(context: context, initial: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Consumer(
        builder: (context, watch, _) {
          final canaisController = watch(canaisControllerNotifier);
          return RefreshIndicator(
            color: Theme.of(context).primaryColor,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            onRefresh: () {
              setState(() {
                loadingCanais = true;
              });
              return context.read(canaisControllerNotifier).getCanaisMaisPopular(context: context).then((value){
                setState(() {
                  loadingCanais = false;
                });
              });
            },
            child: CustomScrollView(
              controller: _sc,
              slivers: <Widget>[
                CustomSliverAppBar(),
                SliverToBoxAdapter(
                  child: Container(
                    height: 30,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 10),
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            loadingCanais = true;
                          });
                        },
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
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: 75,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: BeShimmer(
                      linearGradient: ShimmerGradient,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: loadingCanais ? const NeverScrollableScrollPhysics() : null,
                        itemCount: loadingCanais ? 5 : canaisController.canaisMaisList.length,
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
                                  color: Colors.grey[300],
                                ),
                                child: BeImageCached(
                                  url: "${Config.BASE_URL}${canaisController.canaisMaisList[index].capa}",
                                  sizeIcon: 50,
                                  placeholder: beloadCircular(color: Theme.of(context).accentColor),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
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
                // SliverToBoxAdapter(
                //   child: Consumer<CanaisController>(
                //     builder: (context, _, child){
                //       return Container(
                //         height: 55,
                //         color: Theme.of(context).backgroundColor,
                //         child: ListView.builder(
                //           scrollDirection: Axis.horizontal,
                //           itemCount: typeFilter.length,
                //           itemBuilder: (context, index){
                //             return Padding(
                //               padding: const EdgeInsets.all(8.0),
                //               child: InkWell(
                //                 onTap: (){
                //                   setState(() {
                //                     for (var i = 0; i < typeFilter.length; i++) {
                //                       if(typeFilter[index].name != typeFilter[i].name){
                //                         typeFilter[i].isActive = false;
                //                       }
                //                     }
                //                     typeFilter[index].isActive = !typeFilter[index].isActive;
                //                   });
                //                 },
                //                 child: Container(
                //                   padding: EdgeInsets.only(left:10, right: 10, top: 10, bottom: 10),
                //                   decoration: BoxDecoration(
                //                     color: typeFilter[index].isActive ? Theme.of(context).primaryColor:   Theme.of(context).scaffoldBackgroundColor,
                //                     borderRadius: BorderRadius.circular(15),
                //                   ),
                //                   child: Row(
                //                     mainAxisAlignment: MainAxisAlignment.center,
                //                     crossAxisAlignment: CrossAxisAlignment.center,
                //                     children: [
                //                       Icon(typeFilter[index].icon, size: 16, 
                //                         color: typeFilter[index].isActive ? 
                //                         Theme.of(context).backgroundColor
                //                         :Theme.of(context).accentColor
                //                       ),
                //                       Container(
                //                         child: Text(' ${typeFilter[index].name}',
                //                           style: TextStyle(
                //                             color: typeFilter[index].isActive ? 
                //                             Theme.of(context).backgroundColor:
                //                             Theme.of(context).accentColor,
                //                           ),
                //                         )
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //             );
                //           },
                //         ),
                //       );
                //     },
                //   )
                // ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(left:15.0, right: 15.0, top: 15.0),
                        child: VideoCard(
                          video: dataVideoList[index],
                        ),
                      );
                    },
                    childCount: dataVideoList.length,
                  )
                )




                // loadingvideos ?
                // SliverToBoxAdapter(
                //   child: BeShimmer(
                //     linearGradient: ShimmerGradient,
                //     child: Container(
                //       height: 715,
                //       padding: const EdgeInsets.only(left:15.0, right: 15.0, top: 15.0),
                //       color: Theme.of(context).backgroundColor,
                //       child: Column(
                //         children: [
                //           BeShimmerLoading(
                //             isLoading: loadingvideos,
                //             child: VideoCardShimmer(),
                //           ),
                //           SizedBox(height: 20),
                //           BeShimmerLoading(
                //             isLoading: loadingvideos,
                //             child: VideoCardShimmer(),
                //           ),
                //           SizedBox(height: 20),
                //           BeShimmerLoading(
                //             isLoading: loadingvideos,
                //             child: VideoCardShimmer(),
                //           ),
                //           SizedBox(height: 20),
                //         ],
                //       )
                //     ),
                //   ) 
                // ) : Consumer<VideosController>(
                //   builder: (context, _, child) {
                //     return SliverList(
                //       delegate: SliverChildBuilderDelegate(
                //         (BuildContext context, int index) {
                //           return Padding(
                //             padding: const EdgeInsets.only(left:15.0, right: 15.0, top: 15.0),
                //             child: VideoCard(
                //               video: _.videosList[index],
                //             ),
                //           );
                //         },
                //         childCount: _.videosList.length
                //       )
                //     );
                //   }
                // )
              ],
            )
          );
        }
      )
    );
  }
}


class VideoCardShimmer extends StatelessWidget {
  const VideoCardShimmer({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).accentColor,
            ),
          ),
          SizedBox(height: 6),
          Row(
            children: [
              CircleAvatar(
                radius: 23,
              ),
              SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).accentColor,
                    ),
                    child: Text(''),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).accentColor,
                    ),
                    child: Text(''),
                  ),
                ],
              )
            ],
          )
        ]
      ),
    );
  }
}