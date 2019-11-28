import 'package:bricktime/dbase/user_actions.dart';
import 'package:bricktime/model/user.dart';
import 'package:bricktime/screens/diagonal_clipper.dart';
import 'package:flutter/material.dart';
import 'package:bricktime/auth/authEmail.dart';


class RankingScreen extends StatefulWidget {
  RankingScreen({Key key, this.auth}) : super(key: key);
  final BaseAuth auth;

  @override
  _RankingScreenState createState() => new _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final GlobalKey<AnimatedListState> _listKey = new GlobalKey<AnimatedListState>();
  final double _imageHeight = 210.0;

  @override
  void initState() {
    super.initState();
    setState(() {
      /*getUsersList(2020).then((List<User> userList){
        print(userList.toString());
        userList.forEach((user){
          print(user.pseudo);
        });

      });*/
      initStandings();
    });
  }

  Future initStandings() async {
    List<User> users = await getUsersList(2020);
    print(users.toString());
    users.forEach((user){
      print(user.pseudo + " : " + user.totalScore.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black87
        ),
        child: new Stack(
          children: <Widget>[
            _buildIamge(),
          ]
        )
      )
    );
  }
  Widget _buildIamge() {
    return new Positioned.fill(
      bottom: null,
      child: new ClipPath(
        clipper: new DialogonalClipper(
        ),
        child: new Image.asset(
          'images/birds.jpg',
          fit: BoxFit.cover,
          height: _imageHeight,
          colorBlendMode: BlendMode.srcOver,
          color: new Color.fromARGB(120, 20, 10, 40),
        ),
      ),
    );
  }
}