import 'package:flutter/material.dart';
import 'package:lebonmarche/services/authentication.dart';
import 'package:lebonmarche/services/root_page.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Le Bon Marché',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: new RootPage(auth: new Auth()));
  }
}
