import 'package:bricktime/model/prono.dart';
import 'package:flutter/material.dart';
import 'package:bricktime/dbase/user_prono_actions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:bricktime/model/result.dart';

class PronoRowStream extends StatefulWidget {

  final double dotSize = 12.0;
  final String userId;
  final String path;
  final String playoffYear;
  final bool showPending;

  PronoRowStreamState createState()=> PronoRowStreamState();
  const PronoRowStream({Key key, this.userId, this.path, this.playoffYear, this.showPending}) : super(key: key);
}

class PronoRowStreamState extends State<PronoRowStream>{
  int _value ;// = 4;
  String _winnerScore = "Winner";
  Prono prono ;
  Result result;

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

  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseDatabase.instance.reference().child("users").child(widget.userId).child("pronos").child("2020playoffs").child(widget.path).onValue,
        builder: (BuildContext context,  AsyncSnapshot<Event> event){
          if (!event.hasData) {
            return new Center(child: new Text('Loading...'));
          }
          
          if(event.data.snapshot.value.toString() == "null"){
            return new Center(child: new Text('Loading...'));
          }else{


            var pronoJson = event.data.snapshot.value;
            prono = new Prono(
              teamA: pronoJson["teamA"].toString(),
              teamB: pronoJson["teamB"].toString(),
              winA: pronoJson["winA"],
              winB: pronoJson["winB"],
              score: pronoJson["score"],
              date_limit: DateTime.parse(pronoJson["date_first_game"]),
              competition_level: widget.path,
              points: pronoJson['points'],
              completed: pronoJson['completed'],
            );


            if(prono.teamA.toString() != "null" && prono.teamB.toString() != "null"
                && (widget.showPending ? prono.date_limit.compareTo(DateTime.now()) > 0 : true)){
              return new ListTile(
                title:  new Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0,),
                        child: new Column(
                          children: <Widget>[
                            new Row(
                              children: <Widget>[
                                new Padding(
                                  padding:
                                  new EdgeInsets.symmetric(horizontal: 17.0 - widget.dotSize / 2),
                                  child: new Container(
                                    height: widget.dotSize,
                                    width: widget.dotSize,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle, color: prono.date_limit.compareTo(DateTime.now()) > 0 ? Colors.green : Colors.deepOrange),
                                  ),
                                ),
                                new Expanded(
                                  child: new Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Row(
                                        children: <Widget>[
                                          new Text(
                                            prono.teamA.toString().substring(0,1)+". "+prono.teamA.toString().substring(1),
                                            style: new TextStyle(fontSize: 16.0),
                                          ),
                                          new Text(
                                            " vs ",
                                            style: new TextStyle(fontSize: 14.0),
                                          ),
                                          new Text(
                                            prono.teamB.toString().substring(0,1)+". "+prono.teamB.toString().substring(1),
                                            style: new TextStyle(fontSize: 16.0),
                                          ),
                                        ],
                                      ),
                                      new Text(
                                        prono.competition_level.toString(),
                                        style: new TextStyle(fontSize: 12.0, color: Colors.grey),
                                      ),
                                      prono.completed || prono.date_limit.compareTo(DateTime.now()) < 0 ?
                                       Column(children: <Widget>[
                                         Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                                         Center(child:
                                            new Text(
                                              prono.score == 4 ?
                                              "No Pronostic Made"
                                                  : (prono.score.toInt() > 4 ? prono.teamB+" win " :  (prono.score < 4.toInt() ? prono.teamA+" win " : ""))+getLabel(prono.score.toInt()),
                                              style: new TextStyle(fontSize: 18.0, color: prono.score == 4 ? Colors.red : Colors.green, fontWeight: FontWeight.bold),
                                            )
                                        ),
                                        Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                                        ],)
                                      :Slider(
                                        value: double.parse(prono.score.toString()),
                                        min: 0,
                                        max: 8,
                                        activeColor: Colors.deepOrange,
                                        inactiveColor: Colors.grey,
                                        label: prono.score != null ? getLabel(prono.score) : "waiting for decision",
                                        divisions: 9,
                                        onChanged: prono.date_limit.compareTo(DateTime.now()) < 0 ? null : (value){
                                          setState(() {
                                            _value = value.toInt();
                                            _winnerScore = (value.toInt() > 4 ? prono.teamB+" win " :  (value < 4.toInt() ? prono.teamA+" win " : ""))+getLabel(value.toInt());
                                          });
                                          setPronoFromSliderForUser(widget.userId, value.toInt(), prono.competition_level);
                                        },
                                      ),
                                      prono.completed || prono.date_limit.compareTo(DateTime.now()) < 0 ?
                                          Container(
                                            padding: EdgeInsets.all(5),
                                          )
                                      : Container(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          prono.score == 4 ?
                                          "waiting for decision"
                                              : (prono.score.toInt() > 4 ? prono.teamB+" win " :  (prono.score < 4.toInt() ? prono.teamA+" win " : ""))+getLabel(prono.score.toInt()),
                                          style: new TextStyle(fontSize: 14.0, color: prono.score == 4 ? Colors.red : Colors.black),
                                        ),
                                      ),
                                      DateTime.now().compareTo(prono.date_limit) < 0 ?
                                      new DecoratedBox(
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(10),
                                            shape: BoxShape.rectangle,
                                        ),
                                        child:
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            child: Text(
                                              prono.date_limit.difference(DateTime.now()).inMinutes > 60 ?
                                              (prono.date_limit.difference(DateTime.now()).inHours> 24 ?
                                              prono.date_limit.difference(DateTime.now()).inDays.toString()+" days left"
                                                  : prono.date_limit.difference(DateTime.now()).inHours.toString()+" hours left")
                                                  : prono.date_limit.difference(DateTime.now()).inMinutes.toString()+" minutes left",
                                              style: new TextStyle(fontSize: 14.0, color: Colors.white),
                                            ),
                                            )
                                      )
                                          :actualScoreStream()
                                    ],
                                  ),
                                ),
                                DateTime.now().compareTo(prono.date_limit) > 0 ?
                                  pointsStream(prono.points.toString())
                                  : IconButton(
                                      padding: EdgeInsets.all(0),
                                      iconSize: 26,
                                      icon: prono.completed ?
                                            Icon(Icons.lock, color: Colors.green, )
                                            : Icon(Icons.lock_open, color: Colors.red,),
                                      onPressed: ()=> setPronoCompletedForUser(widget.userId, !prono.completed, prono.competition_level)
                                  )
                              ],
                            ),
                            Divider(thickness: 2,),
                          ],
                        )
                    ),
              );
            }else{
             return Container(padding: EdgeInsets.all(0),);
            }
          }
        },
    );
  }


  Widget actualScoreStream(){
    return StreamBuilder(
        stream: FirebaseDatabase.instance.reference().child("results").child("2020playoffs").child(widget.path).onValue,
        builder: (BuildContext context,  AsyncSnapshot<Event> event){
          if (!event.hasData) {
          return new Center(child: new Text('Loading...',style: new TextStyle(fontSize: 14.0, color: Colors.white),));
          }

          if(event.data.snapshot.value.toString() == "null"){
          return new Center(child: new Text('Loading...',style: new TextStyle(fontSize: 14.0, color: Colors.white),));
          }else{
            var resultJson = event.data.snapshot.value;
             result = new Result(
              teamA: resultJson["teamA"].toString(),
              teamB: resultJson["teamB"].toString(),
              scoreA: resultJson["winA"],
              scoreB: resultJson["winB"],
              isDefinitive: resultJson['definitive'],
            );

            return new DecoratedBox(
                decoration: BoxDecoration(
                  color: result.isDefinitive ? Colors.blueGrey : Colors.green,
                  borderRadius: BorderRadius.circular(10),
                  shape: BoxShape.rectangle,
                ),
                child:
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: new Text((result.isDefinitive ? "Definitive" : "Current")+" score: "+result.scoreA.toString()+"-"+result.scoreB.toString(),
                    style: new TextStyle(fontSize: 14.0, color: Colors.white),),
                )
            );
          }
        }
    );
  }

  Widget pointsStream(String points){
    return StreamBuilder(
        stream: FirebaseDatabase.instance.reference().child("results").child("2020playoffs").child(widget.path).onValue,
        builder: (BuildContext context,  AsyncSnapshot<Event> event) {
          if (!event.hasData) {
            return new Center(child: new Text('Loading...',
              style: new TextStyle(fontSize: 14.0, color: Colors.black),));
          }

          if (event.data.snapshot.value.toString() == "null") {
            return new Center(child: new Text('Loading...',
              style: new TextStyle(fontSize: 14.0, color: Colors.black),));
          } else {

            var resultJson = event.data.snapshot.value;
            result = new Result(
              teamA: resultJson["teamA"].toString(),
              teamB: resultJson["teamB"].toString(),
              scoreA: resultJson["winA"],
              scoreB: resultJson["winB"],
              isDefinitive: resultJson['definitive'],
            );

            return new Padding(
                padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                child:
                Text(
                  result == null ? "-" : result.isDefinitive ? points : "-",
                  style: new TextStyle(
                      fontSize: 30.0,
                      color: result == null ? Colors.grey : result.isDefinitive ? Colors.green : Colors.grey,
                      fontWeight: FontWeight.w800
                  ),
                )
            );
          }
        }
    );
  }

}

