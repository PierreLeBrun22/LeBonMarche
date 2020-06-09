import 'package:cloud_firestore/cloud_firestore.dart';

class Marche {
  final String marcheId;
  final String name;
  final String location;
  final String description;
  final String agriculteurId;
  final String photoCouverture;
  final String photoAgriculteur;
  final int jourDelai;

//Ajout dans le constructeur
  const Marche({this.marcheId, this.name, this.location,
    this.description, this.agriculteurId, this.photoCouverture, this.photoAgriculteur, this.jourDelai});

  Marche.fromSnapshot(DocumentSnapshot  snapshot) :
    marcheId = snapshot.documentID,
    name = snapshot.data["name"],
    location = snapshot.data["location"],
    description = snapshot.data["description"],
    agriculteurId = snapshot.data["agriculteurID"],
    photoAgriculteur = snapshot.data["photoAgriculteur"],
    jourDelai = snapshot.data["jourDelai"],
    photoCouverture = snapshot.data["photoCouverture"];

}