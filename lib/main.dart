import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FashionNet',
      theme: ThemeData(
        fontFamily: 'QuickSand',
        primarySwatch: Colors.indigo,
        accentColor: Colors.orange,
      ),
      home: Container(),
    );
  }
}
