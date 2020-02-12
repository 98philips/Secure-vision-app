import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vision/home.dart';
import 'package:vision/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  static String url = "http://vision.sreeraj.codes";
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }

  static String getURL(){
    return url;
  }
}

class MyAppState extends State<MyApp>{
  final List<Widget> screen = [Home(),Login()];
  int pos = 0;

  @override
  void initState() {
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