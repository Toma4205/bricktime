import 'package:flutter/material.dart';
import 'package:bricktime/auth/authEmail.dart';
import 'package:bricktime/model/user.dart';
import 'package:bricktime/login_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:bricktime/dbase/storage_actions.dart';
import 'package:bricktime/dbase/user_actions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:bricktime/dbase/fantasy_actions.dart';
import 'package:bricktime/model/current_fantasy_model.dart';
import 'dart:math';

class MyProfileScreen extends StatefulWidget {
  MyProfileScreen({Key key, this.user, this.auth, this.tabBarController}) : super(key: key);
  final User user;
  final BaseAuth auth;
  final TabController tabBarController;


  @override
  _MyProfileScreenState createState() => new _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {

  bool isNameEditable = false;
  TextEditingController _nameTextFieldController ;
  String name;
  Future<String> picURL;
  Future<List<String>> allPicURL;
  final snackBarCodeError = SnackBar(content: Text('Wrong code, sorry'),);


  @override
  void initState() {
    super.initState();
    setState(() {
      getUserPseudo(widget.user.id).then((pseudo){
        print('pseudo recu : '+pseudo.toString());
        name = pseudo;
      });
      picURL = widget.user.avatar == null ? null : getImage(widget.user.avatar);
      allPicURL = getAllPicURL();

    });
  }

  _updatePicURL(String avatar){
    setState(() {
      picURL = getImage(avatar);
    });
  }


  _dismissDialog() {
    Navigator.pop(context);
  }


  void _showAvatarDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return FutureBuilder(
              future: allPicURL,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  return GridView.builder(
                      itemCount: snapshot.data.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: GestureDetector(
                            child: new Image.network(snapshot.data[index]),
                            onTap: () {
                              String avatar_tmp =  snapshot.data[index].toString().substring(
                                  snapshot.data[index].toString().lastIndexOf("/")+1,
                                  snapshot.data[index].toString().indexOf("?"));
                              updateUserAvatar(widget.user.id,avatar_tmp);
                              _updatePicURL(avatar_tmp);
                              _dismissDialog();
                            },
                          ),
                        );
                      }
                  );
                }else{ //inutilisé je crois...
                  return SimpleDialog(
                    title: Text('Choose your avatar'),
                    children: <Widget>[
                      SimpleDialogOption(
                        onPressed: () {
                          _dismissDialog();
                        },
                        child: const Text('Option 1'),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          _dismissDialog();
                        },
                        child: const Text('Option 2'),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          _dismissDialog();
                        },
                        child: const Text('Option 3'),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          _dismissDialog();
                        },
                        child: const Text('Option 4'),
                      ),
                    ],
                  );
                }
              }
          );
        }
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black87,
      ),
      child:SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildProfilePictureName(),
            _buildDisconnect(),
                  _buildFantasyLigueList(),
                  _buildTitleHistory(),
                  _buildHistoryStream(),
          ],
        ),
      ),
    );
  }

  

  _switchNameEditable(){
    setState(() {
      if(isNameEditable){
        //Vérifier si le pseudo est valide
        // ...
        if(_nameTextFieldController.text.length >= 3 && _nameTextFieldController.text.length <= 20){
          name = _nameTextFieldController.text ;
          updateUserPseudo(widget.user.id,name);
        }
      }else{
        _nameTextFieldController = new TextEditingController(text: name);
      }
      isNameEditable = !isNameEditable;
    });
  }

  _displayJoinFantasyError(BuildContext context, String error) async {
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            backgroundColor: Colors.deepOrange,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))
            ),
            title: Text("Cannot join competition", style: TextStyle(fontWeight: FontWeight.bold,)),
            content: Text(error),
          );
      }
    );
  }

  _displayValidationSupprFantasy(BuildContext context, String fantasy_name, String fantasy_id, bool isCommissioner, String status) async {
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            backgroundColor: Colors.deepOrange,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))
            ),
            title: Text("Delete competition, are you sure?", style: TextStyle(fontWeight: FontWeight.bold,)),
            content: Text(fantasy_name),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel', style: TextStyle(color: Colors.black),),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
              ),
              FlatButton(
                child: Text('Delete', style: TextStyle(color: Colors.black),),
                onPressed: (){
                  if(status == "Competition completed"){
                    removeFantasyCompetitionForUser(widget.user.id,fantasy_id);
                  }else{
                    if(isCommissioner){
                      removeFantasyCompetitionAllUsers(fantasy_id);
                    }
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }

  _displayDialogNewFantasy(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1),
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: dialogContent(context),
          );
        });
  }

  dialogContent(BuildContext context) {
    TextEditingController _fantasyNameController = TextEditingController();
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: 40,
            bottom: 10,
            left: 10,
            right: 10,
          ),
          margin: EdgeInsets.only(top: 40),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                "New Fantasy Competition",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child:TextField(
                  controller: _fantasyNameController,
                  maxLength: 30,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    labelText: "Competition Name",
                    counterText: "",
                    labelStyle: TextStyle(color: Colors.grey),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepOrange, width: 1.0),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                      onPressed: () {
                         setNewFantasyCompetition(_fantasyNameController.text.toString().replaceAll("/","-"), widget.user.id, name).then((fantasy_id){
                           MOD_current_fantasy_id = fantasy_id;
                            widget.tabBarController.animateTo(2);
                        });
                        Navigator.of(context).pop(); // To close the dialog
                      },
                      child: Text("CREATE NEW"),
                    ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 10,
          right: 10,
          child: CircleAvatar(
            backgroundColor: Colors.deepOrange,
            radius: 40,
            child: Icon(Icons.add_circle, color: Colors.white, size: 45,),
          ),
        ),
      ],
    );
  }


  Widget _buildPseudoStream(){
    return StreamBuilder(
        stream: FirebaseDatabase.instance.reference().child("users").child(widget.user.id).child("infos").child("pseudo").onValue,
        builder: (BuildContext context,  AsyncSnapshot<Event> event) {
          if (!event.hasData) {
            return new Center(child: new Text('Loading...'));
          }

          if (event.data.snapshot.value.toString() == "null") {
            return new Container(padding: EdgeInsets.all(
                0),); //Center(child: new Text('Loading...',style: new TextStyle(fontSize: 14.0, color: Colors.white),));

          } else {
            name = event.data.snapshot.value.toString();
            return Text(
              //name != null ? name : 'pseudo',
              event.data.snapshot.value.toString(),
              overflow: TextOverflow.ellipsis,
              style: new TextStyle(
                  fontSize: 26.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w400),
            );
          }
        }
        );
  }

  Widget _buildProfilePictureName(){
        return new Padding(
        //padding: EdgeInsets.fromLTRB(30,40,10,10),
          padding: EdgeInsets.only(top: 50),
          child: Row(
            children: <Widget>[
              _buildProfilPicture(),
              new Expanded(
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      isNameEditable ?
                      TextField(
                        controller: _nameTextFieldController,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 26
                        ),
                        onEditingComplete: () {
                          _switchNameEditable();
                        },
                      )
                          :new GestureDetector(
                        onTap: () {
                          _switchNameEditable();
                        },
                        child: _buildPseudoStream(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
      );
  }

  Widget _buildAvatarStream() {
    return StreamBuilder(
        stream: FirebaseDatabase.instance
            .reference()
            .child("users")
            .child(widget.user.id)
            .child("infos")
            .child("avatar")
            .onValue,
        builder: (BuildContext context, AsyncSnapshot<Event> event) {
          if (!event.hasData) {
            return new Center(child: new Text('Loading...'));
          }

          if (event.data.snapshot.value.toString() == "null") {
            return new CircleAvatar(
              minRadius: 50.0,
              maxRadius: 50.0,
              backgroundImage: new AssetImage('images/avatar'),
            );
          } else {
            return _getNetworkImage(event.data.snapshot.value.toString());
          }
        }

    );
  }

  Widget _getNetworkImage(String avatar){
    return StreamBuilder(
        stream: getImage(avatar).asStream(),
        builder: (BuildContext context, AsyncSnapshot<String> event) {

        if (event.data.toString() == "null") {
          return new CircleAvatar(
            minRadius: 50.0,
            maxRadius: 50.0,
            backgroundImage: new AssetImage('images/avatar'),
          );
        } else {
          return new CircleAvatar(
            minRadius: 50.0,
            maxRadius: 50.0,
            backgroundImage: !avatar.toString().contains("images")
                ? new NetworkImage(event.data.toString())
                : new AssetImage("images/avatar"),
          );
        }
    }
    );
  }

  Widget _buildProfilPicture(){
    return FutureBuilder(
      future: picURL,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return DecoratedBox(
          decoration: ShapeDecoration(
            shape: CircleBorder(),
            color: Colors.white,
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
                buttonTheme: ButtonTheme.of(context).copyWith(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap)),
            child: OutlineButton(
              borderSide: BorderSide(style: BorderStyle.none),
              child: _buildAvatarStream(),
              onPressed: () => _showAvatarDialog(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRatingLevelStream(){
    return StreamBuilder(
        stream: FirebaseDatabase.instance.reference().child("users").child(widget.user.id).child("infos").child("level").onValue,
        builder: (BuildContext context,  AsyncSnapshot<Event> event) {
          if (!event.hasData) {
            return new Center(child: new Text('Loading...'));
          }

          if (event.data.snapshot.value.toString() == "null") {
            return new Container(padding: EdgeInsets.all(
                0),); //Center(child: new Text('Loading...',style: new TextStyle(fontSize: 14.0, color: Colors.white),));

          } else {
            int levelNumber;
            switch(event.data.snapshot.value.toString()){
              case "Rookie": levelNumber = 1;
              break;
              case "Pro": levelNumber = 2;
              break;
              case "All Star": levelNumber = 3;
              break;
              case "Hall of Famer": levelNumber = 4;
              break;
              case "G.O.A.T": levelNumber = 5;
              break;
              default: levelNumber = 0;
            }
            return new Center(child: Padding(
              padding: EdgeInsets.only(top: 5),
              child:  Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(levelNumber>0?Icons.star:Icons.star_border, size: 30, color: Colors.deepOrange,),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 2),),
                      Icon(levelNumber>1?Icons.star:Icons.star_border, size: 30, color: Colors.deepOrange,),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 2),),
                      Icon(levelNumber>2?Icons.star:Icons.star_border, size: 30, color: Colors.deepOrange,),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 2),),
                      Icon(levelNumber>3?Icons.star:Icons.star_border, size: 30, color: Colors.deepOrange,),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 2),),
                      Icon(levelNumber>4?Icons.star:Icons.star_border, size: 30, color: Colors.deepOrange,),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(event.data.snapshot.value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100, color: Colors.white, letterSpacing: 5),),
                    ],
                  ),
                ],
              ),
            ),
            );


          }
        }
        );
  }

  Widget _buildDisconnect(){
    return new Padding(
      padding: EdgeInsets.only(top: 10),
      //child: Align(
      child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RaisedButton(
            onPressed: (){
              print("Options"); //TODO  Changer motdepasse, Rattacher à Facebook/Gmail, Supprimer mon compte
            },
            elevation: 2,
            color: Colors.deepOrange,
            child: Icon(Icons.settings, color: Colors.white,),
          ),
          _buildRatingLevelStream(),
          RaisedButton(
          onPressed: (){
            widget.auth.signOut();
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen(auth: widget.auth)));
          },
            elevation: 2,
            color: Colors.deepOrange,
            child: Icon(Icons.exit_to_app, color: Colors.white,),
          ),
        ],
      ),
    );
  }

  Widget _buildFantasyLigueList() {
    return StreamBuilder(
        stream: FirebaseDatabase.instance.reference().child("users").child(widget.user.id).child("fantasy").onValue,
        builder: (BuildContext context,  AsyncSnapshot<Event> event) {
          if (!event.hasData) {
            return new Center(child: new Text('Loading...'));
          }
          if (event.data.snapshot.value.toString() == "null"){
            return  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 20),
                    itemCount: 2,
                    itemBuilder: (BuildContext context, int index) {
                      if(index ==0 ){
                        return _buildLauchFantasyCard();
                      }else{
                        return _buildJoinFantasyCard();
                      }

                    }

            );
          }else{
            Map<dynamic, dynamic> snapFantasy = event.data.snapshot.value;
            return ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    itemCount: snapFantasy.length+2,
                    itemBuilder: (BuildContext context, int index) {
                      if(index ==0){
                        return _buildLauchFantasyCard();
                      }else{
                        if(index == 1){
                          return  _buildJoinFantasyCard();
                        }else{
                          return _buildFantasyCard(snapFantasy.keys.elementAt(index-2), snapFantasy.values.elementAt(index-2));
                        }
                      }
                    }

            );
          }
    });
  }


  Widget _buildLauchFantasyCard(){
    return new  Card(
        margin: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 1),
        color: Colors.lightGreenAccent,
        child: Card(
          margin: EdgeInsets.all(2),
          color: Colors.black,
          child: ListTile(
            leading: Icon(Icons.add_circle, size: 40, color: Colors.white,),
            title: Text("Create New Fantasy Competition", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1), overflow: TextOverflow.clip,),
            subtitle: Text("Invite your friends", textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.white), overflow: TextOverflow.ellipsis,),
            onTap: (){
              _displayDialogNewFantasy(context);
            },
          ),
        )
    );
  }

  Widget _buildJoinFantasyCard() {
    TextEditingController _codeController = TextEditingController();

    return new  Card(
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        color: Colors.lightGreenAccent,
        child: Card(
          margin: EdgeInsets.all(2),
          color: Colors.black,
          child: ListTile(
            leading: Text("or Join\nFriends", textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1), overflow: TextOverflow.clip,),
            title: Container(
              color: Colors.black,
              child: TextField(
                controller: _codeController,
                style: TextStyle(fontSize: 22, letterSpacing: 2, color: Colors.white),
                maxLength: 8,
                cursorColor: Colors.deepOrange,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                    counterText: "",
                  labelText: "Type your code",
                  suffix: IconButton(
                    icon: Icon(Icons.play_arrow, color: Colors.deepOrange, size: 40,),
                    onPressed: (){
                      if(_codeController.text.length>=8){
                      joinFantasyWithCodeForUser(widget.user.id, _codeController.text.toString(), name).then((errorMessage){
                        if(errorMessage == ""){

                        }else{
                          Scaffold.of(context).showSnackBar(snackBarCodeError);
                        }
                      });
                      print('Join Friend Check code');
                      }else{
                        Scaffold.of(context).showSnackBar(snackBarCodeError);
                      }
                      },
                    alignment: Alignment.center,),
                  labelStyle: TextStyle(color: Colors.white, letterSpacing: 0, fontSize: 18),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepOrange, width: 1.0),
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepOrange, style: BorderStyle.solid),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0)
                ),
                onSubmitted: (text){
                    if(_codeController.text.length>=8){
                      joinFantasyWithCodeForUser(widget.user.id, _codeController.text.toString(), name).then((errorMessage){
                        if(errorMessage == ""){

                        }else{
                          Scaffold.of(context).showSnackBar(snackBarCodeError);
                        }
                      });
                      print('Join Friend Check code');
                    }else{
                      Scaffold.of(context).showSnackBar(snackBarCodeError);
                    }
                },
              ),
            ),
          ),
        )
    );
  }

  Widget _buildFantasyCard(var key, var snapFantasy){
    Color aroundColor = snapFantasy['status'] == "Competition completed" ? Colors.grey[300] : Colors.orange;
    Color insideColor = snapFantasy['status'] == "Competition completed" ? Colors.grey[600] : Colors.deepOrange;
    IconData iconCompetition = snapFantasy['status'] == "Competition completed" ? Icons.verified_user : Icons.autorenew;
    String code = snapFantasy['status'] == "Waiting for players" ? "\ncode: "+snapFantasy["fantasy_code"] : "";

    return new  Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        color: aroundColor,
        child: Card(
          margin: EdgeInsets.all(7),
          color: insideColor,
          child: ListTile(
            leading: Icon(iconCompetition, size: 40, color: Colors.white,),
            title: Text(snapFantasy["fantasy_name"], textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2), overflow: TextOverflow.ellipsis,),
            subtitle: Text(snapFantasy["status"]+code, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.white), overflow: TextOverflow.ellipsis,),
            onTap: (){
              MOD_current_fantasy_id = key;
              widget.tabBarController.animateTo(2);
            },
            onLongPress: (){
              if((snapFantasy['isCommissioner'] && snapFantasy['status'] == "Waiting for players") || snapFantasy['status'] == "Competition completed"){
                _displayValidationSupprFantasy(context, snapFantasy['fantasy_name'], key.toString(), snapFantasy['isCommissioner'], snapFantasy['status']);
              }else{
                //print("NOT POSSIBLE deleteFantasy");
              }
            },
          ),
        )
    );
  }

  Widget _buildTitleHistory(){
      return Padding(
        padding: EdgeInsets.only(top: 10),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.whatshot, color: Colors.deepOrange),
                Padding(padding: EdgeInsets.symmetric(horizontal: 10),),
                Text("My Records", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange, letterSpacing: 2),),
              ],
            ),
          ),
        ),
      );
  }

  Widget _buildHistoryStream(){
    return StreamBuilder(
        stream: FirebaseDatabase.instance.reference().child("users").child(widget.user.id).child("infos").child("records").onValue,
    builder: (BuildContext context,  AsyncSnapshot<Event> event) {
    if (!event.hasData) {
    return new Center(child: new Text('Loading...'));
    }

    if (event.data.snapshot.value.toString() == "null") {
      return ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10),
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              String competition = "";
              String points = "No record yet";
              String rank = "";
              String suffixRank = "";
              Color color = Colors.grey[500];
              return new  Card(
                color: color,
                child: ListTile(
                  leading: DecoratedBox(
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      //color: color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(competition, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.white),),
                  ),
                  title: Center(child: Text(points, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.white))),
                  trailing: Text(rank+suffixRank, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.white)),
                ),
              );
            }
        );


    } else {
      bool hasRecord = widget.user.records.length > 0;
      int gradient = hasRecord ? widget.user.records.length  : 0;
      return  ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 5),
            itemCount: hasRecord ? widget.user.records.length : 1,
            itemBuilder: (BuildContext context, int index) {
              String competition = "";
              String points = "No record yet";
              String rank = "";
              String suffixRank = "";
              Color color = Colors.grey[500];

              if(hasRecord){
                competition = widget.user.records[index].typeYear.toString();
                points = widget.user.records[index].points.toString()+" points";
                rank = widget.user.records[index].rank.toString();
                suffixRank = rank.endsWith("1") ? "st" : rank.endsWith("2") ? "nd" : rank.endsWith("3") ? "rd" : "th";
                color = Color.lerp(Colors.orangeAccent, Colors.deepOrange, 1-(1/gradient*index));
              }

              return new  Card(
                color: color,
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  leading:  Text(competition, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white),),
                  title: Center(
                      child: Text(points, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white))
                  ),
                  trailing: Text(rank+suffixRank, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white)),
                ),
              );
            }
      );
    }}
    );
  }

}