import 'package:bricktime/model/result.dart';
import 'package:flutter/material.dart';


List<Result> results = [
  new Result(
    teamA: "Toronto Raptors",
    teamB: 'L.A Clippers',
    competition_level: "Conference Final",
    score_final: null,
    scoreA: 2,
    scoreB: 1,
    first_game_date: DateTime(2019,10,15,20,30),
  ),
  new Result(
    teamA: "Boston Celtics",
    teamB: "N.Y Knicks",
    competition_level: "Semi Conference Final",
    score_final: null,
    scoreA: 0,
    scoreB: 4,
    first_game_date: DateTime(2019,9,29,20,30),
  ),
  new Result(
    teamA: "Philadelphia 76ers",
    teamB: "Miami Heat",
    competition_level: "Semi Conference Final",
    score_final: null,
    scoreA: 4,
    scoreB: 1,
    first_game_date: DateTime(2019,9,5,20,30),
  ),
];