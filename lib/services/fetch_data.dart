import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lebonmarche/model/marche.dart';
import 'package:lebonmarche/model/produit.dart';
import 'package:lebonmarche/model/commande.dart';


/* PARTIE MARKET PAGE */
/* ************************************* */
/* ************************************* */
Future<List<Marche>> getMarches() async {
  List<Marche> _marchesList = [];
  CollectionReference ref = Firestore.instance.collection('marche');
  QuerySnapshot eventsQuery = await ref.getDocuments();
  eventsQuery.documents.forEach((document) {
     Marche marche = new Marche(
          marcheId: document.documentID,
          name: document.data['name'],
          location: document.data['location'],
          description: document.data['description'],
          agriculteurId: document.data['agriculteurID'],
          photoAgriculteur: document.data['photoAgriculteur'],
          jourDelai: document.data['jourDelai'],
          photoCouverture: document.data['photoCouverture']);
          
          _marchesList.add(marche);
  });
  return _marchesList;
}

Future<List<Produit>> getProduitMarche(String marcheID) async {
  List<Produit> _produitList = [];
  CollectionReference ref = Firestore.instance.collection('produit');
  QuerySnapshot eventsQuery = await ref.getDocuments();
  eventsQuery.documents.forEach((document) {
     if(document['marcheID'] == marcheID) {
       Produit produit = new Produit(
          marcheId: document.data['marcheID'],
          name: document.data['name'],
          panierId: document.data['panierID'],
          prix: document.data['prix']);
          
          _produitList.add(produit);
     }
  });
  return _produitList;
}
/* ************************************* */
/* ************************************* */

/* PARTIE COMMAND PAGE AFTER DETAIL */
/* ************************************* */
/* ************************************* */
void pushUserCommand(int nbrArticles, String panier, List<String> produits, String marcheID, int total, String userID, String date) async {
  String particulierID;
  CollectionReference ref1 = Firestore.instance.collection('particulier');
  QuerySnapshot eventsQuery = await ref1.getDocuments();
  eventsQuery.documents.forEach((document) {
      if (document.data['userID'] == userID) {
        particulierID = document.documentID;
        Firestore.instance
          .collection('particulier')
          .document(document.documentID)
          .updateData(
        {"nbrCommandes": document.data['nbrCommandes'] + 1},
        );
      }
    });
  Firestore.instance
        .collection('commande')
        .add({"particulierID": particulierID, "nbrArticles": nbrArticles, "panier": panier, "produits": produits, "marcheID": marcheID, "total": total, "date": date});
}
/* ************************************* */
/* ************************************* */

/* PARTIE COMMANDS USER PAGE */
/* ************************************* */
/* ************************************* */
Future<List<Commande>> getCommandesUser(String userID) async {
  List<Commande> _commandsUserList = [];
  String particulierID;
  CollectionReference ref1 = Firestore.instance.collection('particulier');
  QuerySnapshot eventsQuery = await ref1.getDocuments();
  eventsQuery.documents.forEach((document) {
      if (document.data['userID'] == userID) {
        particulierID = document.documentID;
      }
    });
  CollectionReference ref2 = Firestore.instance.collection('commande');
  QuerySnapshot eventsQuery2 = await ref2.getDocuments();
  eventsQuery2.documents.forEach((document) {
     if(document['particulierID'] == particulierID) {
       Commande commande = new Commande(
          particulierId: particulierID,
          commandId: document.documentID,
          marcheId: document.data['marcheID'],
          date: document.data['date'],
          nbrArticles: document.data['nbrArticles'],
          produits: document.data['produits'],
          total: document.data['total'],
          panier: document.data['panier']);
          
          _commandsUserList.add(commande);
     }
  });
  return _commandsUserList;
}

void deleteUserCommand(String commandID, String particulierID) async {
  CollectionReference ref1 = Firestore.instance.collection('particulier');
  QuerySnapshot eventsQuery = await ref1.getDocuments();
    eventsQuery.documents.forEach((document) {
      if (document.documentID == particulierID) {
        Firestore.instance
          .collection('particulier')
          .document(document.documentID)
          .updateData(
        {"nbrCommandes": document.data['nbrCommandes'] - 1},
        );
      }
    });
   Firestore.instance
    .collection('commande').document(commandID).delete();
}
/* ************************************* */
/* ************************************* */

/* PARTIE LOGIN */
/* ************************************* */
/* ************************************* */
void pushUserDataSignupProfile(String userID, String email, String firstName,
    String name,String status) {
    Firestore.instance.collection('user').add({
      userID: {
        "mail": email,
        "firstName": firstName,
        "name": name,
        "status": status,
      }
    });

     if (status == 'Agriculteur') {
    Firestore.instance.collection('agriculteur').add({
        "userID": userID,
        "marcheID": "",
        "note": 0,
        "nbrVente": 0,
    });
  } else {
    Firestore.instance.collection('particulier').add({
        "userID": userID,
        "nbrCommandes": 0,
    });
  }
}
/* ************************************* */
/* ************************************* */
