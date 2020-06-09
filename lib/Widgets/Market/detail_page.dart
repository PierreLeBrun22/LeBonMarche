import 'package:flutter/material.dart';
import 'package:lebonmarche/model/marche.dart';
import 'package:lebonmarche/colors.dart';
import 'package:lebonmarche/Widgets/Market/marketItem.dart';
import 'package:lebonmarche/Widgets/Market/separator.dart';
import 'package:lebonmarche/text_style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lebonmarche/model/produit.dart';
import 'package:lebonmarche/model/panier.dart';
import 'package:lebonmarche/Widgets/Commande/Commande.dart';

class DetailPage extends StatefulWidget {
  final Marche marche;
  final String userId;

  DetailPage(this.marche, this.userId);

  State<StatefulWidget> createState() => new _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
List<NewItem> items = <NewItem>[
            new NewItem(
              false,
              "LOADING",
              new Icon(FontAwesomeIcons.shoppingBag, color: StyleColor.colorVert),
            )
          ];
List<Produit> _produitList = [];
Panier panierMarche;
List<Produit> _produitPanierList = [];


void _getProduitMarche() async {
  CollectionReference ref = Firestore.instance.collection('produit');
  QuerySnapshot eventsQuery = await ref.getDocuments();
  eventsQuery.documents.forEach((document) {
     if(document['marcheID'] == widget.marche.marcheId) {
       Produit produit = new Produit(
          produitId: document.documentID,
          marcheId: document.data['marcheID'],
          name: document.data['name'],
          panierId: document.data['panierID'],
          prix: document.data['prix']);
          setState(() {
             _produitList.add(produit);
          });
     }
  });
  }

  void _getPanierMarche() async {
  CollectionReference ref = Firestore.instance.collection('panier');
  QuerySnapshot eventsQuery = await ref.getDocuments();
  eventsQuery.documents.forEach((document) {
     if(document['marcheID'] == widget.marche.marcheId) {
        Panier panier = new Panier(
          panierId: document.documentID,
          marcheId: document.data['marcheID'],
          name: document.data['name'],
          nbrArticles: document.data['nbrArticles'],
          prix: document.data['prix'],
          quantite: document.data['quantite'],
          articles: document.data['articles']);
        setState(() {
          panierMarche = panier;
          items = <NewItem>[
            new NewItem(
              false,
              panier.name+" : "+panier.prix.toString()+"€",
              new Icon(FontAwesomeIcons.shoppingBag, color: StyleColor.colorVert),
            )
          ];
        });
        for(int i = 0;i<panier.nbrArticles;i++) {
          _getProduitPanier(panier.articles[i]);
        }
     }
  });
  }

  void _getProduitPanier(String produitID) async {
  CollectionReference ref = Firestore.instance.collection('produit');
  QuerySnapshot eventsQuery = await ref.getDocuments();
  eventsQuery.documents.forEach((document) {
     if(document.documentID == produitID) {
       Produit produit = new Produit(
          marcheId: document.data['marcheID'],
          name: document.data['name'],
          panierId: document.data['panierID'],
          prix: document.data['prix']);
          setState(() {
             _produitPanierList.add(produit);
          });
     }
  });
  }

  @override
  void initState() {
    _getProduitMarche();
    _getPanierMarche();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        constraints: new BoxConstraints.expand(),
        color: Colors.white,
        child: new Stack(
          children: <Widget>[
            _getBackground(),
            _getGradient(),
            _getContent(),
            _getToolbar(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
                  new PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>
                        new Commande(widget.marche.marcheId, widget.userId, _produitList, panierMarche, widget.marche.jourDelai),
                    transitionsBuilder: (context, animation, secondaryAnimation,
                            child) =>
                        new FadeTransition(opacity: animation, child: child),
                  ),
                );
        },
        label: Text('COMMANDER', style: TextStyle(fontFamily: 'Dosis', color: Colors.white)),
        backgroundColor: StyleColor.colorVert,
        ),
    );
  }

  Container _getBackground() {
    return new Container(
      color: StyleColor.colorOrange,
      constraints: new BoxConstraints.expand(height: 295.0),
    );
  }

  Container _getGradient() {
    return new Container(
      margin: new EdgeInsets.only(top: 190.0),
      height: 110.0,
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: <Color>[new Color(0x00ffffff), new Color(0xFFffffff)],
          stops: [0.0, 0.9],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 1.0),
        ),
      ),
    );
  }

  Container _getContent() {
    final _produitsTitle = "Produits".toUpperCase();
    final _paniersTitle = "Paniers".toUpperCase();
    return new Container(
      child: new ListView(
        padding: new EdgeInsets.fromLTRB(0.0, 72.0, 0.0, 32.0),
        children: <Widget>[
          new MarketItem(
            widget.marche,
            widget.userId,
            horizontal: false,
          ),
          new Container(
            padding: new EdgeInsets.symmetric(horizontal: 32.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(widget.marche.description,
                    style: TextStyle(fontFamily: 'Dosis', fontSize: 16.0)),
                new Container(height: 10.0),
                new Text(
                  _produitsTitle,
                  style: Style.headerTextStyle,
                ),
                new Separator(),
                
                new Column(
        children: _produitList.map((Produit produit) {
            return new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(produit.name ,
                    style: TextStyle(fontFamily: 'Dosis', fontSize: 16.0)),
                    Text(produit.prix.toString()+"€/K" ,
                    style: TextStyle(fontFamily: 'Dosis', fontSize: 16.0)),
                  ],
                );
        }).toList(),
      ),
                 new Container(height: 10.0),
                new Text(
                  _paniersTitle,
                  style: Style.headerTextStyle,
                ),
                new Separator(),
                new Padding(
            padding: new EdgeInsets.all(10.0),
            child: new ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  items[index].isExpanded = !items[index].isExpanded;
                });
              },
              children: items.map((NewItem item) {
                return new ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return new ListTile(
                        leading: item.iconpic,
                        title: new Text(
                          item.header,
                          textAlign: TextAlign.left,
                          style: new TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'Dosis',
                            fontWeight: FontWeight.w400,
                          ),
                        ));
                  },
                  isExpanded: item.isExpanded,
                  body: new Padding(
                      padding: new EdgeInsets.only(bottom: 20.0),
                      child: new Column(children: _panelList())),
                );
              }).toList(),
            ),
          ),
                new Container(height: 40.0),
              ],
            ),
          ),
        ],
      ),
    );
  }


List<Widget> _panelList() {
    List<Widget> panelList = [];
    for (var i = 0; i < _produitPanierList.length; i++) {
      panelList.add(Text(_produitPanierList[i].name.toUpperCase()+" : "+panierMarche.quantite[i].toString()+" KILOS",
          style: TextStyle(
              fontSize: 16.0,
              fontFamily: 'Dosis')));
      if (i != _produitPanierList.length - 1) {
        panelList.add(Separator());
      }
    }
    return panelList;
  }


  Container _getToolbar(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: new BackButton(color: Colors.white),
    );
  }

}

class NewItem {
  bool isExpanded;
  final String header;
  final Icon iconpic;
  NewItem(this.isExpanded, this.header, this.iconpic);
}

double discretevalue = 2.0;
double hospitaldiscretevalue = 25.0;
