import 'package:firebase_database/firebase_database.dart';
import 'package:bricktime/model/result.dart';
import 'package:bricktime/dbase/constantes_actions.dart';
import 'dart:async';

//Renvoie le gamepath du dessus dans la compétition
List _getLevelUpAndTeam(String gamePath){
  String actualLevel = gamePath.substring(0,gamePath.indexOf("/"));
  String actualConfSerie = gamePath.substring(gamePath.indexOf("/")+1,gamePath.length-1);
  String actualSerieNumber = gamePath.substring(gamePath.length-1);

  List levelAndTeamA = new List();

  if(actualLevel == "firstround"){
    levelAndTeamA.add("confsemifinal/"+actualConfSerie+(int.parse(actualSerieNumber) <= 2 ? "1" : "2"));
    levelAndTeamA.add(int.parse(actualSerieNumber)%2 == 1? "teamA" : "teamB"); //si serie 1 ou 3 alors TeamA
  }else if(actualLevel == "confsemifinal"){
    levelAndTeamA.add("conffinal/"+actualConfSerie+"1");
    levelAndTeamA.add(int.parse(actualSerieNumber) == 1? "teamA" : "teamB");
  }else if(actualLevel == "conffinal"){
    levelAndTeamA.add("final/Serie1");
    levelAndTeamA.add(actualConfSerie.substring(0,1) == "W"? "teamA" : "teamB"); //West teamA en finale
  }else{
    levelAndTeamA.add(null);
    levelAndTeamA.add(null);
  }
  return levelAndTeamA;
}

bool _isTeamA(String gamePath){
  String actualSerieNumber = gamePath.substring(gamePath.length-1);
  String actualConf = gamePath.substring(gamePath.indexOf("/"),gamePath.indexOf("/")+1);

  if(int.parse(actualSerieNumber) <=2){

  }else{

  }
}

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
          'definitive' : false,
        });

    FirebaseDatabase.instance.reference().child('results').child(year.toString()+'playoffs').child('firstround').child("ESerie2").update(
        {
          'date_first_game' : results[1].first_game_date.toString(),
          'teamA' : results[1].teamA,
          'teamB' : results[1].teamB,
          'winA' : results[1].scoreA,
          'winB' : results[1].scoreB,
          'definitive' : false,
        });

    FirebaseDatabase.instance.reference().child('results').child(year.toString()+'playoffs').child('firstround').child("ESerie3").update(
        {
          'date_first_game' : results[2].first_game_date.toString(),
          'teamA' : results[2].teamA,
          'teamB' : results[2].teamB,
          'winA' : results[2].scoreA,
          'winB' : results[2].scoreB,
          'definitive' : false,
        });

    FirebaseDatabase.instance.reference().child('results').child(year.toString()+'playoffs').child('firstround').child("ESerie4").update(
        {
          'date_first_game' : results[3].first_game_date.toString(),
          'teamA' : results[3].teamA,
          'teamB' : results[3].teamB,
          'winA' : results[3].scoreA,
          'winB' : results[3].scoreB,
          'definitive' : false,
        });

  //WEST CONF

    FirebaseDatabase.instance.reference().child('results').child(year.toString()+'playoffs').child('firstround').child("WSerie1").update(
        {
          'date_first_game' : results[4].first_game_date.toString(),
          'teamA' : results[4].teamA,
          'teamB' : results[4].teamB,
          'winA' : results[4].scoreA,
          'winB' : results[4].scoreB,
          'definitive' : false,
        });

    FirebaseDatabase.instance.reference().child('results').child(year.toString()+'playoffs').child('firstround').child("WSerie2").update(
        {
          'date_first_game' : results[5].first_game_date.toString(),
          'teamA' : results[5].teamA,
          'teamB' : results[5].teamB,
          'winA' : results[5].scoreA,
          'winB' : results[5].scoreB,
          'definitive' : false,
        });

    FirebaseDatabase.instance.reference().child('results').child(year.toString()+'playoffs').child('firstround').child("WSerie3").update(
        {
          'date_first_game' : results[6].first_game_date.toString(),
          'teamA' : results[6].teamA,
          'teamB' : results[6].teamB,
          'winA' : results[6].scoreA,
          'winB' : results[6].scoreB,
          'definitive' : false,
        });

    FirebaseDatabase.instance.reference().child('results').child(year.toString()+'playoffs').child('firstround').child("WSerie4").update(
        {
          'date_first_game' : results[7].first_game_date.toString(),
          'teamA' : results[7].teamA,
          'teamB' : results[7].teamB,
          'winA' : results[7].scoreA,
          'winB' : results[7].scoreB,
          'definitive' : false,
        });

    //CONF SEMI FINAL
    FirebaseDatabase.instance.reference().child('results').child(year.toString()+'playoffs').child('confsemifinal').child("ESerie1").update(
      {
        'date_first_game' : DateTime(results[7].first_game_date.year,12,31,20,00).toString(),
        'teamA' : null,
        'teamB' : null,
        'winA' : 0,
        'winB' : 0,
        'definitive' : false,
      });

    FirebaseDatabase.instance.reference().child('results').child(year.toString()+'playoffs').child('confsemifinal').child("ESerie2").update(
      {
        'date_first_game' : DateTime(results[7].first_game_date.year,12,31,20,00).toString(),
        'teamA' : null,
        'teamB' : null,
        'winA' : 0,
        'winB' : 0,
        'definitive' : false,
      });

    FirebaseDatabase.instance.reference().child('results').child(year.toString()+'playoffs').child('confsemifinal').child("WSerie1").update(
      {
        'date_first_game' : DateTime(results[7].first_game_date.year,12,31,20,00).toString(),
        'teamA' : null,
        'teamB' : null,
        'winA' : 0,
        'winB' : 0,
        'definitive' : false,
      });

    FirebaseDatabase.instance.reference().child('results').child(year.toString()+'playoffs').child('confsemifinal').child("WSerie2").update(
      {
        'date_first_game' : DateTime(results[7].first_game_date.year,12,31,20,00).toString(),
        'teamA' : null,
        'teamB' : null,
        'winA' : 0,
        'winB' : 0,
        'definitive' : false,
      });

    //CONF FINAL
    FirebaseDatabase.instance.reference().child('results').child(year.toString()+'playoffs').child('conffinal').child("ESerie1").update(
      {
        'date_first_game' : DateTime(results[7].first_game_date.year,12,31,20,00).toString(),
        'teamA' : null,
        'teamB' : null,
        'winA' : 0,
        'winB' : 0,
        'definitive' : false,
      });

    FirebaseDatabase.instance.reference().child('results').child(year.toString()+'playoffs').child('conffinal').child("WSerie1").update(
      {
        'date_first_game' : DateTime(results[7].first_game_date.year,12,31,20,00).toString(),
        'teamA' : null,
        'teamB' : null,
        'winA' : 0,
        'winB' : 0,
        'definitive' : false,
      });

    //FINAL
    FirebaseDatabase.instance.reference().child('results').child(year.toString()+'playoffs').child('final').child("Serie1").update(
      {
        'date_first_game' : DateTime(results[7].first_game_date.year,12,31,20,00).toString(),
        'teamA' : null,
        'teamB' : null,
        'winA' : 0,
        'winB' : 0,
        'definitive' : false,
      });
}

