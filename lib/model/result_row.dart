import 'package:bricktime/model/result.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ResultRow extends StatefulWidget {

  final Result result;
  final double dotSize = 14.0;
  final Animation<double> animation;

  ResultRowState createState()=> ResultRowState();
  const ResultRow({Key key, this.result, this.animation}) : super(key: key);
}

class ResultRowState extends State<ResultRow>{
  double _value = 2;
  String _winnerScore = "Winner";
  int scoreA =0, scoreB=0;
  Color scoreColor = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      //_value = widget.result.score;
      //_winnerScore = (_value >= 4 ? widget.prono.teamB :  widget.prono.teamA) + " win "+getLabel(_value);
      scoreA = widget.result.scoreA;
      scoreB = widget.result.scoreB;
    });
    _updateScoreColor();
  }

  //0 dom    et   1 ext
  _incrementScore(int domOuExt){
    setState(() {
      domOuExt == 0 ? scoreA = min(scoreA+1,4) : scoreB = min(scoreB+1,4);
    });
    _updateScoreColor();
  }

  //0 dom    et   1 ext
  _decrementScore(int domOuExt){
    setState(() {
      domOuExt == 0 ? scoreA = max(scoreA-1,0) : scoreB = max(scoreB-1,0);
    });
    _updateScoreColor();
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
                          padding:
                          new EdgeInsets.symmetric(horizontal: 2),
                          child: new Column(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.add_circle,),
                                padding: EdgeInsets.all(0),
                                iconSize: 30,
                                color: Colors.green,
                                onPressed: () =>  _incrementScore(0),
                              ),
                              IconButton(
                                icon: Icon(Icons.remove_circle),
                                padding: EdgeInsets.all(0),
                                iconSize: 30,
                                color: Colors.red,
                                onPressed: ()=> _decrementScore(0),
                              ),
                            ],
                          ),
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
                          padding:
                          new EdgeInsets.symmetric(horizontal: 2),
                          child: new Column(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.add_circle,),
                                padding: EdgeInsets.all(0),
                                iconSize: 30,
                                color: Colors.green,
                                onPressed: ()=> _incrementScore(1),
                              ),
                              IconButton(
                                icon: Icon(Icons.remove_circle),
                                padding: EdgeInsets.all(0),
                                iconSize: 30,
                                color: Colors.red,
                                onPressed: ()=> _decrementScore(1),
                              ),
                            ],
                          ),
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
  

}


