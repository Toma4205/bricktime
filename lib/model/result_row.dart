import 'package:bricktime/model/result.dart';
import 'package:flutter/material.dart';

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

  String getLabel(double value){
    if(value == 0){
      return "4-0";
    }else if(value ==1){
      return "4-1";
    }else if(value ==2){
      return "4-2";
    }else if(value ==3){
      return "4-3";
    }else if(value ==4){
      return "3-4";
    }else if(value ==5){
      return "2-4";
    }else if(value ==6){
      return "1-4";
    }else if(value >=7) {
      return "0-4";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      //_value = widget.result.score;
      //_winnerScore = (_value >= 4 ? widget.prono.teamB :  widget.prono.teamA) + " win "+getLabel(_value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new FadeTransition(
      opacity: widget.animation,
      child: new SizeTransition(
        sizeFactor: widget.animation,
        child: new Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          new Text(
                            widget.result.teamA,
                            style: new TextStyle(fontSize: 18.0),
                          ),
                          new Text(
                            " vs ",
                            style: new TextStyle(fontSize: 16.0),
                          ),
                          new Text(
                            widget.result.teamB,
                            style: new TextStyle(fontSize: 18.0),
                          ),
                        ],
                      ),
                      new Text(
                        widget.result.competition_level,
                        style: new TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                      new Row(
                        children: <Widget>[
                          Text(
                            widget.result.scoreA.toString(),
                            style: new TextStyle(fontSize: 14.0, color: Colors.black),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                /*new Expanded(
                  child: new DropdownButton<String>(
                    items: <String>['4', '5', '6', '7'].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),

                    onChanged: (_) {},
                  )
              ),*/
                new Padding(
                  padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                  child: new IconButton(icon: Icon(Icons.label), onPressed: null)
                ),
              ],
            ),
          ),
      ),
    );
  }
}

