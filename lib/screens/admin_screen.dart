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
import 'package:bricktime/dbase/teams_actions.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';


class AdminScreen extends StatefulWidget{
  AdminScreen({Key key, this.auth}) : super(key:key);
  final BaseAuth auth;

   @override
    _AdminScreenState createState() => new _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>{
  final GlobalKey<AnimatedListState> _listKey = new GlobalKey<AnimatedListState>();
  final _formKeyNewPlayoffs = GlobalKey<FormState>();


  final double _imageHeight = 256.0;
  final User myuser = User(id: 'id', pseudo: 'pseudo', level: 'level', lastConnexion: 'lastConnexion');

  List<String> teamsE = ["East Team"];
  List<String> teamsW = ["West Team"];

  ListModel listModel;
  bool showOnlyCompleted = false;
  bool isAdmin = false;


  bool _isShowButton = true; //Sera une valeur issue de la BDD : on affiche le bouton uniquement si la compétition n'est pas lancée
  bool _isShowForm = false; //Idem

  String playoffYear = DateTime.now().year.toString();
  List<DateTime> datesLimites = new List(16);
  List<Color>  datesColors = new List(16);
  List<String> selectedTeamsEast = new List(8);
  List<String> selectedTeamsWest = new List(8);


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

    getTeams('East').then((team){
      teamsE.clear();
      teamsE.addAll(team);
    });

    getTeams('West').then((team){
      teamsW.clear();
      teamsW.addAll(team);
    });

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

  void _selectDateLimit(int gameNumber) {

    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        onChanged: (date) {


        }, onConfirm: (date) {
          if(date.compareTo(DateTime.now())>0) {
            setState(() {
              datesLimites[gameNumber] = date;
              datesColors[gameNumber] = Colors.green;
              print(datesLimites.toString());
            });
          }else{
            setState(() {
              datesLimites[gameNumber] = null;
              datesColors[gameNumber] = null;
              print(datesLimites.toString());
            });
          }
        }, currentTime: DateTime.now(), locale: LocaleType.fr);
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

  String _checkLaunch(){
    String error = null;
    if(selectedTeamsEast.contains(null) || selectedTeamsWest.contains(null)){
      error = "All the 16 teams are not filled";
    }

    if(datesColors.contains(null)){
      error = "All the 8 deadline are not OK";
    }
    
    return error;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          //_buildTimeline(),
          _buildTopHeader(),
          _buildBottomPart(),
          //_buildFilterButton(),
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
      padding: new EdgeInsets.only(top: 100, left: 10),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildMyTasksHeader(), //Titre ADMIN
          _newPlayoffsLauncher(), //Bouton d'initialisation ou texte d'information
          _buildFormPlayoffs(), //Formulaire d'initialisation de toutes les équipes
          //_buildTasksList(), //Liste des pronostics idem utilisateur mais en modifiable
        ],
      ),
    );
  }

  Widget _buildFormPlayoffsRow(String conf, int teamA, int teamB, int serieNumber){
    return new Padding(
      padding: EdgeInsets.all(0.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: DropdownButtonFormField<String>(
                value: conf == "E" ? selectedTeamsEast[teamA-1] : selectedTeamsWest[teamA-1],
                hint: Text("Team "+teamA.toString()+" : "),
                items: conf == "E" ? teamsE.map((label) => DropdownMenuItem(
                            child: Text(label),
                            value: label,)).toList() :
                teamsW.map((label) => DropdownMenuItem(
                            child: Text(label),
                            value: label,)).toList(),
                onChanged: (String value) {
                  setState(() {
                    conf == "E" ? selectedTeamsEast[teamA-1]=value : selectedTeamsWest[teamA-1]=value;
                  });
                }
            ),
          ),
          Padding(
              padding: EdgeInsets.all(0.0),
              child: Column(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.timer, color: (datesColors[serieNumber] == null ? Colors.deepOrange : datesColors[serieNumber]), size: 20),
                    onPressed: (){
                      _selectDateLimit(serieNumber);
                    },
                  ),
                  Text(datesLimites[serieNumber] == null ? '-' :
                  datesLimites[serieNumber].day.toString()+"/"+
                      datesLimites[serieNumber].month.toString()+" "+
                      datesLimites[serieNumber].hour.toString()+":"+
                      datesLimites[serieNumber].hour.toString(),
                    style: TextStyle(fontSize: 10),)
                ],
              )
          ),
          Expanded(
            child: DropdownButtonFormField<String>(
                value: conf == "E" ? selectedTeamsEast[teamB-1] : selectedTeamsWest[teamB-1],
                hint: Text("Team "+teamB.toString()+" : "),
                items: conf == "E" ? teamsE.map((label) => DropdownMenuItem(
                  child: Text(label),
                  value: label,)).toList() :
                teamsW.map((label) => DropdownMenuItem(
                  child: Text(label),
                  value: label,)).toList(),
                onChanged: (String value) {
                  setState(() {
                    conf == "E" ? selectedTeamsEast[teamB-1]=value : selectedTeamsWest[teamB-1]=value;
                  });
                }
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormPlayoffs(){
    if(_isShowForm){
      return new Expanded(
        child: Form(
          key: _formKeyNewPlayoffs,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Eastern Conference", style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                Divider(height: 2, thickness: 2,),
                _buildFormPlayoffsRow("E",1,8,0),
                _buildFormPlayoffsRow("E",4,5,1),
                _buildFormPlayoffsRow("E",3,6,2),
                _buildFormPlayoffsRow("E",2,7,3),
                Divider(height: 2, thickness: 2,),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Western Conference", style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                Divider(height: 2, thickness: 2,),
                _buildFormPlayoffsRow("W",1,8,4),
                _buildFormPlayoffsRow("W",4,5,5),
                _buildFormPlayoffsRow("W",3,6,6),
                _buildFormPlayoffsRow("W",2,7,7),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      child: Text("Launch"),
                      onPressed: () {
                        if(_formKeyNewPlayoffs.currentState.validate()) {
                          _formKeyNewPlayoffs.currentState.save();
                          //print(selectedTeam1E+" vs "+selectedTeam8E);
                          
                          String checkError = _checkLaunch();
                          if(checkError == null){
                            //FORMULAIRE VALIDE
                            print('OK Launch formulaire rapide');
                          }else{
                           showDialog(
                             context: context,
                             builder: (BuildContext context){
                               return AlertDialog(
                                 title: new Text("Error while launching"),
                                 content: new Text(checkError),
                                 actions: <Widget>[
                                   // usually buttons at the bottom of the dialog
                                   new FlatButton(
                                     child: new Text("Close"),
                                     onPressed: () {
                                       Navigator.of(context).pop();
                                     },
                                   ),
                                 ],
                               );
                             }
                           );
                          }
                        }
                      },
                    )
                ),
              ],
            ),
          ),
        ),
      );
    }else{
      return Padding(padding: EdgeInsets.all(0),);
    }
  }

  Widget _newPlayoffsLauncher(){
    if(_isShowButton){
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
                Text("Playoffs in progress ..."),
                Padding(padding: EdgeInsets.all(8)),
                RaisedButton(
                  onPressed: () => print("DELETE"),
                  color: Colors.red,
                  child: Text("Delete actual Playoffs", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                )
            ]
          ),
          RaisedButton(
            onPressed: () => print("CLEAR"),
            color: Colors.purple,
            child: Text("Clear Playoffs From Screens", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
          ),
        ],
      );
    }else {
      return Column(
        children: <Widget>[
          RaisedButton(
            onPressed: () {
            setState(() {
              _isShowForm = !_isShowForm;
              _isShowButton = false;
            });
          },
          elevation: 5,
          color: Colors.blueGrey,
          child: Text('Launch ' + (DateTime
              .now()
              .month >= 7 ? (DateTime
              .now()
              .year + 1).toString() : DateTime
              .now()
              .year
              .toString()) + ' Playoffs Competition',
          style: TextStyle(color: Colors.white),),
          ),
        ],
      );
    }
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
            style: new TextStyle(fontSize: 24.0),
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