import 'package:firebase_database/firebase_database.dart';
import 'package:bricktime/model/user.dart';
import 'package:bricktime/model/player.dart';
import 'package:bricktime/model/bid.dart';
import 'package:bricktime/model/squad.dart';
import 'package:bricktime/model/confrontation.dart';
import 'package:bricktime/dbase/constantes_actions.dart';
import 'package:bricktime/dbase/user_actions.dart';
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
    playersList.forEach((player){
      removeFantasyCompetitionForUser(player.id, fantasy_id);
    });
  }).then((message){
    removeFantasyCompetition(fantasy_id);
  });
}

Future<List<User>> getPlayersFromFantasy(String fantasy_id){
  Completer<List<User>> completer = new Completer<List<User>>();
  List<User> playersList = new List();

  FirebaseDatabase.instance
      .reference()
      .child("fantasy")
      .child(fantasy_id)
      .child("players")
      .once()
      .then((DataSnapshot snapshot) {

    Map<dynamic, dynamic> snapPlayers = snapshot.value;
    snapPlayers.forEach((key, value){
      playersList.add(new User(
        id: key.toString(),
        pseudo: value['name'],
      )
      );
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
        print(value['status'].toString()+" "+status);
        if(value['status'] != 'Auction closed' || status == 'Playing'){
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
          print('debut :: '+snapAuctionsPlayer.keys.toString());
          if(!snapAuctionsPlayer.keys.contains('resolved')){
            if(snapAuctionsPlayer.length==4){

              String owner_id = snapAuctionsPlayer.keys.firstWhere((owner) => owner.toString().length > 16);
              buyPlayer(fantasy_id, owner_id, key.toString(), snapAuctionsPlayer.values.elementAt(snapAuctionsPlayer.values.toList().indexWhere((key){return (key.toString().length > 20);}))['auction'], snapAuctionsPlayer['position'].toString(), snapAuctionsPlayer['name'].toString(), snapAuctionsPlayer['team_id'].toString());
              setAuctionStatus(fantasy_id, owner_id, key.toString(), "won");

            }else{
              //Plusieurs enchères sur le joueur
              var auction_time = DateTime(1987,2,11);
              int highestBid = 0;
              String winner = null;
              snapAuctionsPlayer.forEach((keyPlayer, valuePlayer) {
                if (keyPlayer != "name" && keyPlayer != "position" && keyPlayer != "team_id"){

                  setAuctionStatus(fantasy_id, keyPlayer, key.toString(), "lost");

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

Future<String> getFantasyName(String fantasy_id){
  Completer<String> completer = new Completer<String>();
  String name ;

  FirebaseDatabase.instance
      .reference()
      .child("fantasy")
      .child(fantasy_id)
      .once()
      .then((DataSnapshot snapshot) {

    name = snapshot.value['fantasy_name'];

    completer.complete(name);
  });
  return completer.future;
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


Future initFantasyPostDraft(String fantasy_id){
  print("initFantasyPostDraft");

  getPlayersFromFantasy(fantasy_id).then((List<User> players){
    int nb_week_to_play = (players.length-1)*2;
    int matchup_per_week = (players.length/2).round();

    List<List<Confrontation>> all_weeks_matchup = new List();

    List<int> matrix = new List();
    for(int a=0; a<players.length; a++){
      matrix.add(a);
    }

    DateTime nextMonday = getNextMondayFromNow();

    getRealNBAStartDate().then((String startDate){

      //Borne le lundi à un date postérieure à la date de début de saison officielle
      if(nextMonday.isBefore(DateTime.parse(startDate))){
        nextMonday = DateTime.parse(startDate);
      }

      DateTime next_monday_post_season = nextMonday.add(Duration(days: (nb_week_to_play+1)*7));

      getRealNBAEndDate().then((String date){

        //Borne la saison au lundi qui précède la date de fin de saison officielle
        if(next_monday_post_season.isAfter(DateTime.parse(date))){
          nb_week_to_play = (DateTime.parse(date).difference(nextMonday).inDays/7).round();
        }

        bool week_is_pair = true;
        for(int i=0; i<nb_week_to_play; i++){
          nextMonday = nextMonday.add(Duration(days: 7*i));

          List<Confrontation> week_matchup = new List();

          for(int j=0; j<matchup_per_week; j++){
            if(week_is_pair){
              week_matchup.add(new Confrontation(
                start_date_time: nextMonday,
                domicile: players.elementAt(matrix.elementAt(j)).id,
                domicile_name: players.elementAt(matrix.elementAt(j)).pseudo,
                exterieur: players.elementAt(matrix.elementAt(matrix.length-1-j)).id,
                exterieur_name: players.elementAt(matrix.elementAt(matrix.length-1-j)).pseudo,
              ));
            }else{
              week_matchup.add(new Confrontation(
                start_date_time: nextMonday,
                domicile: players.elementAt(matrix.elementAt(matrix.length-1-j)).id,
                domicile_name: players.elementAt(matrix.elementAt(matrix.length-1-j)).pseudo,
                exterieur: players.elementAt(matrix.elementAt(j)).id,
                exterieur_name: players.elementAt(matrix.elementAt(j)).pseudo,
              ));
            }
          }
          all_weeks_matchup.add(week_matchup);
          week_is_pair = !week_is_pair;

          for(int x=0; x<matrix.length; x++){
            x != 0 ? matrix.elementAt(x)+1 > players.length-1 ? matrix[x] = 1 : matrix[x] +=1 : null;
          }
        }

        //
        //ECRITURE DU CALENDRIER DES RENCONTRES EN BASE
        //
        all_weeks_matchup.forEach((List<Confrontation> wmp){
          wmp.forEach((Confrontation mp){

            String weekLabel = "week"+mp.start_date_time.year.toString()+(mp.start_date_time.month<10 ? "0":"")+mp.start_date_time.month.toString()+(mp.start_date_time.day<10 ? "0":"")+mp.start_date_time.day.toString();
            // L'id d'un match est la concaténation des id users domicile et extérieur
            FirebaseDatabase.instance.reference().child('fantasy').child(fantasy_id).child("calendar").child(weekLabel).child(mp.domicile+mp.exterieur).update(
                {
                  'home': mp.domicile,
                  'home_name': mp.domicile_name,
                  'away': mp.exterieur,
                  'away_name': mp.exterieur_name,
                  'status': 'not played',
                });
          });
        });

      });
    });

    updateSquad(fantasy_id,null,null);
  });
}

//Renvoie le lundi suivant (si on est dimanche il renvoie le lundi dans 8 jours)
DateTime getNextMondayFromNow() {
  var year = DateTime.now().year;
  var month = DateTime.now().month;
  var day = DateTime.now().day;

  var d = new DateTime(year,month,day);

  int diff = d.weekday == 7 ? 8 : 7-d.weekday+1;
  DateTime next = d.add(Duration(days: diff));
  return next;

}

//Renvoie la constante Next_Monday de la base de données
Future<DateTime> getNextMonday(){
  Completer<DateTime> completer = new Completer<DateTime>();
  DateTime next_monday;

  FirebaseDatabase.instance.reference().child("constantes").child('next_monday').once().then((DataSnapshot snapshot){
    if(snapshot != null){

      next_monday = DateTime.parse(snapshot.value);
      completer.complete(next_monday);
    }
  });

  return completer.future;

}


Future<Squad> getSquadData(String fantasy_id, String user_id){
  Completer<Squad> completer = new Completer<Squad>();
  Squad squad = new Squad();

  FirebaseDatabase.instance
      .reference()
      .child("fantasy")
      .child(fantasy_id)
      .child("players")
      .child(user_id)
      .once()
      .then((DataSnapshot snapshot) {

        if(snapshot != null){
          Map<dynamic, dynamic> snapDataCompetition = snapshot.value;
          if(snapDataCompetition.keys.contains('squad')){
            squad.players = new List();
            squad.starters = [null, null, null, null, null];
            squad.subs = [null, null, null, null, null];
            squad.waterboys = new List();
            squad.minutes_per_position = [1, 1, 1, 1, 1];
            squad.strategy_played = new List();

            Map<dynamic, dynamic> snapSquad = snapDataCompetition['squad'];
            snapSquad.forEach((key, value){
              Player tmpPlayer = Player(
                  short_name: value['name'],
                  position: value['position'],
                  teamId: value['team_id'],
                  rotation: value['rotation'],
                  num_poste: value['num_poste'],
                  id: key,
              );

              squad.players.add(tmpPlayer);
              switch(value['rotation']){
                case 'starter': {
                  squad.starters[value['num_poste']] = tmpPlayer;
                  squad.minutes_per_position[value['num_poste']] = value['minute'];
                }
                break;

                case 'sub': {
                  squad.subs[value['num_poste']] = tmpPlayer;
                }
                break;

                case 'waterboy': {
                  squad.waterboys.add(tmpPlayer);
                }
                break;

                default: {
                  squad.waterboys.add(tmpPlayer);
                }
                break;
              };
            });

            if(snapDataCompetition.keys.contains('used_strategies')){
              Map<dynamic, dynamic> snapStrategies = snapDataCompetition['used_strategies'];
              snapStrategies.forEach((key, value) {
                if(value){
                  squad.strategy_played.add(key);
                }
              });
            }

            squad.strategy_selected = snapDataCompetition['strategy_selected'].toString();
            squad.id_bonus_player = snapDataCompetition['bonus_player'].toString();
            squad.num_poste_bonus_player = snapDataCompetition['num_poste_bonus_player'].toString() == "null" ? null : int.parse(snapDataCompetition['num_poste_bonus_player'].toString());
            squad.game_plan = snapDataCompetition['game_plan'] == null ? 'Classic' : snapDataCompetition['game_plan'].toString();

          }
        }

    completer.complete(squad);
  });
  return completer.future;
}


updateSquad(String fantasy_id, String user_id, Squad squad){

  //Si null alors c'est l'init post Draft (pour qu'une équipe soit pré-remplie
  if(user_id == null || squad == null){
    FirebaseDatabase.instance
        .reference()
        .child("fantasy")
        .child(fantasy_id)
        .child("players")
        .once()
        .then((DataSnapshot snapshot) {

      if(snapshot != null){
        Map<dynamic, dynamic> snapDataPlayers = snapshot.value;
        snapDataPlayers.forEach((keyPlayer, valuePlayer){
          FirebaseDatabase.instance.reference().child('fantasy').child(fantasy_id).child("players").child(keyPlayer).update(
              {
                'game_plan': "Classic",
                'strategy_selected': "null",
                'bonus_player': "null",
                'num_poste_bonus_player': "null",
              });

          Map<dynamic, dynamic> snapDataSquad = valuePlayer['squad'];
          bool initC = false;
          bool initF1 = false;
          bool initF2 = false;
          bool initG1 = false;
          bool initG2 = false;

          snapDataSquad.forEach((keySquad, valueSquad){
              switch(valueSquad['position'].toString().substring(0,1)){
                case 'C': {
                  if(initC){
                    FirebaseDatabase.instance.reference().child('fantasy').child(fantasy_id).child("players").child(keyPlayer).child("squad").child(keySquad).update(
                        {
                          "rotation": "waterboy",
                        });
                  }else{
                    initC = true;
                    FirebaseDatabase.instance.reference().child('fantasy').child(fantasy_id).child("players").child(keyPlayer).child("squad").child(keySquad).update(
                        {
                          "num_poste": 4,
                          "minute": 0,
                          "rotation": "starter",
                        });
                  }
                }
                break;
                case 'F': {
                  if(initF1 && initF2){
                    FirebaseDatabase.instance.reference().child('fantasy').child(fantasy_id).child("players").child(keyPlayer).child("squad").child(keySquad).update(
                        {
                          "rotation": "waterboy",
                        });
                  }else if(initF1){
                    initF2 = true;
                    FirebaseDatabase.instance.reference().child('fantasy').child(fantasy_id).child("players").child(keyPlayer).child("squad").child(keySquad).update(
                        {
                          "num_poste": 3,
                          "minute": 0,
                          "rotation": "starter",
                        });

                  }else{
                    initF1 = true;
                    FirebaseDatabase.instance.reference().child('fantasy').child(fantasy_id).child("players").child(keyPlayer).child("squad").child(keySquad).update(
                        {
                          "num_poste": 2,
                          "minute": 0,
                          "rotation": "starter",
                        });
                  }
                }
                break;
                case 'G': {
                  if(initG1 && initG2){
                    FirebaseDatabase.instance.reference().child('fantasy').child(fantasy_id).child("players").child(keyPlayer).child("squad").child(keySquad).update(
                        {
                          "rotation": "waterboy",
                        });

                  }else if(initG1){
                    initG2 = true;
                    FirebaseDatabase.instance.reference().child('fantasy').child(fantasy_id).child("players").child(keyPlayer).child("squad").child(keySquad).update(
                        {
                          "num_poste": 1,
                          "minute": 0,
                          "rotation": "starter",
                        });

                  }else{
                    initG1 = true;
                    FirebaseDatabase.instance.reference().child('fantasy').child(fantasy_id).child("players").child(keyPlayer).child("squad").child(keySquad).update(
                        {
                          "num_poste": 0,
                          "minute": 0,
                          "rotation": "starter",
                        });
                  }
                }
                break;
              }
          });
        });
      }
    });

  }else{
    print("Function update Squad ");
    if(squad.strategy_selected.toString() != "null"){

      FirebaseDatabase.instance
          .reference()
          .child("fantasy")
          .child(fantasy_id)
          .child("players")
          .child(user_id)
          .once()
          .then((DataSnapshot snapshot) async{

        if(snapshot != null){
          Map<dynamic, dynamic> snapDataCompetition = snapshot.value;
          if(snapDataCompetition.keys.contains("used_strategies")){
            Map<dynamic, dynamic> snapStrategies = snapDataCompetition['used_strategies'];
            if(!snapStrategies.keys.contains(squad.strategy_selected.toString())){
              FirebaseDatabase.instance.reference().child('fantasy').child(fantasy_id).child("players").child(user_id).update(
                  {
                    'strategy_selected': squad.strategy_selected.toString(),
                    'bonus_player': squad.id_bonus_player.toString(),
                    'num_poste_bonus_player' : squad.num_poste_bonus_player,
                  });
            }
          }else{
            FirebaseDatabase.instance.reference().child('fantasy').child(fantasy_id).child("players").child(user_id).update(
            {
              'strategy_selected': squad.strategy_selected.toString(),
              'bonus_player': squad.id_bonus_player.toString(),
              'num_poste_bonus_player' : squad.num_poste_bonus_player,
            });
          }
        }else{
          FirebaseDatabase.instance.reference().child('fantasy').child(fantasy_id).child("players").child(user_id).update(
          {
            'strategy_selected': squad.strategy_selected.toString(),
            'bonus_player': squad.id_bonus_player.toString(),
            'num_poste_bonus_player' : squad.num_poste_bonus_player,
          });
        }
      });
    }else{
      FirebaseDatabase.instance.reference().child('fantasy').child(fantasy_id).child("players").child(user_id).update(
          {
            'strategy_selected': squad.strategy_selected.toString(),
            'bonus_player': squad.id_bonus_player.toString(),
            'num_poste_bonus_player' : squad.num_poste_bonus_player,
          });
    }


    FirebaseDatabase.instance.reference().child('fantasy').child(fantasy_id).child("players").child(user_id).update(
        {
          'game_plan': squad.game_plan.toString(),
        });

    squad.players.forEach((Player player){
      int pos_starters = squad.starters.indexOf(player);
      if(pos_starters >= 0){
        FirebaseDatabase.instance.reference().child('fantasy').child(fantasy_id).child("players").child(user_id).child('squad').child(player.id).update(
            {
              'num_poste': pos_starters,
              'rotation': 'starter',
              'minute': squad.minutes_per_position[pos_starters],

            });
      }else{

        //pas starter , Test SUB ?
        int pos_sub = squad.subs.indexOf(player);
        if(pos_sub >= 0){
          FirebaseDatabase.instance.reference().child('fantasy').child(fantasy_id).child("players").child(user_id).child('squad').child(player.id).update(
              {
                'num_poste': pos_sub,
                'rotation': 'sub',
                'minute': squad.minutes_per_position[pos_sub],

              });
        }else{
          //pas starter, pas sub DONC WATERBOY
          FirebaseDatabase.instance.reference().child('fantasy').child(fantasy_id).child("players").child(user_id).child('squad').child(player.id).update(
              {
                'num_poste': null,
                'rotation': 'waterboy',
                'minute': null,

              });
        }
      }
    });
  }
}

//Renvoie Null si aucun next game
Future<DateTime> getNextGameDate(String fantasy_id){
  Completer<DateTime> completer = new Completer<DateTime>();
  DateTime nextGame = null;

  getNextMonday().then((DateTime nextMonday){

    print(nextMonday.toString());

    String weekLabel = "week"+nextMonday.year.toString()+(nextMonday.month<10 ? "0":"")+nextMonday.month.toString()+(nextMonday.day<10 ? "0":"")+nextMonday.day.toString();

    FirebaseDatabase.instance
        .reference()
        .child("fantasy")
        .child(fantasy_id)
        .child('calendar')
        .once()
        .then((DataSnapshot snapshot) {

      Map<dynamic, dynamic> weeks = snapshot.value;
      weeks.forEach((key, value){
        if(key == weekLabel){
          nextGame = DateTime.parse(weekLabel.substring(4));
        }
      });
    });
    completer.complete(nextMonday);
  });

  return completer.future;
}

Future<String> getNextContestant(String fantasy_id, String user_id, DateTime nextGame){
  Completer<String> completer = new Completer<String>();
  String nextContestant;// = null;
  print("next game : "+nextGame.toString());
  String weekLabel = "week"+nextGame.year.toString()+(nextGame.month<10 ? "0":"")+nextGame.month.toString()+(nextGame.day<10 ? "0":"")+nextGame.day.toString();
  
  FirebaseDatabase.instance
      .reference()
      .child("fantasy")
      .child(fantasy_id)
      .child('calendar')
      .child(weekLabel)
      .once()
      .then((DataSnapshot snapshot) {

    Map<dynamic, dynamic> confrontations = snapshot.value;
    confrontations.forEach((key, value){
      if(key.toString().contains(user_id)){
        print(key.toString()+" is in "+user_id);

        if(value['home'] == user_id){
          getUserPseudo(value['away']).then((String pseudo){
            completer.complete(pseudo);
          });
        }else if(value['away'] == user_id){
          getUserPseudo(value['home']).then((String pseudo){
            completer.complete(pseudo);
          });
        }
      }
    });

  });
  return completer.future;
}

Future<List<String>> getWeekLabels(String fantasy_id){
  Completer<List> completer = new Completer<List<String>>();
  List<String> weekLabels = List();

  FirebaseDatabase.instance
      .reference()
      .child("fantasy")
      .child(fantasy_id)
      .child('calendar')
      .once()
      .then((DataSnapshot snapshot) {


    Map<dynamic, dynamic> weeks = snapshot.value;
    if(weeks != null){
      weekLabels = List.from(weeks.keys);
      weekLabels.sort((a, b) => a.compareTo(b));
    }
    completer.complete(weekLabels);
  });
  return completer.future;
}
