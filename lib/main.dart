import 'package:fluictionary/MyHomePage.dart';
import 'package:fluictionary/pages/DictionaryPage/DictionaryTopPage.dart';
import 'package:fluictionary/pages/CardPage/cards.dart';
import 'package:flutter/material.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}
