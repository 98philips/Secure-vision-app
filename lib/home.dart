import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vision/analytics_chart.dart';
import 'package:vision/candidate_analytics.dart';
import 'package:vision/candidate_class.dart';
import 'package:vision/chart_data.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:vision/main.dart';
import 'package:vision/profileInfo.dart';
import 'package:vision/profile_sheet.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeState();
  }
}

class HomeState extends State<Home> {
  int _selectedIndex;
  List<Candidate> candidateList ;
  List<Candidate> oldCandidateList = [];
  bool showSearchButton=false,showSearchBar=false;
  final List<ChartData> data = [
    ChartData(
      x: "Sun",
      y: 88,
      barColor: charts.ColorUtil.fromDartColor(Colors.green),
    ),
    ChartData(
      x: "Mon",
      y: 38,
      barColor: charts.ColorUtil.fromDartColor(Colors.green),
    ),
    ChartData(
      x: "Tue",
      y: 45,
      barColor: charts.ColorUtil.fromDartColor(Colors.green),
    ),
    ChartData(
      x: "Wed",
      y: 45,
      barColor: charts.ColorUtil.fromDartColor(Colors.green),
    ),
    ChartData(
      x: "Thu",
      y: 80,
      barColor: charts.ColorUtil.fromDartColor(Colors.green),
    ),
    ChartData(
      x: "Fri",
      y: 120,
      barColor: charts.ColorUtil.fromDartColor(Colors.green),
    ),
    ChartData(
      x: "Sat",
      y: 50,
      barColor: charts.ColorUtil.fromDartColor(Colors.green),
    ),
  ];
  List<Widget> _widgetOptions;
  String _title;
  List<String> _titleList = ["Overall Analytics", "Candidate Analytics"];
  ProfileInfo profileInfo;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    _title = _titleList.elementAt(_selectedIndex);
    showSearchBar = false;
    showSearchButton = false;
    candidateList = [];
    _getPref();
  }

  void _getData() async{
    print("ORGID:"+profileInfo.orgId.toString());
    try{
    var response = await http.post(
        MyApp.getURL() +'/api/get_candidates/',
        body: {'org_id': profileInfo.orgId.toString()});
        print(response.body);
        if(response.statusCode == 200){
          prepareData(response.body);
        }else{
          Fluttertoast.showToast(
            msg: 'Invalid Username or Password',
            toastLength: Toast.LENGTH_SHORT,
          );
        }
    }catch(e){
      Fluttertoast.showToast(
          msg: 'Something went wrong!',
          toastLength: Toast.LENGTH_SHORT,
        );
        print(e.toString());
    }

  }

  void prepareData(String responseString){
      Map<String, dynamic> responseBody = json.decode(responseString);
      print(responseBody.toString());
      print("Status: "+responseBody['status'].toString());
      if(responseBody['status']== 200){
        Fluttertoast.showToast(
          msg: 'Success',
          toastLength: Toast.LENGTH_SHORT,
        );
        List<dynamic> l = responseBody['data'];
        for(dynamic i in l){
          setState(() {
            candidateList.add(Candidate.fromJson(i));
          });

        }
        oldCandidateList = candidateList;
        print(candidateList[0].email);


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

  }

  @override
  Widget build(BuildContext context) {
    _widgetOptions = <Widget>[
      Column(
        children: <Widget>[
          AnalyticsChart(
            data: data,
            yText: "No. of people",
          ),
          Spacer(
            flex: 1,
          )
        ],
      ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: candidateList.length,
            itemBuilder: (BuildContext context, int index) {
              return candidateTile(
                  candidateList.elementAt(index), context, index);
            },
          ),
    ];
    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: <Widget>[
          getSearchBar(showSearchBar),
          getSearchButton(showSearchButton),
          GestureDetector(
            onTap: () {
              _settingModalBottomSheet(context);
            },
            child: Container(
              width: 30.0,
              height: 30.0,
              decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                  image: new NetworkImage(MyApp.getURL() +
                      profileInfo.imageUrl),
                  fit: BoxFit.cover,
                ),
                borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
                border: new Border.all(
                  color: Colors.greenAccent,
                  width: 1.0,
                ),
              ),
            ),
          ),
        ],
      )),
      body: Container(
        padding: EdgeInsets.all(8),
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Overall'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle),
            title: Text('Candidate'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
            _title = _titleList.elementAt(_selectedIndex);
            showSearchButton = !showSearchButton;
            if(index == 0){
              showSearchBar = false;
            }
            candidateList = oldCandidateList;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.all_inclusive),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget getSearchButton(bool flag){
    if(flag){
      return Container(
            margin: EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {
                setState(() {
                  showSearchBar = !showSearchBar;
                  candidateList = oldCandidateList;
                });
              },
              icon: showSearchBar ? Icon(Icons.close) : Icon(Icons.search)
            ),
          );
    }
    return Container();
  }

  Widget getSearchBar(bool flag){
    if(flag){
      return Expanded(child:Container(
            margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Search",
              ),
              onChanged: (String text)=>search(text),
            )
          ),);
    }
    return Expanded(child:Text(_title));
  }



  Widget candidateTile(Candidate candidate, BuildContext context, int index) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CandidateAnalytics(candidate, candidateList, index))),
      child: _listItemTile(candidate),
    );
  }

  void search(String key) {
    key = key.toLowerCase();
    List<Candidate> searchList = [];
    oldCandidateList.forEach((Candidate c) {
      if (c.name.toLowerCase().contains(key)) {
        searchList.add(c);
      }
    });
    if (key == "") {
      searchList = oldCandidateList;
    }
    setState(() {
      candidateList = searchList;
    });
  }

  Widget _listItemTile(Candidate candidate) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                  image: new NetworkImage(MyApp.getURL()+candidate.imageUrl),
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
                          child: Text(
                            candidate.name,
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Text(
                          candidate.email,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  

  

  void _getPref() async {
    final prefs = await SharedPreferences.getInstance();
    String responseString = prefs.getString('profile_info');
    if (responseString == null) {
      logout();
    }
    setState(() {
      profileInfo = ProfileInfo.fromJson(responseString);
    });
    print("name object: " + profileInfo.username);
    _getData();
  }

  void logout() {
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/login');
  }
  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
      isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(child: ProfileSheet(profileInfo: profileInfo));
        });
  }

  
}
