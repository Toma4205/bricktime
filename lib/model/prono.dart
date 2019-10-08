import 'package:flutter/material.dart';

class Prono {
  final String teamA;
  final String teamB;
  final String competition_level;
  final double score;
  final Color color;
  final bool completed;
  final DateTime date_limit;

  Prono({this.teamA, this.teamB, this.competition_level, this.score, this.color, this.completed, this.date_limit});
}
