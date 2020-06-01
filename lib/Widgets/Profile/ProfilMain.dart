import 'package:flutter/material.dart';
import 'package:lebonmarche/services/authentication.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lebonmarche/services/fetch_data.dart' as dataFetch;

const String signOut = 'LOGOUT';
const String pack = 'PACK';

const List<String> choices = <String>[signOut, pack];

class ProfilPage extends StatefulWidget {
  ProfilPage({Key key, this.auth, this.onSignedOut, this.userId})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  String userPack;
  final _formKey = new GlobalKey<FormState>();
  List<String> _packList = <String>['Choose one'];
  String _pack = 'Choose one';

  void _getPack() async {
    CollectionReference ref = Firestore.instance.collection('packs');
    QuerySnapshot eventsQuery = await ref.getDocuments();
    eventsQuery.documents.forEach((document) {
      if (document['name'] != 'Open') {
        _packList.add(document['name']);
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

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  void _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      dataFetch.changePack(userPack, _pack, widget.userId);
      setState(() {
       userPack = _pack; 
      });
      Navigator.of(context).pop();
    }
  }

  void _changePack() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Change pack",
              style: TextStyle(
                  fontFamily: 'Satisfy',
                  color: Color(0xFF43e97b),
                  fontSize: 25)),
          content: Container(
            height: 50.0, // Change as per your requirement
            width: 300.0, // Change as per your requirement
            child: new Form(
              key: _formKey,
              child: new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Color(0xFF43e97b),
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
                      child: new FormField<String>(
                        builder: (FormFieldState<String> state) {
                          return InputDecorator(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: const Icon(FontAwesomeIcons.suitcase,
                                  color: Colors.grey),
                              errorText:
                                  state.hasError ? state.errorText : null,
                            ),
                            isEmpty: _pack == 'Choose one',
                            child: new DropdownButtonHideUnderline(
                              child: new DropdownButton<String>(
                                value: _pack,
                                isDense: true,
                                onChanged: (String newValue) {
                                  setState(() {
                                    _pack = newValue;
                                    state.didChange(newValue);
                                  });
                                },
                                items: _packList.map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                        validator: (val) {
                          return val != userPack && val != null && val != 'Choose one'
                              ? null
                              : 'Please change your pack';
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss",
                  style: TextStyle(
                      fontFamily: 'Poppins', color: Colors.grey, fontSize: 15)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Change",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF43e97b),
                      fontSize: 15)),
              onPressed: () {
                _validateAndSave();
              },
            ),
          ],
        );
      },
    );
  }

  void choiceAction(String choice) {
    if (choice == signOut) {
      _signOut();
    } else if (choice == pack) {
      _changePack();
    }
  }

  @override
  void initState() {
    _getPack();
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
              color: Color(0xFF302f33),
            ),
            child: Center(child: CircularProgressIndicator()),
          ));
        final record = snapshot.data.documents
            .where((data) => data.data.containsKey(widget.userId))
            .single
            .data[widget.userId];
        return new Expanded(
            child: new Container(
                color: Color(0xFF302f33),
                child: new ListView(children: <Widget>[
                  _logout(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                        tag: 'assets/img/user.png',
                        child: Container(
                          height: 125.0,
                          width: 125.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(62.5),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('assets/img/user.png'))),
                        ),
                      ),
                      SizedBox(height: 25.0),
                      Text(
                        record['firstName'] + " " + record['name'],
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 20.0),
                      ),
                      Text(
                        record['status'],
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xFF43e97b),
                            fontSize: 18.0),
                      ),
                      _userDetails(
                          record['company'], record['mail'], record['pack']),
                      _circularProgress(
                          record['availableServices'], record['usedServices'])
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
            color: Colors.white,
            size: 35.0,
          ),
          onSelected: choiceAction,
          itemBuilder: (BuildContext context) {
            return choices.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(
                  choice,
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              );
            }).toList();
          },
        ));
  }

  Widget _userDetails(String _company, String _mail, String _pack) {
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
                  'COMPANY',
                  style: TextStyle(
                      fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5.0),
                Text(
                  _company,
                  style: TextStyle(
                      fontFamily: 'Poppins', color: Color(0xFF43e97b)),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'MAIL',
                  style: TextStyle(
                      fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5.0),
                Text(
                  _mail,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontFamily: 'Poppins', color: Color(0xFF43e97b)),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'PACK',
                  style: TextStyle(
                      fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5.0),
                Text(
                  _pack,
                  style: TextStyle(
                      fontFamily: 'Poppins', color: Color(0xFF43e97b)),
                )
              ],
            ),
          ],
        ),
      ),
      decoration: new BoxDecoration(
          color: Color(0xFFffffff),
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

  Widget _circularProgress(int availableServices, int usedServices) {
    final remainingServices = availableServices - usedServices;
    double percentage = remainingServices / availableServices;
    return new CircularPercentIndicator(
      radius: 120.0,
      lineWidth: 10.0,
      animation: true,
      percent: percentage,
      center: new Text(
        remainingServices.toString() + " / " + availableServices.toString(),
        style: new TextStyle(
            fontFamily: 'Poppins', color: Colors.white, fontSize: 20.0),
      ),
      footer: new Text(
        "Remaining services",
        style: new TextStyle(
            fontFamily: 'Poppins', color: Colors.white, fontSize: 17.0),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: Color(0xFF43e97b),
      backgroundColor: Colors.white,
    );
  }
}
