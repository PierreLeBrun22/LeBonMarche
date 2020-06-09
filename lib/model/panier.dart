import 'package:cloud_firestore/cloud_firestore.dart';

class Panier {
  final String panierId;
  final String marcheId;
  final String name;
  final int nbrArticles;
  final int prix;
  final List<dynamic> articles;
  final List<dynamic> quantite;

//Ajout dans le constructeur
  const Panier({this.panierId, this.marcheId, this.name, this.nbrArticles, this.prix, this.articles, this.quantite});

  Panier.fromSnapshot(DocumentSnapshot  snapshot) :
    panierId = snapshot.documentID,
    marcheId = snapshot.data["marcheID"],
    name = snapshot.data["name"],
    nbrArticles = snapshot.data["nbrArticles"],
    prix = snapshot.data["prix"],
    quantite = snapshot.data["quantite"],
    articles = snapshot.data["articles"];

}