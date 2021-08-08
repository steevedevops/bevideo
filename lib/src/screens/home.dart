import 'package:bestapp_package/bestapp_package.dart';
import 'package:bevideo/assets/styles/style.dart';
import 'package:bevideo/config.dart';
import 'package:bevideo/src/controllers/canais-controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class TypeFilterModel {
  String name;
  bool isActive;
  IconData icon;

  TypeFilterModel(
      {
      this.name,
      this.isActive,
      this.icon
    });

  TypeFilterModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    isActive = json['isActive'];
    icon = json['icon'];
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['isActive'] = this.isActive;
    return data;
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key key }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loadingCanais = false;

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
    setState(() {
      loadingCanais = true;
    });
    canaisController.getCanaisMaisPopular(context: context).then((result){
      setState(() {
        loadingCanais = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
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
                                image: _.canaisList[index].user.perfil.avatar != null ?
                                DecorationImage(
                                  image: NetworkImage("${Config.BASE_URL}${_.canaisList[index].user.perfil.avatar}"),
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
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200.0,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 4.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.center,
                  color: Colors.teal[100 * (index % 9)],
                  child: Text('Grid Item $index'),
                );
              },
              childCount: 20,
            ),
          ),


          SliverFixedExtentList(
            itemExtent: 50.0,
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.center,
                  color: Colors.lightBlue[100 * (index % 9)],
                  child: Text('List Item $index'),
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}