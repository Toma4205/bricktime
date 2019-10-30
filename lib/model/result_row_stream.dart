import 'package:bricktime/model/result.dart';
import 'package:bricktime/dbase/results_actions.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:firebase_database/firebase_database.dart';

class ResultRowStream extends StatefulWidget {

//  final Result result;
  final double dotSize = 14.0;
  final String path;
  final String playoffYear;
  final bool showFirstRound;
  final bool showConfSemi;
  final bool showConfFinal;
  final bool showFinal;


  ResultRowStreamState createState()=> ResultRowStreamState();
  const ResultRowStream({Key key, this.path, this.playoffYear, this.showFirstRound, this.showConfSemi, this.showConfFinal, this.showFinal}) : super(key: key);
}

class ResultRowStreamState extends State<ResultRowStream>{
  int scoreA =0, scoreB=0;
  bool switchStatus = false;
  Result result;

  @override
  void initState() {
    super.initState();
    setState(() {
      //_value = widget.result.score;
      //_winnerScore = (_value >= 4 ? widget.prono.teamB :  widget.prono.teamA) + " win "+getLabel(_value);
      //scoreA = widget.result.scoreA;
      //scoreB = widget.result.scoreB;
      //switchStatus = widget.result.isDefinitive;
    });
  }

  //0 dom    et   1 ext
  _incrementScore(int domOuExt, int scorA, int scorB){
    int scorA_tmp = scorA;
    int scorB_tmp = scorB;

    if(domOuExt == 0){
      scorA_tmp = ((scorA == 3 && scorB == 4) ? scorA : min(scorA+1,4));
    }else{
      scorB_tmp = ((scorB ==3 && scorA==4) ? scorB : min(scorB+1,4));
    }

    setResultToGame(scorA_tmp, scorB_tmp, widget.path);
  }

  //0 dom    et   1 ext
  _decrementScore(int domOuExt, int scorA, int scorB){
    int scorA_tmp = scorA;
    int scorB_tmp = scorB;

    if(domOuExt == 0){
      scorA_tmp = max(scorA-1,0);
    }else{
      scorB_tmp = max(scorB-1,0);
    }

    setResultToGame(scorA_tmp, scorB_tmp, widget.path);
  }


  _updateSwitchStatus(bool status){

    setIsSerieDefinitive(widget.path,status);
  }

  _passToNextSerie(int scorA, String teamA, String teamB){

      setGoToNextSerie((scorA == 4 ? teamA:  teamB), widget.path);
  }

