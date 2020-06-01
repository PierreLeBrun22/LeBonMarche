import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lebonmarche/model/service.dart';
import 'package:image_test_utils/image_test_utils.dart';

List<Service> services = [
  const Service(
    name: "Daycare",
    location: "Lannion",
    description: "A coupon for 2 hours",
    image:
        "https://raw.githubusercontent.com/PierreLeBrun22/MyServices/master/assets/img/baby.png",
    partners: ["Daycare Lannion", "Baby Way"],
    prix: 20,
    statut: "Both",
    serviceId: "-LeHAyX79q_HBaW-s9xQ",
  ),
];

void main() {
  //Test functionnal
  testWidgets('Succes if the services are displayed', (WidgetTester tester) async {
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
                ]),
              ),
            ],
          ))));

      await tester.pumpWidget(testWidget);

      expect(find.text('Daycare'), findsOneWidget);
      expect(find.text('Statut: Both'), findsOneWidget);
      expect(find.text("Prix TVA: "+(20+20*0.2).toString()+" €"), findsOneWidget);

      /// No crashes.
    });
  });
}
