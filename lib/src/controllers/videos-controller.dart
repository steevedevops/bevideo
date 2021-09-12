import 'package:bestapp_package/bestapp_package.dart';
import 'package:better_player/better_player.dart';
import 'package:bevideo/config.dart';
import 'package:bevideo/src/models/videos-detail-model.dart';
import 'package:bevideo/src/models/videos-model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedVideoProvider = StateProvider<VideosModel>((ref) => null);
final miniPlayerControllerProvider = StateProvider.autoDispose<MiniplayerController>((ref) => MiniplayerController());
final betterPlayerControllerProvider = StateProvider.autoDispose<BetterPlayerController>((ref){
  BetterPlayerConfiguration betterPlayerConfiguration = BetterPlayerConfiguration(
    aspectRatio: 16 / 9,
    fit: BoxFit.contain,
    autoPlay: true,
    autoDispose: true,
    autoDetectFullscreenDeviceOrientation: true,
    controlsConfiguration: BetterPlayerControlsConfiguration(
      enableQualities: false,
      enableAudioTracks: false,
      pipMenuIcon: Icons.picture_in_picture,
      playerTheme: BetterPlayerTheme.beplayer,
      playIcon: CupertinoIcons.play_circle,
      pauseIcon: CupertinoIcons.pause_circle,
      overflowMenuIcon: Icons.settings,
      skipBackIcon: CupertinoIcons.gobackward_15,
      fullscreenEnableIcon: Icons.fullscreen_rounded,
      fullscreenDisableIcon: Icons.fullscreen_exit_rounded,
      skipForwardIcon: CupertinoIcons.goforward_15
    )
  );
  return BetterPlayerController(betterPlayerConfiguration);
});

// quando acontece a mudanca do select do video eu fico escutando o que foi mudado para retornar ele em uma fucao futura 
// para recontruir o widget
final videoDetaileProvider = FutureProvider.autoDispose<VideosDetailModel>((ref) async {
  // lee a mudanca da variabel para atualizar o futurebuilder.
  final VideosModel selectedVideo = ref.watch(selectedVideoProvider).state;
  
  if(selectedVideo != null ){
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      '${Config.BASE_URL}${selectedVideo.video}',
      notificationConfiguration: BetterPlayerNotificationConfiguration(
        showNotification: true,
        title: selectedVideo.nome,
        author: selectedVideo.canal.nome,
        imageUrl: '${Config.BASE_URL}${selectedVideo.capa}',
      ),
    );
    ref.read(betterPlayerControllerProvider).state.setupDataSource(dataSource);
    ref.read(betterPlayerControllerProvider).state.addEventsListener(_handleEvent);
  }
  return getVideodetailInfo(pkVideo: selectedVideo.codigo);
});

void _handleEvent(BetterPlayerEvent event){
  if(event.betterPlayerEventType == BetterPlayerEventType.finished){
    print('Video finalizado iniciar nuevo=-============= ');
  }
}

Future<VideosDetailModel> getVideodetailInfo({int pkVideo}) async {
  ApiServices apiServices = new ApiServices('', baseApiUrl);

  var result = await apiServices.callApi(
    metodo: 'GET',
    rota: 'video-detalhe/',
    params: {
      'watch': '$pkVideo'
    }
  );
  if(apiServices.reqSuccess){
    return VideosDetailModel.fromJson(result);      
  }
  return null;
}

class VideosController extends ChangeNotifier{
  // List<VideosModel> _videosList = [];
  // List<VideosModel> get videosList => _videosList;

  // static String _msgapi;
  // String get msgapi => _msgapi;

  // bool _ultimo = false;
  // int _currentPage = 1;
  // bool get ultimo => _ultimo;

  // final MiniplayerController _mplayerController = new MiniplayerController();
  // MiniplayerController get mplayerController => _mplayerController;

  // VideosModel _videosSelected = new VideosModel();
  // VideosModel get videosSelected => _videosSelected;
  
  // // void startVideo(VideosModel ){
  // // }

  // set startVideo(VideosModel videosModel){
  //   _videosSelected = videosModel;
  //   notifyListeners();
  //   _mplayerController.animateToHeight(state: PanelState.MAX);
  // }

  // Future <bool> listarVideos({@required BuildContext context, @required bool initial, String order})async{    
  //   await PreferenceUtils.init();
  //   ApiServices apiServices = new ApiServices(PreferenceUtils.getString('sessionid'), baseApiUrl);
    
  //   if (initial){
  //     _videosList = [];
  //     _currentPage = 1;
  //     _ultimo = false;
  //   }

  //   var params = {
  //     'page': '${this._currentPage}',
  //     'order': order != null ? order : ''
  //   };
    
  //   var result = await apiServices.callApi(
  //     context: context,
  //     metodo: 'GET',
  //     rota: 'video/',
  //     params: params
  //   );

  //   if(apiServices.reqSuccess){
  //     var resultinfo = VideosModel.fromJsonList(result['videos']);      


  //     // if (result['next'] != null) {
  //       // print('Next != null');
  //     for (var i = 0; i < resultinfo.length; i++) {
  //       _videosList.add(resultinfo[i]);
  //     } 
  //     print('dados');
  //     //   _currentPage += 1;
  //     // }else if(result['next'] == null){

  //     //   if(!_ultimo){
  //     //     print('Next == null');
  //     //     for (var i = 0; i < resultinfo.length; i++) {
  //     //       _videosList.add(resultinfo[i]);
  //     //     } 
  //     //     _ultimo = true;
  //     //   }
  //     // }
  //     notifyListeners();
  //     return true;
  //   }else{
  //     _msgapi = result['msg'];
  //     notifyListeners();
  //     return false;
  //   }
  // }

  // Future <VideosModel> getVideoDetalhe({BuildContext context, int codigo})async{
  //   ApiServices apiServices = new ApiServices('', baseApiUrl);

  //   var result = await apiServices.callApi(
  //     context: context,
  //     metodo: 'GET',
  //     rota: 'video-detalhe/',
  //     params: {
  //       'watch': codigo
  //     }
  //   );
  //   if (result['statusCode'] == 200){
  //     print('inforofeifjoerijfoerijfoirejforiejfioerjof');
  //     return VideosModel.fromJson(result['video']);
  //   }
  //   return null;
  // }
}

