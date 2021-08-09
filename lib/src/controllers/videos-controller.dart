import 'package:bestapp_package/bestapp_package.dart';
import 'package:bevideo/config.dart';
import 'package:bevideo/src/models/videos-model.dart';
import 'package:flutter/material.dart';

class VideosController extends ChangeNotifier{
  List<VideosModel> _videosList = [];
  List<VideosModel> get videosList => _videosList;

  static String _msgapi;
  String get msgapi => _msgapi;

  bool _ultimo = false;
  int _currentPage = 1;
  bool get ultimo => _ultimo;

  
  Future <bool> listarVideos({@required BuildContext context, @required bool initial, String order})async{    
    await PreferenceUtils.init();
    ApiServices apiServices = new ApiServices(PreferenceUtils.getString('sessionid'), Config.BASE_URL);
    
    if (initial){
      _videosList = [];
      _currentPage = 1;
      _ultimo = false;
    }

    var params = {
      'page': '${this._currentPage}',
      'order': order != null ? order : ''
    };
    
    var result = await apiServices.callApi(
      context: context,
      metodo: 'GET',
      rota: 'video/',
      params: params
    );

    if(apiServices.reqSuccess){
      var resultinfo = VideosModel.fromJsonList(result['videos']);      


      // if (result['next'] != null) {
        // print('Next != null');
      for (var i = 0; i < resultinfo.length; i++) {
        _videosList.add(resultinfo[i]);
      } 
      print('dados');
      //   _currentPage += 1;
      // }else if(result['next'] == null){

      //   if(!_ultimo){
      //     print('Next == null');
      //     for (var i = 0; i < resultinfo.length; i++) {
      //       _videosList.add(resultinfo[i]);
      //     } 
      //     _ultimo = true;
      //   }
      // }
      notifyListeners();
      return true;
    }else{
      _msgapi = result['msg'];
      notifyListeners();
      return false;
    }
  }
}