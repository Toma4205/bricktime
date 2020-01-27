import 'package:flutter/material.dart';
import 'package:bricktime/model/user.dart';
import 'package:bricktime/model/player.dart';
import 'package:bricktime/model/squad.dart';
import 'package:bricktime/model/current_fantasy_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:bricktime/dbase/fantasy_actions.dart';
import 'package:bricktime/model/confrontation.dart';
import 'dart:math';

class RankingFantasyScreen extends StatefulWidget {
  RankingFantasyScreen({Key key, this.user, this.fantasy_name}) : super(key: key);
  final User user;
  final String fantasy_name;


  @override
  _RankingFantasyScreenState createState() => new _RankingFantasyScreenState();
}

class _RankingFantasyScreenState extends State<RankingFantasyScreen> {

  List<String> teams = ['Alice', 'Bertrand', 'Caroline', 'Dominique', 'Elodie'];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('initState RankingFantasyScreen');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseDatabase.instance
            .reference()
            .child('fantasy')
            .child(MOD_current_fantasy_id)
            .onValue,
        builder: (BuildContext context, AsyncSnapshot<Event> event) {
          if (!event.hasData) {
            return Container(
              color: Colors.orange,
              padding: EdgeInsets.all(0),
              child: Center(
                child: CircularProgressIndicator(
                   valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            );
          }

          if(event.data.snapshot.value.toString() == "null") {
            return Container(
              color: Colors.orange,
              padding: EdgeInsets.all(0),
            );
          } else{
            print(event.data.snapshot.value.toString());
            Map<dynamic, dynamic> scheduleMap = event.data.snapshot.value;

            return Container(
              color: Colors.orange,
              child: ListView(
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                //mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                          padding: EdgeInsets.symmetric(vertical: 0),
                          color: Colors.orange,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.equalizer, color: Colors.white),
                                  Padding(padding: EdgeInsets.symmetric(horizontal: 10),),
                                  Text("Ranking", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),),
                                ],
                              ),
                              Text(widget.fantasy_name,style: TextStyle(fontSize: 16, color: Colors.white, fontStyle: FontStyle.italic),),
                              Padding(padding: EdgeInsets.symmetric(vertical: 3),),
                              Card(
                                margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                                color: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                  width:  (MediaQuery.of(context).size.width),
                                  child: Text('GENERAL', style: TextStyle(fontSize: 12, color: Colors.white),),
                                )
                              ),
                              ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: teams.length+1,
                                  padding: EdgeInsets.all(0),
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, int index) {
                                    if(index == 0){
                                      return Card(
                                         margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                                         color: Colors.black54,
                                         shape: RoundedRectangleBorder(
                                           borderRadius: BorderRadius.circular(30),
                                         ),
                                         child: Container(
                                           padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                           width:  (MediaQuery.of(context).size.width),
                                           child: Row(
                                             children: <Widget>[
                                               Expanded(
                                                 flex: 1,
                                                 child: Text('#', style: TextStyle(fontSize: 12, color: Colors.white),),
                                               ),
                                               Expanded(
                                                 flex : 10,
                                                 child: Text('Teams', style: TextStyle(fontSize: 12, color: Colors.white),),
                                               ),
                                               Expanded(
                                                 flex: 3,
                                                 child: Align(
                                                   alignment: Alignment.center,
                                                   child: Text('Off', style: TextStyle(fontSize: 12, color: Colors.white), textAlign: TextAlign.center,),
                                                 ),
                                               ),
                                               Expanded(
                                                 flex: 3,
                                                 child:  Align(
                                                   alignment: Alignment.center,
                                                   child: Text('Def', style: TextStyle(fontSize: 12, color: Colors.white), textAlign: TextAlign.center,),
                                                 ),
                                               ),
                                              Expanded(
                                                flex: 3,
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text('Pts', style: TextStyle(fontSize: 12, color: Colors.white), textAlign: TextAlign.center,),
                                                ),
                                              )
                                             ],
                                           ),
                                         )
                                     );
                                    }else{
                                      return Card(
                                          margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                                          color: index%2 == 0 ? Colors.deepOrangeAccent : Colors.deepOrangeAccent[400],
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                            width:  (MediaQuery.of(context).size.width),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(index.toString(), style: TextStyle(fontSize: 12, color: Colors.white),),
                                                ),
                                                Expanded(
                                                  flex : 10,
                                                  child: Text(teams.elementAt(index-1).toString(), style: TextStyle(fontSize: 12, color: Colors.white),),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text('9000', style: TextStyle(fontSize: 12, color: Colors.white), textAlign: TextAlign.center,),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child:  Align(
                                                    alignment: Alignment.center,
                                                    child: Text('500', style: TextStyle(fontSize: 12, color: Colors.white), textAlign: TextAlign.center,),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text('18', style: TextStyle(fontSize: 12, color: Colors.white), textAlign: TextAlign.center,),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                      );
                                    }
                                  },
                              ),
                              Padding(padding: EdgeInsets.symmetric(vertical: 3),),
                              Align(
                                alignment: Alignment.center,
                                child: Icon(Icons.insert_chart, color: Colors.black, size: 40,),
                              ),
                              Card(
                                  margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                                  color: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                    width:  (MediaQuery.of(context).size.width),
                                    child: Text('TEAMS AWARDS', style: TextStyle(fontSize: 12, color: Colors.white),),
                                  )
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child : ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: teams.length+1,
                                      padding: EdgeInsets.all(0),
                                      shrinkWrap: true,
                                      itemBuilder: (BuildContext context, int index) {
                                        if(index == 0){
                                          return Card(
                                              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                                              color: Colors.black54,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                width:  (MediaQuery.of(context).size.width),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex : 7,
                                                      child: Text('Teams', style: TextStyle(fontSize: 12, color: Colors.white),),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Align(
                                                        alignment: Alignment.center,
                                                        child: Text('Off/Def', style: TextStyle(fontSize: 12, color: Colors.white), textAlign: TextAlign.center,),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                          );
                                        }else{
                                          return Card(
                                              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                                              color: index%2 == 0 ? Colors.deepOrangeAccent : Colors.deepOrangeAccent[400],
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                width:  (MediaQuery.of(context).size.width),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex : 7,
                                                      child: Text(teams.elementAt(index-1).toString(), style: TextStyle(fontSize: 12, color: Colors.white),),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Align(
                                                        alignment: Alignment.center,
                                                        child: Text('9000', style: TextStyle(fontSize: 12, color: Colors.white), textAlign: TextAlign.center,),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: teams.length+1,
                                      padding: EdgeInsets.all(0),
                                      shrinkWrap: true,
                                      itemBuilder: (BuildContext context, int index) {
                                        if(index == 0){
                                          return Card(
                                              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                                              color: Colors.black54,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                width:  (MediaQuery.of(context).size.width),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex : 7,
                                                      child: Text('Victims', style: TextStyle(fontSize: 12, color: Colors.white),),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Align(
                                                        alignment: Alignment.center,
                                                        child: Text('Bonus', style: TextStyle(fontSize: 12, color: Colors.white), textAlign: TextAlign.center,),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                          );
                                        }else{
                                          return Card(
                                              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                                              color: index%2 == 0 ? Colors.deepOrangeAccent : Colors.deepOrangeAccent[400],
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                width:  (MediaQuery.of(context).size.width),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex : 7,
                                                      child: Text(teams.elementAt(index-1).toString(), style: TextStyle(fontSize: 12, color: Colors.white),),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Align(
                                                        alignment: Alignment.center,
                                                        child: Text('4', style: TextStyle(fontSize: 12, color: Colors.white), textAlign: TextAlign.center,),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Padding(padding: EdgeInsets.symmetric(vertical: 3),),
                              Align(
                                alignment: Alignment.center,
                                child: Icon(Icons.stars, color: Colors.black, size: 40,),
                              ),
                              Card(
                                  margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                                  color: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                    width:  (MediaQuery.of(context).size.width),
                                    child: Text('PLAYERS AWARDS', style: TextStyle(fontSize: 12, color: Colors.white),),
                                  )
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child : ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: teams.length+1,
                                      padding: EdgeInsets.all(0),
                                      shrinkWrap: true,
                                      itemBuilder: (BuildContext context, int index) {
                                        if(index == 0){
                                          return Card(
                                              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                                              color: Colors.black54,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                width:  (MediaQuery.of(context).size.width),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex : 7,
                                                      child: Text('MVP Race', style: TextStyle(fontSize: 12, color: Colors.white),),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Align(
                                                        alignment: Alignment.center,
                                                        child: Text('Pts/Price', style: TextStyle(fontSize: 12, color: Colors.white), textAlign: TextAlign.center,),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                          );
                                        }else{
                                          return Card(
                                              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                                              color: index%2 == 0 ? Colors.deepOrangeAccent : Colors.deepOrangeAccent[400],
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                width:  (MediaQuery.of(context).size.width),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex : 7,
                                                      child: Text(teams.elementAt(index-1).toString(), style: TextStyle(fontSize: 12, color: Colors.white),),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Align(
                                                        alignment: Alignment.center,
                                                        child: Text('9000', style: TextStyle(fontSize: 12, color: Colors.white), textAlign: TextAlign.center,),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: teams.length+1,
                                      padding: EdgeInsets.all(0),
                                      shrinkWrap: true,
                                      itemBuilder: (BuildContext context, int index) {
                                        if(index == 0){
                                          return Card(
                                              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                                              color: Colors.black54,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                width:  (MediaQuery.of(context).size.width),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex : 7,
                                                      child: Text('Best Scorers', style: TextStyle(fontSize: 12, color: Colors.white),),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Align(
                                                        alignment: Alignment.center,
                                                        child: Text('Pts', style: TextStyle(fontSize: 12, color: Colors.white), textAlign: TextAlign.center,),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                          );
                                        }else{
                                          return Card(
                                              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                                              color: index%2 == 0 ? Colors.deepOrangeAccent : Colors.deepOrangeAccent[400],
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                width:  (MediaQuery.of(context).size.width),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex : 7,
                                                      child: Text(teams.elementAt(index-1).toString(), style: TextStyle(fontSize: 12, color: Colors.white),),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Align(
                                                        alignment: Alignment.center,
                                                        child: Text('4', style: TextStyle(fontSize: 12, color: Colors.white), textAlign: TextAlign.center,),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Padding(padding: EdgeInsets.symmetric(vertical: 3),),
                              Align(
                                alignment: Alignment.center,
                                child: Icon(Icons.fitness_center, color: Colors.black, size: 40,),
                              ),
                              Card(
                                  margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                                  color: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                    width:  (MediaQuery.of(context).size.width),
                                    child: Text('MY SQUAD STATS', style: TextStyle(fontSize: 12, color: Colors.white),),
                                  )
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child : ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: teams.length+1,
                                      padding: EdgeInsets.all(0),
                                      shrinkWrap: true,
                                      itemBuilder: (BuildContext context, int index) {
                                        if(index == 0){
                                          return Card(
                                              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                                              color: Colors.black54,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                width:  (MediaQuery.of(context).size.width),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex : 7,
                                                      child: Text('Valuables Players', style: TextStyle(fontSize: 12, color: Colors.white),),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Align(
                                                        alignment: Alignment.center,
                                                        child: Text('Pts/Price', style: TextStyle(fontSize: 12, color: Colors.white), textAlign: TextAlign.center,),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                          );
                                        }else{
                                          return Card(
                                              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                                              color: index%2 == 0 ? Colors.deepOrangeAccent : Colors.deepOrangeAccent[400],
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                width:  (MediaQuery.of(context).size.width),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex : 7,
                                                      child: Text(teams.elementAt(index-1).toString(), style: TextStyle(fontSize: 12, color: Colors.white),),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Align(
                                                        alignment: Alignment.center,
                                                        child: Text('9000', style: TextStyle(fontSize: 12, color: Colors.white), textAlign: TextAlign.center,),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: teams.length+1,
                                      padding: EdgeInsets.all(0),
                                      shrinkWrap: true,
                                      itemBuilder: (BuildContext context, int index) {
                                        if(index == 0){
                                          return Card(
                                              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                                              color: Colors.black54,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                width:  (MediaQuery.of(context).size.width),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex : 7,
                                                      child: Text('Usage Rate', style: TextStyle(fontSize: 12, color: Colors.white),),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Align(
                                                        alignment: Alignment.center,
                                                        child: Text('Mpg', style: TextStyle(fontSize: 12, color: Colors.white), textAlign: TextAlign.center,),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                          );
                                        }else{
                                          return Card(
                                              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                                              color: index%2 == 0 ? Colors.deepOrangeAccent : Colors.deepOrangeAccent[400],
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                width:  (MediaQuery.of(context).size.width),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex : 7,
                                                      child: Text(teams.elementAt(index-1).toString(), style: TextStyle(fontSize: 12, color: Colors.white),),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Align(
                                                        alignment: Alignment.center,
                                                        child: Text('4', style: TextStyle(fontSize: 12, color: Colors.white), textAlign: TextAlign.center,),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                      ),
                    ),
                  ),




                ],
              ),
            );
          }
        });
  }

}