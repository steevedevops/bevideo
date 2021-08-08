import 'user-model.dart';

class CanaisModel {
  int codigo;
  UserModel user;
  String nome;
  String descricao;
  String datacadastro;
  String capa;
  String banner;
  int inscritos;
  String facebook;
  String twitter;
  String googleplus;
  List<int> categoria;

  CanaisModel(
      {this.codigo,
      this.user,
      this.nome,
      this.descricao,
      this.datacadastro,
      this.capa,
      this.banner,
      this.inscritos,
      this.facebook,
      this.twitter,
      this.googleplus,
      this.categoria});

  CanaisModel.fromJson(Map<String, dynamic> json) {
    codigo = json['codigo'];
    user = json['User'] != null ? new UserModel.fromJson(json['User']) : null;
    nome = json['nome'];
    descricao = json['descricao'];
    datacadastro = json['datacadastro'];
    capa = json['capa'];
    banner = json['banner'];
    inscritos = json['inscritos'];
    facebook = json['facebook'];
    twitter = json['twitter'];
    googleplus = json['googleplus'];
    categoria = json['Categoria'].cast<int>();
  }

  static List<CanaisModel> fromJsonList(jsonList) {
    return jsonList.map<CanaisModel>((obj) => CanaisModel.fromJson(obj)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    if (this.user != null) {
      data['User'] = this.user.toJson();
    }
    data['nome'] = this.nome;
    data['descricao'] = this.descricao;
    data['datacadastro'] = this.datacadastro;
    data['capa'] = this.capa;
    data['banner'] = this.banner;
    data['inscritos'] = this.inscritos;
    data['facebook'] = this.facebook;
    data['twitter'] = this.twitter;
    data['googleplus'] = this.googleplus;
    data['Categoria'] = this.categoria;
    return data;
  }
}