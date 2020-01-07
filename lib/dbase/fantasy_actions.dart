import 'package:firebase_database/firebase_database.dart';
import 'package:bricktime/model/user.dart';
import 'package:bricktime/model/player.dart';
import 'package:bricktime/model/bid.dart';
import 'dart:async';
import 'dart:math';

setNewFantasyCompetitionForUser(String user_id, String fantasy_name, String fantasy_id, String commissioner_id, String fantasy_code, String pseudo) {
  print("setNewFantasyCompetitionForUser : "+pseudo.toString());
  FirebaseDatabase.instance.reference().child('users').child(user_id).child("fantasy").child(fantasy_id).update(
      {
        'fantasy_name': fantasy_name,
        'status': "Waiting for players",
        'isCommissioner': commissioner_id == user_id ? true : false,
        'fantasy_code': fantasy_code,
        'budget': 1000,
      });

  FirebaseDatabase.instance.reference().child('fantasy').child(fantasy_id).child("players").child(user_id).update(
      {
        'status': 'waiting',
        'name': pseudo,
        'budget': 1000,
      });
}

Future<String> setNewFantasyCompetition(String fantasy_name, String commissioner_id, String pseudo) async{
  Completer<String> completer = new Completer<String>();
  String fantasy_id = FirebaseDatabase.instance.reference().child('fantasy').push().key;
  String fantasy_code = String.fromCharCode(Random().nextInt(25)+65)
                        +String.fromCharCode(Random().nextInt(25)+65)
                        +String.fromCharCode(Random().nextInt(25)+65)
                        +String.fromCharCode(Random().nextInt(25)+65)
                        +String.fromCharCode(Random().nextInt(25)+65)
                        +String.fromCharCode(Random().nextInt(25)+65)
                        +String.fromCharCode(Random().nextInt(25)+65)
                        +String.fromCharCode(Random().nextInt(25)+65);


  completer.complete(fantasy_id);

  FirebaseDatabase.instance.reference().child('fantasy').child(fantasy_id).update(
  {
    'fantasy_name': fantasy_name,
    'status': "Waiting for players",
    'commissioner_id': commissioner_id,
    'fantasy_code': fantasy_code,

  }).then((value){
    setNewFantasyCompetitionForUser(commissioner_id, fantasy_name, fantasy_id, commissioner_id, fantasy_code, pseudo);
  });

  return completer.future;
}


Future<String> joinFantasyWithCodeForUser(String user_id, String fantasy_code, String pseudo) async {
  Completer<String> completer = new Completer<String>();
  bool joinPossible = false;
  String typeError = "";
  String fantasy_name="";
  String fantasy_id ="";
  String commissioner_id ="";

  FirebaseDatabase.instance
      .reference()
      .child("fantasy")
      .once()
      .then((DataSnapshot snapshot) {
      print("check :"+fantasy_code);
      Map<dynamic, dynamic> snapFantasy = snapshot.value;
      snapFantasy.forEach((key, value){
        if(value["fantasy_code"] == fantasy_code){
          if(value['status'] == 'Waiting for players'){
            joinPossible = true;
            fantasy_id = key;
            fantasy_name = value["fantasy_name"];
            commissioner_id = value["fantasy_id"];

            Map<dynamic, dynamic> snapPlayers = value["players"];
            snapPlayers.forEach((keyPlayer, valuePlayer){
              if(keyPlayer == user_id){
                joinPossible = false;
                typeError = "User already in the competition";
              }
            });
          }else{
            typeError = "Cannot join this competition anymore";
          }
        }
        //print(key+" - "+value.toString());
      });
      if(!joinPossible && typeError==""){
        typeError = "Competition does not exist";
      }

      if(joinPossible && typeError == ""){
        setNewFantasyCompetitionForUser(user_id, fantasy_name, fantasy_id, commissioner_id, fantasy_code, pseudo);
      }

    completer.complete(typeError);
    //print("return : "+joinPossible.toString()+" : "+typeError);
  });
  return completer.future;
}

