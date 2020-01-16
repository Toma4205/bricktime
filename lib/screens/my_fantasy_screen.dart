import 'package:flutter/material.dart';
import 'package:bricktime/model/current_fantasy_model.dart';
import 'package:bricktime/screens/colored_tabbar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:bricktime/model/user.dart';
import 'package:flutter/services.dart';
import 'package:bricktime/dbase/fantasy_actions.dart';
import 'package:bricktime/screens/draft_auction_screen.dart';
import 'package:bricktime/dbase/init_database.dart';
import 'package:bricktime/model/player.dart';
import 'package:bricktime/dbase/user_actions.dart';
import 'package:bricktime/model/bid.dart';
import 'package:bricktime/screens/home_screen.dart';
import 'package:bricktime/screens/locker_room_screen.dart';
import 'dart:math';



class MyFantasyScreen extends StatefulWidget {
  MyFantasyScreen({Key key, this.user}) : super(key: key);
  final User user;

  @override
  _MyFantasyScreenState createState() => new _MyFantasyScreenState();
}

class _MyFantasyScreenState extends State<MyFantasyScreen> {

  String actual_fantasy_id;
  String fantasy_name="";
  final snackBar = SnackBar(content: Text('Code copied ✅'));
  String filter_team=null;
  String filter_positions=null;
  String filter_name=null;
  int filter_price=null;

  List<Bid> selected_players = List();
  List<String> selected_id = List();
  int budget = 1000;

  List<TextEditingController> guards_controller = List();
  List<TextEditingController> forwards_controller = List();
  List<TextEditingController> centers_controller = List();

  List<double> guards_errorFrameWidth = List();
  List<double> forwards_errorFrameWidth = List();
  List<double> centers_errorFrameWidth = List();

  List<Bid> guards = List();
  List<Bid> forwards = List();
  List<Bid> centers = List();

