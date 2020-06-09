import 'package:flutter/material.dart';
import 'package:lebonmarche/model/commande.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lebonmarche/Widgets/Market/separator.dart';
import 'package:lebonmarche/colors.dart';

class DetailPageDismissible extends StatefulWidget {
  DetailPageDismissible({Key key, this.commande})
      : super(key: key);

  final Commande commande;

  @override
  State<StatefulWidget> createState() => new _DetailPageDismissibleState();
}

class _DetailPageDismissibleState extends State<DetailPageDismissible> {
  String nomMarche = "Loading";
  String locationMarche = "Loading";
  String nomPanier = "-";
  int prixPanier = 0;
  List<String> nomProduit = [];
  List<int> prixProduit = [];

  void getInfoMarche() async {
    CollectionReference ref = Firestore.instance.collection('marche');
    QuerySnapshot eventsQuery = await ref.getDocuments();
    eventsQuery.documents.forEach((document) {
     if(document.documentID == widget.commande.marcheId) {
          setState(() {
            nomMarche = document.data['name'];
            locationMarche = document.data['location'];
          });
     }
  });
}

  void getInfoPanier() async {
    CollectionReference ref = Firestore.instance.collection('panier');
    QuerySnapshot eventsQuery = await ref.getDocuments();
    eventsQuery.documents.forEach((document) {
     if(document.documentID == widget.commande.panier) {
          setState(() {
            nomPanier = document.data['name'];
            prixPanier = document.data['prix'];
          });
     }
  });
  }

  void getInfoProduits() async {
    if(widget.commande.produits.length != 0) {
      CollectionReference ref = Firestore.instance.collection('produit');
      QuerySnapshot eventsQuery = await ref.getDocuments();
      eventsQuery.documents.forEach((document) {
        for(int i = 0;i<widget.commande.produits.length;i++) {
          if(document.documentID == widget.commande.produits[i]) {
            setState(() {
              nomProduit.add(document.data['name']);
              prixProduit.add(document.data['prix']);
            });
          }
        }
      });
    }
  }

  @override
  void initState() {
    getInfoMarche();
    getInfoProduits();
    getInfoPanier();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   return new Container(
     margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: new Column(
        children: <Widget>[
          new Container(height: 4.0),
            new Column(
               crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                 new Text(nomMarche, style: TextStyle(
                           fontFamily: 'IndieFlower',
                          fontWeight: FontWeight.bold,
                          color: StyleColor.colorVert,
                          fontSize: 20.0,
                        ),),
                  new Text("A venir chercher pour le : "+widget.commande.date, style: TextStyle(
                           fontFamily: 'IndieFlower',
                          fontWeight: FontWeight.bold,
                          color: StyleColor.colorOrange,
                          fontSize: 16.0,
                        ),),
                   new Text(locationMarche, style: TextStyle(
                           fontFamily: 'Dosis', fontSize: 16.0
                        ),),
                  new Container(height: 10.0),
                   new Text("Total : "+widget.commande.total.toString()+"€", style: TextStyle(
                           fontFamily: 'Dosis', fontSize: 16.0
                        ),),
                    new Text("Nombre d'articles : "+widget.commande.nbrArticles.toString(), style: TextStyle(
                           fontFamily: 'Dosis', fontSize: 16.0
                        ),),
          new Separator(),
          new Container(height: 10.0),

          nomPanier == "-" ?
          new Container()
          :
              new Text(nomPanier+" : "+prixPanier.toString()+"€", style: TextStyle(
                           fontFamily: 'Dosis', fontSize: 16.0
                        ),),

          nomProduit == [] ?
          new Container()
          :
          new Column(
        children: nomProduit.map((e) {
            return new Row(
                  children: <Widget>[
                    new Text(nomProduit[nomProduit.indexOf(e)]+" : "+prixProduit[nomProduit.indexOf(e)].toString()+"€", style: TextStyle(
                           fontFamily: 'Dosis', fontSize: 16.0
                        ),)
                  ],
                );
        }).toList(),
      ),
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
}