removeFantasyCompetitionAllUsers(String fantasy_id) async {
  await getPlayersFromFantasy(fantasy_id).then((playersList){
    playersList.forEach((playerId){
      removeFantasyCompetitionForUser(playerId, fantasy_id);
    });
  }).then((message){
    removeFantasyCompetition(fantasy_id);
  });
}

Future<List<String>> getPlayersFromFantasy(String fantasy_id){
  Completer<List<String>> completer = new Completer<List<String>>();
  List<String> playersList = new List();

  FirebaseDatabase.instance
      .reference()
      .child("fantasy")
      .child(fantasy_id)
      .child("players")
      .once()
      .then((DataSnapshot snapshot) {

    Map<dynamic, dynamic> snapPlayers = snapshot.value;
    snapPlayers.forEach((key, value){
      playersList.add(key.toString());
    });
    completer.complete(playersList);

  });
  return completer.future;
}


removeFantasyCompetition(String fantasy_id){
  FirebaseDatabase.instance.reference().child('fantasy').child(fantasy_id).remove();
}

removeFantasyCompetitionForUser(String user_id, String fantasy_id){
  FirebaseDatabase.instance.reference().child('users').child(user_id).child('fantasy').child(fantasy_id).remove();
}

removeWaitingUserFantasy(String fantasy_id, String user_id){
  FirebaseDatabase.instance.reference().child('fantasy').child(fantasy_id).child('players').child(user_id).remove();
  removeFantasyCompetitionForUser(user_id, fantasy_id);

}

updateUserFantasyStatus(String user_id, String fantasy_id, String status){
  FirebaseDatabase.instance.reference().child('users').child(user_id).child('fantasy').child(fantasy_id).update({
    'status': status,
  });

  FirebaseDatabase.instance.reference().child('fantasy').child(fantasy_id).child("players").child(user_id).update({
    'status': status,
  });
}

updateFantasyStatus(String fantasy_id, String status){
  FirebaseDatabase.instance.reference().child('fantasy').child(fantasy_id).update({
    'status': status,
  });
}

Future <String> isItLastAuctionUser(String fantasy_id){
  Completer<String> completer = new Completer<String>();
  String last_done;
  int count_players = 0;
  int count_auction_done = 0;
  String id_not_done;

  FirebaseDatabase.instance
      .reference()
      .child("fantasy")
      .child(fantasy_id)
      .child("players")
      .once()
      .then((DataSnapshot snapshot) {

    Map<dynamic, dynamic> snapPlayers = snapshot.value;
    snapPlayers.forEach((key, value){
      count_players++;
      if(value['status'].toString() == "Waiting for auction-draft-resolution" || value['status'].toString() == "Auction closed"){
        count_auction_done++;
      }else{
        id_not_done = key;
      }
    });
    if(count_players-1 == count_auction_done){
      last_done = id_not_done;
    }
    completer.complete(last_done);
  });
  return completer.future;
}

Future<String> isItLastClosedAuctionUser(String fantasy_id){
  Completer<String> completer = new Completer<String>();
  String last_done;
  int count_players = 0;
  int count_auction_closed = 0;
  String id_not_closed;
  print('is it last closed auction user ? ');

  FirebaseDatabase.instance
      .reference()
      .child("fantasy")
      .child(fantasy_id)
      .child("players")
      .once()
      .then((DataSnapshot snapshot) {

    Map<dynamic, dynamic> snapPlayers = snapshot.value;
    snapPlayers.forEach((key, value){
      count_players++;
      if(value['status'].toString() == "Auction closed"){
        count_auction_closed++;
      }else{
        id_not_closed = key;
      }
    });
    if(count_players-1 == count_auction_closed){
      last_done = id_not_closed;
    }
    completer.complete(last_done);
  });
  return completer.future;
}

updateAllUserFantasyStatus(String fantasy_id, String status){
  FirebaseDatabase.instance
      .reference()
      .child("fantasy")
      .child(fantasy_id)
      .child('players')
      .once()
      .then((DataSnapshot snapshot) {

    Map<dynamic, dynamic> snapFantasy = snapshot.value;
    snapFantasy.forEach((key, value) {
        if(value['status'] != 'Auction closed'){
          updateUserFantasyStatus(key, fantasy_id, status);
        }
      });
  });
}

