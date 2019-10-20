import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class profile extends StatefulWidget {
  static final TextEditingController _password1 = new TextEditingController();
  static final TextEditingController _password2 = new TextEditingController();

  Function snap;

  profile(this.snap);

  @override
  _profileState createState() => _profileState(snap);
}

class _profileState extends State<profile> {
  Function snap;

  //Function Ref;
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  _profileState(this.snap) {
    refGet();
  }

  QuerySnapshot usernameRef;

  void refGet() async {
    usernameRef = await snap();
    //print("name2: " + usernameRef);
    setState(() {});
  }

  Future<void> passwordChange() async {
    usernameRef.documents[0].reference.updateData({'password': pass1});
  }

  void onSubmit() {
    FormState dir = _key.currentState;
    dir.save();
    if (pass1 == pass2) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Loading')));
      passwordChange();
      Navigator.of(context).pushReplacementNamed('/task');
    } else {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Try Again')));
    }
  }

  String pass1, pass2;
  final key1 = GlobalKey<FormState>();
  final key2 = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Change Password'),
        ),
        body: Form(
          key: _key,
          child: Center(
            child: Column(
              children: <Widget>[
                Form(
                  key: key1,
                  child: TextFormField(
                      controller: profile._password1,
                      obscureText: true,
                      textAlign: TextAlign.center,
                      decoration:
                          new InputDecoration(hintText: 'Enter password'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Password';
                        }
                        pass1 = value;
                        return null;
                      }),
                ),
                Form(
                  key: key2,
                  child: TextFormField(
                      controller: profile._password2,
                      obscureText: true,
                      textAlign: TextAlign.center,
                      decoration:
                          new InputDecoration(hintText: 'Enter Password'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Password';
                        }
                        pass2 = value;
                        return null;
                      }),
                ),
                ButtonTheme.bar(
                  child: ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: Text('Submit'),
                        onPressed: () {
                          if (key1.currentState.validate()) {
                            if (key2.currentState.validate()) {
                              onSubmit();
                            }
                          }
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
