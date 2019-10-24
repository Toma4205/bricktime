import 'package:flutter/material.dart';
import 'package:bricktime/screens/animated_fab.dart';
import 'package:bricktime/screens/diagonal_clipper.dart';
import 'package:bricktime/model/initial_list.dart';
import 'package:bricktime/model/list_model.dart';
import 'package:bricktime/model/prono_row.dart';
import 'package:bricktime/auth/authEmail.dart';
import 'package:bricktime/login_screen.dart';
import 'package:bricktime/screens/custom_popup_menu.dart';
import 'package:bricktime/dbase/user_actions.dart';
import 'package:bricktime/model/user.dart';
import 'package:bricktime/dbase/constantes_actions.dart';
import 'package:bricktime/screens/admin_screen.dart';
import 'package:bricktime/screens/my_pronostics_screen.dart';


class Ranking extends StatefulWidget {
  Ranking({Key key, this.auth}) : super(key: key);
  final BaseAuth auth;

  @override
  _RankingState createState() => new _RankingState();
}

class _RankingState extends State<Ranking> {
  final GlobalKey<AnimatedListState> _listKey = new GlobalKey<
      AnimatedListState>();
  final double _imageHeight = 256.0;
  final User myuser = User(id: 'id',
      pseudo: 'pseudo',
      level: 'level',
      lastConnexion: 'lastConnexion');

  bool showOnlyCompleted = false;
  bool isAdmin = false;

  String playoffYear = DateTime
      .now()
      .year
      .toString();


  List<CustomPopupMenu> choices = <CustomPopupMenu>[
    CustomPopupMenu(title: 'My Pronostics', icon: Icons.home),
    CustomPopupMenu(title: 'Ranking', icon: Icons.bookmark),
    CustomPopupMenu(title: 'Sign out', icon: Icons.settings),
  ];

  CustomPopupMenu _selectedChoices;

  void _select(CustomPopupMenu choice) {
    setState(() {
      _selectedChoices = choice;
    });
    print(choice.title);
    if (choice.title == 'Sign out') {
      widget.auth.signOut();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen(auth: widget.auth)),
      );
    } else if (choice.title == 'Admin') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminScreen(auth: widget.auth)),
      );
    } else if (choice.title == 'My Pronostics') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyPronosticsScreen(auth: widget.auth)),
      );
    } else if (choice.title == 'Ranking') {
      //On est déjà dessus
    }
  }


  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user){
      getUserInfo(user).then(_updateUserInfo);
      getActualPlayoffYear().then((_updateActualPlayoffsYear));
      getAdminId().then((_updateIsAdmin));
    });
  }

  _updateIsAdmin(String adminId){
    if(adminId.contains(myuser.id))
    {
      setState(() {
        isAdmin = true;
        choices.add(new CustomPopupMenu(title: 'Admin', icon: Icons.settings));
      });
    }
  }

  _updateUserInfo(User user){
    setState(() {
      myuser.pseudo = user.pseudo;
      myuser.level = user.level;
      myuser.id = user.id;
      myuser.lastConnexion = user.lastConnexion;
    });
  }

  _updateActualPlayoffsYear(String year){
    setState(() {
      playoffYear = year;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          _buildIamge(),
          _buildTopHeader(),
          _buildProfileRow(),
          _buildBottomPart(),

        ],
      ),
    );
  }

  Widget MenuButton(){
    return new PopupMenuButton<CustomPopupMenu>(
        icon: Icon(Icons.menu, color: Colors.white,),
        elevation: 3.2,
        //initialValue: MenuList.values.elementAt(0),
        onCanceled: () {
          print('You have not chossed anything');
        },
        offset: Offset(25,50),
        color: Colors.white,
        onSelected: _select,
        itemBuilder: (BuildContext context) {
          return choices.map((CustomPopupMenu choice) {
            return PopupMenuItem<CustomPopupMenu>(
              value: choice,
              child: Text(choice.title, style: TextStyle(color: Colors.deepOrange),),
            );
          }).toList();
        }
    );
  }

  Widget _buildTopHeader() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
      child: new Row(
        children: <Widget>[
          MenuButton(),
          new Expanded(
            child: new Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: new Text(
                "Brick Time",
                style: new TextStyle(
                    fontSize: 30.0,
                    letterSpacing: 4,
                    color: Colors.white,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ),
          new Icon(Icons.linear_scale, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildBottomPart() {
    return new Padding(
      padding: new EdgeInsets.only(top: _imageHeight),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
          itemCount: 10,
          itemBuilder: (BuildContext context, int index){
          return null;
          }
      )
    );
  }
  Widget _buildIamge() {
    return new Positioned.fill(
      bottom: null,
      child: new ClipPath(
        clipper: new DialogonalClipper(),
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

  Widget _buildProfileRow() {
    return new Padding(
      padding: new EdgeInsets.only(left: 16.0, top: _imageHeight / 2.5),
      child: new Row(
        children: <Widget>[
          new CircleAvatar(
            minRadius: 28.0,
            maxRadius: 28.0,
            backgroundImage: new AssetImage('images/avatar.jpeg'),
          ),
          new Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text(
                  myuser.pseudo != null ? myuser.pseudo : 'pseudo',
                  style: new TextStyle(
                      fontSize: 26.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
                new Text(
                  myuser.level,
                  style: new TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}