removeCompetitionResults(year){

  FirebaseDatabase.instance.reference().child('results').child(year.toString()+'playoffs').remove();

}

Future<List<Result>> getResultsFromCompetition(int year) async {
  Completer<List<Result>> completer = new Completer<List<Result>>();
  print("getResultsFromCompetition : "+year.toString());
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
          isDefinitive: value1['definitive'],
          first_game_date: DateTime.tryParse(value1['date_first_game']),
          competition_level: key.toString()+"/"+key1.toString(),
        ));
      });
    });

    results.sort((a,b) => b.first_game_date.compareTo(a.first_game_date));
    completer.complete(results);
  });
  return completer.future;
}

setResultToGame(int scoreA, int scoreB, String gamePath){
  getActualPlayoffYear().then((year){
    FirebaseDatabase.instance.reference().child('results').child(year+"playoffs").child(gamePath).update(
        {
          'winA' : scoreA,
          'winB' : scoreB,
        });
  });
}

setGoToNextSerie(String team, String gamePath){
  List nextGameInfo = _getLevelUpAndTeam(gamePath);
  if(nextGameInfo[0] != null){ //pas de niveau au dessus de la finale
    getActualPlayoffYear().then((year){
      if(nextGameInfo[1] == "teamA"){
        FirebaseDatabase.instance.reference().child('results').child(year+"playoffs").child(nextGameInfo[0]).update(
            {
              'teamA' : team,
            });
      }else{
        FirebaseDatabase.instance.reference().child('results').child(year+"playoffs").child(nextGameInfo[0]).update(
            {
              'teamB' : team,
            });
      }
    });
  }
}

setIsSerieDefinitive(String gamePath, bool status){
  getActualPlayoffYear().then((year){
      FirebaseDatabase.instance.reference().child('results').child(year+"playoffs").child(gamePath).update(
          {
            'definitive' : status,
          });
  });
}

//On vérifie que les TeamA et TeamB de la série du dessus sont complétées
Future<bool> isNextSerieOpen(String nextGamePath) async{
  String nextLevel = _getLevelUpAndTeam(nextGamePath).elementAt(0);
    Completer<bool> completer = new Completer<bool>();

    getActualPlayoffYear().then((year){
      FirebaseDatabase.instance
          .reference()
          .child("results")
          .child(year.toString()+"playoffs")
          .child(nextLevel)
          .once()
          .then((DataSnapshot snapshot) {

            bool isTeamA = snapshot.value['teamA'] != null;
            bool isTeamB = snapshot.value['teamB'] != null;
            completer.complete(isTeamA && isTeamB);
      });
    });

    return completer.future;
}

setDateLimit(String gamePath, DateTime date){
  List nextGameInfo = _getLevelUpAndTeam(gamePath);
  if(nextGameInfo[0] != null) {
    getActualPlayoffYear().then((year) {
      FirebaseDatabase.instance.reference().child('results').child(year + "playoffs").child(nextGameInfo[0]).update(
          {
            'date_first_game': date.toString(),
          });
    });
  }
}