initPlayersMarket(String fantasy_id){
  FirebaseDatabase.instance
      .reference()
      .child("api")
      .child("players")
      .once()
      .then((DataSnapshot snapshot) {

    Map<dynamic, dynamic> snapPlayers = snapshot.value;
    snapPlayers.forEach((key, value){
      String name = value['last_name'] == "" ?
          value['first_name'].toString().toUpperCase()
         : value['first_name'].toString().substring(0,1)+". "+value['last_name'].toString().toUpperCase();

      FirebaseDatabase.instance.reference().child('fantasy').child(fantasy_id).child('market').child(key).update({
        "name": name,
        'team_id': value['team_id'],
        "position": value['position'],
        "price": value['price'],
        "owner": 'free'
      });
    });
  });
}

addNewAuction(String fantasy_id, List<Bid> selected_players, User user, int newBudget){

  selected_players.forEach((Bid player_bid){
    FirebaseDatabase.instance.reference().child('fantasy').child(fantasy_id).child('auctions').child(player_bid.player.id).update({
      "name": player_bid.player.short_name,
      'team_id': player_bid.player.teamAbrev,
      "position": player_bid.player.position,
    });

     FirebaseDatabase.instance.reference().child('fantasy').child(fantasy_id).child('auctions').child(player_bid.player.id).child(user.id).update({
      "auction": player_bid.bid,
      "owner_id": user.id,
      "owner_name": user.pseudo,
      "auction_date": DateTime.now().toUtc().toString(),
    });

    FirebaseDatabase.instance.reference().child('users').child(user.id).child('fantasy').child(fantasy_id).child('auctions').child(player_bid.player.id).update({
      "name": player_bid.player.short_name,
      'team_id': player_bid.player.teamAbrev,
      "position": player_bid.player.position,
      "auction": player_bid.bid,
    });

    FirebaseDatabase.instance.reference().child('fantasy').child(fantasy_id).child('auctions').child(player_bid.player.id).child(user.id).update({
      "auction": player_bid.bid,
      "owner_id": user.id,
      "owner_name": user.pseudo,
      "auction_date": DateTime.now().toUtc().toString(),
    });
  });

  updateBudget(fantasy_id, user.id, newBudget);
}

buyPlayer(String fantasy_id, String user_id, String player_id, int auction, String position, String name, String team){
  FirebaseDatabase.instance.reference().child('fantasy').child(fantasy_id).child("market").child(player_id).update(
      {
        'owner': user_id,
      });

  FirebaseDatabase.instance.reference().child('fantasy').child(fantasy_id).child("players").child(user_id).child("squad").child(player_id).update(
      {
        'auction': auction,
        'name': name,
        'position': position,
        'team_id': team,
      });

  //substractBudget(fantasy_id, user_id, auction);
}

setAuctionStatus(String fantasy_id, String user_id, String player_id, String status){
  FirebaseDatabase.instance.reference().child('fantasy').child(fantasy_id).child("auctions").child(player_id).child(user_id).update(
      {
        'status': status,
      });
  FirebaseDatabase.instance.reference().child('users').child(user_id).child("fantasy").child(fantasy_id).child('auctions').child(player_id).update(
      {
        'status': status,
      });
}

substractBudget(String fantasy_id, String user_id,int auction){
  getBudget(user_id, fantasy_id).then((actualBudget){
    FirebaseDatabase.instance.reference().child('users').child(user_id).child("fantasy").child(fantasy_id).update(
        {
          'budget': actualBudget-auction,
        });

    FirebaseDatabase.instance.reference().child('fantasy').child(fantasy_id).child("players").child(user_id).update(
        {
          'budget': actualBudget-auction,
        });
  });
}

updateBudget(String fantasy_id, String user_id, int newBudget){
  FirebaseDatabase.instance.reference().child('users').child(user_id).child("fantasy").child(fantasy_id).update(
      {
        'budget': newBudget,
      });
  FirebaseDatabase.instance.reference().child('fantasy').child(fantasy_id).child("players").child(user_id).update(
      {
        'budget': newBudget,
      });
}