  void _selectDateLimit() {
    isNextSerieOpen(widget.path).then((status) {
      if (status) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Generate new serie"),
                content: Text(
                    "You are about to create a new serie. You need to set the first game date & time."),
                actions: <Widget>[
                  new FlatButton(onPressed: () => Navigator.of(context).pop(),
                      child: new Text("Cancel")),
                  new FlatButton(onPressed: () {
                    Navigator.of(context).pop();
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          onChanged: (date) {

                          },
                          onConfirm: (date) {
                            if(date.compareTo(DateTime.now())>0) { //La date de la prochaine série doit forcément etre dans le futur
                              setDateLimit(widget.path, date);
                              initNewPronoFromResult(widget.path, date);
                            }
                          },
                          currentTime: DateTime.now(),
                          locale: LocaleType.fr);
                  },
                      child: new Text("Ok")),
                ],
              );
            }
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseDatabase.instance
            .reference()
            .child("results")
            .child(widget.playoffYear)
            .child(widget.path)
            .onValue,
        builder: (BuildContext context, AsyncSnapshot<Event> event) {

          if (!event.hasData) {
            return new Center(child: new Text('Loading...'));
          }

          if(event.data.snapshot.value.toString() == "null"){
            return new Center(child: new Text('Loading...'));
          }else {

            var resultJson = event.data.snapshot.value;
            result = new Result(
              teamA: resultJson["teamA"].toString(),
              teamB: resultJson["teamB"].toString(),
              scoreA: resultJson["winA"],
              scoreB: resultJson["winB"],
              first_game_date: DateTime.parse(resultJson["date_first_game"]),
              competition_level: widget.path,
              isDefinitive: resultJson['definitive'],
            );

            //Filtres d'affichage
            //les noms des deux teams sont remplis
            //
            if(result.teamA.toString() != "null"
                && result.teamB.toString() != "null"
                &&  (widget.path.contains("firstround") ? widget.showFirstRound :
                    widget.path.contains("confsemifinal") ? widget.showConfSemi :
                    widget.path.contains("conffinal") ? widget.showConfFinal :
                    widget.path.contains("final") ? widget.showFinal : false)){


              return new Container(
                  color: result.first_game_date.compareTo(DateTime.now()) < 0 ? null : Colors.grey[200],
                  child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child: new Column(
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          new Padding(
                            padding: new EdgeInsets.symmetric(horizontal: 2),
                            child: _buildPlusMinusButton(0, result.scoreA, result.scoreB, result.isDefinitive, result.first_game_date),
                          ),
                          new Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Flexible(
                                  child: Text(
                                    result.teamA,
                                    style: new TextStyle(fontSize: 14.0),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          new Container(
                            child: Column(
                              children: <Widget>[
                                //AFFICHAGE SCORE
                                new Row(
                                  children: <Widget>[
                                    new Text(
                                    result.scoreA.toString(),
                                    style: new TextStyle(fontSize: 28.0, color: result.scoreA == 4 || result.scoreB == 4 ? Colors.green : Colors.black),
                                    ),
                                    new Text(
                                    " - ",
                                    style: new TextStyle(fontSize: 20.0, color: result.scoreA == 4 || result.scoreB == 4 ? Colors.green : Colors.black),
                                    ),
                                    new Text(
                                      result.scoreB.toString(),
                                    style: new TextStyle(fontSize: 28, color: result.scoreA == 4 || result.scoreB == 4 ? Colors.green : Colors.black),
                                    ),
                                  ]
                                ),
                                _buildInfoGame(result.scoreA, result.scoreB),
                                _buildSwitch(result.scoreA, result.scoreB, result.isDefinitive, result.teamA, result.teamB),
                              ],
                            ),
                          ),
                          new Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Flexible(
                                  child: Text(
                                    result.teamB,
                                    style: new TextStyle(fontSize: 14.0),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          new Padding(
                            padding: new EdgeInsets.symmetric(horizontal: 2),
                            child: _buildPlusMinusButton(1, result.scoreA, result.scoreB, result.isDefinitive, result.first_game_date),
                          ),
                        ],
                      ),
                      Divider(),
                    ],
                  )
              ));

            }else{
              return Container(padding: EdgeInsets.all(0),);
            }
          }
        }
    );
  }

  Widget _buildSwitch(int scorA, int scorB, bool switchPos, String teamA, String teamB){
    if(scorA == 4 || scorB == 4){
      return new Switch(
          value: switchPos,
          onChanged: ((status) {
            _updateSwitchStatus(status);
              if(status){
                _passToNextSerie(scorA, teamA, teamB);
                _selectDateLimit();
                majPointsAllUsersForPath(widget.path);
              }
          }),
      );
    }else{
      return new Container(padding: EdgeInsets.all(0),);
    }
  }

  Widget _buildInfoGame(int scorA, int scorB){
    if(scorA != 4 && scorB != 4){
      return Column(
        children: <Widget>[
          Text(
            result.first_game_date.day.toString()
                +"/"+result.first_game_date.month.toString()
                +" "+(result.first_game_date.minute < 10 ? "0"+result.first_game_date.hour.toString() : result.first_game_date.hour.toString())
                +":"+(result.first_game_date.minute < 10 ? "0"+result.first_game_date.minute.toString() : result.first_game_date.minute.toString()),
            style: TextStyle(fontSize: 10),
          ),
          Text(
            result.competition_level,
            style: TextStyle(fontSize: 10),
          ),
        ],
      );
    }else{
      return new Container(padding: EdgeInsets.all(0),);
    }
  }

  //Dom 0 et Ext 1
  Widget _buildPlusMinusButton(int domExt, int scorA, int scorB, bool switchPos, DateTime startDate){
    if(!switchPos && startDate.compareTo(DateTime.now()) < 0){
      return new Column(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle,),
            padding: EdgeInsets.all(0),
            iconSize: 30,
            color: Colors.green,
            onPressed: () =>  _incrementScore(domExt,scorA, scorB),
          ),
          IconButton(
            icon: Icon(Icons.remove_circle),
            padding: EdgeInsets.all(0),
            iconSize: 30,
            color: Colors.red,
            onPressed: ()=> _decrementScore(domExt, scorA, scorB),
          ),
        ],
      );
    }else{
      return new Container(padding: EdgeInsets.all(0),);
    }
  }
  

}


