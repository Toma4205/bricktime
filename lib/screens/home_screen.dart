import 'package:bricktime/screens/ranking_screen.dart';
import 'package:flutter/material.dart';
import 'package:bricktime/auth/authEmail.dart';
import 'package:bricktime/screens/my_pronostics_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:bricktime/screens/my_profile_screen.dart';
import 'package:bricktime/dbase/user_actions.dart';
import 'package:bricktime/model/user.dart';
import 'package:bricktime/dbase/constantes_actions.dart';
import 'package:bricktime/dbase/user_prono_actions.dart';
import 'package:bricktime/model/prono.dart';
import 'package:bricktime/model/list_model.dart';
import 'package:bricktime/screens/results_screen.dart';

import 'dart:io' show Platform;

class HomeScreen extends StatefulWidget{
  HomeScreen({Key key, this.auth}) : super(key: key);
  final BaseAuth auth;


  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging(); //Notification FCM
  final User myuser = User(id: 'id', pseudo: 'pseudo', level: 'level', lastConnexion: 'lastConnexion');
  final GlobalKey<AnimatedListState> _listKey = new GlobalKey<AnimatedListState>();

  String playoffYear;
  ListModel listModel;
  bool showOnlyPending = false;
  bool isAdmin = false;

  List<Prono> pronos = new List();

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user){
      getUserInfo(user).then(_updateUserInfo);
      getActualPlayoffYear().then((_updateActualPlayoffsYear));
      getAdminId().then((_updateIsAdmin));
    });

    firebaseCloudMessaging_Listeners(); //Notification FCM
  }

  _updateUserInfo(User user){
    setState(() {
      myuser.pseudo = user.pseudo;
      myuser.level = user.level;
      myuser.id = user.id;
      myuser.lastConnexion = user.lastConnexion;
      myuser.records = user.records;
      myuser.avatar = user.avatar;
    });
  }

  _updateActualPlayoffsYear(String year){
    setState(() {
      playoffYear = year;
    });
    _updateInitPronos();
  }

  _updateInitPronos(){
    if(playoffYear != null && myuser.id != null){
      getPronoFromCompetitionForUser(myuser.id, int.parse(playoffYear)).then((pronos){
        _updatesPronos(pronos);
        _updateListModel();
        //_updateIsShowResults(true);
      });
    }
  }

  _updatesPronos(List<Prono> pronoList){
    setState(() {
      print(pronos.toString());
      if(pronos.isNotEmpty) {
        pronos.clear();
      }

      pronos.addAll(pronoList);

    });
    _updateListModel();
    print(pronos.length.toString());
  }

  _updateListModel(){
    setState(() {
      listModel = new ListModel(_listKey, pronos);
    });
  }

  _updateIsAdmin(String adminId){
    if(adminId.contains(myuser.id))
    {
      setState(() {
        isAdmin = true;
      });
    }
  }

  //Notification FCM
  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token){
      print(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  //Notification FCM
  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings)
    {
      print("Settings registered: $settings");
    });
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: 5,
        child: new Scaffold(
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              MyPronosticsScreen(auth: widget.auth),
              new Container(
                color: Colors.orange,
              ),
              MyProfileScreen(user: myuser, auth: widget.auth),
            ],
          ),
          bottomNavigationBar: new TabBar(
              tabs: [
                Tab(
                  icon: new Icon(Icons.home, size: 30,),
                ),
                Tab(
                  icon: new Icon(Icons.videogame_asset, size: 30,),
                ),
                Tab(
                  icon: new Icon(Icons.format_list_numbered, size: 30),
                ),
                Tab(
                  icon: new Icon(Icons.whatshot, size: 30,),
                ),
                Tab(
                  icon: new Icon(Icons.fastfood, size: 30,),
                ),
              ],
              labelColor: Colors.deepOrange,
              unselectedLabelColor: Colors.blueGrey,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorPadding: EdgeInsets.all(5.0),
              indicatorColor: Colors.red,
            ),
          ),
    );
  }

}