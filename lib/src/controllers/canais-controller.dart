import 'package:bestapp_package/bestapp_package.dart';
import 'package:bevideo/config.dart';
import 'package:bevideo/src/models/canais-model.dart';
import 'package:flutter/material.dart';

class CanaisController extends ChangeNotifier{
  static String _msgapi;
  String get msgapi => _msgapi;

  List<CanaisModel> _canaisList = [];
  List<CanaisModel> get canaisList => _canaisList;


  Future <bool> getCanaisMaisPopular({@required BuildContext context})async{
    ApiServices apiServices = new ApiServices('', Config.BASE_URL);

     var result = await apiServices.callApi(
      context: context,
      metodo: 'GET',
      rota: 'home/',
      params: {
        'page': 1,
        'acao':'canais'
      }
    );
    if(apiServices.reqSuccess){
      _canaisList = CanaisModel.fromJsonList(result['canais']);      
      notifyListeners();
      return true;
    }else{
      _msgapi = result['msg'];
      notifyListeners();
    }    
    return false;  
  }


  Future <bool> getTodosCanais({@required BuildContext context})async{
    ApiServices apiServices = new ApiServices('', Config.BASE_URL);

     var result = await apiServices.callApi(
      context: context,
      metodo: 'GET',
      rota: 'canal/'
    );
    if(apiServices.reqSuccess){
      _canaisList = CanaisModel.fromJsonList(result['canais']);      
      notifyListeners();
      return true;
    }else{
      _msgapi = result['msg'];
      notifyListeners();
    }    
    return false;  
  }

}