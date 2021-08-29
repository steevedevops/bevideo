import 'package:bevideo/src/models/videos-model.dart';

class VideosDetailModel {
  VideosModel video;
  List<VideosModel> videosSimilares;
  List<VideosModel> videosOutros;

  VideosDetailModel({this.video, this.videosSimilares, this.videosOutros});

  VideosDetailModel.fromJson(Map<String, dynamic> json) {
    video = json['video'] != null ? new VideosModel.fromJson(json['video']) : null;
    if (json['videos_similares'] != null) {
      videosSimilares = new List<VideosModel>();
      json['videos_similares'].forEach((v) {
        videosSimilares.add(new VideosModel.fromJson(v));
      });
    }
    if (json['videos_outros'] != null) {
      videosOutros = new List<VideosModel>();
      json['videos_outros'].forEach((v) {
        videosOutros.add(new VideosModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.video != null) {
      data['video'] = this.video.toJson();
    }
    if (this.videosSimilares != null) {
      data['videos_similares'] =
          this.videosSimilares.map((v) => v.toJson()).toList();
    }
    if (this.videosOutros != null) {
      data['videos_outros'] = this.videosOutros.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class Video {
//   int codigo;
//   List<Categoria> categoria;
//   Canal canal;
//   String nome;
//   String descricao;
//   String datacadastro;
//   String capa;
//   String video;
//   String duracao;
//   bool publicado;
//   bool destaque;
//   int visualizacao;
//   int clicado;
//   int relevancia;
//   String elenco;
//   bool curtido;
//   bool descurtido;
//   bool vermaistarde;
//   bool denunciado;
//   int totalVideos;
//   int curtidas;
//   int descurtidas;
//   String categorias;
//   int tempolancamento;
//   String tempolancamentometrica;
//   List<Null> legendas;
//   List<Null> partes;
//   String linkShare;

//   Video(
//       {this.codigo,
//       this.categoria,
//       this.canal,
//       this.nome,
//       this.descricao,
//       this.datacadastro,
//       this.capa,
//       this.video,
//       this.duracao,
//       this.publicado,
//       this.destaque,
//       this.visualizacao,
//       this.clicado,
//       this.relevancia,
//       this.elenco,
//       this.curtido,
//       this.descurtido,
//       this.vermaistarde,
//       this.denunciado,
//       this.totalVideos,
//       this.curtidas,
//       this.descurtidas,
//       this.categorias,
//       this.tempolancamento,
//       this.tempolancamentometrica,
//       this.legendas,
//       this.partes,
//       this.linkShare});

//   Video.fromJson(Map<String, dynamic> json) {
//     codigo = json['codigo'];
//     if (json['Categoria'] != null) {
//       categoria = new List<Categoria>();
//       json['Categoria'].forEach((v) {
//         categoria.add(new Categoria.fromJson(v));
//       });
//     }
//     canal = json['Canal'] != null ? new Canal.fromJson(json['Canal']) : null;
//     nome = json['nome'];
//     descricao = json['descricao'];
//     datacadastro = json['datacadastro'];
//     capa = json['capa'];
//     video = json['video'];
//     duracao = json['duracao'];
//     publicado = json['publicado'];
//     destaque = json['destaque'];
//     visualizacao = json['visualizacao'];
//     clicado = json['clicado'];
//     relevancia = json['relevancia'];
//     elenco = json['elenco'];
//     curtido = json['curtido'];
//     descurtido = json['descurtido'];
//     vermaistarde = json['vermaistarde'];
//     denunciado = json['denunciado'];
//     totalVideos = json['total_videos'];
//     curtidas = json['curtidas'];
//     descurtidas = json['descurtidas'];
//     categorias = json['categorias'];
//     tempolancamento = json['tempolancamento'];
//     tempolancamentometrica = json['tempolancamentometrica'];
//     if (json['legendas'] != null) {
//       legendas = new List<Null>();
//       json['legendas'].forEach((v) {
//         legendas.add(new Null.fromJson(v));
//       });
//     }
//     if (json['partes'] != null) {
//       partes = new List<Null>();
//       json['partes'].forEach((v) {
//         partes.add(new Null.fromJson(v));
//       });
//     }
//     linkShare = json['link_share'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['codigo'] = this.codigo;
//     if (this.categoria != null) {
//       data['Categoria'] = this.categoria.map((v) => v.toJson()).toList();
//     }
//     if (this.canal != null) {
//       data['Canal'] = this.canal.toJson();
//     }
//     data['nome'] = this.nome;
//     data['descricao'] = this.descricao;
//     data['datacadastro'] = this.datacadastro;
//     data['capa'] = this.capa;
//     data['video'] = this.video;
//     data['duracao'] = this.duracao;
//     data['publicado'] = this.publicado;
//     data['destaque'] = this.destaque;
//     data['visualizacao'] = this.visualizacao;
//     data['clicado'] = this.clicado;
//     data['relevancia'] = this.relevancia;
//     data['elenco'] = this.elenco;
//     data['curtido'] = this.curtido;
//     data['descurtido'] = this.descurtido;
//     data['vermaistarde'] = this.vermaistarde;
//     data['denunciado'] = this.denunciado;
//     data['total_videos'] = this.totalVideos;
//     data['curtidas'] = this.curtidas;
//     data['descurtidas'] = this.descurtidas;
//     data['categorias'] = this.categorias;
//     data['tempolancamento'] = this.tempolancamento;
//     data['tempolancamentometrica'] = this.tempolancamentometrica;
//     if (this.legendas != null) {
//       data['legendas'] = this.legendas.map((v) => v.toJson()).toList();
//     }
//     if (this.partes != null) {
//       data['partes'] = this.partes.map((v) => v.toJson()).toList();
//     }
//     data['link_share'] = this.linkShare;
//     return data;
//   }
// }

// class Categoria {
//   int codigo;
//   String nome;

//   Categoria({this.codigo, this.nome});

//   Categoria.fromJson(Map<String, dynamic> json) {
//     codigo = json['codigo'];
//     nome = json['nome'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['codigo'] = this.codigo;
//     data['nome'] = this.nome;
//     return data;
//   }
// }
