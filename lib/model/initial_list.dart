import 'package:bricktime/model/prono.dart';
import 'package:flutter/material.dart';


List<Prono> pronos = [
  new Prono(
      teamA: "Toronto Raptors",
      teamB: 'L.A Clippers',
      competition_level: "Conference Final",
      score: 7,
      color: Colors.deepOrange,
      completed: false,
      date_limit: DateTime(2019,10,15,20,30),
      ),
  new Prono(
      teamA: "Boston Celtics",
      teamB: "N.Y Knicks",
      competition_level: "Semi Conference Final",
      score: 1,
      color: Colors.deepOrange,
      completed: true,
      date_limit: DateTime(2019,9,29,20,30),
    ),
  new Prono(
      teamA: "Boston Celtics",
      teamB: "N.Y Knicks",
      competition_level: "Semi Conference Final",
      score: 5,
      color: Colors.deepOrange,
      completed: true,
      date_limit: DateTime(2019,9,5,20,30),
    ),
];