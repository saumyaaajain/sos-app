//import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sms/contact.dart';
import 'package:sms/sms.dart';


class dash extends StatefulWidget {
  VoidCallback refhome, ref, nref, snap;
  Function name; //,snap;
  dash(this.refhome, this.name, this.ref, this.nref, this.snap);

  @override
  _ContactState createState() => _ContactState(refhome, name, ref, nref, snap);
}

class _ContactState extends State<dash> {
  VoidCallback refhome, ref, nref, snap;
  Function name, waitsnap;
  //QuerySnapshot varsnap;
  var nameOfUser;
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  _ContactState(this.refhome, this.name, this.ref, this.nref, this.snap) {
    noName();
    refGet();
    //snapshot();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );
  }

  void main() async{
    ContactQuery contacts = new ContactQuery();
    Contact contact = await contacts.queryContact('8824461309');
    print(contact.fullName);
  }

  void SMS() {
    SmsSender sender = new SmsSender();
    String address = 'Saumya';
    sender.sendSms(new SmsMessage(address, 'HELP NEEDED! Please take me to hospital! '));
  }

  void SMSdoc() {
    SmsSender sender = new SmsSender();
    String address = 'Doctor';
    sender.sendSms(new SmsMessage(address, 'HELP NEEDED DOC, I\'m your patient and on my way. Please be free. ITS URGENT.'));
  }
  _saveDeviceToken() async {
    // Get the current user
    String uid = '123';
    // FirebaseUser user = await _auth.currentUser();

    // Get the token for this device
    String fcmToken = await _fcm.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = _db
          .collection('users')
          .document(uid)
          .collection('tokens')
          .document(fcmToken);

      await tokens.setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem // optional
      });
    }
  }

  void noName() async {
    nameOfUser = await name();
    print("name2: " + nameOfUser);
    setState(() {

    });
  }

  QuerySnapshot usernameRef;

  void refGet() async {
    usernameRef = await waitsnap();
    //print("name2: " + usernameRef);
    setState(() {});
  }

  _launchURL(String toMailId, String subject, String body) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
    // var date= hourFormat(of: );
  }

  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
    if (_image != null) {
      //usernameRef.documents[0].reference.putData(_image);
    }
  }

  //ref.getfile; (
  //timestamp.now

  //void snapshot() async{
  //  varsnap = await waitsnap();
  //  setState(() {
  //  });
  //}

  @override
  var val;
  bool isSwitched = false;

  Widget build(BuildContext context) {
    void logout() {
      //VoidCallback ref
      refhome();
      //_launchURL('jsaumya988@gmail.com', 'Log Out', 'Log Out');
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/login', ModalRoute.withName(':'));
    }


    Future<void> _sure() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return Center(
            // padding: const EdgeInsets.only(
            //left: 25.0, right: 25.0, top: 250, bottom: 225),
            child: AlertDialog(
                title: Text('Are you sure you want to LOG-OUT?'),
                //backgroundColor: Colors.blueAccent,
                content: Row(
                    children: <Widget>[
                      ButtonTheme(
                          child: ButtonBar(
                            children: <Widget>[
                              FlatButton(
                                child: Text('No'),
                                //color: Colors.blueAccent,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                  child: Text('Yes'),
                                  //color: Colors.blueAccent,
                                  onPressed: () {
                                    logout();
                                  }
                              )
                            ],
                          )
                      )
                    ])
            ),
          );
        },
      );
    }

    //RaisedButton dropDownValue = new RaisedButton(
    // child: new Text('My Assign Work'),
    // onPressed: null,
    // );

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        //title: Text('Avyukta Intellical'),
          actions: <Widget>[
//          new IconButton(icon: Icon(Icons.edit), onPressed: () {
//            Navigator.push(context, new MaterialPageRoute(
//                builder: (context) =>
//                new LoginNew()));
//          }),
//          new IconButton(icon: new Icon(Icons.account_box),
//              onPressed: () {
//                Navigator.push(context, new MaterialPageRoute(
//                    builder: (context) =>
//                    new homepage(name))
//                );
//              }),
          new IconButton(icon: new Icon(Icons.settings_power), onPressed: _sure)
          ],
      ),
