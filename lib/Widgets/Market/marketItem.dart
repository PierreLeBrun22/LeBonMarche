import 'package:flutter/material.dart';
import 'package:lebonmarche/model/marche.dart';
import 'package:lebonmarche/Widgets/Market/separator.dart';
import 'package:lebonmarche/Widgets/Market/detail_page.dart';
import 'package:lebonmarche/colors.dart';

class MarketItem extends StatefulWidget {
  final Marche marche;
  final String userId;
  final bool horizontal;

  MarketItem(this.marche, this.userId, {this.horizontal = true});

  MarketItem.vertical(this.marche, this.userId) : horizontal = false;

  @override
  State<StatefulWidget> createState() => new _MarketItemState();
}

class _MarketItemState extends State<MarketItem> {

//Methode qui sexeute avant l'affichage de la page
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final planetThumbnail = new Container(
      margin: new EdgeInsets.symmetric(vertical: 16.0),
      alignment: widget.horizontal
          ? FractionalOffset.centerLeft
          : FractionalOffset.center,
      child: new Hero(
        tag: "planet-hero-${widget.marche.name}",
        child: new CircleAvatar(
                  radius: 45.0,
                  backgroundColor: Colors.white,
                  backgroundImage: new NetworkImage(
          widget.marche.photoAgriculteur, 
        ),
        )
      ),
    );

    final planetCardContent = new Container(
      child: new Column(
        children: <Widget>[
          new Container(height: 4.0),
          new Padding(
            padding: new EdgeInsets.fromLTRB(widget.horizontal ? 76.0 : 16.0,
          widget.horizontal ? 16.0 : 42.0, 16.0, 16.0),
            child: new Column(
               crossAxisAlignment: widget.horizontal
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
              children: <Widget>[
                 new Text(widget.marche.name, style: TextStyle(
                           fontFamily: 'IndieFlower',
                          fontWeight: FontWeight.bold,
                          color: StyleColor.colorVert,
                          fontSize: 20.0,
                        ),),
          new Separator(),
          new Container(height: 10.0),
          new Column(
            children: <Widget>[
               new Text(widget.marche.location, style: TextStyle(
                           fontFamily: 'Dosis', fontSize: 16.0
                        ),),
            ],
          )
              ],
            ),
          ),
          new Image.network(
          widget.marche.photoCouverture, 
        ),    
        ],
      ),
    );

    final planetCard = new Container(
      child: planetCardContent,
      margin: widget.horizontal
          ? new EdgeInsets.only(left: 46.0)
          : new EdgeInsets.only(top: 72.0),
      decoration: new BoxDecoration(
          color: Colors.white,
          border: Border.all(color: StyleColor.colorOrange, width: 0.5),
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

    return new GestureDetector(
        onTap: widget.horizontal
            ? () => Navigator.of(context).push(
                  new PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>
                        new DetailPage(widget.marche, widget.userId),
                    transitionsBuilder: (context, animation, secondaryAnimation,
                            child) =>
                        new FadeTransition(opacity: animation, child: child),
                  ),
                )
            : null,
        child: new Container(
          margin: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 24.0,
          ),
          child: new Stack(
            children: <Widget>[
              planetCard,
              planetThumbnail,
            ],
          ),
        ));
  }
}
