import 'package:bestapp_package/bestapp_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class IncricaoScreen extends StatefulWidget {
  const IncricaoScreen({ Key key }) : super(key: key);

  @override
  _IncricaoScreenState createState() => _IncricaoScreenState();
}

class _IncricaoScreenState extends State<IncricaoScreen> {
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
            title: Row(
              children: [
                Text('You',
                  style: TextStyle(
                  ),
                ),
                Text('Be',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).secondaryHeaderColor
                  ),
                ),
              ],
            ),
            flexibleSpace: Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
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
                                fontSize: 13
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
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
                                fontSize: 13
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
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