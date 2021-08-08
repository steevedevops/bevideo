import 'package:bestapp_package/bestapp_package.dart';
import 'package:bevideo/src/screens/canais.dart';
import 'package:bevideo/src/screens/home.dart';
import 'package:bevideo/src/screens/incricao.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class HomebaseScreen extends StatefulWidget {
  final int defineScreen;
  HomebaseScreen({@required this.defineScreen});

  @override
  _HomebaseScreenState createState() => _HomebaseScreenState();
}

class _HomebaseScreenState extends State<HomebaseScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _menus = <Widget>[
      HomeScreen(),
      IncricaoScreen(),
      HomeScreen(),
      CanaisScreen(),
      Container()
    ];

    return WillPopScope(
      onWillPop: ()async {
        return Future.value(false);
      },
      child: Scaffold(
        key: _scaffoldKey,
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
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: Icon(FeatherIcons.checkSquare),
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
                label: 'Canais',
              ),
              BottomNavigationBarItem(
                icon: Icon(FeatherIcons.user),
                label: 'Profile',
              ),            
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
        body: _menus.elementAt(_selectedIndex)
      )
    );
  }
  void _onItemTapped(int index)async{
    setState(() {
      _selectedIndex = index;
    });
  }
}