import 'package:firebase_database/firebase_database.dart';
import 'package:bricktime/model/result.dart';
import 'dart:async';


/********************************************

    Getter et Setter des valeurs stockées
    dans l'arbre "results"

 **********************************************/

setInitialCompetitionResults(int year, List<Result> results) {

  print('DB : setInitialCompetitionResults : year='+year.toString()+", results.length="+results.length.toString());
  //EAST CONF

    FirebaseDatabase.instance.reference().child('results').child(year.toString()+'playoffs').child('firstround').child("ESerie1").update(
        {
          'date_first_game' : results[0].first_game_date.toString(),
          'teamA' : results[0].teamA,
          'teamB' : results[0].teamB,
          'winA' : results[0].scoreA,
          'winB' : results[0].scoreB,
        });

    FirebaseDatabase.instance.reference().child('results').child(year.toString()+'playoffs').child('firstround').child("ESerie2").update(
        {
          'date_first_game' : results[1].first_game_date.toString(),
          'teamA' : results[1].teamA,
          'teamB' : results[1].teamB,
          'winA' : results[1].scoreA,
          'winB' : results[1].scoreB,
        });

    FirebaseDatabase.instance.reference().child('results').child(year.toString()+'playoffs').child('firstround').child("ESerie3").update(
        {
          'date_first_game' : results[2].first_game_date.toString(),
          'teamA' : results[2].teamA,
          'teamB' : results[2].teamB,
          'winA' : results[2].scoreA,
          'winB' : results[2].scoreB,
        });

    FirebaseDatabase.instance.reference().child('results').child(year.toString()+'playoffs').child('firstround').child("ESerie4").update(
        {
          'date_first_game' : results[3].first_game_date.toString(),
          'teamA' : results[3].teamA,
          'teamB' : results[3].teamB,
          'winA' : results[3].scoreA,
          'winB' : results[3].scoreB,
        });

  //WEST CONF

    FirebaseDatabase.instance.reference().child('results').child(year.toString()+'playoffs').child('firstround').child("WSerie1").update(
        {
          'date_first_game' : results[4].first_game_date.toString(),
          'teamA' : results[4].teamA,
          'teamB' : results[4].teamB,
          'winA' : results[4].scoreA,
          'winB' : results[4].scoreB,
        });

    FirebaseDatabase.instance.reference().child('results').child(year.toString()+'playoffs').child('firstround').child("WSerie2").update(
        {
          'date_first_game' : results[5].first_game_date.toString(),
          'teamA' : results[5].teamA,
          'teamB' : results[5].teamB,
          'winA' : results[5].scoreA,
          'winB' : results[5].scoreB,
        });

    FirebaseDatabase.instance.reference().child('results').child(year.toString()+'playoffs').child('firstround').child("WSerie3").update(
        {
          'date_first_game' : results[6].first_game_date.toString(),
          'teamA' : results[6].teamA,
          'teamB' : results[6].teamB,
          'winA' : results[6].scoreA,
          'winB' : results[6].scoreB,
        });

    FirebaseDatabase.instance.reference().child('results').child(year.toString()+'playoffs').child('firstround').child("WSerie4").update(
        {
          'date_first_game' : results[7].first_game_date.toString(),
          'teamA' : results[7].teamA,
          'teamB' : results[7].teamB,
          'winA' : results[7].scoreA,
          'winB' : results[7].scoreB,
        });
}


removeCompetitionResults(year){

  FirebaseDatabase.instance.reference().child('results').child(year.toString()+'playoffs').remove();

}

Future<List<Result>> getResultsFromCompetition(int year) async {
  Completer<List<Result>> completer = new Completer<List<Result>>();

  FirebaseDatabase.instance
      .reference()
      .child("results")
      .child(year.toString()+"playoffs")
      .once()
      .then((DataSnapshot snapshot) {

    List<Result> results = new List();
    Map<dynamic, dynamic> competitionlevelSnap = snapshot.value;

    competitionlevelSnap.forEach((key, value) {
      Map<dynamic, dynamic> serielevelSnap = value;
      serielevelSnap.forEach((key1, value1) {
        results.add(new Result(
          teamA: value1['teamA'].toString(),
          teamB: value1['teamB'].toString(),
          scoreA: value1['winA'],
          scoreB: value1['winB'],
          first_game_date: DateTime.tryParse(value1['date_first_game']),
          competition_level: key.toString()+key1.toString(),
        ));
      });
    });

    results.sort((a,b) => b.first_game_date.compareTo(a.first_game_date));
    completer.complete(results);
  });
  return completer.future;
}
