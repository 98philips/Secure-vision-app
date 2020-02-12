import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vision/analytics_chart.dart';
import 'package:vision/candidate_analytics.dart';
import 'package:vision/candidate_class.dart';
import 'package:vision/chart_data.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:vision/main.dart';
import 'package:vision/overall_candidate.dart';
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
  List<Candidate> candidateList;
  List<Candidate> oldCandidateList = [];
  List<OverallCandidate> overallCandidateList;
  List<dynamic> cameraList = [];
  bool showSearchButton=false,showSearchBar=false;
  List<ChartData> data = [];
  List<Widget> _widgetOptions;
  String _title;
  List<String> _titleList = ["Overall Analytics", "Candidate Analytics"];
  ProfileInfo profileInfo;
  BuildContext buildContext;
  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    _title = _titleList.elementAt(_selectedIndex);
    showSearchBar = false;
    showSearchButton = false;
    candidateList = [];
    overallCandidateList = [];
    _getPref();
  }

  void _getData() async{
    print("ORGID:"+profileInfo.orgId.toString());
    try{
    var response = await http.post(
        MyApp.getURL() +'/api/get_candidates/',
        body: {'api_key': profileInfo.apiKey});
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
      setState(() {
        cameraList = responseBody['camera_list'];
      });
      //print("CameraList: "+cameraList[0].toString());
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
          print("hhhhh:   "+responseBody['data'].toString());

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

  void fetchAnalytics(String camera, String fromDate, String toDate) async{
    var response;
    try{
      response = await http.post(
          MyApp.getURL() +'/api/get_overall_analytics/',
          body: {'api_key':profileInfo.apiKey,'camera_id':camera,'type': "All",'from_date':fromDate,'to_date':toDate});
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        print(responseBody.toString());
        print("Status: "+responseBody['status'].toString());
        if(responseBody['status']== 200){
          List<dynamic> labels = responseBody['time_list'];
          List<dynamic> values = responseBody['count_list'];
          setData(labels, values);
          List<dynamic> dataList = responseBody['data'];
          List<OverallCandidate> oc = [];
          for(dynamic i in dataList){

              oc.add(OverallCandidate.fromJson(i));
          }
          setState(() {
            overallCandidateList = oc;
          });
          print("DATA: "+responseBody['data'][0]['email'].toString());
        }else{
          Fluttertoast.showToast(
            msg: 'Something went wrong please check your network connection.',
            toastLength: Toast.LENGTH_SHORT,
          );
        }
      }
    }catch(e){
      Fluttertoast.showToast(
        msg: 'Something went wrong!',
        toastLength: Toast.LENGTH_SHORT,
      );
      print(e.toString());
    }
  }


  void changePic(String url){
    setState(() {
      profileInfo.imageUrl = url;
    });

  }

  void setData(List<dynamic> labels,List<dynamic> values){
    List<ChartData> newData =[];
    for( int i = 0 ; i < labels.length ; i++ ){
      ChartData chd = ChartData(
        x: labels.elementAt(i).toString(),
        y: values.elementAt(i),
        barColor: charts.ColorUtil.fromDartColor(Colors.green),
      );
      newData.add(chd);
    }
    setState(() {
      data = newData;
    });
  }
  @override
  Widget build(BuildContext context) {
    buildContext = context;
    _widgetOptions = <Widget>[
      Column(
        children: <Widget>[
          AnalyticsChart(
            data: data,
            yText: "No. of people",
            viewPortNo: 7,
            email: profileInfo.email,
            cameraList: cameraList,
            fetchAnalytics: fetchAnalytics,
            content: "overall",
            context: context,
          ),
        SizedBox(
          height: 200,
          child:ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: overallCandidateList.length,
            itemBuilder: (BuildContext context, int index) {
              return _overallListItemTile(overallCandidateList.elementAt(index));
            },
          ),),
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
            if( _selectedIndex == 1) {
              showSearchButton = true;
            }else{
              showSearchButton = false;
            }
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
      return Expanded(
        child:Container(
            margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration.collapsed(
                hintText: 'Search'
            ),
              onChanged: (String text)=>search(text),
            )
          ),);
    }
    return Expanded(child:Text(_title));
  }



  Widget candidateTile(Candidate candidate, BuildContext context, int index) {
    print("Candidate Tile: "+cameraList.toString());
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CandidateAnalytics(candidate, candidateList, index, cameraList))),
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

  Widget _overallListItemTile(OverallCandidate candidate) {
    print("IN: "+candidate.email);
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
            ),
            Text(
              candidate.count,
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16),
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
    print(profileInfo.apiKey);
    String fromDate = DateTime.now().subtract(Duration(days: 7)).toString().substring(0,10);
    String toDate  = DateTime.now().toString().substring(0,10);
    fetchAnalytics("All Cameras",fromDate,toDate);
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
          return SafeArea(child: ProfileSheet(profileInfo: profileInfo,buildContext: buildContext,changePic: changePic));
        });
  }


}
