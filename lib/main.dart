import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:bricktime/screens/my_pronostics_screen.dart';
import 'package:bricktime/screens/admin_screen.dart';
import 'package:bricktime/auth/authEmail.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brick Time',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(auth: new Auth()),
    );
  }
}
// Coucou ceci est un test de push
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

 final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
