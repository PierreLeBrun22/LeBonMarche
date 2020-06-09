import 'package:cloud_firestore/cloud_firestore.dart';

class Commande {
  final String commandId;
  final String date;
  final String marcheId;
  final String panier;
  final int nbrArticles;
  final int total;
  final List<dynamic> produits;
  final String particulierId;

//Ajout dans le constructeur
  const Commande({this.commandId, this.date, this.marcheId, this.panier, this.nbrArticles, this.total, this.produits, this.particulierId});

  Commande.fromSnapshot(DocumentSnapshot  snapshot) :
    commandId = snapshot.documentID,
    date = snapshot.data['date'],
    marcheId = snapshot.data["marcheID"],
    panier = snapshot.data["panier"],
    nbrArticles = snapshot.data["nbrArticles"],
    total = snapshot.data["total"],
    produits = snapshot.data["produits"],
    particulierId = snapshot.data["particulierId"];

}