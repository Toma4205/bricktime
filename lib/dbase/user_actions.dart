import 'package:firebase_database/firebase_database.dart';
import 'package:bricktime/model/user.dart';
import 'dart:async';

void add_new_user(String id, String pseudo){
  FirebaseDatabase.instance.reference().child('users').child(id).child('infos').update(
      {
        'pseudo': pseudo,
        'level' : 'Rookie',
        'last_connexion': DateTime.now().toString(),
      });
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
          User user = new User(id: id, pseudo: snapshot.value['pseudo'], level: snapshot.value['level'], lastConnexion: snapshot.value['lastConnexion']);
          print('return '+user.pseudo.toString());
          completer.complete(user);
  });
  return completer.future;
}
