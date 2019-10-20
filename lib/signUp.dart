import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';



class signUp extends StatefulWidget {
  static final TextEditingController _user = new TextEditingController();
  static final TextEditingController _pass = new TextEditingController();
  static final TextEditingController _name = new TextEditingController();
  static final TextEditingController _pin = new TextEditingController();

  //static final TextEditingController _status = new TextEditingController();

  @override
  _signUpState createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //final FirebaseAuth _auth = FirebaseAuth.instance;

  String username,
      password,
      name,
      status = 'Logged_Off',
      homeLongitude,
      homeLatitude, pin;




  QuerySnapshot usernameCheck;

  void onSubmit() {
    getLocation();
    print('hgb');
    FormState dir = key.currentState;
    dir.save();
    check();
    //signUpFn();
  }

  void getLocation() async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.latitude.toString());
    setState(() {
      homeLatitude = position.latitude.toString();
      homeLongitude = position.longitude.toString();
    });
  }

  Future<void> check() async {
    usernameCheck = await Firestore.instance.collection('users').where(
        'username', isEqualTo: username).getDocuments();
    if (usernameCheck.documents.isEmpty) {
      signUpFn();
      Navigator.of(context).pushReplacementNamed('/login');
    }
    else {
      _scaffoldKey.currentState
          .showSnackBar(
          SnackBar(content: Text('User already registered.. Try Again')));
    }
  }

  var time = DateTime.now();

  Future<void> signUpFn() async {
    Firestore.instance
        .collection('users')
        .add({
      'username': username,
      'password': password,
      'name': name,
      'status': status,
      'time': time,
      'homeLongitude': homeLongitude,
      'homeLatitude': homeLatitude,
      'pin': pin,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Welcome To Avyukta'),
        ),
        body: new Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: 40.0, right: 40.0),
              child: Form(
                key: key,
                child: Column(children: <Widget>[
                  new TextFormField(
                      controller: signUp._name,
                      textAlign: TextAlign.center,
                      decoration: new InputDecoration(hintText: 'Enter Name'),
                      onSaved: (value) {
                        name = value;
                      }),
                  new TextFormField(
                      controller: signUp._user,
                      textAlign: TextAlign.center,
                      decoration: new InputDecoration(
                          hintText: 'Enter username'),
                      onSaved: (value) {
                        username = value;
                      }),
                  new TextFormField(
                      controller: signUp._pass,
                      textAlign: TextAlign.center,
                      decoration: new InputDecoration(
                          hintText: 'Enter password'),
                      obscureText: true,
                      onSaved: (value) {
                        password = value;
                      }),
                  new TextFormField(
                      controller: signUp._pin,
                      textAlign: TextAlign.center,
                      decoration: new InputDecoration(
                          hintText: 'Enter pin code'),
                      onSaved: (value) {
                        pin = value;
                      }),

                  new RaisedButton(child: new Text('Submit'), onPressed:
                  (){
                    onSubmit();
                  }
                  )
                ]),
              ),
            )
        )
    );
  }
}
