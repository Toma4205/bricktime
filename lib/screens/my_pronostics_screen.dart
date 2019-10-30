import 'package:flutter/material.dart';
import 'package:bricktime/screens/animated_fab.dart';
import 'package:bricktime/screens/diagonal_clipper.dart';
import 'package:bricktime/model/list_model.dart';
import 'package:bricktime/model/prono_row_stream.dart';
import 'package:bricktime/model/prono.dart';
import 'package:bricktime/auth/authEmail.dart';
import 'package:bricktime/login_screen.dart';
import 'package:bricktime/screens/custom_popup_menu.dart';
import 'package:bricktime/dbase/user_actions.dart';
import 'package:bricktime/model/user.dart';
import 'package:bricktime/dbase/constantes_actions.dart';
import 'package:bricktime/screens/admin_screen.dart';
import 'package:bricktime/screens/ranking_screen.dart';
import 'package:bricktime/dbase/user_prono_actions.dart';
import 'package:firebase_database/firebase_database.dart';

class MyPronosticsScreen extends StatefulWidget {
  MyPronosticsScreen({Key key, this.auth}) : super(key: key);
  final BaseAuth auth;


  @override
  _MyPronosticsScreenState createState() => new _MyPronosticsScreenState();
}

class _MyPronosticsScreenState extends State<MyPronosticsScreen> {
  final GlobalKey<AnimatedListState> _listKey = new GlobalKey<AnimatedListState>();
  final double _imageHeight = 256.0;
  final User myuser = User(id: 'id', pseudo: 'pseudo', level: 'level', lastConnexion: 'lastConnexion');

  ListModel listModel;
  bool showOnlyPending = false;
  bool isAdmin = false;

  List<Prono> pronos = new List();
  static const pathPronos = ["firstround/ESerie1","firstround/ESerie2", "firstround/ESerie3", "firstround/ESerie4",
                              "firstround/WSerie1","firstround/WSerie2", "firstround/WSerie3", "firstround/WSerie4",
                              "confsemifinal/ESerie1","confsemifinal/ESerie2", "confsemifinal/WSerie1", "confsemifinal/WSerie2",
                              "conffinal/ESerie1","conffinal/WSerie1",
                              "final/Serie1"];

  String playoffYear; //= DateTime.now().year.toString();


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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminScreen(auth: widget.auth)),
      );
    }else if(choice.title == 'My Pronostics'){
      //On est déjà dessus
    } else if (choice.title == 'Ranking') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Ranking(auth: widget.auth)),
      );
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

    _updateInitPronos();
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


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          _buildTimeline(),
          _buildIamge(),
          _buildTopHeader(),
          _buildProfileRow(),
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
          child: new  Icon(showOnlyPending ? Icons.timer : Icons.filter_list,
              color: Colors.white,
              size: 26.0,
            ),
          ),
          //backgroundColor: _colorAnimation.value,
        );
  }

  void _changeStateFilter(){
    setState(() {
      showOnlyPending = !showOnlyPending;
    });
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
      padding: new EdgeInsets.only(top: _imageHeight),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildMyTasksHeader(),
          _buildTasksList(),
        ],
      ),
    );
  }

  Widget _buildTasksList() {
    return  new Expanded(
      child: ListView.builder(
          itemCount: pathPronos.length,
          itemBuilder: (context, index) {
            return new PronoRowStream(
              userId: myuser.id,
              path: pathPronos[index],
              playoffYear: playoffYear,
              showPending: showOnlyPending,
            );
          }
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
            'My Predictions',
            style: new TextStyle(fontSize: 34.0),
          ),
          new Text(
            'NBA Playoff ',
            style: new TextStyle(color: Colors.grey, fontSize: 12.0),
          ),
          getTotalPoints()
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

  Widget getTotalPoints(){
    return new StreamBuilder(
        stream: FirebaseDatabase.instance.reference().child("users").child(myuser.id).child("pronos").child("2020playoffs").onValue,
        builder: (BuildContext context,  AsyncSnapshot<Event> event){
          if (!event.hasData) {
          return new Center(child: new Text('Loading...'));
          }

          if(event.data.snapshot.value.toString() == "null"){
          return new Center(child: new Text('Loading...'));
          }else{
            int totalPoints = 0;
            Map<dynamic, dynamic> competitionlevelSnap = event.data.snapshot.value;
            competitionlevelSnap.forEach((key,value){

              Map<dynamic, dynamic> serielevelSnap = value;
              serielevelSnap.forEach((keySerie, valueSerie){
                totalPoints += valueSerie["points"];
              });
            });



            return new Text(
              totalPoints.toString()+' points',
              style: new TextStyle(color: Colors.deepOrange, fontSize: 18.0),
            );
          }
        }
    );
  }

}