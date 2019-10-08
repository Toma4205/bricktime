import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bricktime/dbase/user_actions.dart';

Future<void> startFacebookLogin() async{
  final facebookLogin = FacebookLogin();
  final result = await facebookLogin.logInWithReadPermissions(['email']);

  switch (result.status) {
    case FacebookLoginStatus.loggedIn:
      final FacebookAccessToken myToken = result.accessToken;
      ///assuming sucess in FacebookLoginStatus.loggedIn
      /// we use FacebookAuthProvider class to get a credential from accessToken
      /// this will return an AuthCredential object that we will use to auth in firebase
      AuthCredential credential= FacebookAuthProvider.getCredential(accessToken: myToken.token);

      /// this line do auth in firebase with your facebook credential.
      FirebaseUser firebaseUser = await FirebaseAuth.instance.signInWithCredential(credential);
      final graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name&access_token=${myToken.token}');
      final profile = json.decode(graphResponse.body);

      //Ajout de l'aborescence utilisateur dans FIREBASE
      add_new_user(firebaseUser.uid, profile['name'].toString());
      break;
    case FacebookLoginStatus.cancelledByUser:
      print('Facebook Login has been canceled by user');
      break;
    case FacebookLoginStatus.error:
      print('Facebook Login failed');
      break;
  }
}
