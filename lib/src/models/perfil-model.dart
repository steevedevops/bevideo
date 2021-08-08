class PerfilModel {
  int user;
  String avatar;
  bool autoplay;
  bool dark;
  Null pixNome;
  Null pixCidade;
  Null pixKey;
  Null pixCep;
  Null pixValor;

  PerfilModel(
      {this.user,
      this.avatar,
      this.autoplay,
      this.dark,
      this.pixNome,
      this.pixCidade,
      this.pixKey,
      this.pixCep,
      this.pixValor});

  PerfilModel.fromJson(Map<String, dynamic> json) {
    user = json['User'];
    avatar = json['avatar'];
    autoplay = json['autoplay'];
    dark = json['dark'];
    pixNome = json['pix_nome'];
    pixCidade = json['pix_cidade'];
    pixKey = json['pix_key'];
    pixCep = json['pix_cep'];
    pixValor = json['pix_valor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['User'] = this.user;
    data['avatar'] = this.avatar;
    data['autoplay'] = this.autoplay;
    data['dark'] = this.dark;
    data['pix_nome'] = this.pixNome;
    data['pix_cidade'] = this.pixCidade;
    data['pix_key'] = this.pixKey;
    data['pix_cep'] = this.pixCep;
    data['pix_valor'] = this.pixValor;
    return data;
  }
}