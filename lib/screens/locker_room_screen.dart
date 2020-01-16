import 'package:flutter/material.dart';
import 'package:bricktime/model/user.dart';
import 'package:bricktime/model/player.dart';
import 'package:bricktime/model/squad.dart';
import 'package:bricktime/model/current_fantasy_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:bricktime/dbase/fantasy_actions.dart';

class LockerRoomScreen extends StatefulWidget {
  LockerRoomScreen({Key key, this.user, this.fantasy_name}) : super(key: key);
  final User user;
  final String fantasy_name;

  @override
  _LockerRoomScreenState createState() => new _LockerRoomScreenState();
}

class _LockerRoomScreenState extends State<LockerRoomScreen> {

  List<int> valuePos = [1,1,1,1,1];
  List<String> players_name = [];
  Squad squad;

  String selectedIdStarter = null;
  String selectedIdSub = null;

  String selectedStarter = null;
  String selectedSub = null;

  Duration nextGame = null;
  String nextMatchupName = 'unknown';

  //A Stream depuis Firebase pour Init "available"
  Map<String, dynamic> strategyStatus = {
    "T-Mac's Comeback":
    {
      'description': "Losing by 13 points or less at the end of the game? It's a win!"
    },
    "Draymond's Nut Kick":
    {
      'description': "Cut by half your opponennt's big man playing time"
    },
    'Snitch':
    {
      'description': "Turn your opponent's strategy against him"
    },
    'Jordan Rules':
    {
      'description': "Your starting five: Rebounds, Steals and Blocks are doubled. Your opponent's: Turnovers are doubled."
    },
    'Malice at the Palace':
    {
      'description': "Your selected player and his direct opponent are expelled"
    },
    "Michael's Secret Stuff":
    {
      'description': "Double the real points of a chosen player and minus 10% on all the others"
    },
    "Surprise Load Management":
    {
      'description': "Randomly, one starter from either team will be on 24 minutes restriction"
    },
  };

  Map<String, dynamic> posCoordinate = {
    'Classic':
    {
      1 : [1.5,10000, 'G'],
      2 : [2, 1.5, 'G'],
      3 : [3, 1.5, 'F'],
      4 : [6, 1.5, 'F'],
      5 : [8, 5, 'C'],
    },
    'Tall Ball':
    {
      1 : [1.5,10000, 'G'],
      2 : [3, 1.5, 'G'],
      3 : [5, 1.5, 'F'],
      4 : [8, 4, 'C'],
      5 : [8, 5, 'C'],
    },
    'Small Ball':
    {
      1 : [2, 1.5, 'G'],
      2 : [2, 1.5, 'G'],
      3 : [6, 1.5, 'F'],
      4 : [6, 1.5, 'F'],
      5 : [3, 10000, 'F'],
    },
    'Fast Break':
    {
      1 : [1.5, 10000, 'G'],
      2 : [2.5, 1.4, 'G'],
      3 : [2.5, 1.4, 'G'],
      4 : [3, 10000, 'F'],
      5 : [8, 5, 'C'],
    },
  };


  //Si player déjà dans la liste des starters ou des subs alors je le remplace par null dans la liste
  remove_if_already_starter_sub(Player player){
    int deja_starter = squad.starters.indexWhere((Player p){
      return p == player;
    });
    if(deja_starter >= 0){
      setState(() {
        squad.starters[deja_starter] = null;

      });
    }else{
      int deja_sub = squad.subs.indexWhere((Player p){
        return p == player;
      });
      if(deja_sub >= 0){
        setState(() {
          squad.subs[deja_sub] = null;

        });
      }
    }
  }

  _displayDialogAddStarterPlayer(BuildContext context, int position, String pos_name) async {
    String poste = "";
    switch(pos_name) {
      case 'G': {
        poste = "GUARD";
      }
      break;

      case 'F': {
        poste = "FORWARD";
      }
      break;

      case 'C': {
        poste = "CENTER";
      }
      break;

      default: {
        poste = "GUARD";
      }
      break;
    }
    _dialogStarterSelection(context, position, poste);
  }

