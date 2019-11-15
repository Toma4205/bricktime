import 'package:flutter/material.dart';
import 'package:bricktime/model/record.dart';

class User {
  User({this.id, this.pseudo, this.level, this.lastConnexion, this.records, this.avatar});

  String id;
  String pseudo;
  String level;
  String lastConnexion;
  List<Record> records;
  String avatar;
}