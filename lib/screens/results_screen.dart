import 'package:flutter/material.dart';
import 'package:bricktime/auth/authEmail.dart';
import 'package:bricktime/model/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:bricktime/model/result.dart';
import 'package:bricktime/model/player.dart';
import 'package:bricktime/model/player_real_game_stats.dart';


class ResultsScreen extends StatefulWidget {
  ResultsScreen({Key key, this.user, this.auth}) : super(key: key);
  final User user;
  final BaseAuth auth;



  @override
  _ResultsScreenState createState() => new _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {

  var actualYear = '2019'; //EN DUR


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black87,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _buildTitleResults(),
          _buildLastResultsStream(),
        ],
      ),
    );
  }


  Widget _buildTitleResults(){
    return Padding(
      padding: EdgeInsets.only(top: 40),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.whatshot, color: Colors.deepOrange),
              Padding(padding: EdgeInsets.symmetric(horizontal: 10),),
              Text("Last Results", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.deepOrange),),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLastResultsStream(){
    return StreamBuilder(
        stream: FirebaseDatabase.instance.reference().child("api").child("games").child(actualYear).onValue,
        builder: (BuildContext context,  AsyncSnapshot<Event> event) {
          if (!event.hasData) {
            return new Center(child: new Text('Loading...'));
          }


          if (event.data.snapshot.value.toString() == "null") {
            return new Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 10),
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    String competition = "";
                    String points = "No recent game results";
                    String rank = "";
                    String suffixRank = "";
                    Color color = Colors.grey[500];
                    return new  Card(
                      color: color,
                      child: ListTile(
                        leading: DecoratedBox(
                          decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            //color: color,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(competition, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.white),),
                        ),
                        title: Center(child: Text(points, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.white))),
                        trailing: Text(rank+suffixRank, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.white)),
                      ),
                    );
                  }
              ),
            );

          } else {

            var today = DateTime.now();
            var yesterday = DateTime.now().subtract(Duration(days:1));
            var labelToday = today.year.toString()+"-"+today.month.toString()+"-"+today.day.toString();
            var labelYesterday = yesterday.year.toString()+"-"+yesterday.month.toString()+"-"+yesterday.day.toString();
            var gamesNumber = 0;
            List<Result> resultsList = new List();

            Map<dynamic, dynamic> results = event.data.snapshot.value;
            results.forEach((key, value) {
              if(key == labelYesterday || key == labelToday){
                Map<dynamic, dynamic> games = value;
                gamesNumber += games.length;
                games.forEach((keyGame, valueGame){

                  if(valueGame['status'] == 'Final'){
                    List<Player> home_squad = new List();
                    List<Player> visitor_squad = new List();

                    Map<dynamic, dynamic> squadDom = valueGame['home_team_stats'];
                    squadDom.forEach((keySquadDom, valueSquadDom){
                      home_squad.add(Player(
                        short_name: valueSquadDom['shortName'],
                        last_game_real_stats: PlayerRealGameStats(
                          min: valueSquadDom['min'],
                          pts: valueSquadDom['pts'],
                          reb: valueSquadDom['reb'],
                          ast: valueSquadDom['ast'],
                          tov: valueSquadDom['tov'],
                          stl: valueSquadDom['stl'],
                          blk: valueSquadDom['blk'],
                        ),
                      ));
                    });

                    Map<dynamic, dynamic> squadExt = valueGame['visitor_team_stats'];
                    squadExt.forEach((keySquadExt, valueSquadExt){
                      visitor_squad.add(Player(
                        short_name: valueSquadExt['shortName'],
                        last_game_real_stats: PlayerRealGameStats(
                          min: valueSquadExt['min'],
                          pts: valueSquadExt['pts'],
                          reb: valueSquadExt['reb'],
                          ast: valueSquadExt['ast'],
                          tov: valueSquadExt['tov'],
                          stl: valueSquadExt['stl'],
                          blk: valueSquadExt['blk'],
                        ),
                      ));
                    });

                    resultsList.insert(0, Result(
                      teamA: valueGame['home_team'].toString(),
                      teamB: valueGame['visitor_team'].toString(),
                      scoreA: valueGame['home_team_score'],
                      scoreB: valueGame['visitor_team_score'],
                      //isDefinitive: valueGame['status'] == 'Final',
                      first_game_date: DateTime.parse(key.toString()+" 00:00:00"),
                      status: valueGame['status'],
                      squadA: home_squad,
                      squadB: visitor_squad,
                    ));

                  }else{
                    resultsList.insert(0, Result(
                      teamA: valueGame['home_team'].toString(),
                      teamB: valueGame['visitor_team'].toString(),
                      scoreA: valueGame['home_team_score'],
                      scoreB: valueGame['visitor_team_score'],
                      //isDefinitive: valueGame['status'] == 'Final',
                      first_game_date: DateTime.parse(key.toString()+" 00:00:00"),
                      status: valueGame['status'],
                    ));
                  }

                });
              }
            });


            int gradient = gamesNumber;
            return new Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 10),
                  itemCount: gamesNumber > 0 ? gamesNumber : 1,
                  itemBuilder: (BuildContext context, int index) {
                    String teamA = "";
                    String points = "No record yet";
                    String teamB = "";
                    String gameInfo = "";
                    Color color = Colors.grey[500];
                    List<Player> squadA = new List();
                    List<Player> squadB = new List();

                    if(gamesNumber > 0){
                      teamA = resultsList[index].teamA;
                      points = resultsList[index].scoreA.toString()+" - "+resultsList[index].scoreB.toString();
                      teamB = resultsList[index].teamB;
                      gameInfo = resultsList[index].first_game_date.year.toString()
                          +"-"
                          +resultsList[index].first_game_date.month.toString()
                          +"-"
                          +resultsList[index].first_game_date.day.toString()
                          +"\n ("
                          +(resultsList[index].status)
                          +")";
                      color = resultsList[index].status == 'Final' ? Colors.deepOrange
                              : resultsList[index].status.contains(":") ? Colors.blueGrey : Colors.orange;//Color.lerp(Colors.orangeAccent, Colors.deepOrange, 1-(1/gradient*index));
                      if(resultsList[index].status == 'Final'){
                        resultsList[index].squadA.sort((a, b) => b.last_game_real_stats.min.compareTo(a.last_game_real_stats.min));
                        resultsList[index].squadB.sort((a, b) => b.last_game_real_stats.min.compareTo(a.last_game_real_stats.min));
                        squadA.addAll(resultsList[index].squadA);
                        squadB.addAll(resultsList[index].squadB);
                      }
                    }

                    return new  Card(
                      color: color,
                      child: ExpansionTile(
                        leading:  Container(
                          alignment: Alignment.centerLeft,
                          width:  (MediaQuery.of(context).size.width/4),
                          //child: Text(teamA, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.white),),
                          child: new CircleAvatar(
                              backgroundColor: Colors.transparent,
                              minRadius: 30.0,
                              maxRadius: 30.0,
                              backgroundImage: new AssetImage('images/teams_logo/'+teamA.toLowerCase()+".png"),
                            ),
                        ),
                        title: Center(
                            child: Column(
                              children: <Widget>[
                                Text(points, textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Colors.white)),
                                Text(gameInfo, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.white)),
                              ],
                            )
                        ),
                        //subtitle: Center(child: Text(gameInfo, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.white))),
                        trailing: Container(
                            alignment: Alignment.centerRight,
                            width:  (MediaQuery.of(context).size.width/4),
                            //child: Text(teamB, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.white)),
                          child: new CircleAvatar(
                            backgroundColor: Colors.transparent,
                            minRadius: 30.0,
                            maxRadius: 30.0,
                            backgroundImage: new AssetImage('images/teams_logo/'+teamB.toLowerCase()+".png"),
                          ),
                        ),
                        children: <Widget>[
                          _buildExpansTeamStats(squadA, teamA, Colors.orangeAccent),
                          _buildExpansTeamStats(squadB, teamB, Colors.orange),
                        ],
                      ),
                    );
                  }
              ),
            );
          }}
    );
  }


  Widget _buildExpansTeamStats(List<Player> squadA, String teamA, Color couleur){
    if(squadA.isEmpty){
      return Container(padding: EdgeInsets.all(0),);//Text("No stats available yet", style: TextStyle(color: Colors.white),);
    }else{
      List<DataColumn> colonnesDom = new List();
      colonnesDom.add(DataColumn(label: Text("Players",style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15))));
      colonnesDom.add(DataColumn(label: Text("min",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), numeric: true));
      colonnesDom.add(DataColumn(label: Text("pts",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), numeric: true));
      colonnesDom.add(DataColumn(label: Text("reb",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), numeric: true));
      colonnesDom.add(DataColumn(label: Text("ast",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), numeric: true));
      colonnesDom.add(DataColumn(label: Text("stl",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), numeric: true));
      colonnesDom.add(DataColumn(label: Text("blk",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), numeric: true));
      colonnesDom.add(DataColumn(label: Text("tov",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), numeric: true));

      List<DataRow> rowDom = new List();

      squadA.forEach((playerStat){
        List<DataCell> dataCell = new List();
        dataCell.add(DataCell(Text(playerStat.short_name, style: TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)));
        dataCell.add(DataCell(Text(playerStat.last_game_real_stats.min.toString())));
        dataCell.add(DataCell(Text(playerStat.last_game_real_stats.pts.toString())));
        dataCell.add(DataCell(Text(playerStat.last_game_real_stats.reb.toString())));
        dataCell.add(DataCell(Text(playerStat.last_game_real_stats.ast.toString())));
        dataCell.add(DataCell(Text(playerStat.last_game_real_stats.stl.toString())));
        dataCell.add(DataCell(Text(playerStat.last_game_real_stats.blk.toString())));
        dataCell.add(DataCell(Text(playerStat.last_game_real_stats.tov.toString())));
        rowDom.add(DataRow(cells: dataCell));
      });


      return Container(
          color: couleur,
          child:DataTable(columns: colonnesDom, rows: rowDom, columnSpacing: 0, headingRowHeight: 20, dataRowHeight: 20,),
      );
    }
  }


}