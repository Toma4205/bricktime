import 'package:bricktime/model/prono.dart';
import 'package:flutter/material.dart';
import 'package:bricktime/dbase/user_prono_actions.dart';

class PronoRow extends StatefulWidget {

  final Prono prono;
  final double dotSize = 14.0;
  final Animation<double> animation;
  final String userId;

  PronoRowState createState()=> PronoRowState();
  const PronoRow({Key key, this.prono, this.animation, this.userId}) : super(key: key);
}

class PronoRowState extends State<PronoRow>{
  int _value;// = 4;
  String _winnerScore = "Winner";

  String getLabel(int value){
    if(value == 0){
      return "4-0";
    }else if(value ==1){
      return "4-1";
    }else if(value ==2){
      return "4-2";
    }else if(value ==3){
      return "4-3";
    }else if(value ==4) {
      return "waiting for decision";
    }else if(value ==5){
      return "3-4";
    }else if(value ==6){
      return "2-4";
    }else if(value ==7){
      return "1-4";
    }else if(value >=8) {
      return "0-4";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      _value = int.parse(widget.prono.score.toString());
      _winnerScore = (_value.toInt() > 4 ? widget.prono.teamB+" win " :  (_value.toInt() < 4.toInt() ? widget.prono.teamA+" win " : ""))+getLabel(_value.toInt());
      //_winnerScore = (_value >= 4 ? widget.prono.teamB :  widget.prono.teamA) + " win "+getLabel(_value);
    });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.prono.teamA != 'null' && widget.prono.teamB != 'null'){
      return new FadeTransition(
        opacity: widget.animation,
        child: new SizeTransition(
          sizeFactor: widget.animation,
          child: new GestureDetector(
            onTap: () {
              print("onTap called "+widget.prono.teamA);
            },
            child: new Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: new Column(
                children: <Widget>[
                  new Row(
                      children: <Widget>[
                      new Padding(
                      padding:
                          new EdgeInsets.symmetric(horizontal: 32.0 - widget.dotSize / 2),
                      child: new Container(
                        height: widget.dotSize,
                        width: widget.dotSize,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle, color: widget.prono.date_limit.compareTo(DateTime.now()) > 0 ? Colors.green : Colors.deepOrange),
                      ),
                    ),
                    new Expanded(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Row(
                            children: <Widget>[
                              new Text(
                                widget.prono.teamA.toString(),
                                style: new TextStyle(fontSize: 18.0),
                              ),
                              new Text(
                                " vs ",
                                style: new TextStyle(fontSize: 16.0),
                              ),
                              new Text(
                                widget.prono.teamB.toString(),
                                style: new TextStyle(fontSize: 18.0),
                              ),
                            ],
                          ),
                          new Text(
                            widget.prono.competition_level.toString(),
                            style: new TextStyle(fontSize: 12.0, color: Colors.grey),
                          ),
                          new Slider(
                            value: double.parse(_value.toString()),
                            min: 0,
                            max: 8,
                            activeColor: Colors.deepOrange,
                            inactiveColor: Colors.grey,
                            label: getLabel(_value),
                            divisions: 9,
                            onChanged: widget.prono.date_limit.compareTo(DateTime.now()) < 0 ? null : (value){
                              setState(() {
                                _value = value.toInt();
                                _winnerScore = (value.toInt() > 4 ? widget.prono.teamB+" win " :  (value < 4.toInt() ? widget.prono.teamA+" win " : ""))+getLabel(value.toInt());
                              });
                              setPronoFromSliderForUser(widget.userId, value.toInt(), widget.prono.competition_level);
                            },
                          ),
                          new Row(
                            children: <Widget>[
                              Text(
                                _winnerScore,
                                style: new TextStyle(fontSize: 14.0, color: _value == 4 ? Colors.red : Colors.black),
                              ),
                            ],
                          ),
                          new Row(
                            children: <Widget>[
                              DateTime.now().compareTo(widget.prono.date_limit) < 0 ?
                              Text(
                                widget.prono.date_limit.difference(DateTime.now()).inMinutes > 60 ?
                                    (widget.prono.date_limit.difference(DateTime.now()).inHours> 24 ?
                                      widget.prono.date_limit.difference(DateTime.now()).inDays.toString()+" days left"
                                      : widget.prono.date_limit.difference(DateTime.now()).inHours.toString()+" hours left")
                                    : widget.prono.date_limit.difference(DateTime.now()).inMinutes.toString()+" minutes left",
                                style: new TextStyle(fontSize: 14.0, color: _value == 4 ? Colors.red : Colors.black),
                              )
                                  : Container(padding: EdgeInsets.all(0),),
                            ],
                          )
                        ],
                      ),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                      child:  new Text(
                            widget.prono.points.toString(),
                            style: new TextStyle(fontSize: 30.0, color: Colors.green, fontWeight: FontWeight.w800),
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
      return new Container(padding: EdgeInsets.all(0),);
    }
  }
}

