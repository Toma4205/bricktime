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

class AdminScreen extends StatefulWidget{
  AdminScreen({Key key, this.auth}) : super(key:key);
  final BaseAuth auth;

   @override
    _AdminScreenState createState() => new _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>{
  final GlobalKey<AnimatedListState> _listKey = new GlobalKey<AnimatedListState>();
  final double _imageHeight = 256.0;
  final User myuser = User(id: 'id', pseudo: 'pseudo', level: 'level', lastConnexion: 'lastConnexion');

  ListModel listModel;
  bool showOnlyCompleted = false;
  bool isAdmin = false;

  String playoffYear = DateTime.now().year.toString();


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
    if(choice.title == 'Sign out'){
      widget.auth.signOut();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen(auth: widget.auth)),
      );
    }else if(choice.title == 'Admin'){
      //On est déjà dessus
    }else if(choice.title == 'My Pronostics'){

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyPronosticsScreen(auth: widget.auth)),
      );
    }
  }


  @override
  void initState() {
    super.initState();
    listModel = new ListModel(_listKey, pronos);

    widget.auth.getCurrentUser().then((user){
      getUserInfo(user).then(_updateUserInfo);
      getActualPlayoffYear().then((_updateActualPlayoffsYear));
      getAdminId().then((_updateIsAdmin));
    });
  }

  _updateIsAdmin(String adminId){
    if(myuser.id == adminId)
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
          //_buildTimeline(),
          _buildTopHeader(),
          //_buildProfileRow(),
          _buildBottomPart(),
          _buildFilterButton(),
        ],
      ),
    );
  }

  Widget _buildFilterButton(){
    return new Positioned(
      top: _imageHeight - 40.0,
      right: 10.0,
      child: new FloatingActionButton(
        onPressed: _changeStateFilter,
        backgroundColor: Colors.deepOrange,
        child: new  Icon(showOnlyCompleted ? Icons.list : Icons.filter_list,
          color: Colors.white,
          size: 26.0,
        ),
      ),
      //backgroundColor: _colorAnimation.value,
    );
  }

  void _changeStateFilter(){
    setState(() {
      showOnlyCompleted = !showOnlyCompleted;
    });
    pronos.where((prono) => prono.completed).forEach((prono) {
      if (showOnlyCompleted) {
        listModel.removeAt(listModel.indexOf(prono));
      } else {
        listModel.insert(pronos.indexOf(prono), prono);
      }
    });
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
                    color: Colors.black,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ),
          new Icon(Icons.linear_scale, color: Colors.white),
        ],
      ),
    );
  }

  Widget MenuButton(){
    return new PopupMenuButton<CustomPopupMenu>(
        icon: Icon(Icons.menu, color: Colors.black,),
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

  Widget _buildBottomPart() {
    return new Padding(
      padding: new EdgeInsets.only(top: 90),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildMyTasksHeader(),
          new RaisedButton(
            onPressed: null,
            child: Text('TEST FOOT', style: TextStyle(color: Colors.deepOrange),),
          ),
          _buildTasksList(),
        ],
      ),
    );
  }

  Widget _buildTasksList() {
    return new Expanded(
      child: new AnimatedList(
        initialItemCount: pronos.length,
        key: _listKey,
        itemBuilder: (context, index, animation) {
          return new PronoRow(
            prono: listModel[index],
            animation: animation,
          );
        },
      ),
    );
  }

  Widget _buildMyTasksHeader() {
    return new Padding(
      padding: new EdgeInsets.only(left: 64.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            'ADMIN',
            style: new TextStyle(fontSize: 34.0),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return new Positioned(
      top: 0.0,
      bottom: 0.0,
      left: 32.0,
      child: new Container(
        width: 1.0,
        color: Colors.grey[300],
      ),
    );
  }
}