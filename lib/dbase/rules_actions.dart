import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:bricktime/model/points_rules.dart';


/********************************************

    Getter et Setter des valeurs stockées
    dans l'arbre "rules"

 **********************************************/

Future<List<PointsRules>> getPointsRules() async {
  Completer<List<PointsRules>> completer = new Completer<List<PointsRules>>();

  FirebaseDatabase.instance
      .reference()
      .child("rules")
      .child("playoffspredictions")
      .once()
      .then((DataSnapshot snapshot) {

    List<PointsRules> pointsRules = new List();
    Map<dynamic, dynamic> pointsRulesSnap = snapshot.value;

    pointsRulesSnap.forEach((key, value) {
      pointsRules.add(new PointsRules(
        level: key.toString(),
        good: value['good'],
        perfect: value['perfect']
      ));
    });
    //String actualPlayoffYear = snapshot.value['year_actual_playoff'].toString() ;
    pointsRules.sort((a,b) => b.level.compareTo(a.level)); //On aura l'ordre suivant : conffinal 3 / confsemifinal 2 / final 1 / firstround 0
    completer.complete(pointsRules);
  });
  return completer.future;
}

