import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

Future<String> getImage(String imageFile) async {
  Completer<String> completer = new Completer<String>();

  final ref = FirebaseStorage.instance.ref().child(imageFile);
  String url = await ref.getDownloadURL();

  completer.complete(url);
  return completer.future;
}

Future<List<String>> getAllPicURL() async {
  Completer<List<String>> completer = new Completer<List<String>>();

  FirebaseDatabase.instance
      .reference()
      .child("teams")
      .once()
      .then((DataSnapshot snapshot) {

    List<String> teams = new List();
    Map<dynamic, dynamic> teamSnap = snapshot.value;

    teamSnap.forEach((key, value) async {
      getImage(key.toString().toLowerCase()).then((team){
        teams.add(team);
      });
    });
    teams.sort();
    completer.complete(teams);
  });
  return completer.future;
}

