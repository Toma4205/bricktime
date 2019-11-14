import 'package:flutter/material.dart';
import 'package:bricktime/auth/authEmail.dart';
import 'package:bricktime/model/user.dart';
import 'package:bricktime/login_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:bricktime/dbase/storage_actions.dart';
import 'package:bricktime/dbase/user_actions.dart';
import 'package:firebase_database/firebase_database.dart';

class MyProfileScreen extends StatefulWidget {
  MyProfileScreen({Key key, this.user, this.auth}) : super(key: key);
  final User user;
  final BaseAuth auth;


  @override
  _MyProfileScreenState createState() => new _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {

  bool isNameEditable = false;
  TextEditingController _nameTextFieldController ;
  String name;
  Future<String> picURL;
  Future<List<String>> allPicURL;

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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _buildProfilePictureName(),
          _buildDisconnect(),
          _buildRatingLevelStream(),
          _buildTitleHistory(),
          _buildHistoryStream(),
        ],
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
              padding: EdgeInsets.only(top: 20),
              child:  Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.star, size: 48, color: levelNumber>0?Colors.deepOrange:null,),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5),),
                      Icon(Icons.star, size: 48, color: levelNumber>1?Colors.deepOrange:null,),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5),),
                      Icon(Icons.star, size: 48, color: levelNumber>2?Colors.deepOrange:null,),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5),),
                      Icon(Icons.star, size: 48, color: levelNumber>3?Colors.deepOrange:null,),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5),),
                      Icon(Icons.star, size: 48, color: levelNumber>4?Colors.deepOrange:null,),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(event.data.snapshot.value, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w100, color: Colors.white, letterSpacing: 5),),
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
      padding: EdgeInsets.only(top: 20),
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

  Widget _buildTitleHistory(){
      return Padding(
        padding: EdgeInsets.only(top: 20),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.whatshot, color: Colors.deepOrange),
                Padding(padding: EdgeInsets.symmetric(horizontal: 10),),
                Text("My Records", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.deepOrange),),
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
      return new Expanded(
        child: ListView.builder(
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
        ),
      );

    } else {
      bool hasRecord = widget.user.records.length > 0;
      int gradient = hasRecord ? widget.user.records.length  : 0;
      return new Expanded(
        child: ListView.builder(
            padding: EdgeInsets.only(top: 10),
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
        ),
      );
    }}
    );
  }

}