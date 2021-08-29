import 'package:bestapp_package/bestapp_package.dart';
import 'package:bevideo/config.dart';
import 'package:bevideo/src/models/canais-model.dart';
import 'package:flutter/material.dart';

final canaisMaisProvider = FutureProvider.autoDispose<List<CanaisModel>>((ref) async => getCanaisMaisPopular());
Future<List<CanaisModel>> getCanaisMaisPopular({BuildContext context}) async {
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
      return CanaisModel.fromJsonList(result['canais']);      
    }
    return [];
  }

final canaisControllerNotifier = ChangeNotifierProvider<CanaisController>((ref)=> CanaisController());
class CanaisController extends ChangeNotifier{

  static String _msgapi;
  String get msgapi => _msgapi;
  List<CanaisModel> _canaisList = [];
  List<CanaisModel> get canaisList => _canaisList;

  List<CanaisModel> _canaisMaisList = [];
  List<CanaisModel> get canaisMaisList => _canaisMaisList;

  Future<void> getCanaisMaisPopular({BuildContext context}) async {
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
      _canaisMaisList = CanaisModel.fromJsonList(result['canais']);      
    }else{
      _msgapi = result['msg'];
    }
    notifyListeners();
  }
  
  
  Future <void> getTodosCanais({@required BuildContext context})async{
    ApiServices apiServices = new ApiServices('', Config.BASE_URL);
     var result = await apiServices.callApi(
      context: context,
      metodo: 'GET',
      rota: 'canal/'
    );
    if(apiServices.reqSuccess){
      _canaisList = CanaisModel.fromJsonList(result['canais']);      
    }else{
      _msgapi = result['msg'];
    }    
    notifyListeners();
  }

  

}