import 'package:flutter/material.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    username = "";
    password = "";
    profileInfo = null;
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
                            Icon(Icons.arrow_forward)
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
    final response = await http.post(
        'http://secure.pythonanywhere.com/api/app_login/',
        body: {'username': username, 'password': password});


    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = json.decode(response.body);
      print(responseBody.toString());
      print("Status: "+responseBody['status'].toString());
      if(responseBody['status']== 200){
        final snackBar = SnackBar(content: Text('Successfully Logged in'));
        Scaffold.of(context).showSnackBar(snackBar);
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('profile_info', responseBody['data']);
        return ProfileInfo.fromJson(responseBody['data']);
      }else{
        final snackBar = SnackBar(content: Text('Invalid Username or Password'));
        Scaffold.of(context).showSnackBar(snackBar);
      }
      // If server returns an OK response, parse the JSON.
      
    } else {
      final snackBar = SnackBar(content: Text('Something went wrong!'));

      Scaffold.of(context).showSnackBar(snackBar);

      // If that response was not OK, throw an error.
      print("error");
      // throw Exception('Failed to load post');
    }
    return null;
  }
}
