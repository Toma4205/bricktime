import 'package:flutter/material.dart';
import 'package:bricktime/model/user.dart';
import 'package:bricktime/model/player.dart';
import 'package:bricktime/model/squad.dart';
import 'package:bricktime/model/current_fantasy_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:bricktime/dbase/fantasy_actions.dart';
import 'package:bricktime/model/confrontation.dart';
import 'dart:math';

class ScheduleFantasyScreen extends StatefulWidget {
  ScheduleFantasyScreen({Key key, this.user, this.fantasy_name}) : super(key: key);
  final User user;
  final String fantasy_name;

  @override
  _ScheduleFantasyScreenState createState() => new _ScheduleFantasyScreenState();
}

class _ScheduleFantasyScreenState extends State<ScheduleFantasyScreen> {

  List<Confrontation> schedule;
  DateTime nextGameDate = null;
  String selected_week = null;
  List<String> weekLabels = null;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('initState ScheduleFantasyScreen');
    if(!mounted) return;
      setState(() {
        schedule = new List();
      });

      getWeekLabels(MOD_current_fantasy_id).then((List weeks){
        weekLabels = null;
        getNextGameDate(MOD_current_fantasy_id).then((DateTime nextDate){
          if (!mounted) return;
          setState(() {
            weekLabels = weeks;
            nextGameDate = nextDate;
            selected_week = nextDate != null ? "week"+nextDate.year.toString()+(nextDate.month < 10 ? "0":"")+nextDate.month.toString()+(nextDate.day < 10 ? "0":"")+nextDate.day.toString() : weekLabels.last;
          });
        });
      });
  }


  Widget getIconFromStrategySelected(String strategy, double taille){
    switch(strategy) {
      case "T-Mac's Comeback": {
        return Icon(Icons.history, color: Colors.white, size: taille,);
      }
      break;

      case "Draymond's Nut Kick": {
        return Icon(Icons.toll, color: Colors.white, size: taille,);
      }
      break;

      case "Snitch": {
        return Icon(Icons.hearing, color: Colors.white, size: taille,);
      }
      break;

      case "Jordan Rules": {
        return Icon(Icons.security, color: Colors.white, size: taille,);
      }
      break;

      case "Michael's Secret Stuff": {
        return Icon(Icons.local_drink, color: Colors.white, size: taille,);
      }
      break;

      case "Surprise Load Management": {
        return Icon(Icons.pause_circle_outline, color: Colors.white, size: taille,);
      }
      break;

      case "Malice at the Palace": {
        return Icon(Icons.healing, color: Colors.white, size: taille,);
      }
      break;

      default: {
        return Container(padding: EdgeInsets.all(0),);
      }
      break;
    }
  }



  @override
  Widget build(BuildContext context) {
    if(selected_week == null){
      return Container(
        color: Colors.orange,
        padding: EdgeInsets.all(0),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );
    }else{
      return StreamBuilder(
          stream: FirebaseDatabase.instance
              .reference()
              .child("fantasy")
              .child(MOD_current_fantasy_id)
              .child("calendar")
              .child(selected_week)
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
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              );
            } else{

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
                                    Icon(Icons.event, color: Colors.white),
                                    Padding(padding: EdgeInsets.symmetric(horizontal: 10),),
                                    Text("Schedule", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),),
                                  ],
                                ),
                                Text(widget.fantasy_name,style: TextStyle(fontSize: 16, color: Colors.white, fontStyle: FontStyle.italic),),
                              ],
                            )
                        ),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.navigate_before, size:  40, color: Colors.black),
                            onPressed: (){
                              int listPos = weekLabels.indexOf(selected_week);
                              if(listPos != 0) {
                                setState(() {
                                  selected_week = weekLabels.elementAt(listPos-1);
                                });
                              }
                            },
                          ),
                          Container(
                            //color: Colors.orange,
                            //padding: EdgeInsets.only(left: 3, top: 3, right: (MediaQuery.of(context).size.width/1.6)),
                            width: MediaQuery.of(context).size.width/2,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                //hintText: "Game Plan",
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
                                  //border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(width: 0)),
                                  fillColor: Colors.white
                              ),
                              items: weekLabels.map((label) => DropdownMenuItem(
                                child: Container(
                                  alignment: Alignment.center,
                                  //color: Colors.deepOrange,
                                  child: Text("Week "+(weekLabels.indexOf(label)+1).toString()+" ("+label.substring(10,12)+"/"+label.substring(8,10)+")", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                                ),
                                value: label,)
                              ).toList(),
                              onChanged: (value){
                                setState(() {
                                  selected_week = value;
                                });
                              },
                              value: selected_week,
                            ),
                          ),
                          //Text(selected_week, style: TextStyle(fontSize: 20, color: Colors.white),),
                          IconButton(
                            icon: Icon(Icons.navigate_next, size:  40, color: Colors.black),
                            onPressed: (){
                              int listPos = weekLabels.indexOf(selected_week);
                              if(listPos != weekLabels.length-1) {
                                setState(() {
                                  selected_week = weekLabels.elementAt(listPos+1);
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                        padding: EdgeInsets.only(top: 10),
                        shrinkWrap: true,
                        itemCount: scheduleMap.length, // Ici
                        itemBuilder: (BuildContext context, int index) {
                          var scoreDom = 0;
                          var scoreAway = 0;

                          if(scheduleMap.values.elementAt(index)['status'].toString() == 'over'){
                             scoreDom = (scheduleMap.values.elementAt(index)['home_real_points_bonus'].toString() == "null" ? 0 : double.parse(scheduleMap.values.elementAt(index)['home_real_points_bonus'].toString()).round())
                                + (scheduleMap.values.elementAt(index)['home_virtual_points_bonus'].toString() == "null" ? 0 : double.parse(scheduleMap.values.elementAt(index)['home_virtual_points_bonus'].toString()).round());

                             scoreAway = (scheduleMap.values.elementAt(index)['away_real_points_bonus'].toString() == "null" ? 0 : double.parse(scheduleMap.values.elementAt(index)['away_real_points_bonus'].toString()).round())
                                + (scheduleMap.values.elementAt(index)['away_virtual_points_bonus'].toString() == "null" ? 0 : double.parse(scheduleMap.values.elementAt(index)['away_virtual_points_bonus'].toString()).round());

                          }else if(scheduleMap.values.elementAt(index)['status'].toString() == 'playing'){
                             scoreDom = (scheduleMap.values.elementAt(index)['home_real_points'].toString() == "null" ? 0 : double.parse(scheduleMap.values.elementAt(index)['home_real_points'].toString()).round())
                                + (scheduleMap.values.elementAt(index)['home_virtual_points'].toString() == "null" ? 0 : double.parse(scheduleMap.values.elementAt(index)['home_virtual_points'].toString()).round());

                             scoreAway = (scheduleMap.values.elementAt(index)['away_real_points'].toString() == "null" ? 0 : double.parse(scheduleMap.values.elementAt(index)['away_real_points'].toString()).round())
                                + (scheduleMap.values.elementAt(index)['away_virtual_points'].toString() == "null" ? 0 : double.parse(scheduleMap.values.elementAt(index)['away_virtual_points'].toString()).round());

                          }



                          var home_game_plan = "Game Plan";
                          var away_game_plan = "Game Plan";

                          Widget home_strategy = Container(padding: EdgeInsets.all(0),);
                          Widget away_strategy = Container(padding: EdgeInsets.all(0),);

                          Map<dynamic, dynamic> squadHomeInfo = scheduleMap.values.elementAt(index)['homeSquad'];
                          if(squadHomeInfo != null){
                            if(scheduleMap.values.elementAt(index)['homeSquad']['home_game_plan'] !=null){
                              home_game_plan = scheduleMap.values.elementAt(index)['homeSquad']['home_game_plan'].toString();
                            }

                            if(scheduleMap.values.elementAt(index)['homeSquad']['home_strategy_selected'] !=null){
                              home_strategy = getIconFromStrategySelected(scheduleMap.values.elementAt(index)['homeSquad']['home_strategy_selected'],40);
                            }
                          }

                          Map<dynamic, dynamic> squadAwayInfo = scheduleMap.values.elementAt(index)['awaySquad'];
                          if(squadAwayInfo != null){
                            if(scheduleMap.values.elementAt(index)['awaySquad']['away_game_plan'] !=null){
                              away_game_plan = scheduleMap.values.elementAt(index)['awaySquad']['away_game_plan'].toString();
                            }

                            if(scheduleMap.values.elementAt(index)['awaySquad']['away_strategy_selected'] !=null){
                              away_strategy = getIconFromStrategySelected(scheduleMap.values.elementAt(index)['awaySquad']['away_strategy_selected'],40);
                            }
                          }

                          return new  Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            color: Colors.deepOrange,
                            child: ExpansionTile(
                              leading:  Container(
                                alignment: Alignment.centerLeft,
                                width:  (MediaQuery.of(context).size.width/3.5),
                                //child: Text(teamA, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.white),),
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(scheduleMap.values.elementAt(index)['home_name'].toString(), style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: scheduleMap.values.elementAt(index)['home'].toString() == widget.user.id ? FontWeight.bold : FontWeight.normal), overflow: TextOverflow.ellipsis,),
                                )
                              ),
                              title: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(scheduleMap.values.elementAt(index)['status'].toString() == 'not played' ? '-'
                                          : scoreDom.toString()+" - "+scoreAway.toString(),
                                          textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.white)
                                      ),
                                      scheduleMap.values.elementAt(index)['status'].toString() == 'playing' ? Text('playing', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 11, color: Colors.white))
                                          : scheduleMap.values.elementAt(index)['status'].toString() == 'over' ? Text('over', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 11, color: Colors.white)) : Container(padding: EdgeInsets.all(0),),
                                    ],
                                  )
                              ),
                              //subtitle: Center(child: Text(gameInfo, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.white))),
                              trailing: Container(
                                alignment: Alignment.centerRight,
                                width:  (MediaQuery.of(context).size.width/3.5),
                                //child: Text(teamB, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.white)),
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(scheduleMap.values.elementAt(index)['away_name'].toString(), style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: scheduleMap.values.elementAt(index)['away'].toString() == widget.user.id ? FontWeight.bold : FontWeight.normal), overflow: TextOverflow.ellipsis,),
                                ),
                              ),
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                        flex:1,
                                        child: Column(
                                          children: <Widget>[
                                            Text(home_game_plan, style: TextStyle(color: Colors.white,),),
                                            scheduleMap.values.elementAt(index)['home'].toString() == widget.user.id || scheduleMap.values.elementAt(index)['status'].toString() == 'over' ? home_strategy : Text('?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 40),),
                                          ],
                                        )
                                    ),
                                    Expanded(
                                        flex:1,
                                        child: Column(
                                          children: <Widget>[
                                            Text(away_game_plan, style: TextStyle(color: Colors.white,),),
                                            scheduleMap.values.elementAt(index)['away'].toString() == widget.user.id || scheduleMap.values.elementAt(index)['status'].toString() == 'over' ? away_strategy : Text('?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 40),),
                                          ],
                                        )
                                    ),
                                  ],
                                ),
                                _buildPositionConfrontation(scheduleMap.values.elementAt(index)['homeSquad'], scheduleMap.values.elementAt(index)['awaySquad'], scheduleMap.values.elementAt(index)['status'].toString() == 'over'),
                              ],
                            ),
                          );

                        }
                    ),
                  ],
                ),
              );
            }
          });

    }
  }

  Widget _buildPositionConfrontation(Map<dynamic, dynamic> squadHomeInfo, Map<dynamic, dynamic> squadAwayInfo, bool isOver){

    if(squadAwayInfo != null && squadHomeInfo != null){
      squadHomeInfo.removeWhere((key, value){
        return key.contains('game_plan') || key.contains('strategy_selected');
      });

      squadAwayInfo.removeWhere((key, value){
        return key.contains('game_plan') || key.contains('strategy_selected');
      });

      Squad squadHome = new Squad();
      Squad squadAway = new Squad();
      squadHome.starters = [null, null, null, null, null];
      squadHome.subs = [null, null, null, null, null];
      squadAway.starters = [null, null, null, null, null];
      squadAway.subs = [null, null, null, null, null];


      squadHomeInfo.forEach((key, value){
        //Test si on passe bien sur un node Joueur
        if(int.tryParse(key) != null) {

          if (value['rotation'].toString() == 'starter') {

            if(isOver){
              squadHome.starters[value['num_poste']] = Player(
                id: key,
                short_name: value['name'],
                teamId: value['team_id'],
                position: value['position'],
                minute: value['minute'],
                rotation: value['rotation'],
                realPoints: value['real_points_bonus'] == null ? 0 : double.parse(
                    value['real_points_bonus'].toString()).round(),
                virtualPoints: value['virtual_points_bonus'] == null ? 0 : double
                    .parse(value['virtual_points_bonus'].toString()).round(),
                first_bonus_impacted: getIconFromStrategySelected(value['player_first_impact'].toString(), 16),
                second_bonus_impacted: getIconFromStrategySelected(value['player_second_impact'].toString(),16),
                conf_won: value['conf_won'] == null ? false : value['conf_won'],

              );
            }else {
              squadHome.starters[value['num_poste']] = Player(
                id: key,
                short_name: value['name'],
                teamId: value['team_id'],
                position: value['position'],
                minute: value['minute'],
                rotation: value['rotation'],
                realPoints: value['real_points'] == null ? 0 : double.parse(
                    value['real_points'].toString()).round(),
                virtualPoints: value['virtual_points'] == null ? 0 : double
                    .parse(value['virtual_points'].toString()).round(),
                first_bonus_impacted: getIconFromStrategySelected(value['player_first_impact'].toString(), 16),
                second_bonus_impacted: getIconFromStrategySelected(value['player_second_impact'].toString(),16),
                conf_won: value['conf_won'] == null ? false : value['conf_won'],
              );
            }
          } else if (value['rotation'] == 'sub') {
            if(isOver){
              squadHome.subs[value['num_poste']] = Player(
                id: key,
                short_name: value['name'],
                teamId: value['team_id'],
                position: value['position'],
                minute: value['minute'],
                rotation: value['rotation'],
                realPoints: value['real_points_bonus'] == null ? 0 : double.parse(
                    value['real_points_bonus'].toString()).round(),
                virtualPoints: value['virtual_points_bonus'] == null ? 0 : double
                    .parse(value['virtual_points_bonus'].toString()).round(),
                first_bonus_impacted: getIconFromStrategySelected(value['player_first_impact'].toString(), 16),
                second_bonus_impacted: getIconFromStrategySelected(value['player_second_impact'].toString(),16),
                conf_won: value['conf_won'] == null ? false : value['conf_won'],
              );
            }else{
              squadHome.subs[value['num_poste']] = Player(
                id: key,
                short_name: value['name'],
                teamId: value['team_id'],
                position: value['position'],
                rotation: value['rotation'],
                realPoints: value['real_points'] == null ? 0 : double.parse(
                    value['real_points'].toString()).round(),
                virtualPoints: value['virtual_points'] == null ? 0 : double.parse(
                    value['virtual_points'].toString()).round(),
                first_bonus_impacted: getIconFromStrategySelected(value['player_first_impact'].toString(), 16),
                second_bonus_impacted: getIconFromStrategySelected(value['player_second_impact'].toString(),16),
                conf_won: value['conf_won'] == null ? false : value['conf_won'],
              );
            }

          }
        }
      });

      squadAwayInfo.forEach((key, value){

        if(int.tryParse(key) != null) {

          if(value['rotation'].toString() == 'starter'){
            if(isOver){
              squadAway.starters[value['num_poste']] = Player(
                id: key,
                short_name: value['name'],
                teamId: value['team_id'],
                position: value['position'],
                minute: value['minute'],
                rotation: value['rotation'],
                realPoints: value['real_points_bonus'] == null ? 0 : double.parse(
                    value['real_points_bonus'].toString()).round(),
                virtualPoints: value['virtual_points_bonus'] == null ? 0 : double
                    .parse(value['virtual_points_bonus'].toString()).round(),
                first_bonus_impacted: getIconFromStrategySelected(value['player_first_impact'].toString(), 16),
                second_bonus_impacted: getIconFromStrategySelected(value['player_second_impact'].toString(),16),
                conf_won: value['conf_won'] == null ? false : value['conf_won'],
              );
            }else{
              squadAway.starters[value['num_poste']] = Player(
                id: key,
                short_name: value['name'],
                teamId: value['team_id'],
                position: value['position'],
                minute: value['minute'],
                rotation: value['rotation'],
                realPoints: value['real_points'] == null ? 0 : double.parse(value['real_points'].toString()).round(),
                virtualPoints: value['virtual_points'] == null ? 0 : double.parse(value['virtual_points'].toString()).round(),
                first_bonus_impacted: getIconFromStrategySelected(value['player_first_impact'].toString(), 16),
                second_bonus_impacted: getIconFromStrategySelected(value['player_second_impact'].toString(),16),
                conf_won: value['conf_won'] == null ? false : value['conf_won'],
              );
            }
          }else if(value['rotation'] == 'sub'){
            if(isOver){
              squadAway.subs[value['num_poste']] = Player(
                id: key,
                short_name: value['name'],
                teamId: value['team_id'],
                position: value['position'],
                minute: value['minute'],
                rotation: value['rotation'],
                realPoints: value['real_points_bonus'] == null ? 0 : double.parse(
                    value['real_points_bonus'].toString()).round(),
                virtualPoints: value['virtual_points_bonus'] == null ? 0 : double
                    .parse(value['virtual_points_bonus'].toString()).round(),
                first_bonus_impacted: getIconFromStrategySelected(value['player_first_impact'].toString(), 16),
                second_bonus_impacted: getIconFromStrategySelected(value['player_second_impact'].toString(),16),
                conf_won: value['conf_won'] == null ? false : value['conf_won'],
              );
            }else{
              squadAway.subs[value['num_poste']] = Player(
                id: key,
                short_name: value['name'],
                teamId: value['team_id'],
                position: value['position'],
                rotation: value['rotation'],
                realPoints: value['real_points'] == null ? 0 : double.parse(value['real_points'].toString()).round(),
                virtualPoints: value['virtual_points'] == null ? 0 : double.parse(value['virtual_points'].toString()).round(),
                first_bonus_impacted: getIconFromStrategySelected(value['player_first_impact'].toString(), 16),
                second_bonus_impacted: getIconFromStrategySelected(value['player_second_impact'].toString(),16),
                conf_won: value['conf_won'] == null ? false : value['conf_won'],
              );
            }

          }
        }
      });


      return ListView.builder(
        padding: EdgeInsets.only(bottom: 10),
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            width: (MediaQuery.of(context).size.width),
            child: Card(
              color: Colors.deepOrange,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      isOver && squadHome.starters.elementAt(index).conf_won ? Icon(Icons.compare_arrows, color: Colors.white, size: 18,) : Text("      ", style: TextStyle(color: Colors.white,),),
                      Text("#"+(index+1).toString(), style: TextStyle(color: Colors.white),),
                       isOver && squadAway.starters.elementAt(index).conf_won ? Icon(Icons.compare_arrows, color: Colors.white, size: 18,) : Text("      ", style: TextStyle(color: Colors.white),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: squadHome.starters.elementAt(index) != null ?
                            Text(
                              squadHome.starters.elementAt(index).minute != null ? (24+squadHome.starters.elementAt(index).minute*4).toString()+"'": "",
                                textAlign: TextAlign.left, style: TextStyle(color: Colors.white,fontSize: 12), overflow: TextOverflow.ellipsis,)
                            : Container(padding: EdgeInsets.all(0),),
                      ),
                      Expanded(
                        flex: 7,
                        child: Stack(
                          children: <Widget>[
                            Card(
                              elevation: 5,
                              color: Colors.deepOrange[400],
                              child: Container(
                                height: 20,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 2, right: 2),
                                child: squadHome.starters.elementAt(index) != null ? FittedBox(fit: BoxFit.fitWidth,child: Text(squadHome.starters.elementAt(index).short_name, textAlign: TextAlign.left, style: TextStyle(color: Colors.white,fontSize: 12), overflow: TextOverflow.ellipsis,)) : Container(padding: EdgeInsets.all(0),),
                              ),
                            ),
                            isOver ? Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  squadHome.starters.elementAt(index) != null ? squadHome.starters.elementAt(index).first_bonus_impacted : Container(padding: EdgeInsets.all(0),),
                                  squadHome.starters.elementAt(index) != null ? squadHome.starters.elementAt(index).second_bonus_impacted : Container(padding: EdgeInsets.all(0),),
                                ],
                              )
                            ): Container(padding: EdgeInsets.all(0),),
                          ]
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Card(
                          elevation: 5,
                          color: Colors.black,
                          child: Container(
                            height: 20,
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 5),
                            child: squadHome.starters.elementAt(index) != null ? Text((squadHome.starters.elementAt(index).realPoints+squadHome.starters.elementAt(index).virtualPoints).toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white), overflow: TextOverflow.ellipsis,) : Container(padding: EdgeInsets.all(0),)
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Card(
                          elevation: 5,
                          color: Colors.black,
                          child: Container(
                            height: 20,
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 5),
                            child: squadAway.starters.elementAt(index) != null ? Text((squadAway.starters.elementAt(index).realPoints+squadAway.starters.elementAt(index).virtualPoints).toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white), overflow: TextOverflow.ellipsis,) : Container(padding: EdgeInsets.all(0),)
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Stack(
                            children: <Widget>[
                              Card(
                                elevation: 5,
                                color: Colors.deepOrange[800],
                                child: Container(
                                  height: 20,
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(right: 5),
                                  child: squadAway.starters.elementAt(index) != null ? FittedBox(fit: BoxFit.fitWidth,child: Text(squadAway.starters.elementAt(index).short_name, textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontSize: 12), overflow: TextOverflow.ellipsis,)) : Container(padding: EdgeInsets.all(0),),
                                ),
                              ),
                              isOver ? Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      squadAway.starters.elementAt(index) != null ? squadAway.starters.elementAt(index).first_bonus_impacted : Container(padding: EdgeInsets.all(0),),
                                      squadAway.starters.elementAt(index) != null ? squadAway.starters.elementAt(index).second_bonus_impacted : Container(padding: EdgeInsets.all(0),),
                                    ],
                                  )
                              ): Container(padding: EdgeInsets.all(0),),
                            ]
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: squadAway.starters.elementAt(index) != null ?
                        Text(
                          squadAway.starters.elementAt(index).minute != null ? (24+squadAway.starters.elementAt(index).minute*4).toString()+"'": "",
                          textAlign: TextAlign.left, style: TextStyle(color: Colors.white,fontSize: 12), overflow: TextOverflow.ellipsis,)
                            : Container(padding: EdgeInsets.all(0),),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: squadHome.starters.elementAt(index) != null ?
                        Text(
                          squadHome.starters.elementAt(index).minute != null ? (24-squadHome.starters.elementAt(index).minute*4).toString()+"'": "",
                          textAlign: TextAlign.left, style: TextStyle(color: Colors.white,fontSize: 12), overflow: TextOverflow.ellipsis,)
                            : Container(padding: EdgeInsets.all(0),),
                        ),
                      Expanded(
                        flex: 1,
                        child: Card(
                          margin: EdgeInsets.all(0),
                          elevation: 0,
                          color: Colors.deepOrange,
                          child: Container(
                            height: 20,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(0),
                            child: Icon(Icons.subdirectory_arrow_right, color: Colors.white, size: 18,),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child:
                            Card(
                              elevation: 5,
                              color: Colors.deepOrange[400],
                              child: Container(
                                height: 20,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 5),
                                child: squadHome.subs.elementAt(index) != null ? FittedBox(fit: BoxFit.fitWidth,child: Text(squadHome.subs.elementAt(index).short_name, textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 12), overflow: TextOverflow.ellipsis,) ): Container(padding: EdgeInsets.all(0),),
                              ),
                            ),

                      ),
                      Expanded(
                        flex: 2,
                        child: Card(
                          elevation: 5,
                          color: Colors.black,
                          child: Container(
                            height: 20,
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 5),
                            child: squadHome.subs.elementAt(index) != null ? Text((squadHome.subs.elementAt(index).realPoints+squadHome.subs.elementAt(index).virtualPoints).toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white), overflow: TextOverflow.ellipsis,) : Container(padding: EdgeInsets.all(0),)
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Card(
                          elevation: 5,
                          color: Colors.black,
                          child: Container(
                            height: 20,
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 5),
                              child: squadAway.subs.elementAt(index) != null ? Text((squadAway.subs.elementAt(index).realPoints+squadAway.subs.elementAt(index).virtualPoints).toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white), overflow: TextOverflow.ellipsis,) : Container(padding: EdgeInsets.all(0),)
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Card(
                          elevation: 5,
                          color: Colors.deepOrange[800],
                          child: Container(
                            height: 20,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 5),
                            child: squadAway.subs.elementAt(index) != null ? FittedBox(fit: BoxFit.fitWidth,child: Text(squadAway.subs.elementAt(index).short_name, textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontSize: 12), overflow: TextOverflow.ellipsis,)): Container(padding: EdgeInsets.all(0),),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Card(
                          margin: EdgeInsets.all(0),
                          elevation: 0,
                          color: Colors.deepOrange,
                          child: Container(
                            margin: EdgeInsets.all(0),
                            height: 20,
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.subdirectory_arrow_left, color: Colors.white, size: 18,),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: squadAway.starters.elementAt(index) != null ?
                        Text(
                          squadAway.starters.elementAt(index).minute != null ? (24-squadAway.starters.elementAt(index).minute*4).toString()+"'": "",
                          textAlign: TextAlign.left, style: TextStyle(color: Colors.white,fontSize: 12), overflow: TextOverflow.ellipsis,)
                            : Container(padding: EdgeInsets.all(0),),
                      ),
                    ],
                  ),
                ],
              ),
            )
          );
        },
      );
    }else{
      return Container(padding: EdgeInsets.all(0),);
    }
  }

}