Future auctionResolution(String fantasy_id) async {
  FirebaseDatabase.instance
      .reference()
      .child("fantasy")
      .child(fantasy_id)
      .child("auctions")
      .once()
      .then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> snapAuctions = snapshot.value;
        snapAuctions.forEach((key, value){
          Map<dynamic, dynamic> snapAuctionsPlayer = value;
          if(!snapAuctionsPlayer.keys.contains('resolved')){
            if(snapAuctionsPlayer.length==4){
              String owner_id = snapAuctionsPlayer.keys.firstWhere((owner) => owner.toString().length > 16);
              buyPlayer(fantasy_id, owner_id, key.toString(), snapAuctionsPlayer.values.elementAt(0)['auction'], snapAuctionsPlayer['position'].toString(), snapAuctionsPlayer['name'].toString(), snapAuctionsPlayer['team_id'].toString());
              setAuctionStatus(fantasy_id, owner_id, key.toString(), "won");

            }else{
              //Plusieurs enchères sur le joueur
              var auction_time = DateTime(1987,2,11);
              int highestBid = 0;
              String winner = null;
              snapAuctionsPlayer.forEach((keyPlayer, valuePlayer) {
                if (keyPlayer != "name" && keyPlayer != "position" && keyPlayer != "team_id"){

                  setAuctionStatus(fantasy_id, keyPlayer, key.toString(), "lost");

                  print('double auction : '+key.toString());
                  print('if : '+DateTime.parse(valuePlayer['auction_date']).toString()+' is before '+auction_time.toString()+' : '+DateTime.parse(valuePlayer['auction_date']).isBefore(auction_time).toString());
                  if((int.parse(valuePlayer['auction'].toString()) > highestBid) || ((int.parse(valuePlayer['auction'].toString()) == highestBid) && DateTime.parse(valuePlayer['auction_date']).isBefore(auction_time))) {
                    auction_time = DateTime.parse(valuePlayer['auction_date']);
                    highestBid = valuePlayer['auction'];
                    winner = valuePlayer['owner_id'];
                  }
                }
              });
              buyPlayer(fantasy_id, winner.toString(), key.toString(), highestBid, snapAuctionsPlayer['position'].toString(), snapAuctionsPlayer['name'].toString(), snapAuctionsPlayer['team_id'].toString());
              setAuctionStatus(fantasy_id, winner.toString(), key.toString(), "won");

            }
          }
          setAuctionResolved(fantasy_id, key.toString());
        });
      });
  updateAllUserFantasyStatus(fantasy_id, "Waiting for auction-draft");
  print('auction resolution is over');
}

setAuctionResolved(String fantasy_id, String player_id){
  FirebaseDatabase.instance.reference().child('fantasy').child(fantasy_id).child("auctions").child(player_id).update(
      {
        'resolved': true,
      });
}

Future<List<Bid>> getWaitingAuctionSquad(String user_id, String fantasy_id){
  Completer<List<Bid>> completer = new Completer<List<Bid>>();
  List<Bid> listBid = new List();

  FirebaseDatabase.instance
      .reference()
      .child("users")
      .child(user_id)
      .child("fantasy")
      .child(fantasy_id)
      .child("auctions")
      .once()
      .then((DataSnapshot snapshot) {

    Map<dynamic, dynamic> snapPlayers = snapshot.value;
    if(snapPlayers != null){
      snapPlayers.forEach((key, value){
        Map<dynamic, dynamic> snapPlayersAuction = value;

          listBid.add(new Bid(
            player: new Player(id: key, short_name: value['name'], position: value['position'], teamId: value['team_id'], price: value['auction']),
            bid: value['auction'],
            status: snapPlayersAuction .containsKey('status') ? value['status'] : null,
          ));
      });
    }
    completer.complete(listBid);
  });
  return completer.future;

}


Future<int> getBudget(String user_id, String fantasy_id){
  Completer<int> completer = new Completer<int>();
  int budget ;

  FirebaseDatabase.instance
      .reference()
      .child("users")
      .child(user_id)
      .child("fantasy")
      .child(fantasy_id)
      .once()
      .then((DataSnapshot snapshot) {

        budget = snapshot.value['budget'];

    completer.complete(budget);
  });
  return completer.future;
}