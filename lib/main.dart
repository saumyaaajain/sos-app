import 'package:flutter/material.dart';
import 'package:login/login.dart';
import 'package:login/signUp.dart';
import 'package:login/profile.dart';
//import 'package:login/profile.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget{
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget _screen;
  var _title='Help Me!';

  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      title: _title,
      routes: { //"/home": (context) => home(),
        "/login": (context) => login(),
        //"/profilepage": (context) => homepage(),
        //"/dashboard": (context) => dash().
        //"/assignwork": (context) => AssignWork(),
        // "/assignedwork": (context) => AssignedWork(),
        "/signUp": (context) => signUp(),
        // "/task": (context) => Task(),
        //"/pic": (context) => picture(),
        //"/pic": (context) => profile(),
      },
      home: login(),
    );
  }


}