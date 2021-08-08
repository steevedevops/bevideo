import 'package:bevideo/src/models/perfil-model.dart';

class UserModel {
  String firstName;
  String lastName;
  String getFullName;
  String email;
  String username;
  String dateJoined;
  String lastLogin;
  PerfilModel perfil;

  UserModel(
      {this.firstName,
      this.lastName,
      this.getFullName,
      this.email,
      this.username,
      this.dateJoined,
      this.lastLogin,
      this.perfil});

  UserModel.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    getFullName = json['get_full_name'];
    email = json['email'];
    username = json['username'];
    dateJoined = json['date_joined'];
    lastLogin = json['last_login'];
    perfil =
        json['perfil'] != null ? new PerfilModel.fromJson(json['perfil']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['get_full_name'] = this.getFullName;
    data['email'] = this.email;
    data['username'] = this.username;
    data['date_joined'] = this.dateJoined;
    data['last_login'] = this.lastLogin;
    if (this.perfil != null) {
      data['perfil'] = this.perfil.toJson();
    }
    return data;
  }
}