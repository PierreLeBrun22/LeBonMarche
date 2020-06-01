import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  final String name;
  final String location;
  final String description;
  final String image;
  final List<dynamic> partners;
  //Ajout attribut prix
  final int prix;
  //Ajout attribut statut
  final String statut;
  final String serviceId;

//Ajout dans le constructeur
  const Service({this.name, this.location,
    this.description, this.image, this.partners, this.prix, this.statut, this.serviceId});

  Service.fromSnapshot(DocumentSnapshot  snapshot) :
    name = snapshot.data["name"],
    location = snapshot.data["location"],
    description = snapshot.data["description"],
    image = snapshot.data["image"],
    partners = snapshot.data["partners"],
    //Map du nouveau attribut prix
    prix = snapshot.data["prix"],
    //Map du nouveau attribut prix
    statut = snapshot.data["statut"],
    serviceId = snapshot.documentID;

}