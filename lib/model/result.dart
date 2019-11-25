import 'package:flutter/material.dart';
import 'package:bricktime/model/player.dart';

class Result {
  final String teamA;
  final String teamB;
  final String competition_level;
  final bool isDefinitive;
  final int scoreA;
  final int scoreB;
  final DateTime first_game_date;
  final String status;
  final List<Player> squadA;
  final List<Player> squadB;

  Result({this.teamA, this.teamB, this.competition_level, this.isDefinitive, this.scoreA, this.scoreB, this.first_game_date, this.status, this.squadA, this.squadB});
}