//      drawer: Drawer(
//        child: Column(
//          children: <Widget>[
//            Expanded(
//              child: ListView(
//                // Important: Remove any padding from the ListView.
//                padding: EdgeInsets.zero,
//                children: <Widget>[
//                  DrawerHeader(
//                    child: Column(
//                      children: <Widget>[
//                        Container(
//                          height: 85,
//                          decoration: BoxDecoration(
//                            // color: Colors.blue,
//                              image: new DecorationImage(
//                                  fit: BoxFit.fill,
//                                  image: new NetworkImage(
//                                      'https://media.licdn.com/dms/image/C561BAQEFAWLxkwbpgw/company-background_10000/0?e=2159024400&v=beta&t=WrhVSsJYnA1CjoHT04bHh133F3_5dqIw-GQK-VmFqOk')
//                              )
//                          ),
//                        ),
//                        Divider(
//                          height: .25,
//                        ),
//                        Padding(
//                          padding: const EdgeInsets.only(top: 1.0, bottom: 0.0),
//                          child: Row(
//                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                            children: <Widget>[
//                              Text(nameOfUser == null ? 'Name' : nameOfUser),
//                              IconButton(icon: Icon(Icons.add),
//                                onPressed: () async {
//                                  getImage();
//                                },)
//                            ],
//                          ),
//                        )
//                      ],
//                    ),
//                  ),
//                  ListTile(
//                    title: Text('Task'),
//                    leading: Icon(Icons.assignment),
//                    onTap: () {
//                      // Update the state of the app
//                      // ...
//                      // Then close the drawer
//                      //Navigator.of(context).pushNamed('/task');
//                      Navigator.push(
//                          context, new MaterialPageRoute(builder: (context) =>
//                      new Task(name))
//                      );
//                    },
//                  ),
//                  ListTile(
//                    title: Text('Leave Request'),
//                    leading: Icon(Icons.airline_seat_flat),
//                    onTap: () {
//                      // Update the state of the app
//                      // ...
//                      // Then close the drawer
//                      Navigator.push(
//                          context, new MaterialPageRoute(builder: (context) =>
//                      new leave(snap))
//                      );
//                    },
//                  ),
//                  ListTile(
//                    title: Text('Token'),
//                    leading: Icon(Icons.bubble_chart),
//                    onTap: () {
//                      Navigator.push(
//                          context, new MaterialPageRoute(builder: (context) =>
//                      new Token(nameOfUser)
//                      )
//                      );
//                    },
//                  ),
//                  ListTile(
//                    title: Text('Card Raise'),
//                    leading: Icon(Icons.monetization_on),
//                    onTap: () {
//                      Navigator.push(
//                          context, new MaterialPageRoute(builder: (context) =>
//                      new CardRaise(nameOfUser)
//                      )
//                      );
//                    },
//                  ),
//                  ListTile(
//                    title: Text('All Client'),
//                    leading: Icon(Icons.group),
//                    onTap: () {
//                      // Update the state of the app
//                      // ...
//                      // Then close the drawer
//                      null;
//                    },
//                  ),
//                  ListTile(
//                    title: Text('Profile'),
//                    leading: Icon(Icons.account_circle),
//                    onTap: () {
//                      // Update the state of the app
//                      // ...
//                      // Then close the drawer
//                      Navigator.push(
//                          context, new MaterialPageRoute(builder: (context) =>
//                      new profile(snap))
//                      );
//                    },
//                  ),
//                ],
//              ),
//            ),
//            Divider(
//              height: 6.0,
//              //  child: MainAxisAlignment.end
//            ),
//            ListTile(
//              onTap: _sure,
//              leading: Icon(Icons.power_settings_new),
//              title: Text('Log Out?'),
//            ),
//          ],
//        ),
//      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Container(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.call),
                      title: Text('Notify Personal Doctor'),
                      onTap: (){
                        SMSdoc();
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.warning),
                      title: Text('My Allergies'),
                    ),
                  ),
                  Card(
                    child:ListTile(
                        leading: Icon(Icons.healing),
                        title: Text('My Medication'),
                      onTap: (){
                        showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) => AlertDialog(
                              title: Text('Medicines I take'),
                            content: Column(
                              children: <Widget>[
                                Text('Cytarabane'),
                                Text('Gencitabine'),
                                Text('Methotrexate')
                              ],
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Ok'),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                        );
                      },
                  ),
                  ),
                  Card(
                    child:ListTile(
                      leading: Icon(Icons.assignment),
                      title: Text('My Prescription'),
                      trailing: Icon(Icons.add),
                      onTap: (){
                        getImage();
                      },
                    ),
                  ),
                ],
              )),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          SMS();
        },
        child: Text('SOS'),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}