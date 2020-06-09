import 'package:cloud_firestore/cloud_firestore.dart';

class Produit {
  final String produitId;
  final String marcheId;
  final String name;
  final String panierId;
  final int prix;

//Ajout dans le constructeur
  const Produit({this.produitId, this.marcheId, this.name, this.panierId, this.prix});

  Produit.fromSnapshot(DocumentSnapshot  snapshot) :
    produitId = snapshot.documentID,
    marcheId = snapshot.data["marcheID"],
    name = snapshot.data["name"],
    panierId = snapshot.data["panierID"],
    prix = snapshot.data["prix"];

}