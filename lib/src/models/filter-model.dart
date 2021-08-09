import 'package:flutter/material.dart';

class TypeFilterModel {
  String name;
  bool isActive;
  IconData icon;

  TypeFilterModel(
      {
      this.name,
      this.isActive,
      this.icon
    });

  TypeFilterModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    isActive = json['isActive'];
    icon = json['icon'];
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['isActive'] = this.isActive;
    return data;
  }
}