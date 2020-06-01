import 'package:flutter/material.dart';
import 'package:lebonmarche/services/authentication.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lebonmarche/Widgets/Profile/ProfilMain.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lebonmarche/model/service.dart';
import 'package:lebonmarche/services/fetch_data.dart' as dataFetch;

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userPack;
  //Statut du User
  String userStatus;
  bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
    _getData();
    //Ajout à la fonction séxécutant avant l'affichage de la page
    _getStatutUser();
  }

  void _checkEmailVerification() async {
    _isEmailVerified = await widget.auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog();
    }
  }

  void _resentVerifyEmail() {
    widget.auth.sendEmailVerification();
  }

  void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Please verify account in the link sent to email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Resent link"),
              onPressed: () {
                Navigator.of(context).pop();
                _resentVerifyEmail();
              },
            ),
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

//Methode récupérant le statut de l'utilisateur courant
  void _getStatutUser() async {
    CollectionReference ref = Firestore.instance.collection('user');
    QuerySnapshot eventsQuery = await ref.getDocuments();
    eventsQuery.documents.forEach((document) {
      if (document.data.containsKey(widget.userId)) {
        setState(() {
          userStatus = document.data[widget.userId]['status'];
        });
      }
    });
  }

  void _getData() async {
    CollectionReference ref = Firestore.instance.collection('user');
    QuerySnapshot eventsQuery = await ref.getDocuments();
    eventsQuery.documents.forEach((document) {
      if (document.data.containsKey(widget.userId)) {
        setState(() {
          userPack = document.data[widget.userId]['pack'];
        });
      }
    });
  }

  Container _getAppBar() {
    return new Container(
      height: 60.0,
      color: Color(0xFF43e97b),
    );
  }

  Container _getAppbarWhite() {
    return new Container(
      margin: const EdgeInsets.only(top: 24.0, right: 12.0, left: 12.0),
      height: 55,
      decoration: BoxDecoration(
      borderRadius: new BorderRadius.circular(4.0),
      color: Color(0xFFf7f7f7),
      ),
      child:  Row(
           mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[
     new Icon(FontAwesomeIcons.handshake,color: Color(0xFF43e97b),size: 40.0,),  
    new Padding(
       padding: const EdgeInsets.only(left: 35.0),
      child: Text('MyServices', style: TextStyle(fontFamily: 'Satisfy', fontSize: 30, color: Color(0xFF4B4954))),
    ),
     new Padding(
       padding: const EdgeInsets.only(left: 20.0),
    child: new Icon(FontAwesomeIcons.handshake,color: Color(0xFF43e97b),size: 40.0,),
     ),
  ],
),
    );
  }

  int _currentIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new Column(children: <Widget>[
          new ProfilPage(
              auth: widget.auth,
              onSignedOut: widget.onSignedOut,
              userId: widget.userId),
        ]);

      default:
        return new Center(
          child: new Text(
            'Error',
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Satisfy',
                fontWeight: FontWeight.w600,
                fontSize: 36.0),
          ),
        );
    }
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _getDrawerItemWidget(_currentIndex),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: Color(0xFF4B4954),
          // sets the active color of the `BottomNavigationBar` if `Brightness` is light
        ),
        child: new BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.userAlt, color: Color(0xFF43e97b)),
              title: Text(
                'Profile',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.suitcase, color: Color(0xFF43e97b)),
              title: Text(
                'Your pack',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
            ),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.bookOpen, color: Color(0xFF43e97b)),
                title: Text(
                  'Open pack',
                  style: TextStyle(fontFamily: 'Poppins'),
                )),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.solidCalendar,
                    color: Color(0xFF43e97b)),
                title: Text(
                  'Reserved services',
                  style: TextStyle(fontFamily: 'Poppins'),
                ))
          ],
        ),
      ),
    );
  }
}
