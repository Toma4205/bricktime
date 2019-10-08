import 'package:flutter/material.dart';

class Result {
  final String teamA;
  final String teamB;
  final String competition_level;
  final double score_final;
  final int scoreA;
  final int scoreB;
  final DateTime first_game_date;

  Result({this.teamA, this.teamB, this.competition_level, this.score_final, this.scoreA, this.scoreB, this.first_game_date});
}
