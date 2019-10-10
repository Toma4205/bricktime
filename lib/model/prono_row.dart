import 'package:bricktime/model/prono.dart';
import 'package:flutter/material.dart';

class PronoRow extends StatefulWidget {

  final Prono prono;
  final double dotSize = 14.0;
  final Animation<double> animation;

  PronoRowState createState()=> PronoRowState();
  const PronoRow({Key key, this.prono, this.animation}) : super(key: key);
}

class PronoRowState extends State<PronoRow>{
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
      _value = widget.prono.score;
      _winnerScore = (_value >= 4 ? widget.prono.teamB :  widget.prono.teamA) + " win "+getLabel(_value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new FadeTransition(
      opacity: widget.animation,
      child: new SizeTransition(
        sizeFactor: widget.animation,
        child: new GestureDetector(
          onTap: () {
            print("onTap called "+widget.prono.teamA);
          },
          child: new Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: new Row(
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
                          widget.prono.teamA,
                          style: new TextStyle(fontSize: 18.0),
                        ),
                        new Text(
                          " vs ",
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        new Text(
                          widget.prono.teamB,
                          style: new TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                    new Text(
                      widget.prono.competition_level,
                      style: new TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                    new Slider(
                      value: _value,
                      min: 0,
                      max: 8,
                      activeColor: Colors.deepOrange,
                      inactiveColor: Colors.grey,
                      label: getLabel(_value),
                      divisions: 8,
                      onChanged: widget.prono.date_limit.compareTo(DateTime.now()) < 0 ? null : (value){
                        setState(() {
                          _value = value;
                          _winnerScore = (value > 4 ? widget.prono.teamB+" win " :  (value < 4 ? widget.prono.teamA+" win " : ""))+getLabel(value);
                        });
                      },
                    ),
                    new Row(
                      children: <Widget>[
                        Text(
                          _winnerScore,
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
                child: new Column(
                  children: <Widget>[
                      new Text(
                       "4",
                        style: new TextStyle(fontSize: 18.0, color: Colors.green),
                      ),
                      new Text(
                        "3",
                        style: new TextStyle(fontSize: 18.0, color : Colors.grey),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

