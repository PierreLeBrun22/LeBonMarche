import 'package:flutter/material.dart';
import 'package:lebonmarche/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lebonmarche/colors.dart';

const String signOut = 'LOGOUT';

const List<String> choices = <String>[signOut];

class ProfilParticulier extends StatefulWidget {
  ProfilParticulier({Key key, this.auth, this.onSignedOut, this.userId})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _ProfilParticulierState();
}

class _ProfilParticulierState extends State<ProfilParticulier> {
  int _nbrCommandes = 0;

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }


  void choiceAction(String choice) {
    if (choice == signOut) {
      _signOut();
    }
  }

  void _getData() async {
    CollectionReference ref = Firestore.instance.collection('particulier');
  QuerySnapshot eventsQuery = await ref.getDocuments();
  eventsQuery.documents.forEach((document) {
    if (document['userID'] == widget.userId) {
       setState(() {
          _nbrCommandes = document['nbrCommandes'];
        });
    }
  });
  }

  @override
  void initState() {
    _getData(); 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('user').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return new Expanded(
              child: new Container(
            decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.05), BlendMode.dstATop),
          image: AssetImage('assets/img/panierbio.jfif'),
          fit: BoxFit.cover,
        ),
      ),
            child: Center(child: CircularProgressIndicator()),
          ));
        final record = snapshot.data.documents
            .where((data) => data.data.containsKey(widget.userId))
            .single
            .data[widget.userId];
        return new Expanded(
            child: new Container(
                decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.05), BlendMode.dstATop),
          image: AssetImage('assets/img/panierbio.jfif'),
          fit: BoxFit.cover,
        ),
      ),
                child: new ListView(children: <Widget>[
                  _logout(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.solidUserCircle, 
                        color: StyleColor.colorVert,
                        size: 130.0,
                        ),
                      SizedBox(height: 25.0),
                      Text(
                        record['firstName'] + " " + record['name'],
                        style: TextStyle(
                            fontFamily: 'IndieFlower',
                            fontWeight: FontWeight.w400,
                            fontSize: 25.0),
                      ),
                      Text(
                        record['status'],
                        style: TextStyle(
                            fontFamily: 'Dosis',
                            color: StyleColor.colorVert,
                            fontSize: 20.0),
                      ),
                      _userDetails(record['mail']),
                    ],
                  )
                ])));
      },
    );
  }

  Widget _logout() {
    return new Container(
        margin: const EdgeInsets.only(right: 20.0, top: 20.0),
        alignment: Alignment.topRight,
        child: PopupMenuButton<String>(
          icon: new Icon(
            Icons.settings,
            color: StyleColor.colorOrange,
            size: 35.0,
          ),
          onSelected: choiceAction,
          itemBuilder: (BuildContext context) {
            return choices.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(
                  choice,
                  style: TextStyle(fontFamily: 'Dosis'),
                ),
              );
            }).toList();
          },
        ));
  }

  Widget _userDetails(String _mail) {
    return new Container(
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'MAIL',
                  style: TextStyle(
                      fontFamily: 'IndieFlower', fontWeight: FontWeight.bold, fontSize: 17),
                ),
                SizedBox(height: 5.0),
                Text(
                  _mail,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontFamily: 'Dosis', color: Colors.white, fontSize: 15),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'COMMANDES',
                  style: TextStyle(
                      fontFamily: 'IndieFlower', fontWeight: FontWeight.bold, fontSize: 17),
                ),
                SizedBox(height: 5.0),
                Text(
                 _nbrCommandes.toString(),
                  style: TextStyle(
                      fontFamily: 'Dosis', color: Colors.white, fontSize: 15),
                )
              ],
            ),
          ],
        ),
      ),
      decoration: new BoxDecoration(
          color: StyleColor.colorOrange,
          shape: BoxShape.rectangle,
          boxShadow: <BoxShadow>[
            new BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0,
              offset: new Offset(0.0, 8.0),
            ),
          ],
          borderRadius: new BorderRadius.circular(8.0)),
    );
  }
}