  _dialogStarterSelection(BuildContext context, int position, String poste){
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1),
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: Container(
              height: (MediaQuery.of(context).size.height)/2,
              padding: EdgeInsets.fromLTRB(5,0,5,3),
              child: Card(
                color: Colors.deepOrange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Container(
                  //height: 20,
                  margin: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("SELECT A STARTING "+poste, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        ],
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height/2.5,
                        child:  ListView.builder(
                                  itemCount: squad.players.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    if(squad.players.elementAt(index).position == poste.substring(0,1)){
                                      return Container(
                                        padding: EdgeInsets.symmetric(vertical: 5),
                                        child: RaisedButton(
                                          color: Colors.black,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                          child: Container(
                                            height: 70,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text(squad.players.elementAt(index).short_name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),),
                                                squad.starters.contains(squad.players.elementAt(index)) || squad.subs.contains(squad.players.elementAt(index)) ? Icon(Icons.cached, color: Colors.white, size: 16,) : Container(padding: EdgeInsets.all(0),),
                                                Text(squad.players.elementAt(index).teamId, style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 12),),
                                              ],
                                            ),
                                          ),
                                          onPressed: (){
                                            setState(() {
                                              selectedIdStarter = squad.players.elementAt(index).id;
                                              remove_if_already_starter_sub(squad.players.elementAt(index));
                                              squad.starters[position] = squad.players.elementAt(index);
                                              squad.subs[position] = null;

                                            });
                                            Navigator.of(context).pop();
                                            _dialogSubSelection(context, position, poste);
                                          },
                                        ),
                                      );
                                    }else{
                                      return Container(padding: EdgeInsets.all(0),);
                                    }
                              }
                          ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  _dialogSubSelection(BuildContext context, int position, String poste){
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1),
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: Container(
              height: (MediaQuery.of(context).size.height)/2,
              padding: EdgeInsets.fromLTRB(5,0,5,3),
              child: Card(
                color: Colors.deepOrangeAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Container(
                  //height: 20,
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("SELECT HIS SUB "+poste, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        ],
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height/2.5,
                        child:  ListView.builder(
                            itemCount: squad.players.length,
                            itemBuilder: (BuildContext context, int index) {
                              if(squad.players.elementAt(index).id != selectedIdStarter && squad.players.elementAt(index).position == poste.substring(0,1)){
                                return Container(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: RaisedButton(
                                    color: Colors.black,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    child: Container(
                                      height: 70,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(squad.players.elementAt(index).short_name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),),
                                          squad.starters.contains(squad.players.elementAt(index)) || squad.subs.contains(squad.players.elementAt(index)) ? Icon(Icons.cached, color: Colors.white, size: 16,) : Container(padding: EdgeInsets.all(0),),
                                          Text(squad.players.elementAt(index).teamId, style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 12),),
                                        ],
                                      ),
                                    ),
                                    onPressed: (){
                                      setState(() {
                                        remove_if_already_starter_sub(squad.players.elementAt(index));
                                        squad.subs[position] = squad.players.elementAt(index);
                                        selectedIdStarter = null;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                );
                              }else{
                                return Container(padding: EdgeInsets.all(0),);
                              }
                            }
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }


  squad_reinitialisation(){
    setState(() {
      squad.starters = [null, null, null, null, null];
      squad.subs = [null, null, null, null, null];
      squad.waterboys = new List();
      squad.minutes_per_position = [1, 1, 1, 1, 1];
      squad.strategy_selected = null;
      squad.waterboys.addAll(squad.players);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('initState LockerRoom');
    setState(() {
      squad = new Squad();
      squad.players = new List();
      squad.starters = [null, null, null, null, null];
      squad.subs = [null, null, null, null, null];
      squad.waterboys = new List();
      squad.minutes_per_position = [1, 1, 1, 1, 1];
      squad.strategy_played = new List();
      squad.game_plan = 'Classic';
      squad.strategy_selected = null;
    });

    getSquadData(MOD_current_fantasy_id, widget.user.id).then((Squad squadoo) async{
      setState(() {
        squad = squadoo;
      });
    });

    getNextGameDate(MOD_current_fantasy_id).then((DateTime nxt) async{
      if(nxt != null){

        setState(() {
          nextGame = nxt.difference(DateTime.now().toUtc());
        });
         getNextContestant(MOD_current_fantasy_id, widget.user.id, nxt).then((String pseudo) async{
           setState(() {
             nextMatchupName = pseudo;
           });
        });

      }else{
        setState(() {
          nextGame = null;
          nextMatchupName = 'nobody';
        });
      }

    });
  }

  @override
  Widget build(BuildContext context) {
      if (squad == null) {
        return new Center(child: new Text('Loading...'));
      }else if(squad.game_plan == null){
        return new Center(child: new Text('Loading...'));
      }else{
        String waterboys_string ="";
        squad.players.forEach((Player player){
          if(!squad.starters.contains(player) && !squad.subs.contains(player)){
            waterboys_string+=player.short_name+", ";
          }
        });

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
                            Icon(Icons.people, color: Colors.white),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 10),),
                            Text("Locker Room", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),),
                          ],
                        ),
                        Text(widget.fantasy_name,style: TextStyle(fontSize: 16, color: Colors.white, fontStyle: FontStyle.italic),),
                      ],
                    )
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(5,0,5,0),
              margin: EdgeInsets.all(5),
              child: Card(
                color: Colors.black54,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Container(
                  //height: 20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Next Game in '+(nextGame == null ? "DD:HH:MM" : (nextGame.inHours/24).floor().toString()+" days "+(nextGame.inHours%24).floor().toString()+" hours "+(nextGame.inMinutes%60).toString())+" min", style: TextStyle(color: Colors.white, fontSize: 15),),
                      Text('vs '+nextMatchupName.toString(), style: TextStyle(color: Colors.white, fontSize: 15), overflow: TextOverflow.ellipsis,),
                    ],
                  ),
                ),
              ),
            ),
            //
            // CHOIX DU ROSTER + GAME PLAN
            //
            Stack(
              children: <Widget>[
                Center(
                  child: new Image.asset(
                    'images/bballhalfcourt',
                    width: (MediaQuery.of(context).size.width),
                    //height: size.height,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Container(
                  //color: Colors.orange,
                  padding: EdgeInsets.only(left: 3, top: 3, right: (MediaQuery.of(context).size.width/1.6)),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                        hintText: "Game Plan",
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        fillColor: Colors.white
                    ),
                    items: MOD_gameplan.map((label) => DropdownMenuItem(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(label, style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                      ),
                      value: label,)
                    ).toList(),
                    onChanged: (value){
                      setState(() {
                        squad.game_plan = value ;
                        squad_reinitialisation();
                      });
                    },
                    value: squad.game_plan == null ? null : squad.game_plan,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: (MediaQuery.of(context).size.width/posCoordinate[squad.game_plan][5][0]), left: (MediaQuery.of(context).size.width/posCoordinate[squad.game_plan][5][1])),
                  child: Center(
                    child: FloatingActionButton(
                      onPressed: (){
                        _displayDialogAddStarterPlayer(context,4,posCoordinate[squad.game_plan][5][2]);
                      },
                      backgroundColor: squad.subs[4] == null || squad.starters[4] == null ? Colors.transparent : Colors.deepOrange,
                      shape: CircleBorder(side: BorderSide(width: 4.0, color: squad.starters[4] == null ? Colors.black : Colors.deepOrange)),
                      child: Text(posCoordinate[squad.game_plan][5][2], style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),),
                    ),

                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: (MediaQuery.of(context).size.width/posCoordinate[squad.game_plan][4][0]), right: (MediaQuery.of(context).size.width/posCoordinate[squad.game_plan][4][1])),
                  child: Center(
                    child: FloatingActionButton(
                      onPressed: (){
                        _displayDialogAddStarterPlayer(context,3,posCoordinate[squad.game_plan][4][2]);
                      },
                      backgroundColor: squad.subs[3] == null || squad.starters[3] == null ? Colors.transparent : Colors.deepOrange,
                      shape: CircleBorder(side: BorderSide(width: 4.0, color: squad.starters[3] == null ? Colors.black : Colors.deepOrange)),
                      child: Text(posCoordinate[squad.game_plan][4][2], style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),),
                    ),

                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: (MediaQuery.of(context).size.width/posCoordinate[squad.game_plan][3][0]), left: (MediaQuery.of(context).size.width/posCoordinate[squad.game_plan][3][1])),
                  child: Center(
                    child: FloatingActionButton(
                      onPressed: (){
                        _displayDialogAddStarterPlayer(context,2,posCoordinate[squad.game_plan][3][2]);
                      },
                      backgroundColor: squad.subs[2] == null || squad.starters[2] == null ? Colors.transparent : Colors.deepOrange,
                      shape: CircleBorder(side: BorderSide(width: 4.0, color: squad.starters[2] == null ? Colors.black : Colors.deepOrange)),
                      child: Text(posCoordinate[squad.game_plan][3][2], style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),),
                    ),

                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: (MediaQuery.of(context).size.width/posCoordinate[squad.game_plan][2][0]), right: (MediaQuery.of(context).size.width/posCoordinate[squad.game_plan][2][1])),
                  child: Center(
                    child: FloatingActionButton(
                      onPressed: (){
                        _displayDialogAddStarterPlayer(context,1,posCoordinate[squad.game_plan][2][2]);
                      },
                      backgroundColor: squad.subs[1] == null || squad.starters[1] == null ? Colors.transparent : Colors.deepOrange,
                      shape: CircleBorder(side: BorderSide(width: 4.0, color: squad.starters[1] == null ? Colors.black : Colors.deepOrange)),
                      child: Text(posCoordinate[squad.game_plan][2][2], style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),),
                    ),

                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: (MediaQuery.of(context).size.width/posCoordinate[squad.game_plan][1][0]), left: (MediaQuery.of(context).size.width/posCoordinate[squad.game_plan][1][1])),
                  child: Center(
                    child: FloatingActionButton(
                      onPressed: (){
                        _displayDialogAddStarterPlayer(context,0,posCoordinate[squad.game_plan][1][2]);
                      },
                      backgroundColor: squad.subs[0] == null || squad.starters[0] == null ? Colors.transparent : Colors.deepOrange,
                      shape: CircleBorder(side: BorderSide(width: 4.0, color: squad.starters[0] == null ? Colors.black : Colors.deepOrange)),
                      child: Text(posCoordinate[squad.game_plan][1][2], style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),),
                    ),
                  ),
                )
              ],
            ),
            //
            // CHOIX DES BONUS
            //
            Container(
              padding: EdgeInsets.fromLTRB(5,0,5,0),
              child: Card(
                color: Colors.deepOrangeAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  //height: 20,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("ADD A SPECIAL STRATEGY (optional)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //Colors.blueGrey for disabled
                        //Colors.black for picked strategy

                        children: <Widget>[
                          IconButton(padding: EdgeInsets.symmetric(vertical: 2), icon: Icon(Icons.history, color: !squad.strategy_played.contains("T-Mac's Comeback") ? squad.strategy_selected == "T-Mac's Comeback" ? Colors.white : Colors.black : Colors.blueGrey, size: 30,), onPressed: (){
                            if(!squad.strategy_played.contains("T-Mac's Comeback")){
                              setState(() {
                                squad.strategy_selected = squad.strategy_selected == "T-Mac's Comeback"  ? null : "T-Mac's Comeback";


                              });
                            }else{
                              null;
                            }
                          }),
                          IconButton(padding: EdgeInsets.symmetric(vertical: 2),icon: Icon(Icons.looks_5, color: !squad.strategy_played.contains("Draymond's Nut Kick") ? squad.strategy_selected == "Draymond's Nut Kick" ? Colors.white : Colors.black : Colors.blueGrey, size: 30,), onPressed: (){
                            if(!squad.strategy_played.contains("Draymond's Nut Kick")) {
                              setState(() {
                                squad.strategy_selected =
                                squad.strategy_selected == "Draymond's Nut Kick"
                                    ? null
                                    : "Draymond's Nut Kick";
                              });
                            }else{
                              null;
                            }
                          }),
                          IconButton(padding: EdgeInsets.symmetric(vertical: 2),icon: Icon(Icons.hearing, color: !squad.strategy_played.contains('Snitch') ? squad.strategy_selected == 'Snitch' ? Colors.white : Colors.black : Colors.blueGrey, size: 30,), onPressed: (){
                            if(!squad.strategy_played.contains("Snitch")) {
                              setState(() {
                                squad.strategy_selected =
                                squad.strategy_selected == 'Snitch'
                                    ? null
                                    : 'Snitch';
                              });
                            }else{
                              null;
                            }
                          }),
                          IconButton(padding: EdgeInsets.symmetric(vertical: 2),icon: Icon(Icons.security, color: !squad.strategy_played.contains("Jordan Rules") ? squad.strategy_selected == 'Jordan Rules' ? Colors.white : Colors.black : Colors.blueGrey, size: 30,), onPressed: (){
                            if(!squad.strategy_played.contains("Jordan Rules")) {
                              setState(() {
                                squad.strategy_selected =
                                squad.strategy_selected == 'Jordan Rules'
                                    ? null
                                    : 'Jordan Rules';
                              });
                            }else{
                              null;
                            }
                          }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //Colors.blueGrey for disabled
                        //Colors.black for picked strategy

                        children: <Widget>[
                          IconButton(padding: EdgeInsets.symmetric(vertical: 2),icon: Icon(Icons.healing, color: !squad.strategy_played.contains('Malice at the Palace') ? squad.strategy_selected == 'Malice at the Palace' ? Colors.white : Colors.black : Colors.blueGrey, size: 30,), onPressed: (){
                            if(!squad.strategy_played.contains("Malice at the Palace")) {
                              setState(() {
                                squad.strategy_selected =
                                squad.strategy_selected ==
                                    'Malice at the Palace'
                                    ? null
                                    : 'Malice at the Palace';
                              });
                            }else{
                              null;
                            }
                          }),
                          IconButton(padding: EdgeInsets.symmetric(vertical: 2), icon: Icon(Icons.whatshot, color: !squad.strategy_played.contains("Michael's Secret Stuff") ? squad.strategy_selected == "Michael's Secret Stuff" ? Colors.white : Colors.black : Colors.blueGrey, size: 30,), onPressed: (){
                            if(!squad.strategy_played.contains("Michael's Secret Stuff")) {
                              setState(() {
                                squad.strategy_selected =
                                squad.strategy_selected ==
                                    "Michael's Secret Stuff"
                                    ? null
                                    : "Michael's Secret Stuff";
                              });
                            }else{
                              null;
                            }
                          }),
                          IconButton(padding: EdgeInsets.symmetric(vertical: 2),icon: Icon(Icons.pause_circle_outline, color: !squad.strategy_played.contains("Surprise Load Management") ? squad.strategy_selected == "Surprise Load Management" ? Colors.white : Colors.black : Colors.blueGrey, size: 30,), onPressed: (){
                            if(!squad.strategy_played.contains("Surprise Load Management")) {
                              setState(() {
                                squad.strategy_selected =
                                squad.strategy_selected ==
                                    "Surprise Load Management"
                                    ? null
                                    : "Surprise Load Management";
                              });
                            }else{
                              null;
                            }
                          }),
                        ],
                      ),
                      squad.strategy_selected.toString() != "null" ?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: (MediaQuery.of(context).size.width*0.8),
                            child: Column(
                              children: <Widget>[
                                Text(squad.strategy_selected.toString()+": ", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold), overflow: TextOverflow.clip, textAlign: TextAlign.justify,),
                                Text(strategyStatus[squad.strategy_selected.toString()]['description'], style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic,), overflow: TextOverflow.clip, textAlign: TextAlign.center,),
                              ],
                            ),
                          ),
                        ],
                      ): Container(padding: EdgeInsets.all(0)),
                    ],
                  ),
                ),
              ),
            ),
            //
            // CHOIX DES MINUTES
            //
            Container(
              padding: EdgeInsets.fromLTRB(5,0,5,0),
              child: Card(
                color: Colors.deepOrangeAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Container(
                  //height: 20,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[

                          Text("SET PLAYING TIME", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),

                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("STARTERS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),),
                            Text("SUBS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),),
                          ],
                        ),
                      ),
                      _buildSliderMinute(0),
                      _buildSliderMinute(1),
                      _buildSliderMinute(2),
                      _buildSliderMinute(3),
                      _buildSliderMinute(4),
                    ],
                  ),
                ),
              ),
            ),
            //
            //Water boys
            //
            waterboys_string == "" ?
            Container(padding: EdgeInsets.all(0),)
            : Container(
                padding: EdgeInsets.fromLTRB(5,0,5,3),
                child: Card(
                  color: Colors.deepOrangeAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    //height: 20,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[

                            Text("WATER BOYS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),

                          ],
                        ),
                        Text(waterboys_string, style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
                      ],
                    ),
                  ),
                ),
              ),
            //
            // Save Button
            //
            Container(
              padding: EdgeInsets.fromLTRB(5,0,5,5),
              child: RaisedButton(
                color: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('SAVE', style: TextStyle(color: Colors.white, fontSize: 16),),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5),),
                      Icon(Icons.check, color: Colors.white,),
                    ],
                  ),
                ),
                onPressed: (){
                  print("save");
                  updateSquad(MOD_current_fantasy_id, widget.user.id, squad);


                },
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 2),),
            //_buildSquadList(display_mode),
            //_buildValidateSquad(display_mode),
          ],
        ),
      );
    }
  }

  Widget _buildSliderMinute(int position){
   return Row(
     mainAxisAlignment: MainAxisAlignment.spaceAround,
     children: <Widget>[
       Container(
         width: (MediaQuery.of(context).size.width)/4,
         child: FlatButton(
           padding: EdgeInsets.all(0),
           onPressed: (){
             _displayDialogAddStarterPlayer(context,position,posCoordinate[squad.game_plan][position+1][2]);
           },
           child: Column(
           mainAxisAlignment: MainAxisAlignment.start,
           children: <Widget>[
              squad.starters[position] == null ? Text("???", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)) : Text(squad.starters[position].short_name, style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,),
              squad.minutes_per_position[position] == null ? Text("28 min", style: TextStyle(color: Colors.white,)) : Text((24+squad.minutes_per_position[position]*4).toString()+" min", style: TextStyle(color: Colors.white,)),
           ],
         ),
         ),
       ),
       Container(
         width: (MediaQuery.of(context).size.width)/2.5,
         child: Column(
           children: <Widget>[
             Slider(
               value: double.parse(squad.minutes_per_position[position].toString()),
               min: 0,
               max: 3,
               activeColor: Colors.white,
               inactiveColor: Colors.black,
               divisions: 3,
               onChanged: (value){
                 setState(() {
                   squad.minutes_per_position[position] = value.round();
                 });
               },
             ),
           ],
         ),
       ),
      Container(
        width: (MediaQuery.of(context).size.width)/4,
        child: FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: (){
            _displayDialogAddStarterPlayer(context,position,posCoordinate[squad.game_plan][position+1][2]);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              squad.subs[position] == null ? Text("???", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)) : Text(squad.subs[position].short_name, style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,),
              squad.minutes_per_position[position] == null ? Text("20 min", style: TextStyle(color: Colors.white,)) : Text((24-squad.minutes_per_position[position]*4).toString()+" min", style: TextStyle(color: Colors.white,)),
            ],
          ),
        ),
      ),
     ],
   );
  }


}