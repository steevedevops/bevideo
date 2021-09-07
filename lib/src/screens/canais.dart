import 'package:bestapp_package/bestapp_package.dart';
import 'package:bevideo/assets/styles/style.dart';
import 'package:bevideo/config.dart';
import 'package:bevideo/src/controllers/canais-controller.dart';
import 'package:bevideo/src/models/filter-model.dart';
import 'package:bevideo/src/widgets/sliver-appbar.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class CanaisScreen extends StatefulWidget {
  const CanaisScreen({ Key key }) : super(key: key);

  @override
  _CanaisScreenState createState() => _CanaisScreenState();
}

class _CanaisScreenState extends State<CanaisScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _sc = new ScrollController();

  bool loadingCanais = false;

  List<TypeFilterModel> typeFilter = [
    TypeFilterModel(
      name: 'Com mais relevância',
      icon: FeatherIcons.trendingUp,
      isActive: true
    ),
    TypeFilterModel(
      name: 'Canais recentes',
      icon: FeatherIcons.calendar,
      isActive: false
    ),
    TypeFilterModel(
      name: 'Desde AZ',
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
    context.read(canaisControllerNotifier).getTodosCanais(context: context).then((value){
      setState(() {
        loadingCanais = false;
      });
    });

    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        print('dados');
        // canaisController.getTodosCanais(context: context, initial: false);
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
              return context.read(canaisControllerNotifier).getTodosCanais(context: context).then((value){
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
                    height: 20,
                    color: Theme.of(context).backgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 0),
                      // padding: const EdgeInsets.only(left: 12.0, top: 5),// QUando estiver logado
                      child: Text('Mostreme somente os canais',
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
                  child: Container(
                    height: 55,
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
                  )
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: 10,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 0),
                    ),
                  ),
                ),

                loadingCanais ?
                SliverToBoxAdapter(
                  child: BeShimmer(
                    linearGradient: ShimmerGradient,
                    child: Container(
                      height: 715,
                      padding: const EdgeInsets.only(left:15.0, right: 15.0, top: 15.0),
                      color: Theme.of(context).backgroundColor,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: BeShimmerLoading(
                                  isLoading: true,
                                  child: Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Theme.of(context).accentColor,
                                    ),
                                    child: Text(''),
                                  )
                                )
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: BeShimmerLoading(
                                  isLoading: true,
                                  child: Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Theme.of(context).accentColor,
                                    ),
                                    child: Text(''),
                                  ),
                                ),
                              )
                            ]
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: BeShimmerLoading(
                                  isLoading: true,
                                  child: Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Theme.of(context).accentColor,
                                    ),
                                    child: Text(''),
                                  )
                                )
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: BeShimmerLoading(
                                  isLoading: true,
                                  child: Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Theme.of(context).accentColor,
                                    ),
                                    child: Text(''),
                                  ),
                                ),
                              )
                            ]
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: BeShimmerLoading(
                                  isLoading: true,
                                  child: Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Theme.of(context).accentColor,
                                    ),
                                    child: Text(''),
                                  )
                                )
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: BeShimmerLoading(
                                  isLoading: true,
                                  child: Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Theme.of(context).accentColor,
                                    ),
                                    child: Text(''),
                                  ),
                                ),
                              )
                            ]
                          ),
                        ],
                      )
                    ),
                  )
                ) : SliverGrid(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200.0,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: 0.9
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Container(
                          padding: const EdgeInsets.only(left:10.0, right: 10.0, top: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 120,
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 90,
                                      child: BeImageCached(
                                        url: "${Config.BASE_URL}${canaisController.canaisList[index].banner}",
                                        sizeIcon: 50,
                                        radius: 10,
                                        placeholder: beloadCircular(color: Theme.of(context).accentColor),
                                      ),
                                    ),
                                    Positioned(
                                      top: 60,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 60,
                                            child: BeAvatar(
                                              spacer: 2,
                                              shape: BeAvatarShape.circle,
                                              backgroundImage:canaisController.canaisList[index].capa != null ?
                                              NetworkImage('${Config.BASE_URL}${canaisController.canaisList[index].capa}') : null,
                                              child: Text('${canaisController.canaisList[index].user.firstName[0]}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 30
                                                ),
                                              ),
                                            )
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(bottom: 5),
                                            // color: Colors.red,
                                            child: Text('${canaisController.canaisList[index].nome}',
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: AppStyle.fontFamily,
                                                color: Theme.of(context).accentColor
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              Container(
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          // videosController.startVideo();
                                        });
                                      },
                                      child: Container(
                                        height: 28,
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          ),
                                        ),
                                        child: Text('INSCREVER-SE',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: AppStyle.fontFamily,
                                            color: Theme.of(context).scaffoldBackgroundColor
                                          )
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 65,
                                      height: 28,
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                        border: Border.all(color: Colors.redAccent)
                                      ),
                                      child: Center(
                                        child: Text('${NumberFormat.compact(locale: 'pt-br').format(canaisController.canaisList[index].inscritos)}')
                                      )
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              Container(
                                child: Row(
                                  children: [
                                    Icon(FeatherIcons.trendingUp, size: 17),
                                    Container(
                                      child: Text('  Views',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: AppStyle.fontFamily,
                                          color: Colors.grey
                                        )
                                      ),
                                    ),
                                    Container(
                                      child: Text(' ${NumberFormat.compact(locale: 'pt-br').format(canaisController.canaisList[index].totalViews)}')
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Icon(FeatherIcons.film, size: 17),
                                    Container(
                                      child: Text('  Vídeos',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: AppStyle.fontFamily,
                                          color: Colors.grey
                                        )
                                      ),
                                    ),
                                    Container(
                                      child: Text(' ${NumberFormat.compact(locale: 'pt-br').format(canaisController.canaisList[index].totalVideos)}')
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                        );
                      },
                      childCount: canaisController.canaisList.length
                    )
                  )
              ],
            )
          );

        }
      )
    );
  }
}