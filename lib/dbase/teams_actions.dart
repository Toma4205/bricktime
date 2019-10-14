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
        teams.add(key);
      }
    });

    teams.sort();
    completer.complete(teams);
  });
  return completer.future;
}

Future<String> getTeamCity(String id) async {
  Completer<String> completer = new Completer<String>();

  FirebaseDatabase.instance
      .reference()
      .child("teams")
      .child(id)
      .child("city")
      .once()
      .then((DataSnapshot snapshot) {


        completer.complete(snapshot.value.toString());
        print("return : "+snapshot.value.toString());
  });
  return completer.future;
}

Future<List<String>> getTeamsCities(String idA, String idB) async {

  Completer<List<String>> completer = new Completer<List<String>>();

  String cityA, cityB;

  getTeamCity(idA).then((city) => cityA = city);
  getTeamCity(idB).then((city) => cityB = city);

  List<String> cities = new List();
  cities.add(cityA);
  cities.add(cityB);

  completer.complete(cities);
  return completer.future;
}