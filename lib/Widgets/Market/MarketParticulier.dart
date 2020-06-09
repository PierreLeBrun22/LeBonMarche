import 'package:flutter/material.dart';
import 'package:lebonmarche/Widgets/Market/marketItem.dart';
import 'package:lebonmarche/model/marche.dart';


class MarketParticulier extends StatefulWidget {
  MarketParticulier({Key key, this.userId, this.marches})
      : super(key: key);

  final String userId;
  final List<Marche> marches;

  @override
  State<StatefulWidget> createState() => new _MarketParticulierState();
}

class _MarketParticulierState extends State<MarketParticulier> {

  @override
  Widget build(BuildContext context) {
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
        child: new CustomScrollView(
          scrollDirection: Axis.vertical,
          shrinkWrap: false,
          slivers: <Widget>[
            new SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              sliver: new SliverList(
                delegate: new SliverChildBuilderDelegate(
                    (context, index) => new MarketItem(widget.marches[index], widget.userId),
                  childCount: widget.marches.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}