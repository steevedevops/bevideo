import 'package:bestapp_package/bestapp_package.dart';
import 'package:bevideo/assets/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
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
      flexibleSpace: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 1,
        itemBuilder: (context, index){
          return Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
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
                    onTap: (){
                    },
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
          );
        },
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
    );
  }
}