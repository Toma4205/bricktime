import 'package:firebase_database/firebase_database.dart';
import 'package:bricktime/model/result.dart';
import 'package:bricktime/model/prono.dart';
import 'package:bricktime/dbase/constantes_actions.dart';
import 'package:bricktime/dbase/teams_actions.dart';
import 'dart:async';

/********************************************

    Getter et Setter des valeurs stockées
    dans l'arbre "results"

 **********************************************/

setInitialCompetitionPronos(int year, List<Result> results) {

  FirebaseDatabase.instance
      .reference()
      .child("users")
      .once()
      .then((DataSnapshot snapshot) {

    Map<dynamic, dynamic> usersSnap = snapshot.value;
    usersSnap.forEach((key, value) {
      setInitialCompetitionPronosForUser(key, results, year);
    });
  });
}

setInitialCompetitionPronosForUser(String id, List<Result> results, int year){
  int initScore = 4; //4 correspond à Waiting for decision

  FirebaseDatabase.instance.reference().child('users').child(id).child('pronos').child(year.toString()+'playoffs').child('firstround').child("ESerie1").update(
      {
        'date_first_game' : results[0].first_game_date.toString(),
        'teamA' : results[0].teamA,
        'teamB' : results[0].teamB,
        'winA' : results[0].scoreA,
        'winB' : results[0].scoreB,
        'completed' : false,
        'points' : 0,
        'score' : initScore,
      });

  FirebaseDatabase.instance.reference().child('users').child(id).child('pronos').child(year.toString()+'playoffs').child('firstround').child("ESerie2").update(
      {
        'date_first_game' : results[1].first_game_date.toString(),
        'teamA' : results[1].teamA,
        'teamB' : results[1].teamB,
        'winA' : results[1].scoreA,
        'winB' : results[1].scoreB,
        'completed' : false,
        'points' : 0,
        'score' : initScore,
      });

  FirebaseDatabase.instance.reference().child('users').child(id).child('pronos').child(year.toString()+'playoffs').child('firstround').child("ESerie3").update(
      {
        'date_first_game' : results[2].first_game_date.toString(),
        'teamA' : results[2].teamA,
        'teamB' : results[2].teamB,
        'winA' : results[2].scoreA,
        'winB' : results[2].scoreB,
        'completed' : false,
        'points' : 0,
        'score' : initScore,
      });

  FirebaseDatabase.instance.reference().child('users').child(id).child('pronos').child(year.toString()+'playoffs').child('firstround').child("ESerie4").update(
      {
        'date_first_game' : results[3].first_game_date.toString(),
        'teamA' : results[3].teamA,
        'teamB' : results[3].teamB,
        'winA' : results[3].scoreA,
        'winB' : results[3].scoreB,
        'completed' : false,
        'points' : 0,
        'score' : initScore,
      });

  //WEST CONF

  FirebaseDatabase.instance.reference().child('users').child(id).child('pronos').child(year.toString()+'playoffs').child('firstround').child("WSerie1").update(
      {
        'date_first_game' : results[4].first_game_date.toString(),
        'teamA' : results[4].teamA,
        'teamB' : results[4].teamB,
        'winA' : results[4].scoreA,
        'winB' : results[4].scoreB,
        'completed' : false,
        'points' : 0,
        'score' : initScore,
      });

  FirebaseDatabase.instance.reference().child('users').child(id).child('pronos').child(year.toString()+'playoffs').child('firstround').child("WSerie2").update(
      {
        'date_first_game' : results[5].first_game_date.toString(),
        'teamA' : results[5].teamA,
        'teamB' : results[5].teamB,
        'winA' : results[5].scoreA,
        'winB' : results[5].scoreB,
        'completed' : false,
        'points' : 0,
        'score' : initScore,
      });

  FirebaseDatabase.instance.reference().child('users').child(id).child('pronos').child(year.toString()+'playoffs').child('firstround').child("WSerie3").update(
      {
        'date_first_game' : results[6].first_game_date.toString(),
        'teamA' : results[6].teamA,
        'teamB' : results[6].teamB,
        'winA' : results[6].scoreA,
        'winB' : results[6].scoreB,
        'completed' : false,
        'points' : 0,
        'score' : initScore,
      });

  FirebaseDatabase.instance.reference().child('users').child(id).child('pronos').child(year.toString()+'playoffs').child('firstround').child("WSerie4").update(
      {
        'date_first_game' : results[7].first_game_date.toString(),
        'teamA' : results[7].teamA,
        'teamB' : results[7].teamB,
        'winA' : results[7].scoreA,
        'winB' : results[7].scoreB,
        'completed' : false,
        'points' : 0,
        'score' : initScore,
      });

  //CONF SEMI FINAL
  FirebaseDatabase.instance.reference().child('users').child(id).child('pronos').child(year.toString()+'playoffs').child('confsemifinal').child("ESerie1").update(
      {
        'date_first_game' : DateTime(results[7].first_game_date.year,12,31,20,00).toString(),
        'teamA' : null,
        'teamB' : null,
        'winA' : 0,
        'winB' : 0,
        'completed' : false,
        'points' : 0,
        'score' : initScore,
      });

  FirebaseDatabase.instance.reference().child('users').child(id).child('pronos').child(year.toString()+'playoffs').child('confsemifinal').child("ESerie2").update(
      {
        'date_first_game' : DateTime(results[7].first_game_date.year,12,31,20,00).toString(),
        'teamA' : null,
        'teamB' : null,
        'winA' : 0,
        'winB' : 0,
        'completed' : false,
        'points' : 0,
        'score' : initScore,
      });

  FirebaseDatabase.instance.reference().child('users').child(id).child('pronos').child(year.toString()+'playoffs').child('confsemifinal').child("WSerie1").update(
      {
        'date_first_game' : DateTime(results[7].first_game_date.year,12,31,20,00).toString(),
        'teamA' : null,
        'teamB' : null,
        'winA' : 0,
        'winB' : 0,
        'completed' : false,
        'points' : 0,
        'score' : initScore,
      });

  FirebaseDatabase.instance.reference().child('users').child(id).child('pronos').child(year.toString()+'playoffs').child('confsemifinal').child("WSerie2").update(
      {
        'date_first_game' : DateTime(results[7].first_game_date.year,12,31,20,00).toString(),
        'teamA' : null,
        'teamB' : null,
        'winA' : 0,
        'winB' : 0,
        'completed' : false,
        'points' : 0,
        'score' : initScore,
      });

  //CONF FINAL
  FirebaseDatabase.instance.reference().child('users').child(id).child('pronos').child(year.toString()+'playoffs').child('conffinal').child("ESerie1").update(
      {
        'date_first_game' : DateTime(results[7].first_game_date.year,12,31,20,00).toString(),
        'teamA' : null,
        'teamB' : null,
        'winA' : 0,
        'winB' : 0,
        'completed' : false,
        'points' : 0,
        'score' : initScore,
      });

  FirebaseDatabase.instance.reference().child('users').child(id).child('pronos').child(year.toString()+'playoffs').child('conffinal').child("WSerie1").update(
      {
        'date_first_game' : DateTime(results[7].first_game_date.year,12,31,20,00).toString(),
        'teamA' : null,
        'teamB' : null,
        'winA' : 0,
        'winB' : 0,
        'completed' : false,
        'points' : 0,
        'score' : initScore,
      });

  //FINAL
  FirebaseDatabase.instance.reference().child('users').child(id).child('pronos').child(year.toString()+'playoffs').child('final').child("Serie1").update(
      {
        'date_first_game' : DateTime(results[7].first_game_date.year,12,31,20,00).toString(),
        'teamA' : null,
        'teamB' : null,
        'winA' : 0,
        'winB' : 0,
        'completed' : false,
        'points' : 0,
        'score' : initScore,
      });
}

