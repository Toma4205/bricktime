import 'package:flutter/material.dart';
import 'package:bricktime/model/player_real_game_stats.dart';
import 'package:bricktime/model/player_fantasy_game_stats.dart';
import 'package:bricktime/model/user.dart';

class Player {
  final String id;
  final String first_name;
  final String last_name;
  final String short_name;
  final String teamId;
  final String teamAbrev;
  final String teamCity;
  final String teamName;
  final String teamConf;
  String position;
   int num_poste; //1, 2 , 3 , 4 ou 5
  String rotation; //stater, sub ou waterboy
   int minute;
  final int price;
  final User owner;
  final List<PlayerRealGameStats> list_games_real_stats;
  final List<PlayerFantasyGameStats> list_games_fantasy_stats;
  final PlayerRealGameStats last_game_real_stats;
  final PlayerFantasyGameStats last_game_fantasy_stats;

  Player({this.id, this.first_name, this.last_name, this.short_name, this.teamId, this.teamAbrev, this.teamCity, this.teamName, this.teamConf, this.position, this.num_poste, this.rotation, this.minute, this.price, this.owner, this.list_games_real_stats, this.list_games_fantasy_stats, this.last_game_real_stats, this.last_game_fantasy_stats});
}
