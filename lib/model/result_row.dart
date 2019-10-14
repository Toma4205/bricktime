import 'package:bricktime/model/result.dart';
import 'package:bricktime/dbase/results_actions.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class ResultRow extends StatefulWidget {

  final Result result;
  final double dotSize = 14.0;
  final Animation<double> animation;

  ResultRowState createState()=> ResultRowState();
  const ResultRow({Key key, this.result, this.animation}) : super(key: key);
}

class ResultRowState extends State<ResultRow>{
  int scoreA =0, scoreB=0;
  Color scoreColor = null;
  bool switchStatus = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      //_value = widget.result.score;
      //_winnerScore = (_value >= 4 ? widget.prono.teamB :  widget.prono.teamA) + " win "+getLabel(_value);
      scoreA = widget.result.scoreA;
      scoreB = widget.result.scoreB;
      switchStatus = widget.result.isDefinitive;
    });
    _updateScoreColor();
  }

  //0 dom    et   1 ext
  _incrementScore(int domOuExt){
    setState(() {
      domOuExt == 0 ? scoreA =((scoreA == 3 && scoreB == 4) ? scoreA : min(scoreA+1,4)) : scoreB = ((scoreB ==3 && scoreA==4) ? scoreB : min(scoreB+1,4));
    });
    _updateScoreColor();
    setResultToGame(scoreA, scoreB, widget.result.competition_level);
  }

  //0 dom    et   1 ext
  _decrementScore(int domOuExt){
    setState(() {
      domOuExt == 0 ? scoreA = max(scoreA-1,0) : scoreB = max(scoreB-1,0);
    });
    _updateScoreColor();
    setResultToGame(scoreA, scoreB, widget.result.competition_level);

  }

  _updateScoreColor(){
    if(scoreA==4 || scoreB==4){
      setState(() {
        scoreColor = Colors.green;
      });
    }else{
      scoreColor = null;
    }
  }

  _updateSwitchStatus(bool status){
    setState(() {
      switchStatus = status;
    });
    setIsSerieDefinitive(widget.result.competition_level,status);
  }

  _passToNextSerie(){

      setGoToNextSerie((scoreA == 4 ? widget.result.teamA:  widget.result.teamB), widget.result.competition_level);
  }

  void _selectDateLimit() {
    isNextSerieOpen(widget.result.competition_level).then((status) {
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
                              setDateLimit(widget.result.competition_level, date);
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
    if(widget.result.first_game_date.compareTo(DateTime.now()) < 0){ //On affiche seulement les results modifiables (donc seulement les matchs déjà commencés)
      return new FadeTransition(
        opacity: widget.animation,
        child: new SizeTransition(
          sizeFactor: widget.animation,
          child: new GestureDetector(
            onTap: () {
              print("onTap called "+widget.result.teamA);
            },
            child: new Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0),
                child: new Column(
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        new Padding(
                          padding: new EdgeInsets.symmetric(horizontal: 2),
                          child: _buildPlusMinusButton(0),
                        ),
                        new Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Flexible(
                                child: Text(
                                  widget.result.teamA,
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
                              _buildFutureScore(),
                              _buildInfoGame(),
                              _buildSwitch(),
                            ],
                          ),
                        ),
                        new Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Flexible(
                                child: Text(
                                  widget.result.teamB,
                                  style: new TextStyle(fontSize: 14.0),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        new Padding(
                          padding: new EdgeInsets.symmetric(horizontal: 2),
                          child: _buildPlusMinusButton(1),
                        ),
                      ],
                    ),
                    Divider(),
                  ],
                )
            ),
          ),
        ),
      );
    }else{
      return Container(padding: EdgeInsets.all(0),);
    }
  }


  Widget _buildFutureScore() {
    return new FutureBuilder<String>(builder: (context, snapshot) {
      if (scoreA != null && scoreB != null) {
        return _buildScore(scoreA, scoreB);
      }
      return  _buildScore(9, 9);
    });
  }

  Widget _buildScore(int scoreDom, int scoreExt){
    return new Row(
      children: <Widget>[
        new Text(
          scoreDom.toString(),
          style: new TextStyle(fontSize: 28.0, color: scoreColor),
        ),
        new Text(
          " - ",
          style: new TextStyle(fontSize: 20.0, color: scoreColor),
        ),
        new Text(
          scoreExt.toString(),
          style: new TextStyle(fontSize: 28, color: scoreColor),
        ),
      ],
    );
  }

  Widget _buildSwitch(){
    if(scoreA == 4 || scoreB == 4){
      return new Switch(
          value: switchStatus,
          onChanged: ((status) => {
          _updateSwitchStatus(status),
              if(status){
                _passToNextSerie(),
                _selectDateLimit(),
              }
          }),
      );
    }else{
      return new Container(padding: EdgeInsets.all(0),);
    }
  }

  Widget _buildInfoGame(){
    if(scoreA != 4 && scoreB != 4){
      return Column(
        children: <Widget>[
          Text(
            widget.result.first_game_date.day.toString()
                +"/"+widget.result.first_game_date.month.toString()
                +" "+(widget.result.first_game_date.minute < 10 ? "0"+widget.result.first_game_date.hour.toString() : widget.result.first_game_date.hour.toString())
                +":"+(widget.result.first_game_date.minute < 10 ? "0"+widget.result.first_game_date.minute.toString() : widget.result.first_game_date.minute.toString()),
            style: TextStyle(fontSize: 10),
          ),
          Text(
            widget.result.competition_level,
            style: TextStyle(fontSize: 10),
          ),
        ],
      );
    }else{
      return new Container(padding: EdgeInsets.all(0),);
    }
  }

  //Dom 0 et Ext 1
  Widget _buildPlusMinusButton(int domExt){
    if(!switchStatus){
      return new Column(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle,),
            padding: EdgeInsets.all(0),
            iconSize: 30,
            color: Colors.green,
            onPressed: () =>  _incrementScore(domExt),
          ),
          IconButton(
            icon: Icon(Icons.remove_circle),
            padding: EdgeInsets.all(0),
            iconSize: 30,
            color: Colors.red,
            onPressed: ()=> _decrementScore(domExt),
          ),
        ],
      );
    }else{
      return new Container(padding: EdgeInsets.all(0),);
    }
  }
  

}


