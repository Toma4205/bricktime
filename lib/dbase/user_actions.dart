import 'package:firebase_database/firebase_database.dart';
import 'package:bricktime/model/user.dart';
import 'package:bricktime/model/record.dart';
import 'package:bricktime/dbase/user_prono_actions.dart';
import 'dart:async';



Future<void> add_new_user(String id, String pseudo) async{
  //Only first connexion
  Completer<void> completer = new Completer<void>();

  FirebaseDatabase.instance.reference().child('users').child(id).once().then((DataSnapshot snapshot){
    if(snapshot.value == null){
      print('Sign in');
      FirebaseDatabase.instance.reference().child('users').child(id).child('infos').update(
          {
            'pseudo': pseudo,
            'level' : 'Rookie',
            'first_connexion': DateTime.now().toString(),
            'last_connexion': DateTime.now().toString(),
            'avatar': "images/avatar",
          }).whenComplete((){
        completer.complete();
        return completer;
      });
      setInProgressCompetitionPronosForUser(id);
    }else{
      print('Log in');
      FirebaseDatabase.instance.reference().child('users').child(id).child('infos').update(
          {
            'last_connexion': DateTime.now().toString(),
          }).whenComplete((){
        completer.complete();
        return completer;
      });
    }
  });
}

void updateUserAvatar(String id, String avatar){
  FirebaseDatabase.instance.reference().child('users').child(id).child('infos').update(
      {
        'avatar': avatar,
      });
}

void updateUserPseudo(String id, String pseudo){
  FirebaseDatabase.instance.reference().child('users').child(id).child('infos').update(
      {
        'pseudo': pseudo,
      });
}

Future<String> getUserPseudo(String id){
  Completer<String> completer = new Completer<String>();
  FirebaseDatabase.instance
      .reference()
      .child("users")
      .child(id)
      .child("infos")
      .once()
      .then((DataSnapshot snapshot){

        if(snapshot.value != null){
          completer.complete(snapshot.value['pseudo']);
          print('getPseudo : '+snapshot.value['pseudo']);
        }
  });
  return completer.future;
}

Future<User> getUserInfo(String id) async {
  Completer<User> completer = new Completer<User>();
  print('getuser : '+id);

  FirebaseDatabase.instance
      .reference()
      .child("users")
      .child(id)
      .child("infos")
      .once()
      .then((DataSnapshot snapshot) {

          List<Record> records = new List();
          if(snapshot.value != null){
            if(snapshot.value['records'] != null){
              Map<dynamic, dynamic> recordsMap = snapshot.value['records'];
              recordsMap.forEach((key, value){
                records.add(new Record(
                  typeYear: key,
                  points: value.toString().substring(0,value.toString().indexOf("-")),
                  rank: value.toString().substring(value.toString().indexOf("-")+1),
                )
                );
              });

              records.sort((a,b) => b.typeYear.compareTo(a.typeYear));
            }
            User user = new User(id: id, pseudo: snapshot.value['pseudo'], level: snapshot.value['level'], lastConnexion: snapshot.value['lastConnexion'], records: records, avatar: snapshot.value['avatar']);
            print('return '+user.pseudo.toString());
            completer.complete(user);
          }else{
            User user = new User(id: id, pseudo: "pseudo", level: "level", lastConnexion: "0000000000", records: null, avatar: null);
            print('return '+user.pseudo.toString());
            completer.complete(user);
          }

  });
  return completer.future;
}

Future<List<User>> getUsersList(int year) async {
  Completer<List<User>> completer = new Completer<List<User>>();

  FirebaseDatabase.instance.reference().child("users").once().then((DataSnapshot snapshot){
    Map<dynamic, dynamic> usersSnapshot = snapshot.value;
    List<User> users = new List();

    if(usersSnapshot != null){
      usersSnapshot.forEach((index, data){
        Map<dynamic, dynamic> infosSnap = data;
        infosSnap.forEach((index1, data1) async {
          if(data1['pseudo'] != null){
            computeScore(index, year.toString()+"playoffs").then((score){
              users.add(new User(
                  pseudo: data1['pseudo'].toString(),
                  level: data1['level'].toString(),
                  avatar: data1['avatar'].toString(),
                  totalScore: score
              ));
            });

                 // print(data1['pseudo'] + " = " + score.toString());
          }
        });
      });
    }

    completer.complete(users);
  });

  return completer.future;
}

Future<int> computeScore(String id, String playoffsYear) async {
  Completer<int> completer = new Completer<int>();
  int totalPoints = 0;

  FirebaseDatabase.instance
      .reference()
      .child("users")
      .child(id)
      .child('pronos')
      .child(playoffsYear)
      .once()
      .then((DataSnapshot snapshot) {

        Map<dynamic, dynamic> playoffsPronosByUserSnap = snapshot.value;
        playoffsPronosByUserSnap.forEach((key, data){
          Map<dynamic, dynamic> serieByConf = data;
          serieByConf.forEach((key1, data1){
            totalPoints += data1["points"];
          });
        });

        completer.complete(totalPoints);
      });

  return completer.future;
}