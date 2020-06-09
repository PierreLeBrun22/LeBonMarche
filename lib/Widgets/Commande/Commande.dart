import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lebonmarche/model/panier.dart';
import 'package:lebonmarche/model/produit.dart';
import 'package:lebonmarche/colors.dart';
import 'package:intl/intl.dart';
import 'package:lebonmarche/services/fetch_data.dart' as dataFetch;

class Commande extends StatefulWidget {
  final String marcheId;
  final String userId;
  final List<Produit> produits;
  final Panier panier;
  final int jourDelai;

  Commande(this.marcheId, this.userId, this.produits, this.panier, this.jourDelai);

  State<StatefulWidget> createState() => new _CommandeState();
}

class _CommandeState extends State<Commande> {
bool selected = false;
var produitsStatus = List<bool>();
bool panierStatus = false;
int currentStep = 0;
bool complete = false;
int total = 0;
bool date1Status = false;
bool date2Status = false;
bool date3Status = false;
List<String> dates = List<String>();
List<String> produitsAchetes = List<String>();
String panierAchete = "-";
int nbrArticlesAchetes = 0;
String dateLivraison;

void calibrageCheckbox() {
  for(int i = 0;i<widget.produits.length;i++) {
    produitsStatus.add(false);
  }
}

void fixementDates() {
  int i = 0;
  int j = 0;
    while(i != 3) {
      final now = new DateTime.now();
      if(now.add(new Duration(days: widget.jourDelai+j)).weekday != 6 && now.add(new Duration(days: widget.jourDelai+j)).weekday != 7) {
        String date = DateFormat('yMd').format(now.add(new Duration(days: widget.jourDelai+j)));
        dates.add(date);
        i++;
      }
      j++;
    }
}

next() {
  currentStep + 1 == 3
      ? calculCommand()
      : currentStep + 1 == 4
      ? setState(() {
        validateCommand();
        complete = true;
      })
      : 
      goTo(currentStep + 1);
}

cancel() {
  if (currentStep > 0) {
    goTo(currentStep - 1);
  }
}

goTo(int step) {
  setState(() => currentStep = step);
}

  void calculCommand() {
    setState(() {
      total = 0;
      nbrArticlesAchetes = 0;
      produitsAchetes = [];
      panierAchete = "-";
    });
    for(int i = 0;i<produitsStatus.length;i++) {
      if(produitsStatus[i]) {
        setState(() {
          total += widget.produits[i].prix;
          produitsAchetes.add(widget.produits[i].produitId);
          nbrArticlesAchetes++;
        });
      }
    }
    if(panierStatus) {
      setState(() {
        total += widget.panier.prix;
        panierAchete = widget.panier.panierId;
        nbrArticlesAchetes++;
      });
    }
    if(date1Status) {
      dateLivraison = dates[0];
    }
    else if(date2Status) {
      dateLivraison = dates[1];
    }
    else if(date3Status) {
      dateLivraison = dates[2];
    }
    goTo(currentStep + 1);
  }

  void validateCommand() {
    dataFetch.pushUserCommand(nbrArticlesAchetes, panierAchete, produitsAchetes, widget.marcheId, total, widget.userId, dateLivraison);
  }

