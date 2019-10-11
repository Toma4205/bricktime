import 'package:bricktime/model/result.dart';
import 'package:bricktime/dbase/results_actions.dart';
import 'package:bricktime/dbase/constantes_actions.dart';
import 'package:flutter/material.dart';



//Cette fonction retourne une liste de 8 Results dans l'ordre suivant :
// 1er Est vs 8eme Est
// 2eme Est vs 7eme Est
// ...
// 1er West vs 8eme West
// 2eme West vs 7eme West
// ...
// 4eme West vs 5eme West

List<Result> modelInitAdminForm(int year, List<String> selectedEast, List<String> selectedWest, List<DateTime> deadlines){
  List<Result> listResults = new List();
  int i = 0;

  deadlines.forEach((time){
    listResults.add(new Result(
      teamA: i > 3 ? selectedWest[i%4] : selectedEast[i],
      teamB: i > 3 ? selectedWest[7-(i%4)] : selectedEast[7-i],
      scoreA: 0,
      scoreB: 0,
      score_final: 4,
      first_game_date: time
    ));
    i++;
  });

  setInitialCompetitionResults(year, listResults);
  setIsCompetitionInProgress(true);

  return listResults;
}


deleteCompetition(int year){

  removeCompetitionResults(year);
  setIsCompetitionInProgress(false);
}
