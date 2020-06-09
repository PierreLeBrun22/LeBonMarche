import 'package:flutter/material.dart';

class Style {
  static final titreStyle = const TextStyle(
    fontFamily: 'IndieFlower',
    fontSize: 20.0,
    fontWeight: FontWeight.w400
  );
  static final texteStyle = const TextStyle(
    fontFamily: 'Dosis'
  );
  static final baseTextStyle = const TextStyle(
    fontFamily: 'Poppins'
  );
  static final smallTextStyle = commonTextStyle.copyWith(
    fontSize: 8.0,
  );
  static final commonTextStyle = baseTextStyle.copyWith(
      color: Color(0xFF4B4954),
    fontSize: 14.0,
      fontWeight: FontWeight.w400
  );
  static final locationTextStyle = baseTextStyle.copyWith(
      color: Colors.white,
    fontSize: 14.0,
      fontWeight: FontWeight.w400
  );
  static final titleTextStyle = baseTextStyle.copyWith(
    color: Colors.white,
    fontSize: 25.0,
    fontFamily: 'Satisfy',
  );
  static final headerTextStyle = baseTextStyle.copyWith(
    color: Color(0xFF4B4954),
    fontSize: 20.0,
    fontWeight: FontWeight.w400
  );
}