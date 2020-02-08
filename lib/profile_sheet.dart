import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vision/main.dart';
import 'package:vision/profileInfo.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileSheet extends StatefulWidget {
  ProfileInfo profileInfo;

  ProfileSheet({this.profileInfo});

  @override
  State<StatefulWidget> createState() {
    return ProfileSheetState();
  }
}

class ProfileSheetState extends State<ProfileSheet> {
  bool editMode = false;
  Future<File> imageFile;

  @override
  Widget build(BuildContext context) {
    return editMode ? _editProfile() : _profile();
  }

  pickImageFromGallery(ImageSource source) {
    setState(() {
      imageFile = ImagePicker.pickImage(source: source);
    });
    if (imageFile != null) {
      imageDialog();
    }
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return Image.file(
            snapshot.data,
          );
        } else if (snapshot.error != null) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  void imageDialog() {
    Dialog imageDialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Wrap(
        children:<Widget>[
        Container(
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(15.0), child: showImage()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'CANCEL',
                ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                ),
                RaisedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'SAVE',
                ),
                ),
              ]),
          ],
        ),
      ),]),
    );
    showDialog(
        context: context, builder: (BuildContext context) => imageDialog);
  }

  Widget _editProfile() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(16),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    image: DecorationImage(
                      image: new NetworkImage(
                          MyApp.getURL() +
                              widget.profileInfo.imageUrl),
                      fit: BoxFit.cover,
                    ),
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(50.0)),
                    border: new Border.all(
                      color: Colors.greenAccent,
                      width: 1.0,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(50.0)),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    child: Icon(Icons.add_a_photo),
                  ),
                  onTap: () {
                    pickImageFromGallery(ImageSource.gallery);
                  },
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 16),
            child: TextFormField(
              initialValue: widget.profileInfo.name,
              decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  )),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 16),
            child: TextFormField(
              initialValue: widget.profileInfo.phNo,
              decoration: InputDecoration(
                  labelText: "Moble Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  )),
            ),
          ),
          Container(
              margin: EdgeInsets.fromLTRB(0, 0, 8, 8),
              child: Row(
                children: <Widget>[
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(right: 8),
                    child: FlatButton(
                      shape: Border.all(
                          color: Colors.green,
                          width: 1,
                          style: BorderStyle.solid),
                      child: Text('CANCEL'),
                      onPressed: () {
                        setState(() {
                          editMode = false;
                        });
                      },
                    ),
                  ),
                  RaisedButton(
                    child: Text('DONE'),
                    onPressed: () {
                      setState(() {
                        editMode = false;
                      });
                    },
                  ),
                ],
              )),
          Spacer(),
        ],
      ),
    );
  }

  Widget _profile() {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              color: Colors.green,
              image: DecorationImage(
                image: new NetworkImage(MyApp.getURL() +
                    widget.profileInfo.imageUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
              border: new Border.all(
                color: Colors.greenAccent,
                width: 1.0,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Row(children: <Widget>[
                          Text(
                            widget.profileInfo.name,
                          ),
                          Text(
                            '.' + widget.profileInfo.username,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ]),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Text(
                        widget.profileInfo.email,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _clearData();
              logout();
            },
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              setState(() {
                editMode = true;
              });
            },
          )
        ],
      ),
    );
  }

  void _clearData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void logout() {
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/login');
  }
}
