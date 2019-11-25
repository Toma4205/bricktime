import 'package:flutter/material.dart';

class PlayerRealGameStats {
  final String game_id;
  final String labelDate;
  final int min;
  final int ast;
  final int pts;
  final int reb;
  final int stl;
  final int tov;
  final int blk;

  PlayerRealGameStats({this.game_id, this.labelDate, this.min, this.ast, this.pts, this.reb, this.stl, this.tov, this.blk});
}