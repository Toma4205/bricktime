import 'package:flutter/material.dart';
import 'package:bricktime/model/player_real_game_stats.dart';
import 'package:bricktime/model/player_fantasy_game_stats.dart';

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
  final String position;
  final List<PlayerRealGameStats> list_games_real_stats;
  final List<PlayerFantasyGameStats> list_games_fantasy_stats;
  final PlayerRealGameStats last_game_real_stats;
  final PlayerFantasyGameStats last_game_fantasy_stats;

  Player({this.id, this.first_name, this.last_name, this.short_name, this.teamId, this.teamAbrev, this.teamCity, this.teamName, this.teamConf, this.position, this.list_games_real_stats, this.list_games_fantasy_stats, this.last_game_real_stats, this.last_game_fantasy_stats});
}