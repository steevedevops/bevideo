import 'package:bevideo/src/models/canais-model.dart';
import 'package:bevideo/src/models/categorias-model.dart';

class VideosModel {
  int codigo;
  List<CategoriaModel> categoria;
  CanaisModel canal;
  String nome;
  String descricao;
  String datacadastro;
  String capa;
  String video;
  String duracao;
  bool publicado;
  bool destaque;
  int visualizacao;
  int clicado;
  double relevancia;
  String elenco;
  bool curtido;
  bool descurtido;
  int curtidas;
  int descurtidas;

  VideosModel(
      {this.codigo,
      this.categoria,
      this.canal,
      this.nome,
      this.descricao,
      this.datacadastro,
      this.capa,
      this.video,
      this.duracao,
      this.publicado,
      this.destaque,
      this.visualizacao,
      this.clicado,
      this.relevancia,
      this.curtido,
      this.descurtido,
      this.curtidas,
      this.descurtidas,
      this.elenco});

  VideosModel.fromJson(Map<String, dynamic> json) {
    codigo = json['codigo'];
    if (json['Categoria'] != null) {
      categoria = new List<CategoriaModel>();
      json['Categoria'].forEach((v) {
        categoria.add(new CategoriaModel.fromJson(v));
      });
    }
    canal = json['Canal'] != null ? new CanaisModel.fromJson(json['Canal']) : null;
    nome = json['nome'];
    descricao = json['descricao'];
    datacadastro = json['datacadastro'];
    capa = json['capa'];
    video = json['video'];
    duracao = json['duracao'];
    publicado = json['publicado'];
    destaque = json['destaque'];
    visualizacao = json['visualizacao'];
    clicado = json['clicado'];
    relevancia = json['relevancia'];
    curtido = json['curtido'];
    descurtido = json['descurtido'];
    curtidas = json['curtidas'];
    descurtidas = json['descurtidas'];
    elenco = json['elenco'];
  }

  static List<VideosModel> fromJsonList(jsonList) {
    return jsonList.map<VideosModel>((obj) => VideosModel.fromJson(obj)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    if (this.categoria != null) {
      data['Categoria'] = this.categoria.map((v) => v.toJson()).toList();
    }
    if (this.canal != null) {
      data['Canal'] = this.canal.toJson();
    }
    data['nome'] = this.nome;
    data['descricao'] = this.descricao;
    data['datacadastro'] = this.datacadastro;
    data['capa'] = this.capa;
    data['video'] = this.video;
    data['duracao'] = this.duracao;
    data['publicado'] = this.publicado;
    data['destaque'] = this.destaque;
    data['visualizacao'] = this.visualizacao;
    data['clicado'] = this.clicado;
    data['relevancia'] = this.relevancia;
    data['descurtido'] = this.descurtido;
    data['curtido'] = this.curtido;
    data['elenco'] = this.elenco;
    data['curtidas'] = this.curtidas;
    data['descurtidas'] = this.descurtidas;
    return data;
  }
}