removeCompetitionPronos(int year){
  FirebaseDatabase.instance
      .reference()
      .child("users")
      .once()
      .then((DataSnapshot snapshot) {

    Map<dynamic, dynamic> usersSnap = snapshot.value;
    usersSnap.forEach((key, value) {
      removeCompetitionPronosForUser(key, year);
    });
  });
}

removeCompetitionPronosForUser(String id, int year){

  FirebaseDatabase.instance.reference().child('results').child(year.toString()+'playoffs').remove();

}

Future<List<Prono>> getPronoFromCompetitionForUser(String id, int year) async {
  Completer<List<Prono>> completer = new Completer<List<Prono>>();
  print("getPronoFromCompetitionForUser : "+year.toString());
  FirebaseDatabase.instance
      .reference()
      .child("users")
      .child(id)
      .child('pronos')
      .child(year.toString()+"playoffs")
      .once()
      .then((DataSnapshot snapshot) {

    List<Prono> pronos = new List();
    Map<dynamic, dynamic> competitionlevelSnap = snapshot.value;

    competitionlevelSnap.forEach((key, value) {
      Map<dynamic, dynamic> serielevelSnap = value;
      serielevelSnap.forEach((key1, value1) {
        pronos.add(new Prono(
          teamA: value1['teamA'].toString(),
          teamB: value1['teamB'].toString(),
          winA: value1['winA'],
          winB: value1['winB'],
          score: value1['score'],
          points: value1['points'],
          completed: value1['completed'],
          competition_level: key.toString()+"/"+key1.toString(),
          date_limit: DateTime.tryParse(value1['date_first_game']),));

      });
    });

    pronos.sort((a,b) => b.date_limit.compareTo(a.date_limit));
    print("Length : "+pronos.length.toString());
    completer.complete(pronos);
  });
  return completer.future;
}

setPronoFromSliderForUser(String id, int score, String pathGame){
  getActualPlayoffYear().then((year) {
    FirebaseDatabase.instance.reference().child('users').child(id).child('pronos').child(year.toString()+'playoffs').child(pathGame).update(
        {
          'score' : score,
        });
  });
}