List<VideosModel> dataVideoList = VideosModel.fromJsonList(
  [
        {
            "codigo": 1263,
            "Categoria": [
                {
                    "codigo": 2,
                    "nome": "Politica"
                },
                {
                    "codigo": 3,
                    "nome": "Alta cultura"
                }
            ],
            "Canal": {
                "codigo": 76,
                "User": {
                    "first_name": "Bruna",
                    "last_name": "Torlay",
                    "get_full_name": "Bruna Torlay",
                    "email": "bruna@gmail.com",
                    "username": "bruna@gmail.com",
                    "date_joined": "2021-08-12T13:22:04.121156-03:00",
                    "last_login": "2021-08-12T13:22:04.770361-03:00",
                    "perfil": {
                        "User": 86,
                        "avatar": "/media/perfil/unnamed_CvSmQ1v.jpg",
                        "autoplay": true,
                        "dark": true,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Bruna Torlay",
                "descricao": "Welcome to my channel",
                "datacadastro": "2021-08-12T14:18:12.071057-03:00",
                "capa": "/media/perfil/unnamed_CvSmQ1v.jpg",
                "banner": "/media/banners/channels4_banner_rprT9nM.jpg",
                "inscritos": 0,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    2,
                    3
                ]
            },
            "nome": "O vírus que transformou a liberdade em luxo",
            "descricao": "O vírus que transformou a liberdade em luxo",
            "datacadastro": "2021-08-12T14:19:48.488804-03:00",
            "capa": "/media/capas/FlfItvWs0vk.jpg",
            "video": "/media/videos/O_v%C3%ADrus_que_transformou_a_liberdade_em_luxo-FlfItvWs0vk.mp4",
            "duracao": "00:13:03",
            "publicado": true,
            "destaque": false,
            "visualizacao": 0,
            "clicado": 1,
            "relevancia": 0.0,
            "elenco": null
        },
        {
            "codigo": 1262,
            "Categoria": [
                {
                    "codigo": 2,
                    "nome": "Politica"
                },
                {
                    "codigo": 3,
                    "nome": "Alta cultura"
                }
            ],
            "Canal": {
                "codigo": 3,
                "User": {
                    "first_name": "Flávio",
                    "last_name": "Morgteins",
                    "get_full_name": "Flávio Morgteins",
                    "email": "flavio@gmail.com",
                    "username": "flavio@gmail.com",
                    "date_joined": "2021-03-20T21:28:36-03:00",
                    "last_login": "2021-08-12T11:27:27.177877-03:00",
                    "perfil": {
                        "User": 5,
                        "avatar": "/media/perfil/maxresdefault.jpg",
                        "autoplay": true,
                        "dark": true,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Senso Incomum",
                "descricao": "Senso Incomum - Alta, média e baixa cultura.",
                "datacadastro": "2021-03-20T21:29:07-03:00",
                "capa": "/media/capas/unnamed.jpg",
                "banner": "/media/banners/channels4_banner_zOntAlG.jpg",
                "inscritos": 4,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    2,
                    3
                ]
            },
            "nome": "TOMANDO UMA DOSE DE DEMOCRACIA _ Live Senso Incomum #37",
            "descricao": "Assine a Formação Senso Incomum. Inscrições abertas somente até segunda-feira (16/08):  https://bit.ly/3xJVFoJ",
            "datacadastro": "2021-08-12T11:51:47.986279-03:00",
            "capa": "/media/capas/_LlTWEhtNIw.jpg",
            "video": "/media/videos/TOMANDO_UMA_DOSE_DE_DEMOCRACIA___Live_Senso_Incomum_37-_LlTWEhtNIw.mp4",
            "duracao": "03:02:26",
            "publicado": true,
            "destaque": false,
            "visualizacao": 0,
            "clicado": 0,
            "relevancia": 0.0,
            "elenco": null
        },
        {
            "codigo": 1261,
            "Categoria": [
                {
                    "codigo": 2,
                    "nome": "Politica"
                },
                {
                    "codigo": 3,
                    "nome": "Alta cultura"
                }
            ],
            "Canal": {
                "codigo": 3,
                "User": {
                    "first_name": "Flávio",
                    "last_name": "Morgteins",
                    "get_full_name": "Flávio Morgteins",
                    "email": "flavio@gmail.com",
                    "username": "flavio@gmail.com",
                    "date_joined": "2021-03-20T21:28:36-03:00",
                    "last_login": "2021-08-12T11:27:27.177877-03:00",
                    "perfil": {
                        "User": 5,
                        "avatar": "/media/perfil/maxresdefault.jpg",
                        "autoplay": true,
                        "dark": true,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Senso Incomum",
                "descricao": "Senso Incomum - Alta, média e baixa cultura.",
                "datacadastro": "2021-03-20T21:29:07-03:00",
                "capa": "/media/capas/unnamed.jpg",
                "banner": "/media/banners/channels4_banner_zOntAlG.jpg",
                "inscritos": 4,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    2,
                    3
                ]
            },
            "nome": "Argumentos lógicos não convencem ninguém _ Flavio Morgenstern",
            "descricao": "Argumentos lógicos não convencem ninguém _ Flavio Morgenstern",
            "datacadastro": "2021-08-12T11:28:01.971889-03:00",
            "capa": "/media/capas/8qnxOXknNoc.jpg",
            "video": "/media/videos/Argumentos_l%C3%B3gicos_n%C3%A3o_convencem_ningu%C3%A9m___Flavio_Morgenstern-8qnxOXknNoc.mp4",
            "duracao": "00:02:25",
            "publicado": true,
            "destaque": false,
            "visualizacao": 0,
            "clicado": 0,
            "relevancia": 0.0,
            "elenco": null
        },
        {
            "codigo": 1260,
            "Categoria": [
                {
                    "codigo": 2,
                    "nome": "Politica"
                }
            ],
            "Canal": {
                "codigo": 19,
                "User": {
                    "first_name": "Kim",
                    "last_name": "Paim",
                    "get_full_name": "Kim Paim",
                    "email": "kim@gmail.com",
                    "username": "kim@gmail.com",
                    "date_joined": "2021-03-26T18:34:58-03:00",
                    "last_login": "2021-08-12T11:10:17.730102-03:00",
                    "perfil": {
                        "User": 20,
                        "avatar": "/media/perfil/unnamed_tDdG0bf.jpg",
                        "autoplay": true,
                        "dark": false,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Kim Paim",
                "descricao": "Politica",
                "datacadastro": "2021-03-26T18:35:18-03:00",
                "capa": "/media/capas/unnamed_iu57SCB.jpg",
                "banner": "/media/banners/channels4_banner_vQSLoR6.jpg",
                "inscritos": 2,
                "facebook": "#",
                "twitter": "#",
                "googleplus": "#",
                "Categoria": [
                    2
                ]
            },
            "nome": "Bolsonaro DOBRA a Aposta e MOSTRA mais 'ESTRANHEZAS' + CPI do Curandeiro + Notícias Boas",
            "descricao": "Bolsonaro DOBRA a Aposta e MOSTRA mais 'ESTRANHEZAS' + CPI do Curandeiro + Notícias Boas",
            "datacadastro": "2021-08-12T11:21:35.527394-03:00",
            "capa": "/media/capas/esssse.png",
            "video": "/media/videos/Bolsonaro_DOBRA_a_Aposta_e_MOSTRA_mais_ESTRANHEZAS__CPI_do_Curandeiro__Not%C3%ADcias_B_55Z3FSc.mp4",
            "duracao": "00:59:20",
            "publicado": true,
            "destaque": false,
            "visualizacao": 0,
            "clicado": 3,
            "relevancia": 0.0,
            "elenco": null
        },
        {
            "codigo": 1259,
            "Categoria": [
                {
                    "codigo": 2,
                    "nome": "Politica"
                }
            ],
            "Canal": {
                "codigo": 34,
                "User": {
                    "first_name": "Jair",
                    "last_name": "Bolsonaro",
                    "get_full_name": "Jair Bolsonaro",
                    "email": "bolsonaro@gmail.com",
                    "username": "bolsonaro@gmail.com",
                    "date_joined": "2021-04-02T16:45:55-03:00",
                    "last_login": "2021-08-12T10:45:44.310983-03:00",
                    "perfil": {
                        "User": 36,
                        "avatar": "/media/perfil/unnamed_AYOqQAz.jpg",
                        "autoplay": true,
                        "dark": false,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Jair Bolsonaro",
                "descricao": "Politica",
                "datacadastro": "2021-04-02T16:46:26-03:00",
                "capa": "/media/capas/unnamed_20ELrQE.jpg",
                "banner": "/media/banners/channels4_banner_jXPeVaT.jpg",
                "inscritos": 1,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    2
                ]
            },
            "nome": "A mentalidade desse presidente é IMPRESSIONANTE",
            "descricao": "A mentalidade desse presidente é IMPRESSIONANTE",
            "datacadastro": "2021-08-12T11:02:03.165193-03:00",
            "capa": "/media/capas/GIhWFkGxaZY.jpg",
            "video": "/media/videos/A_mentalidade_desse_presidente_%C3%A9_IMPRESSIONANTE-GIhWFkGxaZY.mp4",
            "duracao": "00:54:16",
            "publicado": true,
            "destaque": false,
            "visualizacao": 2,
            "clicado": 8,
            "relevancia": 25.0,
            "elenco": null
        },
        {
            "codigo": 1258,
            "Categoria": [
                {
                    "codigo": 2,
                    "nome": "Politica"
                }
            ],
            "Canal": {
                "codigo": 4,
                "User": {
                    "first_name": "Barbara",
                    "last_name": "Silva",
                    "get_full_name": "Barbara Silva",
                    "email": "barbara@gmail.com",
                    "username": "barbara@gmail.com",
                    "date_joined": "2021-03-21T10:09:30-03:00",
                    "last_login": "2021-08-12T10:38:14.754046-03:00",
                    "perfil": {
                        "User": 6,
                        "avatar": "/media/perfil/unnamed_1mw23bP.jpg",
                        "autoplay": true,
                        "dark": false,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Te Atualizei",
                "descricao": "O Canal que irá te atualizar sobre a política do Brasil",
                "datacadastro": "2021-03-21T10:09:51-03:00",
                "capa": "/media/capas/unnamed_zkfn2aV.jpg",
                "banner": "/media/banners/channels4_banner.jpg",
                "inscritos": 1,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    2
                ]
            },
            "nome": "Impeachment não passa, uma nova chance e um exposed de muita qualidade.",
            "descricao": "No vídeo de hoje vamos de exposed  dos que votaram contra a transparência, vamos falar do Fux e do Barroso e comentar a nova chance que está sendo ventilada. separa a pipoca, fica confortável  e bora lá.",
            "datacadastro": "2021-08-12T10:42:42.753368-03:00",
            "capa": "/media/capas/QaBvfFXKurA.jpg",
            "video": "/media/videos/Impeachment_n%C3%A3o_passa_uma_nova_chance_e_um_exposed_de_muita_qualidade.-QaBvfFXKurA.mp4",
            "duracao": "00:18:16",
            "publicado": true,
            "destaque": false,
            "visualizacao": 1,
            "clicado": 1,
            "relevancia": 0.0,
            "elenco": null
        },
        {
            "codigo": 1257,
            "Categoria": [
                {
                    "codigo": 2,
                    "nome": "Politica"
                }
            ],
            "Canal": {
                "codigo": 19,
                "User": {
                    "first_name": "Kim",
                    "last_name": "Paim",
                    "get_full_name": "Kim Paim",
                    "email": "kim@gmail.com",
                    "username": "kim@gmail.com",
                    "date_joined": "2021-03-26T18:34:58-03:00",
                    "last_login": "2021-08-12T11:10:17.730102-03:00",
                    "perfil": {
                        "User": 20,
                        "avatar": "/media/perfil/unnamed_tDdG0bf.jpg",
                        "autoplay": true,
                        "dark": false,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Kim Paim",
                "descricao": "Politica",
                "datacadastro": "2021-03-26T18:35:18-03:00",
                "capa": "/media/capas/unnamed_iu57SCB.jpg",
                "banner": "/media/banners/channels4_banner_vQSLoR6.jpg",
                "inscritos": 2,
                "facebook": "#",
                "twitter": "#",
                "googleplus": "#",
                "Categoria": [
                    2
                ]
            },
            "nome": "Não ACABOU - Nova PEC na PRÓXIMA Semana + Vídeo POLÊMICO do Barroso + CPI e Fakes, agora COMEÇOU",
            "descricao": "Não ACABOU - Nova PEC na PRÓXIMA Semana + Vídeo POLÊMICO do Barroso + CPI e Fakes, agora COMEÇOU",
            "datacadastro": "2021-08-11T14:09:19.625653-03:00",
            "capa": "/media/capas/83rtR75QAU0.jpg",
            "video": "/media/videos/N%C3%A3o_ACABOU_-_Nova_PEC_na_PR%C3%93XIMA_Semana__V%C3%ADdeo_POL%C3%8AMICO_do_Barroso__CPI_e_Fakes_a_ZihIY42.mp4",
            "duracao": "00:59:49",
            "publicado": true,
            "destaque": false,
            "visualizacao": 2,
            "clicado": 24,
            "relevancia": 8.33,
            "elenco": null
        },
        {
            "codigo": 1256,
            "Categoria": [
                {
                    "codigo": 1,
                    "nome": "Aventura"
                },
                {
                    "codigo": 12,
                    "nome": "Natureza"
                },
                {
                    "codigo": 16,
                    "nome": "Viagens"
                }
            ],
            "Canal": {
                "codigo": 18,
                "User": {
                    "first_name": "Vanessa",
                    "last_name": "Cristina Kapper",
                    "get_full_name": "Vanessa Cristina Kapper",
                    "email": "kombi@gmail.com",
                    "username": "kombi@gmail.com",
                    "date_joined": "2021-03-25T21:00:41-03:00",
                    "last_login": "2021-08-11T13:51:36.377964-03:00",
                    "perfil": {
                        "User": 19,
                        "avatar": "/media/perfil/2021-03-25_22-15.png",
                        "autoplay": true,
                        "dark": true,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Por aí de Kombi",
                "descricao": "Por aí de Kombi",
                "datacadastro": "2021-03-25T21:03:41-03:00",
                "capa": "/media/capas/por_ae_kombi.jpg",
                "banner": "/media/banners/channels4_banner_9xrMVhx.jpg",
                "inscritos": 1,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    1,
                    12,
                    16
                ]
            },
            "nome": "Porque fomos embora do MARANHÃO Descida no rio Balsas e a treta do Galeto - Vlog Por Aí de Kombi",
            "descricao": "Inicialmente pretendíamos rodar por algumas semanas o estado do Maranhão, mas após vários acontecimentos, a briga do Galeto foi a gota d'água e seguimos viagem rumo ao próximo estado.\r\n\r\nGaleto está bem, a patinha está sarando!!\r\nQuem ficou preocupado aí com a nossa lontra?",
            "datacadastro": "2021-08-11T13:57:10.296014-03:00",
            "capa": "/media/capas/haEZ3Y0Ddqs.jpg",
            "video": "/media/videos/Porque_fomos_embora_do_MARANH%C3%83O_Descida_no_rio_Balsas_e_a_treta_do_Galeto_-_Vlog__Aeb1LAw.mp4",
            "duracao": "00:11:25",
            "publicado": true,
            "destaque": false,
            "visualizacao": 1,
            "clicado": 33,
            "relevancia": 3.03,
            "elenco": null
        },
        {
            "codigo": 1255,
            "Categoria": [
                {
                    "codigo": 4,
                    "nome": "Ciência"
                }
            ],
            "Canal": {
                "codigo": 75,
                "User": {
                    "first_name": "Vitor",
                    "last_name": "Santos",
                    "get_full_name": "Vitor Santos",
                    "email": "metaforando@gmail.com",
                    "username": "metaforando@gmail.com",
                    "date_joined": "2021-08-11T11:00:57.048244-03:00",
                    "last_login": "2021-08-11T11:00:57.632851-03:00",
                    "perfil": {
                        "User": 85,
                        "avatar": "/media/perfil/channels4_profile.jpg",
                        "autoplay": true,
                        "dark": false,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Vitor Santos",
                "descricao": "Welcome to my channel",
                "datacadastro": "2021-08-11T11:01:38.708606-03:00",
                "capa": "/media/perfil/channels4_profile.jpg",
                "banner": "/media/banners/channels4_banner_AVR45nL.jpg",
                "inscritos": 0,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    4
                ]
            },
            "nome": "Joice Hasselmann - “Agressão Inventada” (Análise de Linguagem Corporal - Metaforando)",
            "descricao": "Joice Hasselmann - “Agressão Inventada” (Análise de Linguagem Corporal - Metaforando)",
            "datacadastro": "2021-08-11T11:03:32.521381-03:00",
            "capa": "/media/capas/R8Rw3X1cZ6A_ehKH35O.jpg",
            "video": "/media/videos/Joice_Hasselmann_-_Agress%C3%A3o_Inventada_An%C3%A1lise_de_Linguagem_Corporal_-_Metaforando_2cboKNk.mp4",
            "duracao": "00:22:15",
            "publicado": true,
            "destaque": false,
            "visualizacao": 1,
            "clicado": 56,
            "relevancia": 1.79,
            "elenco": null
        },
        {
            "codigo": 1253,
            "Categoria": [
                {
                    "codigo": 2,
                    "nome": "Politica"
                }
            ],
            "Canal": {
                "codigo": 5,
                "User": {
                    "first_name": "Paula",
                    "last_name": "Marisa",
                    "get_full_name": "Paula Marisa",
                    "email": "paula@gmail.com",
                    "username": "paula@gmail.com",
                    "date_joined": "2021-03-21T10:13:54-03:00",
                    "last_login": "2021-08-11T11:04:02.683933-03:00",
                    "perfil": {
                        "User": 7,
                        "avatar": "/media/perfil/ZmIPLsx5_400x400.jpg",
                        "autoplay": true,
                        "dark": false,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Paula Marisa",
                "descricao": "Paula Marisa Descriação Canal",
                "datacadastro": "2021-03-21T10:14:12-03:00",
                "capa": "/media/capas/ZmIPLsx5_400x400.jpg",
                "banner": "/media/banners/channels4_banner_1UHIUgi.jpg",
                "inscritos": 1,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    2
                ]
            },
            "nome": "Encontro SECRETO do Xandy, PLANO B do Bolsonaro e declaração POLÊMICA do Barroso",
            "descricao": "Encontro SECRETO do Xandy, PLANO B do Bolsonaro e declaração POLÊMICA do Barroso",
            "datacadastro": "2021-08-11T10:19:37.622558-03:00",
            "capa": "/media/capas/5kgxwxHUQeI.jpg",
            "video": "/media/videos/Encontro_SECRETO_do_Xandy_PLANO_B_do_Bolsonaro_e_declara%C3%A7%C3%A3o_POL%C3%8AMICA_do_Barroso-5_7uxv0s2.mp4",
            "duracao": "00:21:29",
            "publicado": true,
            "destaque": false,
            "visualizacao": 2,
            "clicado": 6,
            "relevancia": 33.33,
            "elenco": null
        },
        {
            "codigo": 1252,
            "Categoria": [
                {
                    "codigo": 2,
                    "nome": "Politica"
                }
            ],
            "Canal": {
                "codigo": 20,
                "User": {
                    "first_name": "Marcelo",
                    "last_name": "Pontes",
                    "get_full_name": "Marcelo Pontes",
                    "email": "pontes@gmail.com",
                    "username": "pontes@gmail.com",
                    "date_joined": "2021-03-27T11:22:46-03:00",
                    "last_login": "2021-08-10T19:34:43.087071-03:00",
                    "perfil": {
                        "User": 21,
                        "avatar": "/media/perfil/unnamed_jhcVp22.jpg",
                        "autoplay": true,
                        "dark": true,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Verdade Politica",
                "descricao": "Politica",
                "datacadastro": "2021-03-27T11:23:38-03:00",
                "capa": "/media/capas/unnamed_157JBOr.jpg",
                "banner": "/media/banners/channels4_banner_eoRo9Fk.jpg",
                "inscritos": 1,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    2
                ]
            },
            "nome": "Brasília foi TOMADA pelos militares",
            "descricao": "Militares adentraram a esplanada e deixaram a esquerda em polvorosa, porém não é um golpe muito menos um alerta, é apenas um dos mais belos exercícios da Marinha.\r\n\r\nPorém foi o bastante para revelar quem de fato está prendendo dar um golpe no país.",
            "datacadastro": "2021-08-10T19:36:08.741962-03:00",
            "capa": "/media/capas/uzo0q9uMet8.jpg",
            "video": "/media/videos/Bras%C3%ADlia_foi_TOMADA_pelos_militares-uzo0q9uMet8.mp4",
            "duracao": "00:13:09",
            "publicado": true,
            "destaque": false,
            "visualizacao": 1,
            "clicado": 9,
            "relevancia": 11.11,
            "elenco": null
        },
        {
            "codigo": 1251,
            "Categoria": [
                {
                    "codigo": 2,
                    "nome": "Politica"
                }
            ],
            "Canal": {
                "codigo": 19,
                "User": {
                    "first_name": "Kim",
                    "last_name": "Paim",
                    "get_full_name": "Kim Paim",
                    "email": "kim@gmail.com",
                    "username": "kim@gmail.com",
                    "date_joined": "2021-03-26T18:34:58-03:00",
                    "last_login": "2021-08-12T11:10:17.730102-03:00",
                    "perfil": {
                        "User": 20,
                        "avatar": "/media/perfil/unnamed_tDdG0bf.jpg",
                        "autoplay": true,
                        "dark": false,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Kim Paim",
                "descricao": "Politica",
                "datacadastro": "2021-03-26T18:35:18-03:00",
                "capa": "/media/capas/unnamed_iu57SCB.jpg",
                "banner": "/media/banners/channels4_banner_vQSLoR6.jpg",
                "inscritos": 2,
                "facebook": "#",
                "twitter": "#",
                "googleplus": "#",
                "Categoria": [
                    2
                ]
            },
            "nome": "TENSÃO - Votação da PEC do Voto Auditável com Tanques em Brasília + Renan Já COMBINOU com LULA",
            "descricao": "TENSÃO - Votação da PEC do Voto Auditável com Tanques em Brasília + Renan Já COMBINOU com LULA",
            "datacadastro": "2021-08-10T10:23:14.979359-03:00",
            "capa": "/media/capas/HmSkvZtO0dU.jpg",
            "video": "/media/videos/TENS%C3%83O_-_Vota%C3%A7%C3%A3o_da_PEC_do_Voto_Audit%C3%A1vel_com_Tanques_em_Bras%C3%ADlia__Renan_J%C3%A1_COMBI_PP3tnEH.mp4",
            "duracao": "00:57:02",
            "publicado": true,
            "destaque": false,
            "visualizacao": 1,
            "clicado": 8,
            "relevancia": 12.5,
            "elenco": null
        },
        {
            "codigo": 1250,
            "Categoria": [
                {
                    "codigo": 5,
                    "nome": "Música"
                },
                {
                    "codigo": 24,
                    "nome": "Música Rock"
                }
            ],
            "Canal": {
                "codigo": 74,
                "User": {
                    "first_name": "Therion",
                    "last_name": "--",
                    "get_full_name": "Therion --",
                    "email": "therion@gmail.com",
                    "username": "therion@gmail.com",
                    "date_joined": "2021-08-10T08:24:21.055612-03:00",
                    "last_login": "2021-08-10T08:24:21.647293-03:00",
                    "perfil": {
                        "User": 84,
                        "avatar": "/media/perfil/unnamed_z86x74t.jpg",
                        "autoplay": true,
                        "dark": true,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Therion --",
                "descricao": "Welcome to my channel",
                "datacadastro": "2021-08-10T08:33:43.159489-03:00",
                "capa": "/media/perfil/unnamed_z86x74t.jpg",
                "banner": "/media/banners/channels4_banner_HRQnCzs.jpg",
                "inscritos": 0,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    5,
                    24
                ]
            },
            "nome": "Therion - Vovin [1998] FULL ALBUM",
            "descricao": "Therion - Vovin [1998] FULL ALBUM",
            "datacadastro": "2021-08-10T08:37:03.913156-03:00",
            "capa": "/media/capas/fWkcXIx5Bgg.jpg",
            "video": "/media/videos/Therion_-_Vovin_1998_FULL_ALBUM-fWkcXIx5Bgg.mp4",
            "duracao": "00:55:32",
            "publicado": true,
            "destaque": false,
            "visualizacao": 1,
            "clicado": 1,
            "relevancia": 0.0,
            "elenco": null
        },
        {
            "codigo": 1249,
            "Categoria": [
                {
                    "codigo": 2,
                    "nome": "Politica"
                },
                {
                    "codigo": 3,
                    "nome": "Alta cultura"
                }
            ],
            "Canal": {
                "codigo": 3,
                "User": {
                    "first_name": "Flávio",
                    "last_name": "Morgteins",
                    "get_full_name": "Flávio Morgteins",
                    "email": "flavio@gmail.com",
                    "username": "flavio@gmail.com",
                    "date_joined": "2021-03-20T21:28:36-03:00",
                    "last_login": "2021-08-12T11:27:27.177877-03:00",
                    "perfil": {
                        "User": 5,
                        "avatar": "/media/perfil/maxresdefault.jpg",
                        "autoplay": true,
                        "dark": true,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Senso Incomum",
                "descricao": "Senso Incomum - Alta, média e baixa cultura.",
                "datacadastro": "2021-03-20T21:29:07-03:00",
                "capa": "/media/capas/unnamed.jpg",
                "banner": "/media/banners/channels4_banner_zOntAlG.jpg",
                "inscritos": 4,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    2,
                    3
                ]
            },
            "nome": "INFOWAR _ EPISÓDIO 4_4 - Uma conclusão inevitável",
            "descricao": "INFOWAR _ EPISÓDIO 4_4 - Uma conclusão inevitável",
            "datacadastro": "2021-08-10T08:16:39.903694-03:00",
            "capa": "/media/capas/MQUtNOKLIDY.jpg",
            "video": "/media/videos/INFOWAR___EPIS%C3%93DIO_4_4_-_Uma_conclus%C3%A3o_inevit%C3%A1vel-MQUtNOKLIDY.mp4",
            "duracao": "01:14:05",
            "publicado": true,
            "destaque": false,
            "visualizacao": 3,
            "clicado": 4,
            "relevancia": 75.0,
            "elenco": null
        },
        {
            "codigo": 1248,
            "Categoria": [
                {
                    "codigo": 2,
                    "nome": "Politica"
                }
            ],
            "Canal": {
                "codigo": 5,
                "User": {
                    "first_name": "Paula",
                    "last_name": "Marisa",
                    "get_full_name": "Paula Marisa",
                    "email": "paula@gmail.com",
                    "username": "paula@gmail.com",
                    "date_joined": "2021-03-21T10:13:54-03:00",
                    "last_login": "2021-08-11T11:04:02.683933-03:00",
                    "perfil": {
                        "User": 7,
                        "avatar": "/media/perfil/ZmIPLsx5_400x400.jpg",
                        "autoplay": true,
                        "dark": false,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Paula Marisa",
                "descricao": "Paula Marisa Descriação Canal",
                "datacadastro": "2021-03-21T10:14:12-03:00",
                "capa": "/media/capas/ZmIPLsx5_400x400.jpg",
                "banner": "/media/banners/channels4_banner_1UHIUgi.jpg",
                "inscritos": 1,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    2
                ]
            },
            "nome": "Tanques em Brasília e a NOVA ESTRATÉGIA de Barroso",
            "descricao": "Tanques em Brasília e a NOVA ESTRATÉGIA de Barroso",
            "datacadastro": "2021-08-10T08:07:17.251380-03:00",
            "capa": "/media/capas/5NsOcmENEO4.jpg",
            "video": "/media/videos/Tanques_em_Bras%C3%ADlia_e_a_NOVA_ESTRAT%C3%89GIA_de_Barroso-5NsOcmENEO4.mp4",
            "duracao": "00:24:20",
            "publicado": true,
            "destaque": false,
            "visualizacao": 2,
            "clicado": 11,
            "relevancia": 18.18,
            "elenco": null
        },
        {
            "codigo": 1247,
            "Categoria": [
                {
                    "codigo": 5,
                    "nome": "Música"
                }
            ],
            "Canal": {
                "codigo": 12,
                "User": {
                    "first_name": "Tuomas",
                    "last_name": "Nightwish",
                    "get_full_name": "Tuomas Nightwish",
                    "email": "tuomas@gmail.com",
                    "username": "tuomas@gmail.com",
                    "date_joined": "2021-03-23T14:14:39-03:00",
                    "last_login": "2021-08-09T18:42:52.957066-03:00",
                    "perfil": {
                        "User": 13,
                        "avatar": "/media/perfil/unnamed_jghxhMX.jpg",
                        "autoplay": true,
                        "dark": true,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Nightwish",
                "descricao": "Nightwish",
                "datacadastro": "2021-03-23T14:15:05-03:00",
                "capa": "/media/capas/unnamed_Sms7U1q.jpg",
                "banner": "/media/banners/channels4_banner_0iU3vnu.jpg",
                "inscritos": 1,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    5
                ]
            },
            "nome": "Nightwish and John Two-Hawks - 16 Creek Mary's Blood (HD)",
            "descricao": "Nightwish and John Two-Hawks - 16 Creek Mary's Blood (HD)",
            "datacadastro": "2021-08-09T18:47:43.237227-03:00",
            "capa": "/media/capas/VcbQtIWzLrw_wJkdrFw.jpg",
            "video": "/media/videos/Nightwish_and_John_Two-Hawks_-_16_Creek_Marys_Blood_HD-VcbQtIWzLrw_CewAjXO.mp4",
            "duracao": "00:08:38",
            "publicado": true,
            "destaque": false,
            "visualizacao": 6,
            "clicado": 15,
            "relevancia": 26.67,
            "elenco": null
        },
        {
            "codigo": 1245,
            "Categoria": [
                {
                    "codigo": 2,
                    "nome": "Politica"
                },
                {
                    "codigo": 17,
                    "nome": "Jornal"
                }
            ],
            "Canal": {
                "codigo": 39,
                "User": {
                    "first_name": "André",
                    "last_name": "Luiz",
                    "get_full_name": "André Luiz",
                    "email": "jovempan@gmail.com",
                    "username": "jovempan@gmail.com",
                    "date_joined": "2021-04-10T08:58:06-03:00",
                    "last_login": "2021-08-09T18:12:53.398035-03:00",
                    "perfil": {
                        "User": 44,
                        "avatar": "/media/perfil/unnamed.jpg",
                        "autoplay": true,
                        "dark": true,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Jovem Pan",
                "descricao": "Jornal - Radio",
                "datacadastro": "2021-04-10T09:00:01-03:00",
                "capa": "/media/capas/unnamed_vCfLS8e.jpg",
                "banner": "/media/banners/channels4_banner_0oz4NGc.jpg",
                "inscritos": 0,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    2,
                    17
                ]
            },
            "nome": "NOVA CHANCE AO VOTO AUDITÁVEL_ BARROSO AMPLIA ATAQUES_ CORREIOS SEM PT - Os Pingos Nos Is - 06_08_21",
            "descricao": "NOVA CHANCE AO VOTO AUDITÁVEL_ BARROSO AMPLIA ATAQUES_ CORREIOS SEM PT - Os Pingos Nos Is - 06_08_21",
            "datacadastro": "2021-08-09T18:37:01.872874-03:00",
            "capa": "/media/capas/ib_qBYEa6NE.jpg",
            "video": "/media/videos/NOVA_CHANCE_AO_VOTO_AUDIT%C3%81VEL__BARROSO_AMPLIA_ATAQUES__CORREIOS_SEM_PT_-_Os_Pingo_GMbuqG8.mp4",
            "duracao": "02:30:35",
            "publicado": true,
            "destaque": false,
            "visualizacao": 1,
            "clicado": 13,
            "relevancia": 7.69,
            "elenco": null
        },
        {
            "codigo": 1244,
            "Categoria": [
                {
                    "codigo": 2,
                    "nome": "Politica"
                }
            ],
            "Canal": {
                "codigo": 20,
                "User": {
                    "first_name": "Marcelo",
                    "last_name": "Pontes",
                    "get_full_name": "Marcelo Pontes",
                    "email": "pontes@gmail.com",
                    "username": "pontes@gmail.com",
                    "date_joined": "2021-03-27T11:22:46-03:00",
                    "last_login": "2021-08-10T19:34:43.087071-03:00",
                    "perfil": {
                        "User": 21,
                        "avatar": "/media/perfil/unnamed_jhcVp22.jpg",
                        "autoplay": true,
                        "dark": true,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Verdade Politica",
                "descricao": "Politica",
                "datacadastro": "2021-03-27T11:23:38-03:00",
                "capa": "/media/capas/unnamed_157JBOr.jpg",
                "banner": "/media/banners/channels4_banner_eoRo9Fk.jpg",
                "inscritos": 1,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    2
                ]
            },
            "nome": "Barroso contrata MARQUETEIRO do PT para eleger URNA ELETRÔNICA",
            "descricao": "Barroso promete mais auditabilidade ignorando o fato que zero mais zero é igual a zero.  \r\n\r\nE pela primeira vez, uma urna eletrônica supostamente elaborada para eleger candidatos vira um candidato com direito até a marqueteiro do PT.\r\n\r\nE Bolsonaro volta a defender o voto auditável e chama Barroso de mentiroso.",
            "datacadastro": "2021-08-09T17:35:22.592988-03:00",
            "capa": "/media/capas/iqW-WzpvY-Y.jpg",
            "video": "/media/videos/Barroso_contrata_MARQUETEIRO_do_PT_para_eleger_URNA_ELETR%C3%94NICA-iqW-WzpvY-Y.mp4",
            "duracao": "00:08:35",
            "publicado": true,
            "destaque": false,
            "visualizacao": 2,
            "clicado": 17,
            "relevancia": 11.76,
            "elenco": null
        },
        {
            "codigo": 1243,
            "Categoria": [
                {
                    "codigo": 2,
                    "nome": "Politica"
                }
            ],
            "Canal": {
                "codigo": 34,
                "User": {
                    "first_name": "Jair",
                    "last_name": "Bolsonaro",
                    "get_full_name": "Jair Bolsonaro",
                    "email": "bolsonaro@gmail.com",
                    "username": "bolsonaro@gmail.com",
                    "date_joined": "2021-04-02T16:45:55-03:00",
                    "last_login": "2021-08-12T10:45:44.310983-03:00",
                    "perfil": {
                        "User": 36,
                        "avatar": "/media/perfil/unnamed_AYOqQAz.jpg",
                        "autoplay": true,
                        "dark": false,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Jair Bolsonaro",
                "descricao": "Politica",
                "datacadastro": "2021-04-02T16:46:26-03:00",
                "capa": "/media/capas/unnamed_20ELrQE.jpg",
                "banner": "/media/banners/channels4_banner_jXPeVaT.jpg",
                "inscritos": 1,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    2
                ]
            },
            "nome": "ENTREVISTA RÁDIO BRADO _ BA (09_08_2021)",
            "descricao": "ENTREVISTA RÁDIO BRADO _ BA (09_08_2021)",
            "datacadastro": "2021-08-09T12:07:25.455394-03:00",
            "capa": "/media/capas/2021-08-09_12-03.png",
            "video": "/media/videos/ENTREVISTA_R%C3%81DIO_BRADO___BA_09_08_2021.-6e-ms95h3d0.mp4",
            "duracao": "00:48:44",
            "publicado": true,
            "destaque": false,
            "visualizacao": 0,
            "clicado": 2,
            "relevancia": 0.0,
            "elenco": null
        },
        {
            "codigo": 1242,
            "Categoria": [
                {
                    "codigo": 2,
                    "nome": "Politica"
                }
            ],
            "Canal": {
                "codigo": 31,
                "User": {
                    "first_name": "Anderson",
                    "last_name": "Nunes",
                    "get_full_name": "Anderson Nunes",
                    "email": "brasileirinhos@gmail.com",
                    "username": "brasileirinhos@gmail.com",
                    "date_joined": "2021-04-01T14:52:40-03:00",
                    "last_login": "2021-08-09T06:30:32.074466-03:00",
                    "perfil": {
                        "User": 33,
                        "avatar": null,
                        "autoplay": true,
                        "dark": false,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Brasileirinhhos",
                "descricao": "--",
                "datacadastro": "2021-04-01T14:52:59-03:00",
                "capa": "/media/capas/unnamed_exvnqAr.jpg",
                "banner": "/media/banners/channels4_banner_Rdrgrlb.jpg",
                "inscritos": 0,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    2
                ]
            },
            "nome": "Edifício Master System - Parte 2",
            "descricao": "💰 Colabore com nosso APOIO COLETIVO! LINK: https://apoiocoletivo.com/campanha/969\r\n\r\n💰 AGORA CHEGAMOS DO FUTURO, temos Bitcoin!\r\n- temos Bitcoin, veja o código QR no fim do vídeo e nos mande umas moedas elétricas!  ou copie e cole: 1NUye52HMUV3Pz5zDrCNDpFCWW4hn8jCfa\r\n\r\n💰 TORNE-SE MEMBRO DA BRASIL PARALELO USANDO NOSSO LINK E NOS AJUDE A AJUDAR VOCÊ A AJUDAR O BRASIL A AJUDAR TOOS NÓS (e tem vários benefícios tipo assistir aos documentários sem cortes e aulas de brasil):\r\n\r\nLINK: https://go.brasilparalelo.com.br/camp...",
            "datacadastro": "2021-08-09T06:39:50.868403-03:00",
            "capa": "/media/capas/2021-08-09_06-31.png",
            "video": "/media/videos/Edif%C3%ADcio_Master_System_-_Parte_2-JT-u78iHoS8.mp4",
            "duracao": "00:52:05",
            "publicado": true,
            "destaque": false,
            "visualizacao": 1,
            "clicado": 4,
            "relevancia": 25.0,
            "elenco": null
        },
        {
            "codigo": 1241,
            "Categoria": [
                {
                    "codigo": 2,
                    "nome": "Politica"
                }
            ],
            "Canal": {
                "codigo": 31,
                "User": {
                    "first_name": "Anderson",
                    "last_name": "Nunes",
                    "get_full_name": "Anderson Nunes",
                    "email": "brasileirinhos@gmail.com",
                    "username": "brasileirinhos@gmail.com",
                    "date_joined": "2021-04-01T14:52:40-03:00",
                    "last_login": "2021-08-09T06:30:32.074466-03:00",
                    "perfil": {
                        "User": 33,
                        "avatar": null,
                        "autoplay": true,
                        "dark": false,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Brasileirinhhos",
                "descricao": "--",
                "datacadastro": "2021-04-01T14:52:59-03:00",
                "capa": "/media/capas/unnamed_exvnqAr.jpg",
                "banner": "/media/banners/channels4_banner_Rdrgrlb.jpg",
                "inscritos": 0,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    2
                ]
            },
            "nome": "Brasileirinhos - Edifício Master System - Parte Hum",
            "descricao": "Colabore com nosso APOIO COLETIVO! EM BREVE NOVOS VÍDEOS! NOVAS TEMPORADAS! ALTSA PRESEPADAS! - LINK: https://apoiocoletivo.com/campanha/969\r\n\r\nTORNE-SE MEMBRO DA BRASIL PARALELO USANDO NOSSO LINK E NOS AJUDE A COMPRAR UMAS GARRAFAS DE QUILMES (e tem vários benefícios tipo assistir aos documentários sem cortes):\r\nLINK: https://go.brasilparalelo.com.br/camp...",
            "datacadastro": "2021-08-09T06:33:47.085898-03:00",
            "capa": "/media/capas/2021-08-09_06-27.png",
            "video": "/media/videos/Brasileirinhos_-_Edif%C3%ADcio_Master_System_-_Parte_Hum-UYjZzS9Ljq0.mp4",
            "duracao": "00:41:44",
            "publicado": true,
            "destaque": false,
            "visualizacao": 2,
            "clicado": 3,
            "relevancia": 33.33,
            "elenco": null
        },
        {
            "codigo": 1240,
            "Categoria": [
                {
                    "codigo": 1,
                    "nome": "Aventura"
                },
                {
                    "codigo": 12,
                    "nome": "Natureza"
                },
                {
                    "codigo": 16,
                    "nome": "Viagens"
                }
            ],
            "Canal": {
                "codigo": 18,
                "User": {
                    "first_name": "Vanessa",
                    "last_name": "Cristina Kapper",
                    "get_full_name": "Vanessa Cristina Kapper",
                    "email": "kombi@gmail.com",
                    "username": "kombi@gmail.com",
                    "date_joined": "2021-03-25T21:00:41-03:00",
                    "last_login": "2021-08-11T13:51:36.377964-03:00",
                    "perfil": {
                        "User": 19,
                        "avatar": "/media/perfil/2021-03-25_22-15.png",
                        "autoplay": true,
                        "dark": true,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Por aí de Kombi",
                "descricao": "Por aí de Kombi",
                "datacadastro": "2021-03-25T21:03:41-03:00",
                "capa": "/media/capas/por_ae_kombi.jpg",
                "banner": "/media/banners/channels4_banner_9xrMVhx.jpg",
                "inscritos": 1,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    1,
                    12,
                    16
                ]
            },
            "nome": "O RAIO CAIU 2 VEZES no mesmo lugar! Quebramos de novo no Maranhão. Vlog Por Aí de Kombi",
            "descricao": "Era pra ser um vídeo de superação, que se transformou em um perrengue semelhante ao da nossa primeira passagem pelo Maranhão. Mesma cidade, mesmo lugar e mesmo perrengue, como isso poderia ser possível 2 anos depois? Tem coisas que nem a gente acredita.",
            "datacadastro": "2021-08-09T06:27:05.883895-03:00",
            "capa": "/media/capas/C8td1JLvIe0.jpg",
            "video": "/media/videos/O_RAIO_CAIU_2_VEZES_no_mesmo_lugar_Quebramos_de_novo_no_Maranh%C3%A3o._Vlog_Por_A%C3%AD_de__JjIqNR9.mp4",
            "duracao": "00:25:10",
            "publicado": true,
            "destaque": false,
            "visualizacao": 3,
            "clicado": 5,
            "relevancia": 60.0,
            "elenco": null
        },
        {
            "codigo": 1239,
            "Categoria": [
                {
                    "codigo": 3,
                    "nome": "Alta cultura"
                },
                {
                    "codigo": 5,
                    "nome": "Música"
                },
                {
                    "codigo": 20,
                    "nome": "Música Classica"
                }
            ],
            "Canal": {
                "codigo": 42,
                "User": {
                    "first_name": "Ana",
                    "last_name": "Due",
                    "get_full_name": "Ana Due",
                    "email": "anaclassic@gmail.com",
                    "username": "anaclassic@gmail.com",
                    "date_joined": "2021-04-13T22:09:33.251847-03:00",
                    "last_login": "2021-08-08T16:34:04.982921-03:00",
                    "perfil": {
                        "User": 48,
                        "avatar": "/media/perfil/unnamed_aZl9FfY.jpg",
                        "autoplay": true,
                        "dark": false,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Musica Classica",
                "descricao": "Welcome to my channel",
                "datacadastro": "2021-04-13T22:10:13-03:00",
                "capa": "/media/capas/unnamed_a3Uwjca.jpg",
                "banner": "/media/banners/channels4_banner_ufwZg5u.jpg",
                "inscritos": 0,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    3,
                    5,
                    20
                ]
            },
            "nome": "CONAN THE BARBARIAN - 2017 TVE CONCERT (Live) - EIMEAR NOONE conducts BASIL POLEDOURIS - Film Music",
            "descricao": "Interpretación, en concierto, de los principales temas musicales de CONAN EL BÁRBARO (John Milius, 1982) de la banda sonora (BSO) del admirado compositor Basil Poledouris (1945-2006) que compuso para este clásico de la \"Espada y Brujería\".\r\n\r\nTemas: Anvil of Crom/ Suite Conan (Riddle of Steel; Riders of Doom; etc.)/ Theology/ Awakening.\r\n\r\nAdaptación de la obra de Robert E. Howard\r\n\r\n¡Qué la disfruteis!\r\n\r\nCompositor: Basil Poledouris\r\nOrquesta sinfónica: Orquesta Sinfónica de Tenerife & Tenerife Film Choir\r\nDirector de orquesta: Eímear Noone\r\n\r\nDirector FIMUCITÉ: Diego Navarro\r\n\r\nFestival Internacional de Música de Tenerife (FIMUCITÉ)\r\n\r\nTenerife (España), 2017\r\n\r\n\r\nTodos los derechos pertenecen a sus respectivos autores, intérpretes y propietarios legales. Este vídeo sólo tiene el propósito educativo de la difusión de la música cinematográfica y de televisión.\r\n\r\n---------------------------------------------------------------------------\r\n\r\nPerformance in concert from the Original Soundtrack of CONAN THE BARBARIAN (John Milius, 1982) by the admired composer BASIL POLEDOURIS (1945-2006) who composed for this classic \"Sword and Witchcraft\". Conan the barbarian score (OST).\r\n\r\nSoundtracks: Anvil of Crom / Suite Conan (Riddle of Steel; Riders of Doom; etc.) / Theology / Awakening.\r\n\r\nAdaptation from Robert E. Howard fiction\r\n\r\nEnjoy it!\r\n\r\nComposer: Basil Poledouris\r\nSymphony Orchestra: Tenerife Symphony Orchestra & Tenerife Film Choir\r\nConductor: Eímear Noone\r\n\r\nDirector FIMUCITÉ: Diego Navarro\r\n\r\nTenerife International Music Festival (FIMUCITÉ)\r\n\r\nTenerife (Spain), 2017\r\n\r\nAll rights belong to their respective authors, interpreters and legal owners. This video is for the educational purpose of broadcasting film and television music only.",
            "datacadastro": "2021-08-08T16:37:26.269783-03:00",
            "capa": "/media/capas/WKVt-pjZp7E.jpg",
            "video": "/media/videos/CONAN_THE_BARBARIAN_-_2017_TVE_CONCERT_Live_-_EIMEAR_NOONE_conducts_BASIL_POLEDOU_3Ynhwkj.mp4",
            "duracao": "00:24:33",
            "publicado": true,
            "destaque": false,
            "visualizacao": 5,
            "clicado": 9,
            "relevancia": 55.56,
            "elenco": null
        },
        {
            "codigo": 1238,
            "Categoria": [
                {
                    "codigo": 5,
                    "nome": "Música"
                },
                {
                    "codigo": 24,
                    "nome": "Música Rock"
                }
            ],
            "Canal": {
                "codigo": 73,
                "User": {
                    "first_name": "Ana",
                    "last_name": "Shine",
                    "get_full_name": "Ana Shine",
                    "email": "shine@gmail.com",
                    "username": "shine@gmail.com",
                    "date_joined": "2021-08-08T15:25:39.179752-03:00",
                    "last_login": "2021-08-08T15:27:27.339291-03:00",
                    "perfil": {
                        "User": 83,
                        "avatar": "/media/perfil/images.png",
                        "autoplay": true,
                        "dark": false,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Ana Shine",
                "descricao": "Welcome to my channel",
                "datacadastro": "2021-08-08T15:27:45.452224-03:00",
                "capa": "/media/perfil/images.png",
                "banner": "/media/banners/channels4_banner_WSou26y.jpg",
                "inscritos": 0,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    5,
                    24
                ]
            },
            "nome": "We Are Pilots",
            "descricao": "We Are Pilots",
            "datacadastro": "2021-08-08T15:35:18.035881-03:00",
            "capa": "/media/capas/maxresdefault_uas3UhL.jpg",
            "video": "/media/videos/We_Are_Pilots-FjBzcGWWx_I.mp4",
            "duracao": "00:04:14",
            "publicado": true,
            "destaque": false,
            "visualizacao": 1,
            "clicado": 1,
            "relevancia": 0.0,
            "elenco": null
        },
        {
            "codigo": 1237,
            "Categoria": [
                {
                    "codigo": 5,
                    "nome": "Música"
                },
                {
                    "codigo": 24,
                    "nome": "Música Rock"
                }
            ],
            "Canal": {
                "codigo": 73,
                "User": {
                    "first_name": "Ana",
                    "last_name": "Shine",
                    "get_full_name": "Ana Shine",
                    "email": "shine@gmail.com",
                    "username": "shine@gmail.com",
                    "date_joined": "2021-08-08T15:25:39.179752-03:00",
                    "last_login": "2021-08-08T15:27:27.339291-03:00",
                    "perfil": {
                        "User": 83,
                        "avatar": "/media/perfil/images.png",
                        "autoplay": true,
                        "dark": false,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Ana Shine",
                "descricao": "Welcome to my channel",
                "datacadastro": "2021-08-08T15:27:45.452224-03:00",
                "capa": "/media/perfil/images.png",
                "banner": "/media/banners/channels4_banner_WSou26y.jpg",
                "inscritos": 0,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    5,
                    24
                ]
            },
            "nome": "Shaken",
            "descricao": "Shaken",
            "datacadastro": "2021-08-08T15:34:55.680034-03:00",
            "capa": "/media/capas/maxresdefault_bqEIqcz.jpg",
            "video": "/media/videos/Shaken-tqQUf8CrEPA.mp4",
            "duracao": "00:03:43",
            "publicado": true,
            "destaque": false,
            "visualizacao": 1,
            "clicado": 26,
            "relevancia": 3.85,
            "elenco": null
        },
        {
            "codigo": 1236,
            "Categoria": [
                {
                    "codigo": 5,
                    "nome": "Música"
                },
                {
                    "codigo": 24,
                    "nome": "Música Rock"
                }
            ],
            "Canal": {
                "codigo": 73,
                "User": {
                    "first_name": "Ana",
                    "last_name": "Shine",
                    "get_full_name": "Ana Shine",
                    "email": "shine@gmail.com",
                    "username": "shine@gmail.com",
                    "date_joined": "2021-08-08T15:25:39.179752-03:00",
                    "last_login": "2021-08-08T15:27:27.339291-03:00",
                    "perfil": {
                        "User": 83,
                        "avatar": "/media/perfil/images.png",
                        "autoplay": true,
                        "dark": false,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Ana Shine",
                "descricao": "Welcome to my channel",
                "datacadastro": "2021-08-08T15:27:45.452224-03:00",
                "capa": "/media/perfil/images.png",
                "banner": "/media/banners/channels4_banner_WSou26y.jpg",
                "inscritos": 0,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    5,
                    24
                ]
            },
            "nome": "Jackie Will Save Me",
            "descricao": "Jackie Will Save Me",
            "datacadastro": "2021-08-08T15:34:31.446640-03:00",
            "capa": "/media/capas/maxresdefault_8Vph8he.jpg",
            "video": "/media/videos/Jackie_Will_Save_Me-NQF-vLakpyo.mp4",
            "duracao": "00:03:59",
            "publicado": true,
            "destaque": false,
            "visualizacao": 1,
            "clicado": 1,
            "relevancia": 0.0,
            "elenco": null
        },
        {
            "codigo": 1235,
            "Categoria": [
                {
                    "codigo": 5,
                    "nome": "Música"
                },
                {
                    "codigo": 24,
                    "nome": "Música Rock"
                }
            ],
            "Canal": {
                "codigo": 73,
                "User": {
                    "first_name": "Ana",
                    "last_name": "Shine",
                    "get_full_name": "Ana Shine",
                    "email": "shine@gmail.com",
                    "username": "shine@gmail.com",
                    "date_joined": "2021-08-08T15:25:39.179752-03:00",
                    "last_login": "2021-08-08T15:27:27.339291-03:00",
                    "perfil": {
                        "User": 83,
                        "avatar": "/media/perfil/images.png",
                        "autoplay": true,
                        "dark": false,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Ana Shine",
                "descricao": "Welcome to my channel",
                "datacadastro": "2021-08-08T15:27:45.452224-03:00",
                "capa": "/media/perfil/images.png",
                "banner": "/media/banners/channels4_banner_WSou26y.jpg",
                "inscritos": 0,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    5,
                    24
                ]
            },
            "nome": "Rainy Monday",
            "descricao": "Rainy Monday",
            "datacadastro": "2021-08-08T15:34:06.697179-03:00",
            "capa": "/media/capas/maxresdefault_zYqJ5bu.jpg",
            "video": "/media/videos/Rainy_Monday-rM25_7HRUBg.mp4",
            "duracao": "00:03:59",
            "publicado": true,
            "destaque": false,
            "visualizacao": 1,
            "clicado": 3,
            "relevancia": 33.33,
            "elenco": null
        },
        {
            "codigo": 1234,
            "Categoria": [
                {
                    "codigo": 5,
                    "nome": "Música"
                },
                {
                    "codigo": 24,
                    "nome": "Música Rock"
                }
            ],
            "Canal": {
                "codigo": 73,
                "User": {
                    "first_name": "Ana",
                    "last_name": "Shine",
                    "get_full_name": "Ana Shine",
                    "email": "shine@gmail.com",
                    "username": "shine@gmail.com",
                    "date_joined": "2021-08-08T15:25:39.179752-03:00",
                    "last_login": "2021-08-08T15:27:27.339291-03:00",
                    "perfil": {
                        "User": 83,
                        "avatar": "/media/perfil/images.png",
                        "autoplay": true,
                        "dark": false,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Ana Shine",
                "descricao": "Welcome to my channel",
                "datacadastro": "2021-08-08T15:27:45.452224-03:00",
                "capa": "/media/perfil/images.png",
                "banner": "/media/banners/channels4_banner_WSou26y.jpg",
                "inscritos": 0,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    5,
                    24
                ]
            },
            "nome": "Waiting",
            "descricao": "Waiting",
            "datacadastro": "2021-08-08T15:33:42.498333-03:00",
            "capa": "/media/capas/maxresdefault_VDjLSAI.jpg",
            "video": "/media/videos/Waiting-BY5jTi-jlNw.mp4",
            "duracao": "00:04:21",
            "publicado": true,
            "destaque": false,
            "visualizacao": 1,
            "clicado": 1,
            "relevancia": 0.0,
            "elenco": null
        },
        {
            "codigo": 1233,
            "Categoria": [
                {
                    "codigo": 5,
                    "nome": "Música"
                },
                {
                    "codigo": 24,
                    "nome": "Música Rock"
                }
            ],
            "Canal": {
                "codigo": 73,
                "User": {
                    "first_name": "Ana",
                    "last_name": "Shine",
                    "get_full_name": "Ana Shine",
                    "email": "shine@gmail.com",
                    "username": "shine@gmail.com",
                    "date_joined": "2021-08-08T15:25:39.179752-03:00",
                    "last_login": "2021-08-08T15:27:27.339291-03:00",
                    "perfil": {
                        "User": 83,
                        "avatar": "/media/perfil/images.png",
                        "autoplay": true,
                        "dark": false,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Ana Shine",
                "descricao": "Welcome to my channel",
                "datacadastro": "2021-08-08T15:27:45.452224-03:00",
                "capa": "/media/perfil/images.png",
                "banner": "/media/banners/channels4_banner_WSou26y.jpg",
                "inscritos": 0,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    5,
                    24
                ]
            },
            "nome": "Chemistry Of A Car Crash",
            "descricao": "Chemistry Of A Car Crash",
            "datacadastro": "2021-08-08T15:33:17.707244-03:00",
            "capa": "/media/capas/maxresdefault_1FmJp7E.jpg",
            "video": "/media/videos/Chemistry_Of_A_Car_Crash-gkIg8qX4x2c.mp4",
            "duracao": "00:03:51",
            "publicado": true,
            "destaque": false,
            "visualizacao": 1,
            "clicado": 1,
            "relevancia": 0.0,
            "elenco": null
        },
        {
            "codigo": 1232,
            "Categoria": [
                {
                    "codigo": 5,
                    "nome": "Música"
                },
                {
                    "codigo": 24,
                    "nome": "Música Rock"
                }
            ],
            "Canal": {
                "codigo": 73,
                "User": {
                    "first_name": "Ana",
                    "last_name": "Shine",
                    "get_full_name": "Ana Shine",
                    "email": "shine@gmail.com",
                    "username": "shine@gmail.com",
                    "date_joined": "2021-08-08T15:25:39.179752-03:00",
                    "last_login": "2021-08-08T15:27:27.339291-03:00",
                    "perfil": {
                        "User": 83,
                        "avatar": "/media/perfil/images.png",
                        "autoplay": true,
                        "dark": false,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Ana Shine",
                "descricao": "Welcome to my channel",
                "datacadastro": "2021-08-08T15:27:45.452224-03:00",
                "capa": "/media/perfil/images.png",
                "banner": "/media/banners/channels4_banner_WSou26y.jpg",
                "inscritos": 0,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    5,
                    24
                ]
            },
            "nome": "Don't Cry Out",
            "descricao": "Don't Cry Out",
            "datacadastro": "2021-08-08T15:32:52.366238-03:00",
            "capa": "/media/capas/maxresdefault_iQPdAIO.jpg",
            "video": "/media/videos/Dont_Cry_Out-volabypa4JY.mp4",
            "duracao": "00:04:10",
            "publicado": true,
            "destaque": false,
            "visualizacao": 1,
            "clicado": 2,
            "relevancia": 0.0,
            "elenco": null
        },
        {
            "codigo": 1231,
            "Categoria": [
                {
                    "codigo": 5,
                    "nome": "Música"
                },
                {
                    "codigo": 24,
                    "nome": "Música Rock"
                }
            ],
            "Canal": {
                "codigo": 73,
                "User": {
                    "first_name": "Ana",
                    "last_name": "Shine",
                    "get_full_name": "Ana Shine",
                    "email": "shine@gmail.com",
                    "username": "shine@gmail.com",
                    "date_joined": "2021-08-08T15:25:39.179752-03:00",
                    "last_login": "2021-08-08T15:27:27.339291-03:00",
                    "perfil": {
                        "User": 83,
                        "avatar": "/media/perfil/images.png",
                        "autoplay": true,
                        "dark": false,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Ana Shine",
                "descricao": "Welcome to my channel",
                "datacadastro": "2021-08-08T15:27:45.452224-03:00",
                "capa": "/media/perfil/images.png",
                "banner": "/media/banners/channels4_banner_WSou26y.jpg",
                "inscritos": 0,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    5,
                    24
                ]
            },
            "nome": "When They Came For Us",
            "descricao": "When They Came For Us",
            "datacadastro": "2021-08-08T15:32:19.848335-03:00",
            "capa": "/media/capas/maxresdefault_JaIzHkN.jpg",
            "video": "/media/videos/When_They_Came_For_Us-S9Oas1OQhdE.mp4",
            "duracao": "00:04:24",
            "publicado": true,
            "destaque": false,
            "visualizacao": 2,
            "clicado": 6,
            "relevancia": 33.33,
            "elenco": null
        },
        {
            "codigo": 1230,
            "Categoria": [
                {
                    "codigo": 5,
                    "nome": "Música"
                },
                {
                    "codigo": 24,
                    "nome": "Música Rock"
                }
            ],
            "Canal": {
                "codigo": 73,
                "User": {
                    "first_name": "Ana",
                    "last_name": "Shine",
                    "get_full_name": "Ana Shine",
                    "email": "shine@gmail.com",
                    "username": "shine@gmail.com",
                    "date_joined": "2021-08-08T15:25:39.179752-03:00",
                    "last_login": "2021-08-08T15:27:27.339291-03:00",
                    "perfil": {
                        "User": 83,
                        "avatar": "/media/perfil/images.png",
                        "autoplay": true,
                        "dark": false,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Ana Shine",
                "descricao": "Welcome to my channel",
                "datacadastro": "2021-08-08T15:27:45.452224-03:00",
                "capa": "/media/perfil/images.png",
                "banner": "/media/banners/channels4_banner_WSou26y.jpg",
                "inscritos": 0,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    5,
                    24
                ]
            },
            "nome": "Starts With One",
            "descricao": "Starts With One",
            "datacadastro": "2021-08-08T15:31:10.621391-03:00",
            "capa": "/media/capas/maxresdefault_3iTiVkv.jpg",
            "video": "/media/videos/Starts_With_One-xFml_Ww1DCw.mp4",
            "duracao": "00:03:45",
            "publicado": true,
            "destaque": false,
            "visualizacao": 6,
            "clicado": 8,
            "relevancia": 75.0,
            "elenco": null
        },
        {
            "codigo": 1229,
            "Categoria": [
                {
                    "codigo": 5,
                    "nome": "Música"
                },
                {
                    "codigo": 24,
                    "nome": "Música Rock"
                }
            ],
            "Canal": {
                "codigo": 73,
                "User": {
                    "first_name": "Ana",
                    "last_name": "Shine",
                    "get_full_name": "Ana Shine",
                    "email": "shine@gmail.com",
                    "username": "shine@gmail.com",
                    "date_joined": "2021-08-08T15:25:39.179752-03:00",
                    "last_login": "2021-08-08T15:27:27.339291-03:00",
                    "perfil": {
                        "User": 83,
                        "avatar": "/media/perfil/images.png",
                        "autoplay": true,
                        "dark": false,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Ana Shine",
                "descricao": "Welcome to my channel",
                "datacadastro": "2021-08-08T15:27:45.452224-03:00",
                "capa": "/media/perfil/images.png",
                "banner": "/media/banners/channels4_banner_WSou26y.jpg",
                "inscritos": 0,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    5,
                    24
                ]
            },
            "nome": "Le Disko",
            "descricao": "Le Disko",
            "datacadastro": "2021-08-08T15:30:43.166759-03:00",
            "capa": "/media/capas/maxresdefault_bLp06Ld.jpg",
            "video": "/media/videos/Le_Disko-qDlxG0p1Vsc.mp4",
            "duracao": "00:03:23",
            "publicado": true,
            "destaque": false,
            "visualizacao": 1,
            "clicado": 1,
            "relevancia": 0.0,
            "elenco": null
        },
        {
            "codigo": 1228,
            "Categoria": [
                {
                    "codigo": 5,
                    "nome": "Música"
                },
                {
                    "codigo": 24,
                    "nome": "Música Rock"
                }
            ],
            "Canal": {
                "codigo": 73,
                "User": {
                    "first_name": "Ana",
                    "last_name": "Shine",
                    "get_full_name": "Ana Shine",
                    "email": "shine@gmail.com",
                    "username": "shine@gmail.com",
                    "date_joined": "2021-08-08T15:25:39.179752-03:00",
                    "last_login": "2021-08-08T15:27:27.339291-03:00",
                    "perfil": {
                        "User": 83,
                        "avatar": "/media/perfil/images.png",
                        "autoplay": true,
                        "dark": false,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Ana Shine",
                "descricao": "Welcome to my channel",
                "datacadastro": "2021-08-08T15:27:45.452224-03:00",
                "capa": "/media/perfil/images.png",
                "banner": "/media/banners/channels4_banner_WSou26y.jpg",
                "inscritos": 0,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    5,
                    24
                ]
            },
            "nome": "You Are The One",
            "descricao": "You Are The One",
            "datacadastro": "2021-08-08T15:28:54.061855-03:00",
            "capa": "/media/capas/maxresdefault_Zu4XWP4.jpg",
            "video": "/media/videos/You_Are_The_One--fmomjFNhvg.mp4",
            "duracao": "00:04:30",
            "publicado": true,
            "destaque": false,
            "visualizacao": 1,
            "clicado": 1,
            "relevancia": 0.0,
            "elenco": null
        },
        {
            "codigo": 1227,
            "Categoria": [
                {
                    "codigo": 19,
                    "nome": "Filme ação"
                }
            ],
            "Canal": {
                "codigo": 47,
                "User": {
                    "first_name": "Tainara",
                    "last_name": "Dornel",
                    "get_full_name": "Tainara Dornel",
                    "email": "dornel.tainara@gmail.com",
                    "username": "dornel.tainara@gmail.com",
                    "date_joined": "2021-03-17T21:42:07-03:00",
                    "last_login": "2021-08-08T12:48:53.632826-03:00",
                    "perfil": {
                        "User": 3,
                        "avatar": "/media/perfil/2021-03-21_12-35_TYVRBTM.png",
                        "autoplay": true,
                        "dark": false,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Tainara Dornel",
                "descricao": "Welcome to my channel",
                "datacadastro": "2021-04-29T17:49:19.781463-03:00",
                "capa": "/media/perfil/2021-03-21_12-35_TYVRBTM.png",
                "banner": null,
                "inscritos": 0,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    1,
                    19
                ]
            },
            "nome": "Prometheus",
            "descricao": "Prometheus",
            "datacadastro": "2021-08-08T13:11:47.908550-03:00",
            "capa": "/media/capas/prometheus-2012-movie-b58a5.jpg",
            "video": "/media/videos/Prometheus.2012.720p.BluRay.X264.YIFY.mp4",
            "duracao": "02:03:45",
            "publicado": true,
            "destaque": false,
            "visualizacao": 1,
            "clicado": 6,
            "relevancia": 0.0,
            "elenco": null
        },
        {
            "codigo": 1226,
            "Categoria": [
                {
                    "codigo": 2,
                    "nome": "Politica"
                }
            ],
            "Canal": {
                "codigo": 19,
                "User": {
                    "first_name": "Kim",
                    "last_name": "Paim",
                    "get_full_name": "Kim Paim",
                    "email": "kim@gmail.com",
                    "username": "kim@gmail.com",
                    "date_joined": "2021-03-26T18:34:58-03:00",
                    "last_login": "2021-08-12T11:10:17.730102-03:00",
                    "perfil": {
                        "User": 20,
                        "avatar": "/media/perfil/unnamed_tDdG0bf.jpg",
                        "autoplay": true,
                        "dark": false,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Kim Paim",
                "descricao": "Politica",
                "datacadastro": "2021-03-26T18:35:18-03:00",
                "capa": "/media/capas/unnamed_iu57SCB.jpg",
                "banner": "/media/banners/channels4_banner_vQSLoR6.jpg",
                "inscritos": 2,
                "facebook": "#",
                "twitter": "#",
                "googleplus": "#",
                "Categoria": [
                    2
                ]
            },
            "nome": "FORTALECIDO - Bolsonaro FEZ História + Judiciário e CPI Perdem Tração + Boa MARÉ Internacional",
            "descricao": "FORTALECIDO - Bolsonaro FEZ História + Judiciário e CPI Perdem Tração + Boa MARÉ Internacional",
            "datacadastro": "2021-08-08T12:19:27.700676-03:00",
            "capa": "/media/capas/yvAgsEzXiUg.jpg",
            "video": "/media/videos/FORTALECIDO_-_Bolsonaro_FEZ_Hist%C3%B3ria__Judici%C3%A1rio_e_CPI_Perdem_Tra%C3%A7%C3%A3o__Boa_MAR%C3%89_In_iFn8myK.mp4",
            "duracao": "00:59:56",
            "publicado": true,
            "destaque": false,
            "visualizacao": 1,
            "clicado": 3,
            "relevancia": 0.0,
            "elenco": null
        },
        {
            "codigo": 1225,
            "Categoria": [
                {
                    "codigo": 2,
                    "nome": "Politica"
                },
                {
                    "codigo": 3,
                    "nome": "Alta cultura"
                }
            ],
            "Canal": {
                "codigo": 3,
                "User": {
                    "first_name": "Flávio",
                    "last_name": "Morgteins",
                    "get_full_name": "Flávio Morgteins",
                    "email": "flavio@gmail.com",
                    "username": "flavio@gmail.com",
                    "date_joined": "2021-03-20T21:28:36-03:00",
                    "last_login": "2021-08-12T11:27:27.177877-03:00",
                    "perfil": {
                        "User": 5,
                        "avatar": "/media/perfil/maxresdefault.jpg",
                        "autoplay": true,
                        "dark": true,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Senso Incomum",
                "descricao": "Senso Incomum - Alta, média e baixa cultura.",
                "datacadastro": "2021-03-20T21:29:07-03:00",
                "capa": "/media/capas/unnamed.jpg",
                "banner": "/media/banners/channels4_banner_zOntAlG.jpg",
                "inscritos": 4,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    2,
                    3
                ]
            },
            "nome": "INFOWAR _ EPISÓDIO 3_4 - Os estudos sobre a narrativa",
            "descricao": "INFOWAR _ EPISÓDIO 3_4 - Os estudos sobre a narrativa",
            "datacadastro": "2021-08-07T21:17:39.457462-03:00",
            "capa": "/media/capas/6Gh8wDwRtSY.jpg",
            "video": "/media/videos/INFOWAR___EPIS%C3%93DIO_3_4_-_Os_estudos_sobre_a_narrativa-6Gh8wDwRtSY.mp4",
            "duracao": "00:35:20",
            "publicado": true,
            "destaque": false,
            "visualizacao": 2,
            "clicado": 2,
            "relevancia": 50.0,
            "elenco": null
        },
        {
            "codigo": 1224,
            "Categoria": [
                {
                    "codigo": 2,
                    "nome": "Politica"
                }
            ],
            "Canal": {
                "codigo": 19,
                "User": {
                    "first_name": "Kim",
                    "last_name": "Paim",
                    "get_full_name": "Kim Paim",
                    "email": "kim@gmail.com",
                    "username": "kim@gmail.com",
                    "date_joined": "2021-03-26T18:34:58-03:00",
                    "last_login": "2021-08-12T11:10:17.730102-03:00",
                    "perfil": {
                        "User": 20,
                        "avatar": "/media/perfil/unnamed_tDdG0bf.jpg",
                        "autoplay": true,
                        "dark": false,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Kim Paim",
                "descricao": "Politica",
                "datacadastro": "2021-03-26T18:35:18-03:00",
                "capa": "/media/capas/unnamed_iu57SCB.jpg",
                "banner": "/media/banners/channels4_banner_vQSLoR6.jpg",
                "inscritos": 2,
                "facebook": "#",
                "twitter": "#",
                "googleplus": "#",
                "Categoria": [
                    2
                ]
            },
            "nome": "Chora FUX - Aras NÃO VÊ Crime em Bolsonaro + PEC vai ao PLENÁRIO, Mas SERÁ Aprovada + O Trunfo de JB",
            "descricao": "Chora FUX - Aras NÃO VÊ Crime em Bolsonaro + PEC vai ao PLENÁRIO, Mas SERÁ Aprovada + O Trunfo de JB",
            "datacadastro": "2021-08-07T19:39:58.038185-03:00",
            "capa": "/media/capas/6C0uwrDnV9U.jpg",
            "video": "/media/videos/Chora_FUX_-_Aras_N%C3%83O_V%C3%8A_Crime_em_Bolsonaro__PEC_vai_ao_PLEN%C3%81RIO_Mas_SER%C3%81_Aprovada_yBO9XQO.mp4",
            "duracao": "00:58:52",
            "publicado": true,
            "destaque": false,
            "visualizacao": 2,
            "clicado": 5,
            "relevancia": 40.0,
            "elenco": null
        },
        {
            "codigo": 1223,
            "Categoria": [
                {
                    "codigo": 2,
                    "nome": "Politica"
                }
            ],
            "Canal": {
                "codigo": 20,
                "User": {
                    "first_name": "Marcelo",
                    "last_name": "Pontes",
                    "get_full_name": "Marcelo Pontes",
                    "email": "pontes@gmail.com",
                    "username": "pontes@gmail.com",
                    "date_joined": "2021-03-27T11:22:46-03:00",
                    "last_login": "2021-08-10T19:34:43.087071-03:00",
                    "perfil": {
                        "User": 21,
                        "avatar": "/media/perfil/unnamed_jhcVp22.jpg",
                        "autoplay": true,
                        "dark": true,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Verdade Politica",
                "descricao": "Politica",
                "datacadastro": "2021-03-27T11:23:38-03:00",
                "capa": "/media/capas/unnamed_157JBOr.jpg",
                "banner": "/media/banners/channels4_banner_eoRo9Fk.jpg",
                "inscritos": 1,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    2
                ]
            },
            "nome": "A CORDA ARREBENTOU - E AGORA",
            "descricao": "A CORDA ARREBENTOU - E AGORA",
            "datacadastro": "2021-08-07T18:26:49.752616-03:00",
            "capa": "/media/capas/qeQNqyXzSCo.jpg",
            "video": "/media/videos/A_CORDA_ARREBENTOU_-_E_AGORA-qeQNqyXzSCo.mp4",
            "duracao": "00:14:58",
            "publicado": true,
            "destaque": false,
            "visualizacao": 1,
            "clicado": 2,
            "relevancia": 50.0,
            "elenco": null
        },
        {
            "codigo": 1222,
            "Categoria": [
                {
                    "codigo": 13,
                    "nome": "Humor"
                }
            ],
            "Canal": {
                "codigo": 8,
                "User": {
                    "first_name": "Carl",
                    "last_name": "Tucson",
                    "get_full_name": "Carl Tucson",
                    "email": "fail@gmail.com",
                    "username": "fail@gmail.com",
                    "date_joined": "2021-04-08T14:56:13-03:00",
                    "last_login": "2021-08-07T15:19:26.063052-03:00",
                    "perfil": {
                        "User": 43,
                        "avatar": null,
                        "autoplay": true,
                        "dark": false,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Fail Army",
                "descricao": "--",
                "datacadastro": "2021-03-21T21:05:49-03:00",
                "capa": "/media/capas/unnamed_KtCLOKD.jpg",
                "banner": "/media/banners/channels4_banner_aVV1bXG.jpg",
                "inscritos": 0,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    13
                ]
            },
            "nome": "People Vs. Nature Fails - Taken Out By Wave _ FailArmy",
            "descricao": "People Vs. Nature Fails - Taken Out By Wave _ FailArmy",
            "datacadastro": "2021-08-07T15:21:45.870639-03:00",
            "capa": "/media/capas/OSgYQl6GZbU.jpg",
            "video": "/media/videos/People_Vs._Nature_Fails_-_Taken_Out_By_Wave___FailArmy-OSgYQl6GZbU.mp4",
            "duracao": "00:07:17",
            "publicado": true,
            "destaque": false,
            "visualizacao": 1,
            "clicado": 1,
            "relevancia": 0.0,
            "elenco": null
        },
        {
            "codigo": 1221,
            "Categoria": [
                {
                    "codigo": 5,
                    "nome": "Música"
                }
            ],
            "Canal": {
                "codigo": 12,
                "User": {
                    "first_name": "Tuomas",
                    "last_name": "Nightwish",
                    "get_full_name": "Tuomas Nightwish",
                    "email": "tuomas@gmail.com",
                    "username": "tuomas@gmail.com",
                    "date_joined": "2021-03-23T14:14:39-03:00",
                    "last_login": "2021-08-09T18:42:52.957066-03:00",
                    "perfil": {
                        "User": 13,
                        "avatar": "/media/perfil/unnamed_jghxhMX.jpg",
                        "autoplay": true,
                        "dark": true,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Nightwish",
                "descricao": "Nightwish",
                "datacadastro": "2021-03-23T14:15:05-03:00",
                "capa": "/media/capas/unnamed_Sms7U1q.jpg",
                "banner": "/media/banners/channels4_banner_0iU3vnu.jpg",
                "inscritos": 1,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    5
                ]
            },
            "nome": "Nightwish - Nemo (live @ Qstock, Oulu 30.7.2021)",
            "descricao": "Nightwish - Nemo (live @ Qstock, Oulu 30.7.2021)",
            "datacadastro": "2021-08-07T10:20:22.606875-03:00",
            "capa": "/media/capas/I_P_CL5eAPQ.jpg",
            "video": "/media/videos/Nightwish_-_Nemo_live__Qstock_Oulu_30.7.2021-I_P_CL5eAPQ.mp4",
            "duracao": "00:04:30",
            "publicado": true,
            "destaque": false,
            "visualizacao": 1,
            "clicado": 1,
            "relevancia": 0.0,
            "elenco": null
        },
        {
            "codigo": 1220,
            "Categoria": [
                {
                    "codigo": 5,
                    "nome": "Música"
                }
            ],
            "Canal": {
                "codigo": 12,
                "User": {
                    "first_name": "Tuomas",
                    "last_name": "Nightwish",
                    "get_full_name": "Tuomas Nightwish",
                    "email": "tuomas@gmail.com",
                    "username": "tuomas@gmail.com",
                    "date_joined": "2021-03-23T14:14:39-03:00",
                    "last_login": "2021-08-09T18:42:52.957066-03:00",
                    "perfil": {
                        "User": 13,
                        "avatar": "/media/perfil/unnamed_jghxhMX.jpg",
                        "autoplay": true,
                        "dark": true,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Nightwish",
                "descricao": "Nightwish",
                "datacadastro": "2021-03-23T14:15:05-03:00",
                "capa": "/media/capas/unnamed_Sms7U1q.jpg",
                "banner": "/media/banners/channels4_banner_0iU3vnu.jpg",
                "inscritos": 1,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    5
                ]
            },
            "nome": "Nightwish - Last Ride of the Day (live @ Qstock, Oulu 30.7.2021)",
            "descricao": "Nightwish - Last Ride of the Day (live @ Qstock, Oulu 30.7.2021)",
            "datacadastro": "2021-08-07T10:18:19.703362-03:00",
            "capa": "/media/capas/2021-08-07_10-17.png",
            "video": "/media/videos/Nightwish_-_Last_Ride_of_the_Day_live__Qstock_Oulu_30.7.2021-MEr2DayUXe4.mp4",
            "duracao": "00:04:29",
            "publicado": true,
            "destaque": false,
            "visualizacao": 1,
            "clicado": 2,
            "relevancia": 0.0,
            "elenco": null
        },
        {
            "codigo": 1219,
            "Categoria": [
                {
                    "codigo": 2,
                    "nome": "Politica"
                }
            ],
            "Canal": {
                "codigo": 34,
                "User": {
                    "first_name": "Jair",
                    "last_name": "Bolsonaro",
                    "get_full_name": "Jair Bolsonaro",
                    "email": "bolsonaro@gmail.com",
                    "username": "bolsonaro@gmail.com",
                    "date_joined": "2021-04-02T16:45:55-03:00",
                    "last_login": "2021-08-12T10:45:44.310983-03:00",
                    "perfil": {
                        "User": 36,
                        "avatar": "/media/perfil/unnamed_AYOqQAz.jpg",
                        "autoplay": true,
                        "dark": false,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Jair Bolsonaro",
                "descricao": "Politica",
                "datacadastro": "2021-04-02T16:46:26-03:00",
                "capa": "/media/capas/unnamed_20ELrQE.jpg",
                "banner": "/media/banners/channels4_banner_jXPeVaT.jpg",
                "inscritos": 1,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    2
                ]
            },
            "nome": "Foi tanto tapão de verdades do Bolsonaro que ninguém desgrudou o olho dele",
            "descricao": "Foi tanto tapão de verdades do Bolsonaro que ninguém desgrudou o olho dele",
            "datacadastro": "2021-08-07T10:16:51.378159-03:00",
            "capa": "/media/capas/lkBr31g3vSk.jpg",
            "video": "/media/videos/Foi_tanto_tap%C3%A3o_de_verdades_do_Bolsonaro_que_ningu%C3%A9m_desgrudou_o_olho_dele-lkBr31g3vSk.mp4",
            "duracao": "00:38:13",
            "publicado": true,
            "destaque": false,
            "visualizacao": 1,
            "clicado": 3,
            "relevancia": 33.33,
            "elenco": null
        },
        {
            "codigo": 1218,
            "Categoria": [
                {
                    "codigo": 2,
                    "nome": "Politica"
                },
                {
                    "codigo": 3,
                    "nome": "Alta cultura"
                }
            ],
            "Canal": {
                "codigo": 3,
                "User": {
                    "first_name": "Flávio",
                    "last_name": "Morgteins",
                    "get_full_name": "Flávio Morgteins",
                    "email": "flavio@gmail.com",
                    "username": "flavio@gmail.com",
                    "date_joined": "2021-03-20T21:28:36-03:00",
                    "last_login": "2021-08-12T11:27:27.177877-03:00",
                    "perfil": {
                        "User": 5,
                        "avatar": "/media/perfil/maxresdefault.jpg",
                        "autoplay": true,
                        "dark": true,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Senso Incomum",
                "descricao": "Senso Incomum - Alta, média e baixa cultura.",
                "datacadastro": "2021-03-20T21:29:07-03:00",
                "capa": "/media/capas/unnamed.jpg",
                "banner": "/media/banners/channels4_banner_zOntAlG.jpg",
                "inscritos": 4,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    2,
                    3
                ]
            },
            "nome": "INFOWAR _ EPISÓDIO 2_4 - O caso escola base - A maior manipulação da mídia.",
            "descricao": "INFOWAR _ EPISÓDIO 2_4 - O caso escola base - A maior manipulação da mídia.",
            "datacadastro": "2021-08-07T10:04:51.542569-03:00",
            "capa": "/media/capas/4N0-ArQd4H4.jpg",
            "video": "/media/videos/INFOWAR___EPIS%C3%93DIO_2_4_-_O_caso_escola_base_-_A_maior_manipula%C3%A7%C3%A3o_da_m%C3%ADdia.-4N0-ArQd4H4.mp4",
            "duracao": "01:07:30",
            "publicado": true,
            "destaque": false,
            "visualizacao": 2,
            "clicado": 7,
            "relevancia": 28.57,
            "elenco": null
        },
        {
            "codigo": 1217,
            "Categoria": [
                {
                    "codigo": 1,
                    "nome": "Aventura"
                },
                {
                    "codigo": 19,
                    "nome": "Filme ação"
                }
            ],
            "Canal": {
                "codigo": 47,
                "User": {
                    "first_name": "Tainara",
                    "last_name": "Dornel",
                    "get_full_name": "Tainara Dornel",
                    "email": "dornel.tainara@gmail.com",
                    "username": "dornel.tainara@gmail.com",
                    "date_joined": "2021-03-17T21:42:07-03:00",
                    "last_login": "2021-08-08T12:48:53.632826-03:00",
                    "perfil": {
                        "User": 3,
                        "avatar": "/media/perfil/2021-03-21_12-35_TYVRBTM.png",
                        "autoplay": true,
                        "dark": false,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Tainara Dornel",
                "descricao": "Welcome to my channel",
                "datacadastro": "2021-04-29T17:49:19.781463-03:00",
                "capa": "/media/perfil/2021-03-21_12-35_TYVRBTM.png",
                "banner": null,
                "inscritos": 0,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    1,
                    19
                ]
            },
            "nome": "Jungle Cruise - 2021",
            "descricao": "Jungle Cruise -2021",
            "datacadastro": "2021-08-06T22:59:07-03:00",
            "capa": "/media/capas/2148330.png",
            "video": "/media/videos/Jungle.Cruise.2021.1080p.WEBRip.x264.AAC5.1-YTS.MX.mp4",
            "duracao": "02:07:18",
            "publicado": true,
            "destaque": false,
            "visualizacao": 2,
            "clicado": 14,
            "relevancia": 14.29,
            "elenco": ""
        },
        {
            "codigo": 1216,
            "Categoria": [
                {
                    "codigo": 2,
                    "nome": "Politica"
                }
            ],
            "Canal": {
                "codigo": 20,
                "User": {
                    "first_name": "Marcelo",
                    "last_name": "Pontes",
                    "get_full_name": "Marcelo Pontes",
                    "email": "pontes@gmail.com",
                    "username": "pontes@gmail.com",
                    "date_joined": "2021-03-27T11:22:46-03:00",
                    "last_login": "2021-08-10T19:34:43.087071-03:00",
                    "perfil": {
                        "User": 21,
                        "avatar": "/media/perfil/unnamed_jhcVp22.jpg",
                        "autoplay": true,
                        "dark": true,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Verdade Politica",
                "descricao": "Politica",
                "datacadastro": "2021-03-27T11:23:38-03:00",
                "capa": "/media/capas/unnamed_157JBOr.jpg",
                "banner": "/media/banners/channels4_banner_eoRo9Fk.jpg",
                "inscritos": 1,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    2
                ]
            },
            "nome": "A 'BOMBA' que a MÍDIA evitou de publicar",
            "descricao": "A CPI da pandemia segue no picadeiro sem agradar o público e devido a falta de audiência abusa e vira caso de polícia.  \r\n\r\nPorém outra CPI pode surgir no Parlamento, uma CPI que buscará defender a nossa democracia contra os abusos de um sistema eletrônico e de um tribunal que tem muito a se explicar.",
            "datacadastro": "2021-08-06T21:53:58.100445-03:00",
            "capa": "/media/capas/2021-08-06_21-52.png",
            "video": "/media/videos/A_BOMBA_que_a_M%C3%8DDIA_evitou_de_publicar-tBt7ygg366M.mp4",
            "duracao": "00:14:31",
            "publicado": true,
            "destaque": false,
            "visualizacao": 3,
            "clicado": 4,
            "relevancia": 50.0,
            "elenco": null
        },
        {
            "codigo": 1215,
            "Categoria": [
                {
                    "codigo": 1,
                    "nome": "Aventura"
                },
                {
                    "codigo": 12,
                    "nome": "Natureza"
                },
                {
                    "codigo": 16,
                    "nome": "Viagens"
                }
            ],
            "Canal": {
                "codigo": 18,
                "User": {
                    "first_name": "Vanessa",
                    "last_name": "Cristina Kapper",
                    "get_full_name": "Vanessa Cristina Kapper",
                    "email": "kombi@gmail.com",
                    "username": "kombi@gmail.com",
                    "date_joined": "2021-03-25T21:00:41-03:00",
                    "last_login": "2021-08-11T13:51:36.377964-03:00",
                    "perfil": {
                        "User": 19,
                        "avatar": "/media/perfil/2021-03-25_22-15.png",
                        "autoplay": true,
                        "dark": true,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Por aí de Kombi",
                "descricao": "Por aí de Kombi",
                "datacadastro": "2021-03-25T21:03:41-03:00",
                "capa": "/media/capas/por_ae_kombi.jpg",
                "banner": "/media/banners/channels4_banner_9xrMVhx.jpg",
                "inscritos": 1,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    1,
                    12,
                    16
                ]
            },
            "nome": "A KOMBIHOME mais econômica do Brasil. Consumo de uma KOMBI carregada - Ep 03 Expedição Redescobrindo",
            "descricao": "Rodando por Santa Catarina com a nossa Kombi, aproveitamos para fazer o cálculo do consumo de gasolina, depois da instalação da Injeção Eletrônica Programável. O que vocês acharam da média?",
            "datacadastro": "2021-08-06T21:26:34.317870-03:00",
            "capa": "/media/capas/qefJnSUsrmA.jpg",
            "video": "/media/videos/A_KOMBIHOME_mais_econ%C3%B4mica_do_Brasil._Consumo_de_uma_KOMBI_carregada_-_Ep_03_Expe_SyyyJU9.mp4",
            "duracao": "00:12:06",
            "publicado": true,
            "destaque": false,
            "visualizacao": 1,
            "clicado": 1,
            "relevancia": 0.0,
            "elenco": null
        },
        {
            "codigo": 1214,
            "Categoria": [
                {
                    "codigo": 2,
                    "nome": "Politica"
                },
                {
                    "codigo": 3,
                    "nome": "Alta cultura"
                }
            ],
            "Canal": {
                "codigo": 3,
                "User": {
                    "first_name": "Flávio",
                    "last_name": "Morgteins",
                    "get_full_name": "Flávio Morgteins",
                    "email": "flavio@gmail.com",
                    "username": "flavio@gmail.com",
                    "date_joined": "2021-03-20T21:28:36-03:00",
                    "last_login": "2021-08-12T11:27:27.177877-03:00",
                    "perfil": {
                        "User": 5,
                        "avatar": "/media/perfil/maxresdefault.jpg",
                        "autoplay": true,
                        "dark": true,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Senso Incomum",
                "descricao": "Senso Incomum - Alta, média e baixa cultura.",
                "datacadastro": "2021-03-20T21:29:07-03:00",
                "capa": "/media/capas/unnamed.jpg",
                "banner": "/media/banners/channels4_banner_zOntAlG.jpg",
                "inscritos": 4,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    2,
                    3
                ]
            },
            "nome": "Primeiro o sigilo, depois as pernas - Com - Filipe G. Martins _ Live Senso Incomum #36#",
            "descricao": "Primeiro o sigilo, depois as pernas - Com - Filipe G. Martins _ Live Senso Incomum #36#",
            "datacadastro": "2021-08-06T12:32:14.474957-03:00",
            "capa": "/media/capas/FIIMURoLHVI.jpg",
            "video": "/media/videos/Primeiro_o_sigilo_depois_as_pernas_-_Com_-_Filipe_G._Martins___Live_Senso_Incomum_6vTKn1v.mp4",
            "duracao": "02:57:22",
            "publicado": true,
            "destaque": false,
            "visualizacao": 3,
            "clicado": 8,
            "relevancia": 25.0,
            "elenco": null
        },
        {
            "codigo": 1213,
            "Categoria": [
                {
                    "codigo": 2,
                    "nome": "Politica"
                }
            ],
            "Canal": {
                "codigo": 4,
                "User": {
                    "first_name": "Barbara",
                    "last_name": "Silva",
                    "get_full_name": "Barbara Silva",
                    "email": "barbara@gmail.com",
                    "username": "barbara@gmail.com",
                    "date_joined": "2021-03-21T10:09:30-03:00",
                    "last_login": "2021-08-12T10:38:14.754046-03:00",
                    "perfil": {
                        "User": 6,
                        "avatar": "/media/perfil/unnamed_1mw23bP.jpg",
                        "autoplay": true,
                        "dark": false,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Te Atualizei",
                "descricao": "O Canal que irá te atualizar sobre a política do Brasil",
                "datacadastro": "2021-03-21T10:09:51-03:00",
                "capa": "/media/capas/unnamed_zkfn2aV.jpg",
                "banner": "/media/banners/channels4_banner.jpg",
                "inscritos": 1,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    2
                ]
            },
            "nome": "Bolsonaro vs Eles. O último recado.",
            "descricao": "Nesse video vamos comentar os últimos acontecimentos e entender num bom português (ou mineires) o que foi que rolou e quem é o protagonista dessa história que tá fazendo a gente ficar com a sensação que tá perto do fim. Vídeo gigante, então separa a pipoca, fica confortável e bora lá.",
            "datacadastro": "2021-08-06T08:54:19.871489-03:00",
            "capa": "/media/capas/2021-08-06_08-51.png",
            "video": "/media/videos/Bolsonaro_vs_Eles._O_%C3%BAltimo_recado.-FgILW9OJzYI.mp4",
            "duracao": "00:34:09",
            "publicado": true,
            "destaque": false,
            "visualizacao": 2,
            "clicado": 2,
            "relevancia": 50.0,
            "elenco": null
        },
        {
            "codigo": 1212,
            "Categoria": [
                {
                    "codigo": 2,
                    "nome": "Politica"
                }
            ],
            "Canal": {
                "codigo": 5,
                "User": {
                    "first_name": "Paula",
                    "last_name": "Marisa",
                    "get_full_name": "Paula Marisa",
                    "email": "paula@gmail.com",
                    "username": "paula@gmail.com",
                    "date_joined": "2021-03-21T10:13:54-03:00",
                    "last_login": "2021-08-11T11:04:02.683933-03:00",
                    "perfil": {
                        "User": 7,
                        "avatar": "/media/perfil/ZmIPLsx5_400x400.jpg",
                        "autoplay": true,
                        "dark": false,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Paula Marisa",
                "descricao": "Paula Marisa Descriação Canal",
                "datacadastro": "2021-03-21T10:14:12-03:00",
                "capa": "/media/capas/ZmIPLsx5_400x400.jpg",
                "banner": "/media/banners/channels4_banner_1UHIUgi.jpg",
                "inscritos": 1,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    2
                ]
            },
            "nome": "Fux DECLAROU GUER.RA a Bolsonaro",
            "descricao": "Fux DECLAROU GUER.RA a Bolsonaro",
            "datacadastro": "2021-08-06T08:48:49.085919-03:00",
            "capa": "/media/capas/Hlq5YvF-Z6c.jpg",
            "video": "/media/videos/Fux_DECLAROU_GUER.RA_a_Bolsonaro-Hlq5YvF-Z6c.mp4",
            "duracao": "00:23:48",
            "publicado": true,
            "destaque": false,
            "visualizacao": 1,
            "clicado": 1,
            "relevancia": 0.0,
            "elenco": null
        },
        {
            "codigo": 1211,
            "Categoria": [
                {
                    "codigo": 1,
                    "nome": "Aventura"
                },
                {
                    "codigo": 12,
                    "nome": "Natureza"
                },
                {
                    "codigo": 16,
                    "nome": "Viagens"
                }
            ],
            "Canal": {
                "codigo": 18,
                "User": {
                    "first_name": "Vanessa",
                    "last_name": "Cristina Kapper",
                    "get_full_name": "Vanessa Cristina Kapper",
                    "email": "kombi@gmail.com",
                    "username": "kombi@gmail.com",
                    "date_joined": "2021-03-25T21:00:41-03:00",
                    "last_login": "2021-08-11T13:51:36.377964-03:00",
                    "perfil": {
                        "User": 19,
                        "avatar": "/media/perfil/2021-03-25_22-15.png",
                        "autoplay": true,
                        "dark": true,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Por aí de Kombi",
                "descricao": "Por aí de Kombi",
                "datacadastro": "2021-03-25T21:03:41-03:00",
                "capa": "/media/capas/por_ae_kombi.jpg",
                "banner": "/media/banners/channels4_banner_9xrMVhx.jpg",
                "inscritos": 1,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    1,
                    12,
                    16
                ]
            },
            "nome": "Cachorro no toboágua 😂",
            "descricao": "Cachorro no toboágua 😂",
            "datacadastro": "2021-08-06T08:44:15.328594-03:00",
            "capa": "/media/capas/JgXDS1pBH0U.jpg",
            "video": "/media/videos/Cachorro_no_tobo%C3%A1gua_-JgXDS1pBH0U.mp4",
            "duracao": "00:00:15",
            "publicado": true,
            "destaque": false,
            "visualizacao": 0,
            "clicado": 0,
            "relevancia": 0.0,
            "elenco": null
        },
        {
            "codigo": 1210,
            "Categoria": [
                {
                    "codigo": 2,
                    "nome": "Politica"
                },
                {
                    "codigo": 17,
                    "nome": "Jornal"
                }
            ],
            "Canal": {
                "codigo": 15,
                "User": {
                    "first_name": "Gustavo",
                    "last_name": "Gayer",
                    "get_full_name": "Gustavo Gayer",
                    "email": "gustavo@gmail.com",
                    "username": "gustavo@gmail.com",
                    "date_joined": "2021-03-25T16:01:16-03:00",
                    "last_login": "2021-08-05T18:02:54.552799-03:00",
                    "perfil": {
                        "User": 16,
                        "avatar": "/media/perfil/unnamed_8Hj9wtU.jpg",
                        "autoplay": true,
                        "dark": false,
                        "pix_nome": null,
                        "pix_cidade": null,
                        "pix_key": null,
                        "pix_cep": null,
                        "pix_valor": null
                    }
                },
                "nome": "Gustavo Gayer",
                "descricao": "Análise politica",
                "datacadastro": "2021-03-25T16:01:36-03:00",
                "capa": "/media/capas/unnamed_8Hj9wtU.jpg",
                "banner": "/media/banners/channels4_banner_PdjIjlD.jpg",
                "inscritos": 0,
                "facebook": null,
                "twitter": null,
                "googleplus": null,
                "Categoria": [
                    2,
                    17
                ]
            },
            "nome": "Barroso mostra seu lado racista - ' Negro de primeira linha'",
            "descricao": "Barroso mostra seu lado racista - ' Negro de primeira linha'",
            "datacadastro": "2021-08-05T18:03:53.708997-03:00",
            "capa": "/media/capas/2021-08-05_18-03.png",
            "video": "/media/videos/Barroso_mostra_seu_lado_racista_-__Negro_de_primeira_linha-N_qjC2_QxhY.mp4",
            "duracao": "00:03:23",
            "publicado": true,
            "destaque": false,
            "visualizacao": 1,
            "clicado": 3,
            "relevancia": 33.33,
            "elenco": null
        }
    ]);