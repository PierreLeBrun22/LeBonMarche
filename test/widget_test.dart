import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lebonmarche/model/marche.dart';
import 'package:image_test_utils/image_test_utils.dart';
import 'package:lebonmarche/Widgets/Market/MarketParticulier.dart';

List<Marche> marches = [
  const Marche(
    marcheId: "mID",
    name: "Name",
    location: "Location",
    description: "Description",
    agriculteurId: "aID",
    photoCouverture: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQBir2UKxyY9k2NleKRP_crBXqrctxzEIWbOgY0igp17x1oXhJi&usqp=CAU",
    photoAgriculteur: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQBir2UKxyY9k2NleKRP_crBXqrctxzEIWbOgY0igp17x1oXhJi&usqp=CAU",
    jourDelai: 2,
  ),
];

void main() {
  //Test functionnal
  testWidgets('Succes if the marches are displayed', (WidgetTester tester) async {
    provideMockedNetworkImages(() async {
      
      Widget testWidget = new MediaQuery(
          data: new MediaQueryData(),
          child: new MaterialApp(
              home: new Scaffold(
                  body: new Stack(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.only(top: 60.0),
                child: new Column(children: <Widget>[
                  new MarketParticulier(userId: "sdfsdfsdfsdfsfd", marches: marches)
                ]),
              ),
            ],
          ))));

      await tester.pumpWidget(testWidget);

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Location'), findsOneWidget);

      /// No crashes.
    });
  });
}
