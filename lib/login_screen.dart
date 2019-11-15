import 'package:flutter/material.dart';
import 'package:bricktime/auth/facebook.dart';
import 'package:bricktime/auth/google.dart';
import 'package:bricktime/auth/authEmail.dart';
import 'package:bricktime/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {

  LoginScreen({this.auth});
  final BaseAuth auth;

  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _formKeySignup = GlobalKey<FormState>();
  final _firstPasswordController = TextEditingController();
  final _emailLogInController = TextEditingController();
  String _password;
  String _passwordsignup;
  String _passwordsignupconfirm;
  String _email;
  String _emailsignup;
  String _errorMessage = "";
  String _errorMessageSignup = "";
  bool _showLoading;


  save_validate() async{
    final form = _formKey.currentState;
    form.save();

    if (form.validate()) {
      String userId = "";
      try {
          print("$_email $_password");
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        if (userId.length > 0 && userId != null) {
          updateShowLoading();
          _buildLoading();
          widget.auth.getCurrentUser().then((user) {
            updateShowLoading();
            if (user != null) {
              print('SaveValidate Current user is : '+user.toString());
              Navigator.push(
                context,
                //TABBAR MaterialPageRoute(builder: (context) => MyPronosticsScreen(auth: widget.auth)),
                MaterialPageRoute(builder: (context) => HomeScreen(auth: widget.auth)),
              );
            }
          });
        }
      } catch (e) {
        updateShowLoading();
        print('Error: $e');
        String erreurType = "Error during SignIn";
        if(e.toString().contains("NOT_FOUND")){
          erreurType = "Email not found";
        }else if(e.toString().contains("INVALID")){
          erreurType = "Invalid Email address";
        }
        setState(() {
          _errorMessage = erreurType;
        });
      }
    }
  }

  save_validate_signup() async{
    final form = _formKeySignup.currentState;
    form.save();

    if (form.validate()) {
      String userId = "";
      updateShowLoading();
      _buildLoading();
      try {
        userId = await widget.auth.signUp(_emailsignup, _passwordsignupconfirm);
        print('Signed in: $userId');
        if (userId.length > 0 && userId != null) {
          widget.auth.getCurrentUser().then((user) {
            updateShowLoading();
            if (user != null) {
              print('SaveValidate Current user is : '+user.toString());
              Navigator.push(
                context,
                //TABBAR MaterialPageRoute(builder: (context) => MyPronosticsScreen(auth: widget.auth)),
                MaterialPageRoute(builder: (context) => HomeScreen(auth: widget.auth)),
              );
            }
          });
        }
      } catch (e) {
        updateShowLoading();
        print('Error: $e');
        String erreurType = "Error during Signup";
        if(e.toString().contains("ALREADY")){
          erreurType = "Email address is already in use";
        }else if(e.toString().contains("INVALID")){
          erreurType = "Invalid Email address";
        }
        setState(() {
          _errorMessageSignup = erreurType;
        });
      }
    }
  }

  empty_error_message() async{
    setState(() {
      _errorMessage = "";
    });
  }

  empty_errorsignup_message() async{
    setState(() {
      _errorMessageSignup = "";
    });
  }

  reset_password() async {
    print('reset password');
    if(_emailLogInController.text.isNotEmpty){
      try {
        await widget.auth.resetPassword(_emailLogInController.text);
      } catch (e) {
        print(e);
        String erreurType = "Error during password reset";
        if(e.toString().contains("INVALID")){
          erreurType = "Invalid Email address";
        }else{
          erreurType = "Email not found";
        }
        setState(() {
          _errorMessage = erreurType;
        });
      }
    }else{
      setState(() {
        _errorMessage = "Email cannot be empty";
      });
    }
  }

  updateShowLoading(){
    setState(() {
      _showLoading = !_showLoading;
    });
  }

  @override
  void initState() {
    super.initState();
    _showLoading = false;


    //init_db_constantes();
    widget.auth.getCurrentUser().then((user) {
      if (user != null) {
        print('INITSTATE Current user is : '+user.toString());
          Navigator.push(
            context,
            //TABBAR MaterialPageRoute(builder: (context) => MyPronosticsScreen(auth: widget.auth)),
            MaterialPageRoute(builder: (context) => HomeScreen(auth: widget.auth)),
          );
      }
    });
  }

  void _buildLoading(){
    if(_showLoading){
       showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Connexion, please wait...'),
              content: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.deepOrange),
              ),
            );
          });
    }
  }

  Widget HomePage() {
    return new Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.deepOrange,
        image: DecorationImage(
          image: AssetImage('images/birds.jpg'),
          fit: BoxFit.fitHeight,
          colorFilter: ColorFilter.mode(Colors.black87.withOpacity(0.8), BlendMode.darken),
        ),
      ),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height/2),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "BRICKTIME",
                  style: TextStyle(
                    fontFamily: 'bballfont',
                    color: Colors.white,
                    //fontWeight: FontWeight.w900,
                    //letterSpacing: 5,
                    fontSize: 50.0,
                  ),
                ),
              ],
            ),
          ),
          new Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 20),
            alignment: Alignment.center,
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new OutlineButton(
                    borderSide: BorderSide(color: Colors.white, width: 3.0),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.redAccent,
                    highlightedBorderColor: Colors.white,
                    onPressed: () => gotoSignup(),
                    child: new Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 20.0,
                      ),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Expanded(
                            child: Text(
                              "CREATE NEW USER",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          new Container(
            width: MediaQuery.of(context).size.width,
            padding:  EdgeInsets.only(left: 30.0, right: 30.0, bottom: 20),
            alignment: Alignment.center,
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new FlatButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.white,
                    onPressed: () => gotoLogin(),
                    child: new Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 20.0,
                      ),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Expanded(
                            child: Text(
                              "LOGIN",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 30.0, right: 30.0),
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                new Expanded(
                  child: new Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(border: Border.all(width: 0.25)),
                  ),
                ),
                Text(
                  "OR CONNECT WITH",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                new Expanded(
                  child: new Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(border: Border.all(width: 0.25)),
                  ),
                ),
              ],
            ),
          ),
          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0, bottom: 20),
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new Container(
                    margin: EdgeInsets.only(right: 8.0),
                    alignment: Alignment.center,
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                          child: new FlatButton(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                            color: Color(0Xff3B5998),
                            onPressed: () => {},
                            child: new Container(
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Expanded(
                                    child: new FlatButton(
                                      onPressed: () {
                                        updateShowLoading();
                                        _buildLoading();
                                        startFacebookLogin().whenComplete((){
                                          widget.auth.getCurrentUser().then((user) {
                                            updateShowLoading();
                                            if (user != null) {
                                              Navigator.push(
                                                context,
                                                //TABBAR MaterialPageRoute(builder: (context) => MyPronosticsScreen(auth: widget.auth)),
                                                MaterialPageRoute(builder: (context) => HomeScreen(auth: widget.auth)),
                                              );
                                            }else{
                                              print('Facebook connexion annulee');
                                            }
                                          });

                                        });
                                      },
                                      padding: EdgeInsets.only(
                                        top: 20.0,
                                        bottom: 20.0,
                                      ),
                                      child: new Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Icon(
                                            const IconData(0xea90,
                                                fontFamily: 'icomoon'),
                                            color: Colors.white,
                                            size: 15.0,
                                          ),
                                          Text(
                                            "FACEBOOK",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                new Expanded(
                  child: new Container(
                    margin: EdgeInsets.only(left: 8.0),
                    alignment: Alignment.center,
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                          child: new FlatButton(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                            color: Color(0Xffdb3236),
                            onPressed: () => {},
                            child: new Container(
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Expanded(
                                    child: new FlatButton(
                                      onPressed: (){
                                        signInWithGoogle().whenComplete(() {
                                          _buildLoading();
                                          widget.auth.getCurrentUser().then((user) {
                                            updateShowLoading();
                                            if (user != null) {
                                              Navigator.push(
                                                context,
                                                //TABBAR MaterialPageRoute(builder: (context) => MyPronosticsScreen(auth: widget.auth)),
                                                MaterialPageRoute(builder: (context) => HomeScreen(auth: widget.auth)),
                                              );
                                            }else{
                                              print('Google connexion annulee');
                                            }
                                          });
                                        });
                                      },
                                      padding: EdgeInsets.only(
                                        top: 20.0,
                                        bottom: 20.0,
                                      ),
                                      child: new Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Icon(
                                            const IconData(0xea88,
                                                fontFamily: 'icomoon'),
                                            color: Colors.white,
                                            size: 15.0,
                                          ),
                                          Text(
                                            "GOOGLE",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget LoginPage() {
    return Scaffold(
        body: new Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          /*image: DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.05), BlendMode.dstATop),
            image: AssetImage('assets/images/mountains.jpg'),
            fit: BoxFit.cover,
          ),*/
        ),
        child: Form(
          key: _formKey,
          child: new ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(120.0),
                child: Center(
                  child: Icon(
                    Icons.verified_user,
                    color: Colors.redAccent,
                    size: 50.0,
                  ),
                ),
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: new Text(
                        "EMAIL",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.redAccent,
                        width: 0.5,
                        style: BorderStyle.solid),
                  ),
                ),
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: TextFormField(
                        onSaved: (value) => _email = value,
                        controller: _emailLogInController,
                        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
                        onTap: empty_error_message,
                        textAlign: TextAlign.left,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type your email adresse here',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 24.0,
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: new Text(
                        "PASSWORD",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.redAccent,
                        width: 0.5,
                        style: BorderStyle.solid),
                  ),
                ),
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: TextFormField(
                        onSaved: (value) => _password = value,
                        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
                        onTap: empty_error_message,
                        obscureText: true,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '*********',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 24.0,
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: new FlatButton(
                      child: new Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          fontSize: 15.0,
                        ),
                        textAlign: TextAlign.end,
                      ),
                      onPressed: ()  {
                        empty_error_message;
                        reset_password();
                      },
                    ),
                  ),
                ],
              ),
              errorLogin(),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
                alignment: Alignment.center,
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new FlatButton(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        color: Colors.redAccent,
                        onPressed: ()  {
                          save_validate();
                        }, //AJOUTER Passage à la page d'accueil
                        child: new Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 20.0,
                          ),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Expanded(
                                child: Text(
                                  "LOGIN",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget errorLogin(){
    if(_errorMessage == ''){
      return new Container(height: 0);
    }else{
      return new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: new Text(
              _errorMessage.toString(),
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 13.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }
  }

  Widget errorSignup(){
    if(_errorMessageSignup == ''){
      return new Container(height: 0);
    }else{
      return new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: new Text(
              _errorMessageSignup.toString(),
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 13.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }
  }

  Widget SignupPage() {
    return new Scaffold(
        body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          /*image: DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.05), BlendMode.dstATop),
            image: AssetImage('assets/images/mountains.jpg'),
            fit: BoxFit.cover,
          ),*/
        ),
        child: Form(
          key: _formKeySignup,
          child: new ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(100.0),
                child: Center(
                  child: Icon(
                    Icons.stars,
                    color: Colors.redAccent,
                    size: 50.0,
                  ),
                ),
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: new Text(
                        "EMAIL",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.redAccent,
                        width: 0.5,
                        style: BorderStyle.solid),
                  ),
                ),
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onTap: empty_errorsignup_message,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type your email adress here',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
                        onSaved: (value) => _emailsignup = value.trim(),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 24.0,
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: new Text(
                        "PASSWORD",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.redAccent,
                        width: 0.5,
                        style: BorderStyle.solid),
                  ),
                ),
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: TextFormField(
                        obscureText: true,
                        onTap: empty_errorsignup_message,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '*********',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        controller: _firstPasswordController,
                        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
                        onSaved: (value) {
                          _passwordsignup = value.trim();
                        }
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 24.0,
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: new Text(
                        "CONFIRM PASSWORD",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.redAccent,
                        width: 0.5,
                        style: BorderStyle.solid),
                  ),
                ),
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: TextFormField(
                        obscureText: true,
                        textAlign: TextAlign.left,
                        onTap: empty_errorsignup_message,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '*********',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        validator: (value) => value.toString() != _firstPasswordController.text ? 'Passwords do not match' : null,
                        onSaved: (value) => _passwordsignupconfirm = value.trim(),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 24.0,
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: new FlatButton(
                      child: new Text(
                        "Already have an account?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          fontSize: 15.0,
                        ),
                        textAlign: TextAlign.end,
                      ),
                      onPressed: () => {gotoLogin(),},
                    ),
                  ),
                ],
              ),
              errorSignup(),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 50.0),
                alignment: Alignment.center,
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new FlatButton(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        color: Colors.redAccent,
                        onPressed: () => {
                          save_validate_signup(),
                        },
                        child: new Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 20.0,
                          ),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Expanded(
                                child: Text(
                                  "CREATE NEW PLAYER",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  gotoLogin() {
    //controller_0To1.forward(from: 0.0);
    _controller.animateToPage(
      0,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  gotoSignup() {
    //controller_minus1To0.reverse(from: 0.0);
    _controller.animateToPage(
      2,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  PageController _controller = new PageController(initialPage: 1, viewportFraction: 1.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,

          child: PageView(
            //child: ListView(
            controller: _controller,
            physics: new AlwaysScrollableScrollPhysics(),
            children: <Widget>[LoginPage(), HomePage(), SignupPage()],
            scrollDirection: Axis.horizontal,
          )),
    );
  }
}