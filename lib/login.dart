import 'package:flutter/material.dart';
import 'package:vision/home.dart';
class Login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginState();
  }
}

class LoginState extends State<Login>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(32),
        child:Column(
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
              child:Text(
              "Please sign to continue",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white54
              ),
              textAlign: TextAlign.left,
            ),),
            Container(
              margin: EdgeInsets.only(top: 32),
              child:TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.mail_outline),
                  labelText: 'EMAIL',
                ),
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ),
            Container(
              margin: EdgeInsets.only(top: 16),
              child:TextField(
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock_outline),
                  labelText: 'PASSWORD',
                ),
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ),
            Container(
              margin: EdgeInsets.only(top: 24),
              child:Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Card(
                  color: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)
                  ),
                  child:FlatButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => Home(),
                    ));
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 8,right: 8),
                    child: Row(
                      children: <Widget>[
                        Text("LOGIN",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),),
                        Icon(Icons.arrow_forward)
                      ],
                      ),
                  ),
                ),)
              ],
            ),),
          Spacer(),
          ],
        ),
      ),)
    ;
  }

}