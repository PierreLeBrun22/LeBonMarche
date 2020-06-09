import 'package:flutter/material.dart';
import 'package:lebonmarche/Widgets/CommandsPage/DetailPageDismissible.dart';
import 'package:lebonmarche/colors.dart';
import 'package:lebonmarche/model/commande.dart';
import 'package:lebonmarche/services/fetch_data.dart' as dataFetch;

class CommandsPage extends StatefulWidget {
  CommandsPage({Key key, this.userId, this.commandes})
      : super(key: key);

  final String userId;
  final List<Commande> commandes;

  @override
  State<StatefulWidget> createState() => new _CommandsPageState();
}

class _CommandsPageState extends State<CommandsPage> {

  @override
  Widget build(BuildContext context) {
     if(widget.commandes.isEmpty) {
      return new Expanded(
      child: new Container(
        decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.05), BlendMode.dstATop),
          image: AssetImage('assets/img/panierbio.jfif'),
          fit: BoxFit.cover,
        ),
      ),
        child: Center(
          child: Text("Vous n'avez effectué aucune commande", style: TextStyle(fontFamily: 'IndieFlower', fontWeight: FontWeight.bold, color: StyleColor.colorVert, fontSize: 22)),
        )
      ),
    );
    }
    else {
   return new Expanded(
      child: new Container(
        decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.05), BlendMode.dstATop),
          image: AssetImage('assets/img/panierbio.jfif'),
          fit: BoxFit.cover,
        ),
      ),
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 40.0),
          itemCount: widget.commandes.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: Key(widget.commandes[index].commandId),
              onDismissed: (direction) {
                setState(() {
                  dataFetch.deleteUserCommand(widget.commandes[index].commandId, widget.commandes[index].particulierId);
                  widget.commandes.removeAt(index);
                });
              },
              background: Container(
                margin: EdgeInsets.all(10.0),
                decoration: new BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.rectangle,
                    boxShadow: <BoxShadow>[
                      new BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10.0,
                        offset: new Offset(0.0, 8.0),
                      ),
                    ],
                    borderRadius: new BorderRadius.circular(8.0)),
              ),
              child: new DetailPageDismissible(commande: widget.commandes[index]),
            );
          },
        ),
      ),
    );
    }
  }

}