  int nb_guards_won = 0;
  int nb_forwards_won = 0;
  int nb_centers_won = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('initState MFS');
    initValues();
    getFantasyName(MOD_current_fantasy_id).then((String name){
      setState(() {
        fantasy_name = name;
      });
    });
  }

  void initValues(){
    clearSquadList();
    loadActualFantasyId().then((data) {
      setState(() {
        this.actual_fantasy_id = data;
        getWaitingAuctionSquad(widget.user.id, MOD_current_fantasy_id).then((List<Bid> list){
          if(list.isNotEmpty){
            //comment ?
            //selected_players.addAll(list);
            //
            majSquadList();
          }
        });

      });
    });
  }

  List<Bid> compareBid(List<Bid> bids){
    List<Bid> tmp_bids = new List();
    List<String> ids_sorted = new List();

    //Tri du par enchère de la plus élevée à la plus faible
    bids.sort((a,b)=> b.bid.compareTo(a.bid));

    bids.forEach((Bid bid){
      if(!ids_sorted.contains(bid.player.id)){

        List<Bid> sub_bid = new List();
        sub_bid.addAll(bids.where((Bid elem){
          return elem.player.id == bid.player.id;
        }));

        sub_bid.sort((a,b)=> b.bid.compareTo(a.bid));

        List<int> bids_sorted = new List();
        sub_bid.forEach((Bid sb){
          if(!bids_sorted.contains(sb.bid)){
            List<Bid> sub_bid_bydate = new List();
            sub_bid_bydate.addAll(sub_bid.where((Bid elem_date){
              return elem_date.bid == sb.bid;
            }));

            sub_bid_bydate.sort((a,b)=> a.date.compareTo(b.date));
            tmp_bids.addAll(sub_bid_bydate);

            ids_sorted.add(bid.player.id);
            bids_sorted.add(sb.bid);
          }
        });
      }
    });

    return tmp_bids;
  }

  void launchAuctionDraft(){
    initPlayersMarket(actual_fantasy_id);
    updateAllUserFantasyStatus(actual_fantasy_id, "Waiting for auction-draft");
    updateFantasyStatus(actual_fantasy_id, "Waiting for auction-draft");
  }

  Future loadActualFantasyId() async {
    actual_fantasy_id =  MOD_current_fantasy_id;
    return actual_fantasy_id;
  }


  removePlayerFromSelection(String player_id, int price){

      int posElement = selected_id.indexOf(player_id);
      int posE = selected_players.indexWhere((bid){
        return bid.player.id == player_id;
      });

      print('remove '+selected_players.elementAt(posE).player.short_name.toString());

      if (posElement >= 0) {
          setState(() {
            budget += selected_players.elementAt(posE).bid;
            selected_id.removeAt(posElement);
            selected_players.removeAt(posE);
          });
      }
      majSquadList();
  }

  addPlayerToSelection(Player player){
      setState(() {
        selected_id.add(player.id);
        selected_players.add(Bid(player: player, bid: player.price));
        budget -= player.price;
      });
      majSquadList();
  }

  clearFilters(){
    print('clearFilters...');
    setState(() {
      filter_team = null;
      filter_positions = null;
      filter_price = null;
      filter_name = null;
    });
  }

  clearSquadList(){
    print('clearSquadList...');
    setState(() {
      guards.clear();
      forwards.clear();
      centers.clear();

      guards_controller.clear();
      forwards_controller.clear();
      centers_controller.clear();

      guards_errorFrameWidth.clear();
      forwards_errorFrameWidth.clear();
      centers_errorFrameWidth.clear();

      selected_players.clear();
      budget = 1000;
    });
  }

  majSquadList(){
    setState(() {
      guards.clear();
      forwards.clear();
      centers.clear();

      guards_controller.clear();
      forwards_controller.clear();
      centers_controller.clear();

      guards_errorFrameWidth.clear();
      forwards_errorFrameWidth.clear();
      centers_errorFrameWidth.clear();

      selected_players.forEach((Bid bid_player){
        TextEditingController init_price = new TextEditingController();
        init_price.text = bid_player.bid.toString();
        switch(bid_player.player.position.substring(0,1)) {
          case 'G': {
            guards.add(bid_player);
            guards_controller.add(init_price);
            bid_player.bid < bid_player.player.price ? guards_errorFrameWidth.add(4) : guards_errorFrameWidth.add(0);
          }
          break;

          case 'F': {
            forwards.add(bid_player);
            forwards_controller.add(init_price);
            bid_player.bid < bid_player.player.price ? forwards_errorFrameWidth.add(4) : forwards_errorFrameWidth.add(0);
          }
          break;

          case 'C': {
            centers.add(bid_player);
            centers_controller.add(init_price);
            bid_player.bid < bid_player.player.price ? centers_errorFrameWidth.add(4) : centers_errorFrameWidth.add(0);
          }
          break;

          default: {
            guards.add(bid_player);
            guards_controller.add(init_price);
            bid_player.bid < bid_player.player.price ? guards_errorFrameWidth.add(4) : guards_errorFrameWidth.add(0);
          }
          break;
        }
      });
    });
  }

  updatePlayerPrice(String player_id, int price, int limit_price){
    int posElement = selected_id.indexOf(player_id);
    if(posElement >= 0){
      setState(() {
        selected_players.elementAt(posElement).bid = price;
      });
    }
    updateBudget();
  }

  updateBudget(){
    int bud_tmp = 1000;
    selected_players.forEach((Bid player_bid){
      bud_tmp -= player_bid.bid;
    });

    if(bud_tmp != budget){
      setState(() {
        budget = bud_tmp;
      });
    }
  }

  bool checkSquadError(){
    bool check = true;
    int i = 0;
    selected_players.forEach((player_bid){
      if(player_bid.player.price > player_bid.bid){
        check = false;
      }
    });
    return check;
  }


  _displayDialogCloseAuctions(BuildContext context, int budgetCheck, int nbPlayers) async {
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))
            ),
            title: Text("⚠️ Close auctions, are you sure?", style: TextStyle(fontWeight: FontWeight.bold,)),
            content: Text("You won't be able to buy more players. Your squad auctions will be over.", style: TextStyle(), textAlign: TextAlign.justify,),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel', style: TextStyle(color: Colors.black),),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("I'm sure", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                onPressed: (){
                  isItLastClosedAuctionUser(MOD_current_fantasy_id).then((String last_id) async{
                    if(last_id == null){ //Ce n'est pas le dernier
                      updateUserFantasyStatus(widget.user.id, MOD_current_fantasy_id, 'Auction closed');
                    }else if(last_id == widget.user.id){ //C'est le dernier

                      //Création du championnat
                      await initFantasyPostDraft(MOD_current_fantasy_id);

                      updateAllUserFantasyStatus(MOD_current_fantasy_id, "Playing");
                      updateFantasyStatus(MOD_current_fantasy_id, "Playing");
                    }else{
                      print('else');
                    }
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }



  @override
  Widget build(BuildContext context) {
    if(actual_fantasy_id == ""){
      loadActualFantasyId();
      return Container(
        color: Colors.deepOrange,
        child: Center(child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.black87),
        )),
      );
    }else {
      return Container(
        color: Colors.deepOrange,
        child: _buildMainStream(),
      );
    }
  }

  Widget _buildMainStream() {
    return StreamBuilder(
        stream: FirebaseDatabase.instance
            .reference()
            .child("users")
            .child(widget.user.id)
            .child("fantasy")
            .child(MOD_current_fantasy_id)
            .onValue,
        builder: (BuildContext context, AsyncSnapshot<Event> event) {
          if (!event.hasData) {
            return new Center(child: new Text('Loading...'));
          }

          if (event.data.snapshot.value.toString() == "null") {
            return new Container(padding: EdgeInsets.all(0),); //Center(child: new Text('Loading...',style: new TextStyle(fontSize: 14.0, color: Colors.white),));

          } else {
            if(event.data.snapshot.value['status'].toString() == "Waiting for players"){
              return waitingPlayerScreen();
            }else if(event.data.snapshot.value['status'].toString() == "Waiting for auction-draft"){
              return draftAuctionTabBar("draft"); //En mode DRAFT
            }else if(event.data.snapshot.value['status'].toString() == "Waiting for auction-draft-resolution" || event.data.snapshot.value['status'].toString() == "Auction closed"){
              return draftAuctionTabBar("auction"); //En mode Attente DRAFT
            }else{
              return fantasyTabBar();
            }
            //print(event.data.snapshot.value['status'].toString());

          }
        }
    );
  }

  Widget waitingPlayerScreen(){
    return StreamBuilder(
        stream: FirebaseDatabase.instance
            .reference()
            .child("fantasy")
            .child(MOD_current_fantasy_id)
            .onValue,
        builder: (BuildContext context, AsyncSnapshot<Event> event) {
          if (!event.hasData) {
            return new Center(child: new Text('Loading...'));
          }

          if(event.data.snapshot.value.toString() == "null") {
            return new Container(padding: EdgeInsets.all(0),);
          } else {
            print(event.data.snapshot.value);
            Map<dynamic, dynamic> snapPlayers = event.data.snapshot.value['players'];
            List<String> players_list = List();
            List<String> players_id = List();
            snapPlayers.forEach((key, value){
              players_list.add(value['name']);
              players_id.add(key);

            });

            return SingleChildScrollView(
              padding: EdgeInsets.only(top: 40, left: 5, right: 5, bottom: 20),
              child: Card(
                color: Colors.deepOrange,
                elevation: 0,
                //margin: EdgeInsets.all(5),
                child: Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.symmetric(vertical: 10),),
                    Text(event.data.snapshot.value['fantasy_name'], style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),),
                    Padding(padding: EdgeInsets.symmetric(vertical: 5),),
                    RaisedButton(
                      elevation: 10,
                      color: Colors.blueGrey,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Text(event.data.snapshot.value['fantasy_code'], style: TextStyle(fontSize: 14, color: Colors.white),),
                      onPressed: (){
                        Clipboard.setData(new ClipboardData(text: event.data.snapshot.value['fantasy_code'].toString()));
                        Scaffold.of(context).showSnackBar(snackBar);
                      },
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 10),),
                    Text("CONTESTANTS WAITING ROOM:", style: TextStyle(fontSize: 14, color: Colors.white, letterSpacing: 2),),
                    Padding(padding: EdgeInsets.symmetric(vertical: 5),),
                    waitingPlayerCase(players_list, players_id, event.data.snapshot.value["commissioner_id"]),
                    Padding(padding: EdgeInsets.symmetric(vertical: 5),),
                    buildLetsgoButton(event.data.snapshot.value["commissioner_id"], players_list.length),

                  ],
                ),
              ),
            );
          }

    });
  }

  Widget buildLetsgoButton(String commissioner_id, int nb_players){

    if(widget.user.id == commissioner_id) {
      bool isPair = nb_players%2 == 0;
      return RaisedButton(
        elevation: 10,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        color: isPair ? Colors.black87: Colors.blueGrey,
        shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white, width: 2), borderRadius: BorderRadius.circular(15),),
        child: isPair ?
          Text("Let's go!", style: TextStyle(fontSize: 18, color: Colors.white),)
          : Text("Waiting for\nmore players", style: TextStyle(fontSize: 18, color: Colors.white), textAlign: TextAlign.center,),
        onPressed: () {
          isPair ?
          launchAuctionDraft()
          : null;
        },
      );
    }else{
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20),
      );
    }
  }

  Widget waitingPlayerCase(List<String> player_list, List<String> players_id, String commissioner_id){
    int nb_ligne = 5;
    int nb_colonne = 2;
    int nb_players = player_list.length;

    List<Widget> row = new List<Widget>();

    for(var i = 0; i<nb_ligne; i++){
        List<Widget> rowElement = new List<Widget>();
        if(i*2 < nb_players){
          rowElement.add(lonelyCase(player_list.elementAt(2*i), commissioner_id, players_id.elementAt(2*i)));
        }else{
          rowElement.add(lonelyCase(null, null, null));
        }

        if(i*2+1 < nb_players){
          rowElement.add(lonelyCase(player_list.elementAt(2*i+1), commissioner_id, players_id.elementAt(2*i+1)));
        }else{
          rowElement.add(lonelyCase(null, null, null));
        }
        row.add(new Row(
          children: rowElement,
          mainAxisAlignment: MainAxisAlignment.center,
        ));
    }
    return Column(children: row, mainAxisAlignment: MainAxisAlignment.center,);
  }

  Widget lonelyCase(String playerName, String commissioner_id, String user_id){
    bool isCommissioner = commissioner_id == user_id;
    String me = widget.user.id == user_id ? " (me)" : "";
    String isAdmin = isCommissioner ? "Admin: " : "";

    return Expanded(
        child: Stack(
          children: [
            Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      style: BorderStyle.solid,
                      color: Colors.white,
                      width: 1,
                    )
                ),
                margin: EdgeInsets.all(7),
                color: playerName == null ? Colors.black26 : Colors.deepOrangeAccent,
                child: Container(
                  padding: EdgeInsets.all(0),
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(playerName == null ? "" :  isAdmin+playerName+me, overflow: TextOverflow.ellipsis, maxLines: 1,textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: playerName == null ? Colors.black87 : Colors.white) ,),
                )
            ),
            playerName == null || isCommissioner || widget.user.id != commissioner_id ?
                Container(padding: EdgeInsets.all(0),)
                :IconButton(
                icon: Icon(Icons.cancel, color: Colors.white,),
                padding: EdgeInsets.all(0),
                alignment: Alignment.topLeft,
                onPressed: (){
                  print("Delete from fantasy");
                  removeWaitingUserFantasy(actual_fantasy_id, user_id);
              }
            )
          ],
        )
    );
  }

  Widget fantasyTabBar(){
    TabController _fantasyTabController;
    return new DefaultTabController(
      length: 3,
      child: new Scaffold(
        body: TabBarView(
          controller: _fantasyTabController,
          children: [
            LockerRoomScreen(user: widget.user, fantasy_name: fantasy_name),
            new Container(
              color: Colors.orange,
            ),
            new Container(
              color: Colors.pink,
            ),
          ],
        ),
        bottomNavigationBar: new ColoredTabBar(
          Colors.deepOrange,
          TabBar(
            controller: _fantasyTabController,
            tabs: [
              Tab(
                icon: new Icon(Icons.people, size: 30,color: Colors.white,),
              ),
              Tab(
                icon: new Icon(Icons.event, size: 30, color: Colors.white,),
              ),
              Tab(
                icon: new Icon(Icons.equalizer, size: 30,color: Colors.white),
              ),
            ],
            labelColor: Colors.black87,
            unselectedLabelColor: Colors.blueGrey,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Colors.white,
          ),
         ),
      ),
    );
  }


  Widget draftAuctionTabBar(String display_mode){
    TabController _fantasyTabController;
    return new DefaultTabController(
      length: 2,
      child: new Scaffold(
        body: TabBarView(
          controller: _fantasyTabController,
          children: [
            allPlayersAuctionScreen(display_mode),
            mySquadAuctionScreen(display_mode),
          ],
        ),
        bottomNavigationBar: new ColoredTabBar(
          Colors.deepOrange,
          TabBar(
            controller: _fantasyTabController,
            tabs: [
              Tab(
                icon: new Icon(Icons.supervised_user_circle, size: 30,color: Colors.white,),
                text: "ALL PLAYERS",
              ),
              Tab(
                icon: new Icon(Icons.add_shopping_cart, size: 30, color: Colors.white,),
                text: "MY SQUAD",
              ),
            ],
            labelColor: Colors.white,
            labelStyle: TextStyle(letterSpacing: 2),
            unselectedLabelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget allPlayersAuctionScreen(String display_mode){
    return  display_mode == "draft" ?
    new Container(
      color: Colors.black,
      child: Column(
        children: <Widget>[
          _buildTitle(Icons.supervised_user_circle, "Draft Players", fantasy_name, Colors.black, Colors.deepOrange),
          display_mode == "draft" ? _buildFilters() : Container(padding: EdgeInsets.all(0),),
          _buildCounters(Colors.white),
          Divider(color: Colors.white, thickness: 2, height: 5,),
          _buildPlayersList(),
        ],
      ),
    )
    : new Container(
      color: Colors.black,
      child: Column(
        children: <Widget>[
          _buildTitle(Icons.supervised_user_circle, "Draft Players", fantasy_name, Colors.black, Colors.deepOrange),
          Padding(padding: EdgeInsets.symmetric(vertical: 20),),
          _buildDraftWaitingRoom(),
          //Center(
            //child: Text('Waiting for players...', style: TextStyle(color: Colors.white),),
            //heightFactor: 5,
         //),
        ],
      ),
    );
  }

  Widget _buildDraftWaitingRoom(){
    return StreamBuilder(
        stream: FirebaseDatabase.instance
        .reference()
        .child("fantasy")
        .child(MOD_current_fantasy_id)
        .child('players')
        .onValue,
        builder: (BuildContext context, AsyncSnapshot<Event> event) {
          if (!event.hasData) {
            return new Center(child: new Text('Loading...'));
          }

          if (event.data.snapshot.value.toString() == "null") {
            return new Container(padding: EdgeInsets.all(0),);
          } else {
            Map<dynamic, dynamic> snapPlayers = event.data.snapshot.value;
            List<String> names = new List();
            List<int> budgets = new List();
            List<String> status = new List();

            snapPlayers.forEach((key, value) {
              names.add(value['name'].toString());
              budgets.add(value['budget']);
              status.add(value['status'].toString() );
            });

            return Expanded(
              child: ListView.separated(
                  padding: EdgeInsets.only(top:10),
                  itemCount: names.length+1,
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.white,
                    height: 4,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    if(index == 0){
                      return Container(
                          margin: EdgeInsets.symmetric(vertical: 0),
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: InkWell(
                            child: Card(
                              margin: EdgeInsets.symmetric(vertical: 0),
                              color:  Colors.black,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Padding(padding: EdgeInsets.symmetric(horizontal: 10),),
                                      Text("Who's late?", style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold,),),
                                    ],
                                  ),
                                  Row(
                                      children: [
                                        Text("Budget", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold,),),
                                        Padding(padding: EdgeInsets.symmetric(horizontal: 10),),
                                      ]
                                  ),
                                ],
                              ),
                            ),
                          )
                      );
                    }else{
                      return Container(
                          margin: EdgeInsets.symmetric(vertical: 0),
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: InkWell(
                            child: Card(
                              margin: EdgeInsets.symmetric(vertical: 0),
                              color: Colors.black,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Padding(padding: EdgeInsets.symmetric(horizontal: 5),),
                                      SizedBox(
                                        width: 30,
                                        child: Icon(status[index-1] == "Waiting for auction-draft" ? Icons.timer: status[index-1] == "Auction closed" ? Icons.thumb_up : Icons.check_circle,
                                                color: status[index-1] == "Waiting for auction-draft" ? Colors.red[300] : status[index-1] == "Auction closed" ? Colors.greenAccent : Colors.white,),
                                      ),
                                      Padding(padding: EdgeInsets.symmetric(horizontal: 5),),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width/3,
                                        child: Text(names[index-1], style: TextStyle(fontSize: 14, color: Colors.white), overflow: TextOverflow.ellipsis,),
                                      ),
                                    ],
                                  ),
                                  Row(
                                      children: [
                                        Text(status[index-1] == "Waiting for auction-draft" ? "picking players" : status[index-1] == "Auction closed" ? "squad ready" : "auctions submitted",
                                            style: TextStyle(color:  Colors.white, fontStyle: FontStyle.italic, fontSize: 12),),
                                        Padding(padding: EdgeInsets.only(right: 10),),
                                        SizedBox(
                                            width: 30,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(budgets[index-1].toString(), style: TextStyle(color: Colors.white, fontSize: 12),),
                                            )
                                        ),
                                        Padding(padding: EdgeInsets.symmetric(horizontal: 10),),
                                      ]
                                  ),
                                ],
                              ),
                            ),
                          )
                      );
                    }
                  }
              ),
            );
          }
        }
      );
  }

  Widget _buildAuctionsResultsList(){
    return StreamBuilder(
        stream: FirebaseDatabase.instance
            .reference()
            .child("fantasy")
            .child(MOD_current_fantasy_id)
            .child('auctions')
            .onValue,
        builder: (BuildContext context, AsyncSnapshot<Event> event) {
          if (!event.hasData) {
            return new Center(child: new Text('Loading...'));
          }

          if (event.data.snapshot.value.toString() == "null") {
            return new Container(padding: EdgeInsets.all(0),);
          } else {
            Map<dynamic, dynamic> snapAuctions = event.data.snapshot.value;
            List<Bid> bids = new List();

            snapAuctions.forEach((key, value) {
              Map<dynamic, dynamic> snapAuctionsPlayer = value;
              snapAuctionsPlayer.forEach((keyPlayer, valuePlayer) {
                if (keyPlayer != "name" && keyPlayer != "position" && keyPlayer != "team_id" && keyPlayer != "resolved"){
                  Map<dynamic, dynamic> snapAuctionValuePlayer = valuePlayer;
                  if(snapAuctionValuePlayer.containsKey("status")){
                    bids.add(Bid(player: new Player(id: key, short_name: value['name'], position: value['position'], teamId: value['team_id'], owner: new User(id: keyPlayer, pseudo: valuePlayer['owner_name'])), bid: valuePlayer['auction'], date: DateTime.parse(valuePlayer['auction_date'])));
                  }
                }
              });
            });
            //bids.sort((a,b) => b.bid.compareTo(a.bid));
            bids.setAll(0,compareBid(bids));


            if(bids.isEmpty){
              return Container(padding: EdgeInsets.all(0),);
            }
            return SingleChildScrollView(child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ExpansionTile(
                  title: Center(
                   child: Text("Players Bids", textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Colors.black)),
                  ),
                  children: <Widget>[
                     _buildExpansLastBids(bids),
                  ],
                )
            ),
            );
          }
        }
    );
  }

  Widget _buildExpansLastBids(List<Bid> bids){
    if(bids.isEmpty){
      return Container(padding: EdgeInsets.all(0),);//Text("No stats available yet", style: TextStyle(color: Colors.white),);
    }else{
      List<DataColumn> colonnesDom = new List();
      colonnesDom.add(DataColumn(label: Text("Players",style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15))));
      colonnesDom.add(DataColumn(label: Text("Biders",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))));
      colonnesDom.add(DataColumn(label: Text("Bids",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), numeric: true));

      List<DataRow> rowDom = new List();

      String last_id = "0";

      bids.forEach((bid){
        List<DataCell> dataCell = new List();
        dataCell.add(DataCell(Text(bid.player.short_name, style: last_id == bid.player.id ? TextStyle(fontSize: 12) : TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green), overflow: TextOverflow.ellipsis)));
        dataCell.add(DataCell(Text(bid.player.owner.pseudo.toString(), style : last_id == bid.player.id ? TextStyle(fontSize: 12) : TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green))));
        dataCell.add(DataCell(Text(bid.bid.toString(), style: last_id == bid.player.id ? TextStyle(fontSize: 12) : TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green),)));
        rowDom.add(DataRow(cells: dataCell));
        last_id = bid.player.id;
      });

      return SizedBox(
          width: MediaQuery.of(context).size.width-50,
          child: Container(
            color: Colors.white,
            child:DataTable(columns: colonnesDom, rows: rowDom, columnSpacing: 0, headingRowHeight: 20, dataRowHeight: 20, horizontalMargin: 5,),
          )
      );
    }
  }

  Widget mySquadAuctionScreen(String display_mode){
    return Container(
          color: Colors.orange,
          child: ListView(
            shrinkWrap: false,
            //mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildTitle(Icons.add_shopping_cart, "Squad Auction", fantasy_name, Colors.orange, Colors.white),
              _buildAuctionsResultsList(),
              Padding(padding: EdgeInsets.symmetric(vertical: 2),),
              _buildSquadList(display_mode),
              _buildValidateSquad(display_mode),
            ],
          ),
    );
  }

  Widget _buildValidateSquad(String display_mode){
    return StreamBuilder(
        stream: FirebaseDatabase.instance
            .reference()
            .child("users")
            .child(widget.user.id)
            .child("fantasy")
            .child(MOD_current_fantasy_id)
            .child("auctions")
            .onValue,
        builder: (BuildContext context, AsyncSnapshot<Event> event) {
          if (!event.hasData) {
            return _buildValidateSquadFromStream(display_mode, 0, 0, 0, 0);
          } else {
            if (event.data.snapshot.value == null) {
              return _buildValidateSquadFromStream(display_mode, 0, 0, 0, 0);
            } else {
              Map<dynamic, dynamic> snapPlayers = event.data.snapshot.value;
              int nb_guards_won = 0;
              int nb_forwards_won = 0;
              int nb_centers_won = 0;
              int budget_paid = 0;
              snapPlayers.forEach((key, value) {
                if (value['status'] != 'lost') {

                  switch(value['position'].substring(0,1)) {
                    case 'G': {
                      nb_guards_won++;
                    }
                    break;

                    case 'F': {
                      nb_forwards_won++;
                    }
                    break;

                    case 'C': {
                     nb_centers_won++;
                    }
                    break;

                    default: {
                      nb_guards_won++;
                    }
                    break;
                  }
                  budget_paid += value['auction'];
                }
              });
              return _buildValidateSquadFromStream(display_mode, nb_guards_won, nb_forwards_won, nb_centers_won, budget_paid);
            }
          }
        });
  }

  Widget _buildValidateSquadFromStream(String display_mode, int nb_guards_won, int nb_forwards_won, int nb_centers_won, int budget_paid){
    return Container(
      color: Colors.orange,
      //height: 80,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Card(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.info, color: Colors.white, size: 50,),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 4),),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text("Budget: "+(budget-budget_paid).toString(), style: TextStyle(color: budget-budget_paid >= 0 ? Colors.white : Colors.red[300], fontSize: 12,),),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text("Players selected: "+(nb_centers_won+nb_forwards_won+nb_guards_won+selected_players.length).toString()+"/15", style: TextStyle(color: (nb_centers_won+nb_forwards_won+nb_guards_won+selected_players.length >= 10 && nb_centers_won+nb_forwards_won+nb_guards_won+selected_players.length <= 15) ? Colors.white : Colors.red[300], fontSize: 12),)
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text("G: "+(nb_guards_won+guards.length).toString()+"/4", style: TextStyle(color: nb_guards_won+guards.length >= 4 ? Colors.white : Colors.red[300], fontSize: 12),),
                                Text(" || ", style: TextStyle(color: Colors.white, fontSize: 12),),
                                Text("F: "+(nb_forwards_won+forwards.length).toString()+"/4", style: TextStyle(color: nb_forwards_won+forwards.length >= 4 ? Colors.white : Colors.red[300], fontSize: 12),),
                                Text(" || ", style: TextStyle(color: Colors.white, fontSize: 12),),
                                Text("C: "+(nb_centers_won+centers.length).toString()+"/2 ", style: TextStyle(color: nb_centers_won+centers.length >= 2 ? Colors.white : Colors.red[300], fontSize: 12),)
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _buildSubmitButton(nb_guards_won, nb_forwards_won, nb_centers_won, budget_paid),
            ],
          ),
          _buildCloseAuctionButton(),
        ],
      )
    );
  }

  Widget _buildCloseAuctionButton(){
    return StreamBuilder(
        stream: FirebaseDatabase.instance
            .reference()
            .child("fantasy")
            .child(MOD_current_fantasy_id)
            .child('players')
            .child(widget.user.id)
            .onValue,
        builder: (BuildContext context, AsyncSnapshot<Event> event) {
          if (!event.hasData) {
            return new Center(child: new Text('Loading...'));
          }

          if (event.data.snapshot.value.toString() == "null") {
            return new Container(padding: EdgeInsets.all(0),);
          } else {
            Map<dynamic, dynamic> snapPlayers = event.data.snapshot.value;
            if(snapPlayers.containsValue('Waiting for auction-draft') && snapPlayers.keys.contains('squad')){
              Map<dynamic, dynamic> snapSquad = snapPlayers.values.elementAt(snapPlayers.keys.toList().indexOf('squad'));
              int budgetCheck = 0;
              int guardCheck = 0;
              int forwardCheck = 0;
              int centerCheck = 0;

              snapSquad.forEach((keyPlayer, valuePlayer){
                switch(valuePlayer['position'].toString().substring(0,1)) {
                  case 'G':
                    {
                      guardCheck++;
                    }
                    break;

                  case 'F':
                    {
                      forwardCheck++;
                    }
                    break;

                  case 'C':
                    {
                      centerCheck++;
                    }
                    break;

                  default:
                    {

                    }
                    break;
                }
                budgetCheck+=valuePlayer['auction'];
              });

              if(budgetCheck<=1000 && snapSquad.keys.length <= 15 &&  guardCheck >= 4 && forwardCheck >= 4 && centerCheck >= 2){
                return Container(
                  padding: EdgeInsets.fromLTRB(5,0,5,5),
                  child: RaisedButton(
                    color: Colors.deepOrange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('CLOSE MY AUCTIONS', style: TextStyle(color: Colors.white, fontSize: 16),),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 5),),
                          Icon(Icons.gavel, color: Colors.white,),
                        ],
                      ),
                    ),
                    onPressed: (){
                      _displayDialogCloseAuctions(context, budget, snapSquad.keys.length);
                    },
                  ),
                );
              }else{
                return new Container(padding: EdgeInsets.all(0),);
              }
            }else{
              return new Container(padding: EdgeInsets.all(0),);
            }
          }
        });


  }

  Widget _buildSubmitButton(int nb_guards_won, int nb_forwards_won, int nb_centers_won, int budget_paid) {
    return StreamBuilder(
        stream: FirebaseDatabase.instance
            .reference()
            .child("fantasy")
            .child(MOD_current_fantasy_id)
            .child('players')
            .child(widget.user.id)
            .child('status')
            .onValue,
        builder: (BuildContext context, AsyncSnapshot<Event> event) {
          if (!event.hasData) {
            return new Center(child: new Text('Loading...'));
          }

          if (event.data.snapshot.value.toString() == "null") {
            return new Container(padding: EdgeInsets.all(0),);
          } else {
            if(event.data.snapshot.value.toString() != "Auction closed"){
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: RaisedButton(
                  color: event.data.snapshot.value.toString() == "Waiting for auction-draft-resolution" ? Colors.grey : Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    height: 50,
                    child: Row(
                      children: <Widget>[
                        Text((event.data.snapshot.value.toString() == "Waiting for auction-draft-resolution" ? 'WAIT' : 'SUBMIT'), style: TextStyle(color: Colors.white),),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 5),),
                        Icon((event.data.snapshot.value.toString() == "Waiting for auction-draft-resolution" ? Icons.av_timer : Icons.check_circle), color: Colors.white,),
                      ],
                    ),
                  ),
                  disabledColor: Colors.red[300],
                  onPressed: ((budget-budget_paid >= 0 && selected_players.length+nb_centers_won+nb_forwards_won+nb_guards_won >= 10 && selected_players.length+nb_centers_won+nb_forwards_won+nb_guards_won <= 15 && guards.length+nb_guards_won >= 4 && forwards.length+nb_forwards_won >= 4 && centers.length+nb_centers_won >=2 && checkSquadError()) && (event.data.snapshot.value.toString() != "Waiting for auction-draft-resolution")) ? (){
                    addNewAuction(MOD_current_fantasy_id, selected_players, widget.user, budget-budget_paid);
                    clearSquadList();
                    clearFilters();

                    isItLastAuctionUser(MOD_current_fantasy_id).then((String last_id) async{
                      if(last_id == null){ //Ce n'est pas le dernier
                        updateUserFantasyStatus(widget.user.id, MOD_current_fantasy_id, "Waiting for auction-draft-resolution");
                      }else if(last_id == widget.user.id){ //C'est le dernier
                        updateUserFantasyStatus(widget.user.id, MOD_current_fantasy_id, "Waiting for auction-draft-resolution");
                        await auctionResolution(MOD_current_fantasy_id).then((result){
                          print('refresh');
                        });
                        //updateAllUserFantasyStatus(fantasy_id, "Waiting for auction-draft");
                      }else{
                        print('else');
                      }
                    });
                    //Navigator.pop(context)
                    print('OK');
                  } : null,
                ),
              );
            }else{
              return new Container(padding: EdgeInsets.all(0),);
            }
          }
        });
  }

  Widget _buildTitle(IconData icon, String title, String subtitle, Color backgroundColor, Color textColor){
    return Padding(
      padding: EdgeInsets.only(top: 40),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 0),
            color: backgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(icon, color: textColor),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10),),
                    Text(title, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: textColor),),
                  ],
                ),
                Text(subtitle, style: TextStyle(fontSize: 16, color: Colors.white, fontStyle: FontStyle.italic),),
              ],
            )
        ),
      ),
    );
  }

  Widget _buildCounters(Color basic_color){
    return StreamBuilder(
        stream: FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(widget.user.id)
        .child("fantasy")
        .child(MOD_current_fantasy_id)
        .child("auctions")
        .onValue,
    builder: (BuildContext context, AsyncSnapshot<Event> event) {
      if (!event.hasData) {
        return _buildCountersFromStream(basic_color, 0, 0);
      } else {
        if (event.data.snapshot.value == null) {
          return _buildCountersFromStream(basic_color, 0, 0);
        } else {
          Map<dynamic, dynamic> snapPlayers = event.data.snapshot.value;
          int nb_players_won = 0;
          int budget_paid = 0;
          snapPlayers.forEach((key, value) {
            if (value['status'] != 'lost') {
              nb_players_won++;
              budget_paid += value['auction'];
            }
          });
          return _buildCountersFromStream(basic_color, nb_players_won, budget_paid);
        }
      }
    });
  }

  Widget _buildCountersFromStream(Color basic_color, int nb_players_won, int budget_paid){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(padding: EdgeInsets.symmetric(horizontal: 5),),
        Text("Players selected: "+(nb_players_won+selected_players.length).toString()+"/15", style: (nb_players_won+selected_players.length) > 15 ? TextStyle(color: Colors.red, fontWeight: FontWeight.bold) : TextStyle(color: basic_color),),
        Text("Budget: "+(budget-budget_paid).toString(), style: budget-budget_paid < 0 ? TextStyle(color: Colors.red, fontWeight: FontWeight.bold) : TextStyle(color: basic_color),),
        Padding(padding: EdgeInsets.symmetric(horizontal: 5),),
      ],
    );
  }

  Widget _buildFilters(){
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        color: Colors.black,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Find player",
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),//here your padding
                            filled: true,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            fillColor: Colors.white,
                          ),
                          onChanged: (value){
                            setState(() {
                              filter_name = value == "" ? null : value;
                            });
                          },
                        ),
                      )
                  ),
                  Expanded(
                      child: Container(
                        color: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                              hintText: "Position",
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              fillColor: Colors.white
                          ),
                          items: MOD_positions.map((label) => DropdownMenuItem(
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(label, style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                            ),
                            value: label,)
                          ).toList(),
                          onChanged: (value){
                            setState(() {
                              filter_positions = value == "All Positions" ? null : value;
                            });
                          },
                          value: filter_positions == null ? null : filter_positions,
                        ),
                      )
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    color: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                          hintText: "Teams",
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          fillColor: Colors.white
                      ),
                      items: MOD_teams.map((label) => DropdownMenuItem(
                        child: Container(
                          child: Text(label.substring(0,1)+". "+label.substring(1), style: TextStyle(fontSize: 18,),),
                        ),
                        value: label,)
                      ).toList(),
                      onChanged: (value){
                        setState(() {
                          filter_team = value == ">All Teams" ? null : value;
                        });
                      },
                      value: filter_team == null? null : filter_team,
                    ),
                  ),
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        color: Colors.black,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Max price",
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),//here your padding
                            filled: true,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            fillColor: Colors.white,
                          ),
                          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                          onChanged: (value){
                            print(value.toString());
                            setState(() {
                              filter_price = value == "" ? null : int.parse(value);
                            });
                          },
                        ),
                      )
                  ),
                ],
              ),

            ],
          )
      ),
    );
  }

  Widget _buildPlayersList(){
    return StreamBuilder(
        stream: FirebaseDatabase.instance
        .reference()
        .child("fantasy")
        .child(MOD_current_fantasy_id)
        .child('market')
        .onValue,
      builder: (BuildContext context, AsyncSnapshot<Event> event) {
        if (!event.hasData) {
          return new Center(child: new Text('Loading...'));
        }

        if (event.data.snapshot.value.toString() == "null") {
          return new Container(padding: EdgeInsets.all(0),);
        } else {
          Map<dynamic, dynamic> snapPlayers = event.data.snapshot.value;

          List<Player> players_list = List();
          snapPlayers.forEach((key, value){
            if(value['owner'] == 'free'
                && (filter_positions != null ? value['position'].toString().contains(filter_positions): true)
                && (filter_team != null ? value['team_id'] == filter_team : true)
                && (filter_name != null ? value['name'].toString().toUpperCase().contains(filter_name.toUpperCase()) : true)
                && (filter_price != null ? (value['price'] == null ? 1 : value['price']) <= filter_price : true)){ //Si le prix est null c'est que le jour n'a pas encore été init en base. //A FAIRE, fonction d'init à 1 si bug ?
              players_list.add(new Player(
                id: key,
                short_name: value['name'],
                position: value['position'],
                teamAbrev: value['team_id'],
                price: value['price'] == null ? 1 : value['price'],
              ));
            }
          });

          players_list.sort((a,b) => b.price.compareTo(a.price));

          if(players_list.isNotEmpty){
            return Expanded(
              child: ListView.separated(
                  padding: EdgeInsets.only(top:10),
                  itemCount: players_list.length,
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.white,
                    height: 4,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 0),
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: InkWell(
                        onTap: (){
                            int posElement = selected_id.indexOf(players_list.elementAt(index).id);

                            if (posElement >= 0) {
                             removePlayerFromSelection(players_list.elementAt(index).id, players_list.elementAt(index).price);
                            } else {
                              addPlayerToSelection(players_list.elementAt(index));
                            }
                        },
                        child: Card(
                          margin: EdgeInsets.symmetric(vertical: 0),
                          color: selected_id.contains(players_list.elementAt(index).id) ? Colors.deepOrange : Colors.black,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(padding: EdgeInsets.symmetric(horizontal: 10),),
                                  SizedBox(
                                    width: 30,
                                    child: Text(players_list.elementAt(index).position.toString(), style: TextStyle(fontSize: 14, color: Colors.white),),
                                  ),
                                  Padding(padding: EdgeInsets.symmetric(horizontal: 10),),
                                  Text(players_list.elementAt(index).short_name.substring(0,min(players_list.elementAt(index).short_name.length,22 )), style: TextStyle(color: Colors.white, fontSize: 12),),
                                ],
                              ),
                              Row(
                                  children: [
                                    Text(players_list.elementAt(index).teamAbrev.substring(0,1)+". "+players_list.elementAt(index).teamAbrev.substring(1), style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 12),),
                                    Padding(padding: EdgeInsets.only(right: 10),),
                                    SizedBox(
                                        width: 30,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(players_list.elementAt(index).price.toString(), style: TextStyle(color: Colors.white, fontSize: 12),),
                                        )
                                    ),
                                    Padding(padding: EdgeInsets.symmetric(horizontal: 10),),
                                  ]
                              ),
                            ],
                          ),
                        ),
                      )
                    );
                  }
              ),
            );
          }else{
             return Container(padding: EdgeInsets.all(0));
          }
        }
      }
    );
  }

  Widget _buildSquadList(String display_mode){
    return  Container(
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          _buildSquadPerPosition("Guards", guards, guards_controller, guards_errorFrameWidth, display_mode),
          _buildSquadPerPosition("Forwards", forwards, forwards_controller, forwards_errorFrameWidth, display_mode),
          _buildSquadPerPosition("Centers", centers, centers_controller, centers_errorFrameWidth, display_mode),
        ],
      ),
    );
  }

  Widget _buildSquadPerPosition(String title, List<Bid> squad, List<TextEditingController> squad_controller, List<double> squad_errorFrameWidth, String display_mode) {
    return StreamBuilder(
        stream: FirebaseDatabase.instance
            .reference()
            .child("users")
            .child(widget.user.id)
            .child("fantasy")
            .child(MOD_current_fantasy_id)
            .child("auctions")
            .onValue,
        builder: (BuildContext context, AsyncSnapshot<Event> event) {
          if (!event.hasData) {
            return _buildSquadPerPositionPostStream(title, squad, squad_controller, squad_errorFrameWidth, display_mode, new List(), new List());
          }else{
            if(event.data.snapshot.value == null){
              return _buildSquadPerPositionPostStream(title, squad, squad_controller, squad_errorFrameWidth, display_mode, new List(), new List());
            }else {
              Map<dynamic, dynamic> snapPlayers = event.data.snapshot.value;
              List<Bid> players_won = List();
              players_won.clear();

              List<Bid> players_wait = List();
              players_wait.clear();

              snapPlayers.forEach((key, value) {

                if(value['status'] != 'lost' && value['position'].toString().substring(0,1) == title.substring(0,1)){
                  if(value['status'] == 'won'){
                    players_won.add(new Bid(
                      status: value['status'],
                      player: Player(short_name: value['name']),
                      bid: value['auction'],
                    ));
                  }else{
                    players_wait.add(new Bid(
                      status: value['status'],
                      player: Player(short_name: value['name']),
                      bid: value['auction'],
                    ));
                  }
                }
              });
              return _buildSquadPerPositionPostStream(title, squad, squad_controller, squad_errorFrameWidth, display_mode, players_won, players_wait);
            }
          }
        }
    );
  }

    Widget _buildSquadPerPositionPostStream(String title, List<Bid> squad, List<TextEditingController> squad_controller, List<double> squad_errorFrameWidth, String display_mode, List<Bid> players_won, List<Bid> players_wait){
      return Column(
          children: <Widget>[
            Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                color: Colors.black,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: Row(
                    children: <Widget>[
                      Text(title, style: TextStyle(color: Colors.white),),
                    ],
                  ),
                )
            ),
            squad.isNotEmpty || players_won.isNotEmpty || players_wait.isNotEmpty ?
            ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 0),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: squad.length + players_won.length + players_wait.length,
                itemBuilder: (BuildContext context, int index) {
                  return  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                GestureDetector(
                                    onTap: () {
                                      /*display_mode == "draft"  && */index < squad.length ?
                                      removePlayerFromSelection(squad.elementAt(index).player.id, int.parse(squad_controller.elementAt(index).text)) : null;
                                    },
                                    child: /*display_mode == "draft" && */index < squad.length ? Icon(Icons.clear) : (index < squad.length+players_wait.length ? Icon(Icons.av_timer) : Icon(Icons.lock,)),
                                ),
                                index < squad.length ?
                                  Text(" "+squad.elementAt(index).player.short_name.toString(), style: TextStyle(color: Colors.black))
                                : index < squad.length + players_wait.length ?
                                  Text(" "+players_wait.elementAt(index-squad.length).player.short_name.toString(), style: TextStyle(color: Colors.black))
                                  : Text(" "+players_won.elementAt(index-squad.length-players_wait.length).player.short_name.toString(), style: TextStyle(color: Colors.black)),
                              ],
                            ),
                            padding: EdgeInsets.only(left: 10, right: 10),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 10, bottom: 1, top: 1),
                            color: Colors.orange,
                            child: SizedBox(
                              child: index < squad.length ?
                              TextField(
                                controller: squad_controller.elementAt(index),
                                enabled: display_mode == "draft",
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:  BorderSide(
                                        color: Colors.red,
                                        width: (squad_controller.elementAt(index).text.isEmpty ? 4.0 : int.parse(squad_controller.elementAt(index).text) < squad.elementAt(index).player.price ? 4.0 : 0.0)
                                    ), // Si erreur
                                  ),
                                  hintText: squad.elementAt(index).player.price.toString(),
                                  contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
                                  filled: true,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8),),
                                  fillColor: display_mode == "draft" ? Colors.white: Colors.grey[200],
                                  counterText: "",
                                ),
                                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                                textAlign: TextAlign.end,
                                maxLength: 4,
                                onChanged: (value){
                                  setState(() {
                                    updatePlayerPrice(squad.elementAt(index).player.id, int.parse(value), squad.elementAt(index).player.price);
                                  });
                                },
                              )
                              : index < squad.length + players_wait.length ?
                                Text(players_wait.elementAt(index-squad.length).bid.toString(), style: TextStyle(fontSize: 16), textAlign: TextAlign.end,)
                                : Text(players_won.elementAt(index-squad.length-players_wait.length).bid.toString(), style: TextStyle(fontSize: 16), textAlign: TextAlign.end,),
                              width: 50,
                            ),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                      Divider(thickness: 1, color: Colors.black, height: 2,),
                    ],
                    mainAxisSize: MainAxisSize.max,
                  );
                }
            )
                : Text("No "+title+" selected"),
          ],
        );
  }
}

