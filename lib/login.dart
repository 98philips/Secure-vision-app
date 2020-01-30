import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:vision/profileInfo.dart';
import 'dart:convert' show json;

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginState();
  }
}

class LoginState extends State<Login> {
  String username, password;
  ProfileInfo profileInfo;
  bool loader;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    username = "";
    password = "";
    profileInfo = null;
    loader = false;
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Spacer(),
            Text(
              "Login",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
              textAlign: TextAlign.left,
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              child: Text(
                "Please sign to continue",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white54),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 32),
                child: TextField(
                  onChanged: (String text) {
                    setState(() {
                      username = text;
                    });
                  },
                  decoration: InputDecoration(
                    icon: Icon(Icons.mail_outline),
                    labelText: 'USERNAME',
                  ),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Container(
                margin: EdgeInsets.only(top: 16),
                child: TextField(
                  onChanged: (String text) {
                    setState(() {
                      password = text;
                    });
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    icon: Icon(Icons.lock_outline),
                    labelText: 'PASSWORD',
                  ),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Container(
              margin: EdgeInsets.only(top: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Card(
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    child: FlatButton(
                      onPressed: () async{
                        setState(() {
                          loader = true;
                        });
                        if (await _auth(username, password)) {
                          login();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "LOGIN",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            decide(loader),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget decide(bool loader){
    if(loader){
      return Container(
        height: 20,
        width: 20,
        margin: EdgeInsets.only(left: 4),
        child:CircularProgressIndicator()
        );
    }else{
      return Icon(Icons.arrow_forward);
    }
  }

  Future<bool> _auth(String username, String password) async{
    profileInfo = await fetchPost(username, password);
    print(username + " " + password);
    if(profileInfo != null){
      return true;
    }
    return false;
  }

  void login(){
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/home');
  }

  Future<ProfileInfo> fetchPost(String username, String password) async {
    print(username);
    var response;
    try{
    response = await http.post(
        'http://secure.pythonanywhere.com/api/app_login/',
        body: {'username': username, 'password': password});
    }catch(e){
      Fluttertoast.showToast(
          msg: 'Something went wrong!',
          toastLength: Toast.LENGTH_SHORT,
        );
        setState(() {
          loader = false;
        });
        return null;
    }
    setState(() {
          loader = false;
        });
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = json.decode(response.body);
      print(responseBody.toString());
      print("Status: "+responseBody['status'].toString());
      if(responseBody['status']== 200){
        Fluttertoast.showToast(
          msg: 'Successfully Logged in',
          toastLength: Toast.LENGTH_SHORT,
        );
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('profile_info', responseBody['data']);
        return ProfileInfo.fromJson(responseBody['data']);
      }else{
        Fluttertoast.showToast(
          msg: 'Invalid Username or Password',
          toastLength: Toast.LENGTH_SHORT,
        );
      }
      // If server returns an OK response, parse the JSON.
      
    } else {
      Fluttertoast.showToast(
          msg: 'Something went wrong!',
          toastLength: Toast.LENGTH_SHORT,
        );
      // If that response was not OK, throw an error.
      print("error");
      // throw Exception('Failed to load post');
    }
    return null;
  }
}
