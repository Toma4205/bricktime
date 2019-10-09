import 'package:firebase_database/firebase_database.dart';
import 'package:bricktime/model/user.dart';
import 'dart:async';

Future<List<String>> getTeams(String conference) async {
  Completer<List<String>> completer = new Completer<List<String>>();

  FirebaseDatabase.instance
      .reference()
      .child("teams")
      .once()
      .then((DataSnapshot snapshot) {

    List<String> teams = new List();
    Map<dynamic, dynamic> teamSnap = snapshot.value;

    teamSnap.forEach((key, value) {
      if(value['conference'] == conference){
        teams.add(value['city']);
      }
    });

    teams.sort();
    completer.complete(teams);
  });
  return completer.future;
}