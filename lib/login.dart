import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:login/dashboard.dart';

class login extends StatefulWidget{

  static final TextEditingController _user = new TextEditingController();
  static final TextEditingController _pass = new TextEditingController();


  @override
  loginState createState() => loginState();

  bool stat = false;

  bool getStat() {return this.stat ;}
//login(){}
}

class loginState extends State<login> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setAuthenticated(false);
  }

  bool stat = false;
  var now = new DateTime.now();

  void setStat(bool s) {
    this.status = s;
  }

  var _title = 'Help Me!';
  Widget _screen;
  login _login;
  bool authenticated = false;
  String username = ' ';
  String password = ' ';
  bool status = false;

  //bool stat = false;
  GlobalKey<FormState> v = GlobalKey<FormState>();
  StreamSubscription<DocumentSnapshot> subscription;

  final _usernameKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void setAuthenticated(bool auth) {
    setState(() {
      if (auth == true) {
        _title = 'Welcome';
        status = true;
        Navigator.pushReplacement(
            context, new MaterialPageRoute(builder: (context) =>
        new dash(
            logOutInLogIn, Details, BreakTimeOn, BreakTimeOff, passusername)));
      }
      else {
        _screen = _login;
        status = false;
        _title = 'Help Me!';
      }
    });
  }

  var loginTime, logOutTime, breakonTime, breakOffTime;

  void time() {
    print('time' + loginTime);
  }

  QuerySnapshot usernameGot, passwordGot, master;
  var docID;

  Future<void> signIn() async {
    print(username);
    usernameGot = await Firestore.instance.collection("users").where(
        "username", isEqualTo: username).getDocuments();
    passwordGot = await Firestore.instance.collection("users").where(
        "password", isEqualTo: password).getDocuments();
    master = await Firestore.instance.collection('users').where(
        'username_main', isEqualTo: username).getDocuments();
    print(usernameGot.documents.length);
    if (usernameGot.documents.isNotEmpty) {
      docID = usernameGot.documents[0].reference;
      print('madhav');
      if (passwordGot.documents.isNotEmpty) {
        setAuthenticated(true);
        setStat(true);
        status = true;
        docID.updateData({'status': 'Logged_In'});
        loginTime = new DateTime.now();
        usernameGot.documents[0].reference.updateData(
            {'log in time': loginTime});
        usernameGot = await Firestore.instance.collection("users").where(
            "username", isEqualTo: username).getDocuments();
        print("docID:" + docID);
        //time();
        //print(loginTime);
      }
      else {
        usernameGot = await Firestore.instance.collection("users").where(
            "username", isEqualTo: username).getDocuments();
        setState(() {
          _title = 'Wrong Details';
        });
      }
    }
  }

  String nameOfUser;
  QuerySnapshot name, usernameGot1;

  Future<String> Details() async {
    name = await Firestore.instance.collection('users').where('username',
        isEqualTo: username).getDocuments();
    //nameOfUser= Record.fromSnapshot(name);
    print("len");
    print(name.documents.length);
    if(name.documents.length!=0){
      nameOfUser = name.documents[0]["name"];
      print("name: " + nameOfUser);
    }
    else{
      nameOfUser=null;
    }
    return nameOfUser;
  }

  Future<void> logOutInLogIn() async {
    usernameGot1 = await Firestore.instance.collection("users").where(
        "username", isEqualTo: username).getDocuments();
    //if(usernameGot1.documents.isEmpty){
    usernameGot1.documents[0].reference.updateData({'status': 'Logged_Off'});
    //usernameGot.documents[0].reference.updateData({'status': 'Logged_Off'});
    usernameGot1 = await Firestore.instance.collection("users").where(
        "username", isEqualTo: username).getDocuments();
    logOutTime = new DateTime.now();
    print(Timestamp.fromDate(logOutTime));
    //print(logOutTime);
    print(logOutTime.minute);
    usernameGot1.documents[0].reference.updateData(
        {'log out time': logOutTime});
  }

  Future<void> BreakTimeOn() async {
    usernameGot = await Firestore.instance.collection("users").where(
        "username", isEqualTo: username).getDocuments();
    //if(usernameGot.documents.isEmpty){
    usernameGot.documents[0].reference.updateData({'status': 'On Break'});
    usernameGot = await Firestore.instance.collection("users").where(
        "username", isEqualTo: username).getDocuments();
    breakonTime = new DateTime.now();
    usernameGot.documents[0].reference.updateData(
        {'break on time': breakonTime});
  }

  Future<QuerySnapshot> passusername() async {
    usernameGot = await Firestore.instance.collection("users").where(
        "username", isEqualTo: username).getDocuments();
    print('usernameGot Sending');
    return usernameGot;
  }

  Future<void> BreakTimeOff() async {
    usernameGot = await Firestore.instance.collection("users").where(
        "username", isEqualTo: username)
        .getDocuments();
    //if(usernameGot.documents.isEmpty){
    usernameGot.documents[0].reference.updateData({'status': 'Logged_In'});
    usernameGot = await Firestore.instance.collection("users").where(
        "username", isEqualTo: username).getDocuments();
    breakOffTime = new DateTime.now();
    print(breakOffTime);
    usernameGot.documents[0].reference.updateData(
        {'break off time': breakOffTime});
    var breaktimemin = breakOffTime.minute - breakonTime.minute;
    var breaktimehh = breakOffTime.hour - breakonTime.hour;
    usernameGot.documents[0].reference.updateData(
        {'total break time': '$breaktimehh : $breaktimemin'});
  }

  void onSubmit() {
    print('hgb');
    FormState dir = v.currentState;
    dir.save();
    signIn();
    Details();
    print('Access Granted');

    if (username.compareTo('user') == 0 && password.compareTo('pass') == 0) {
      setAuthenticated(true);
      status = true;
      setStat(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
            title: new Text(_title),
        ),


        body: new Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: 40.0, right: 40.0, bottom: 100),
              child: Column(
                children: <Widget>[
                  Form(
                    key: v,
                    child: Card(
                      borderOnForeground: true,
                      child: Container(
                        foregroundDecoration: BoxDecoration(
                          //color: Colors.blue,
                        ),
                        child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 18.0, left: 50, bottom: 12),
                                child: ListTile(
                                    leading: Icon(
                                        Icons.account_circle, size: 60.0),
                                    title: Text('Sign In'),
                                    onTap: () {
                                      showDialog<void>(
                                          context: context,
                                          barrierDismissible: true,
                                          // user must tap button!
                                          builder: (BuildContext context) {
                                            return Center(
                                              child: AlertDialog(
                                                title: Text(
                                                    'Not registered with us?'),
                                                contentPadding: EdgeInsets
                                                    .all(10.0),
                                                content: SingleChildScrollView(
                                                  child: Column(
                                                    children: <Widget>[
                                                      ListTile(
                                                        title: Text(
                                                            'Sign Up?'),
                                                        leading: Icon(
                                                            Icons.add),
                                                        onTap: () {
                                                          Navigator.of(
                                                              context)
                                                              .pushReplacementNamed(
                                                              '/signUp');
                                                        },
                                                      ),
                                                      ListTile(
                                                        title: Text(
                                                            'Contact Us'),
                                                        leading: Icon(
                                                            Icons.home),
                                                        onTap: () {
                                                          // Update the state of the app
                                                          // ...
                                                          // Then close the drawer
                                                          Navigator.of(
                                                              context)
                                                              .pushNamed(
                                                              '/pic');
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                      );
                                    }
                                ),
                              ),

                              Form(
                                key: _usernameKey,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25.0, right: 25),
                                  child: new TextFormField(
                                      controller: login._user,
                                      textAlign: TextAlign.center,
                                      decoration: new InputDecoration(
                                          prefixIcon: Icon(Icons.email),
                                          hintText: 'Enter username'),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Enter username';
                                        }
                                        username = value;
                                        return null;
                                      }
                                  ),
                                ),
                              ),
                              Form(
                                key: _passwordKey,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25.0, right: 25.0),
                                  child: new TextFormField(
                                    controller: login._pass,
                                    textAlign: TextAlign.center,
                                    decoration: new InputDecoration(
                                        prefixIcon: IconButton(
                                          icon: Icon(Icons.remove_red_eye),
                                          onPressed: () {
                                            print('hello');
                                          },
                                        ),
                                        hintText: 'Enter password'),
                                    obscureText: true,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please Enter Some Text';
                                      }
                                      password = value;
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              ButtonTheme.bar(
                                child: ButtonBar(
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          FlatButton(
                                              child: const Text('Submit'),
                                              onPressed: () {
                                                if (_usernameKey.currentState
                                                    .validate()) {
                                                  if (_passwordKey.currentState
                                                      .validate()) {
//                                                    showDialog(
//                                                        context: context,
//                                                        barrierDismissible: false,
//                                                        builder: (context) {
//                                                          return AlertDialog(
//                                                            title: Center(
//                                                              child: Padding(
//                                                                padding: const EdgeInsets
//                                                                    .all(10.0),
//                                                                child: Column(
//                                                                  children: <
//                                                                      Widget>[
//                                                                    Text(
//                                                                        'Processing... \n Please Wait'),
//                                                                    Container(
//                                                                        height: 75,
//                                                                        width: 75,
//                                                                        child: CircularProgressIndicator()),
//                                                                  ],
//                                                                ),
//                                                              ),
//                                                            ),
//                                                          );
//                                                        }
//                                                    );
                                                    onSubmit();
                                                  }
                                                }
                                              }),
                                          FlatButton(
                                            child: Text('Sign up?'),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pushReplacementNamed(
                                                  '/signUp');
                                            },
                                          )
                                        ],
                                      ),
                                    ]
                                ),
                              )
                            ]
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
        )
    );
  }
}

