import 'package:firebase_database/firebase_database.dart';
import 'package:bricktime/model/user.dart';
import 'dart:async';

Future<String> getActualPlayoffYear() async {
  Completer<String> completer = new Completer<String>();

  FirebaseDatabase.instance
      .reference()
      .child("constantes")
      .once()
      .then((DataSnapshot snapshot) {

        String actualPlayoffYear = snapshot.value['year_actual_playoff'].toString() ;
        completer.complete(actualPlayoffYear);
  });
  return completer.future;
}

Future<String> getAdminId() async {
  Completer<String> completer = new Completer<String>();

  FirebaseDatabase.instance
      .reference()
      .child("constantes")
      .once()
      .then((DataSnapshot snapshot) {

    String adminId = snapshot.value['admin_id'].toString() ;
    completer.complete(adminId);
  });
  return completer.future;
}