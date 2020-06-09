import 'package:flutter/material.dart';
import 'package:lebonmarche/services/authentication.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lebonmarche/Widgets/Profile/ProfilParticulier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lebonmarche/model/marche.dart';
import 'package:lebonmarche/model/commande.dart';
import 'package:lebonmarche/services/fetch_data.dart' as dataFetch;
import 'package:lebonmarche/colors.dart';
import 'package:lebonmarche/Widgets/Market/MarketParticulier.dart';
import 'package:lebonmarche/text_style.dart';
import 'package:lebonmarche/Widgets/CommandsPage/CommandsPage.dart';

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
          title: new Text("Verify your account", style: Style.titreStyle),
          content: new Text("Please verify account in the link sent to email", style: Style.texteStyle),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Resent link", style: Style.texteStyle),
              onPressed: () {
                Navigator.of(context).pop();
                _resentVerifyEmail();
              },
            ),
            new FlatButton(
              child: new Text("Dismiss", style: Style.texteStyle),
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

  Container _getAppBar() {
    return new Container(
      height: 80.0,
      color: StyleColor.colorOrange,
      child:  Row(
           mainAxisAlignment: MainAxisAlignment.start,
  children: <Widget>[
     new Padding(
       padding: const EdgeInsets.only(left: 10.0, top: 10.0),
      child: new Icon(FontAwesomeIcons.carrot,color: Color(0xFF67BF24),size: 40.0,),  
     ),
    new Padding(
       padding: const EdgeInsets.only(left: 15.0, top: 20.0),
      child: Text('Le Bon Marché', style: TextStyle(fontFamily: 'ChelseaMarket', fontSize: 30, color: Colors.white)),
    ),
  ],
),
    );
  }

  int _currentIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0: 
      return "Agriculteur" == userStatus ? 
      new Column(children: <Widget>[
        new Text("Not developped yet")])
      :
      new Column(children: <Widget>[
          new ProfilParticulier(
              auth: widget.auth,
              onSignedOut: widget.onSignedOut,
              userId: widget.userId),
        ]);
      case 1:
      return "Agriculteur" == userStatus ? 
       new Text("Not developped yet")
      :
       new Stack(
          children: <Widget>[
            new Container(
              padding: EdgeInsets.only(top: 60.0),
              child: new Column(children: <Widget>[
                FutureBuilder<List<Marche>>(
                  future: dataFetch.getMarches(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    return snapshot.hasData
                        ? MarketParticulier(
                            userId: widget.userId, marches: snapshot.data)
                        : new Expanded(
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
                  },
                )
              ]),
            ),
            _getAppBar(),
          ],
        );

        case 2:
      return "Agriculteur" == userStatus ? 
       new Text("Not developped yet")
      :
       new Stack(
          children: <Widget>[
            new Container(
              padding: EdgeInsets.only(top: 60.0),
              child: new Column(children: <Widget>[
                FutureBuilder<List<Commande>>(
                  future: dataFetch.getCommandesUser(widget.userId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    return snapshot.hasData
                        ? CommandsPage(
                            userId: widget.userId, commandes: snapshot.data)
                        : new Expanded(
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
                  },
                )
              ]),
            ),
            _getAppBar(),
          ],
        );

      default:
        return new Center(
          child: new Text(
            'Error',
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'IndieFlower',
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
          canvasColor: StyleColor.colorOrange,
          // sets the active color of the `BottomNavigationBar` if `Brightness` is light
        ),
        child: new BottomNavigationBar(
          fixedColor: Colors.white,
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.userAlt, color: StyleColor.colorVert),
              title: Text(
                'Profile',
                style: Style.titreStyle,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.shoppingBag, color: StyleColor.colorVert),
              title: Text(
                'Market',
                style: Style.titreStyle,
              ),
            ),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.bookOpen, color: StyleColor.colorVert),
                title: Text(
                  'Commands',
                  style: Style.titreStyle,
                )),
          ],
        ),
      ),
    );
  }
}
