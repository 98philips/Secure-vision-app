import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vision/home.dart';
import 'package:vision/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyAppState();
  }
}

class MyAppState extends State<MyApp>{
  final List<Widget> screen = [Home(),Login()];
  int pos = 0;
  // This widget is the root of your application.

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkLogin();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Vision',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          brightness: Brightness.dark
        ),
        home: screen.elementAt(pos),
        routes: {
          '/home': (BuildContext context) => Home(),
          '/login': (BuildContext context) => Login(),
        },
    );
  }
  void _checkLogin() async{
    final prefs = await SharedPreferences.getInstance();
    String responseString = prefs.getString('profile_info');

    if(responseString != null){
      pos = 0;
    }else{
      pos = 1;
    }
  }

}