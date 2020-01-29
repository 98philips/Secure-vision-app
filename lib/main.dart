import 'package:flutter/material.dart';
import 'file:///Users/philippaul/dev/flutter_projects/vision/lib/home.dart';
import 'package:vision/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          brightness: Brightness.dark
        ),
        home: Login()
    );
  }
}