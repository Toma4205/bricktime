import 'package:firebase_database/firebase_database.dart';
import 'package:bricktime/model/user.dart';
import 'dart:async';


/********************************************

    Getter et Setter des valeurs stockées
    dans l'arbre "constantes"

**********************************************/


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

setActualPlayoffYear(int year) {
  FirebaseDatabase.instance.reference().child('constantes').update(
      {
        'year_actual_playoff': year,
      });
}

Future<String> getRealNBAStartDate() async {
  Completer<String> completer = new Completer<String>();

  FirebaseDatabase.instance
      .reference()
      .child("constantes")
      .once()
      .then((DataSnapshot snapshot) {

    String realNBAStartDate = snapshot.value['start_date'].toString() ;
    completer.complete(realNBAStartDate);
  });
  return completer.future;
}

setRealNBAStartDate(DateTime date) {
  FirebaseDatabase.instance.reference().child('constantes').update(
      {
        'start_date': date.toString(),
      });
}

Future<String> getRealNBAEndDate() async {
  Completer<String> completer = new Completer<String>();

  FirebaseDatabase.instance
      .reference()
      .child("constantes")
      .once()
      .then((DataSnapshot snapshot) {

    String realNBAEndDate = snapshot.value['end_date'].toString() ;
    completer.complete(realNBAEndDate);
  });
  return completer.future;
}

setRealNBAEndDate(DateTime date) {
  FirebaseDatabase.instance.reference().child('constantes').update(
      {
        'end_date': date.toString(),
      });
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

Future<bool> isCompetitionInProgress() async{
  Completer<bool> completer = new Completer<bool>();

  FirebaseDatabase.instance
      .reference()
      .child("constantes")
      .once()
      .then((DataSnapshot snapshot) {

    bool isInProgress = snapshot.value['is_competition_in_progress'] ;

    completer.complete(isInProgress);
  });
  return completer.future;
}

setIsCompetitionInProgress(bool status) {
  FirebaseDatabase.instance.reference().child('constantes').update(
      {
        'is_competition_in_progress': status,
      });
}