  @override
  void initState() {
    calibrageCheckbox();
    fixementDates();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      body: new Container(
        constraints: new BoxConstraints.expand(),
        decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.05), BlendMode.dstATop),
          image: AssetImage('assets/img/panierbio.jfif'),
          fit: BoxFit.cover,
        ),
      ),
        child: new Stack(
          children: <Widget>[
            _getContent(),
            _getToolbar(context),
          ],
        ),
      ),
    );
  }

  Container _getContent() {
    return  Container(
      padding: new EdgeInsets.only(top: 30.0),
      child: Column(
      children: <Widget>[
        complete ? Expanded(
                child: Center(
                  child: AlertDialog(
                    title: new Text("Commande effectué", style: TextStyle(
                           fontFamily: 'IndieFlower',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        )),
                    content: new Text(
                      "Vous pouvez retrouvez vos commandes dans votre espace \"Commands\"", style: TextStyle(
                           fontFamily: 'Dosis',
                        )
                    ),
                    actions: <Widget>[
                      new FlatButton(
                        child: new Text(
                      "OK", style: TextStyle(
                           fontFamily: 'Dosis',
                           color: StyleColor.colorVert
                        )
                    ),
                        onPressed: () {
                          setState(() {
                            complete = false;
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              )
            : Expanded(
                child: Stepper(
                  steps: [
    Step(
      title: const Text('Choix des produits', style: TextStyle(
                           fontFamily: 'IndieFlower',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        )),
      isActive: true,
      content: Column(
      children: widget.produits.map((Produit produit) {
         return ListTile(
                    title: Text(produit.name),
                    subtitle: Text(produit.prix.toString()+"€/K"),
                    trailing: new Checkbox(
                        value: produitsStatus[widget.produits.indexOf(produit)],
                        onChanged: (bool val) {
                          setState(() {
                            produitsStatus[widget.produits.indexOf(produit)] = !produitsStatus[widget.produits.indexOf(produit)];
                          });
                        }));

        }).toList(),
      ),
    ),
    Step(
      isActive: true,
      title: const Text('Choix des paniers', style: TextStyle(
                           fontFamily: 'IndieFlower',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        )),
      content: Column(
        children: <Widget>[
          new ListTile(
                    title: Text(widget.panier.name),
                    subtitle: Text(widget.panier.prix.toString()+"€"),
                    trailing: new Checkbox(
                        value: panierStatus,
                        onChanged: (bool val) {
                          setState(() {
                            panierStatus = !panierStatus;
                          });
                        })),
        ],
      ),
    ),
    Step(
      isActive: true,
      title: const Text('Choix de la date de retrait', style: TextStyle(
                           fontFamily: 'IndieFlower',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        )),
      content: Column(
        children: <Widget>[
         new ListTile(
                    title: Text(dates[0]),
                    trailing: new Checkbox(
                        value: date1Status,
                        onChanged: (bool val) {
                          setState(() {
                            date1Status = !date1Status;
                            date2Status = false;
                            date3Status = false;
                          });
                        })),
         new ListTile(
                    title: Text(dates[1]),
                    trailing: new Checkbox(
                        value: date2Status,
                        onChanged: (bool val) {
                          setState(() {
                            date2Status = !date2Status;
                            date1Status = false;
                            date3Status = false;
                          });
                        })),
         new ListTile(
                    title: Text(dates[2]),
                    trailing: new Checkbox(
                        value: date3Status,
                        onChanged: (bool val) {
                          setState(() {
                            date3Status = !date3Status;
                            date2Status = false;
                            date1Status = false;
                          });
                        })),
        ],
      ),
    ),
    Step(
      isActive: true,
      title: const Text('Validation', style: TextStyle(
                           fontFamily: 'IndieFlower',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        )),
      content: Column(
        children: <Widget>[
          new Row(
            children: <Widget>[
               new Icon(FontAwesomeIcons.checkCircle, color: StyleColor.colorVert, size: 30.0,),
               new Padding(
                 padding: new EdgeInsets.only(left: 20.0),
                 child: new Text('Confirmer la commande ?', style: TextStyle(
                           fontFamily: 'Dosis',
                          fontSize: 19.0,
                        )),
               ),
            ],
          ),
           new Text("Total de la commande : "+total.toString()+"€", style: TextStyle(
                           fontFamily: 'Dosis',
                          fontSize: 19.0,
                        )),
        ],
      ),
    ),
  ],
                  currentStep: currentStep,
                  onStepContinue: next,
                  onStepTapped: (step) => goTo(step),
                  onStepCancel: cancel,
                ),
              ),
      ],
      ),
    );
  }

  Container _getToolbar(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: new BackButton(color: StyleColor.colorOrange),
    );
  }

}
