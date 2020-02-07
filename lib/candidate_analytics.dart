import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vision/analytics_chart.dart';
import 'package:vision/candidate_class.dart';
import 'package:vision/chart_data.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'package:vision/main.dart';
import 'dart:convert' show json;

import 'package:vision/profileInfo.dart';

class CandidateAnalytics extends StatefulWidget {
  final Candidate candidate;
  final List<Candidate> candidateList;
  final int index;
  final List<dynamic> cameraList;
  CandidateAnalytics(this.candidate, this.candidateList, this.index, this.cameraList);

  @override
  State<StatefulWidget> createState() {
    return CandidateState();
  }
}

class CandidateState extends State<CandidateAnalytics> {
  List<List<ChartData>> data = [];
  PageController pageController;
  Candidate candidate;
  ProfileInfo profileInfo;
  int currentIndex;
  AnalyticsChart analyticsChart;
  List<String> intervals=[],cams=[];

  @override
  void initState() {
    super.initState();
    candidate = widget.candidate;
    pageController = PageController(
      initialPage: widget.index,
      viewportFraction: 0.92,
    );
    for(int i=0;i<widget.candidateList.length;i++){
      data.add([]);
      intervals.add("Last 7 days");
      cams.add("All Cameras");
    }
    _getPref();
    currentIndex = widget.index;
    print("Candidates Camera List"+widget.cameraList.toString());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
          margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
          child: PageView.builder(
              controller: pageController,
              itemCount: widget.candidateList.length,
              onPageChanged: (int index) {
                setState(() {
                  candidate = widget.candidateList.elementAt(index);
                  currentIndex = index;
                });
                fetchAnalytics(intervals[index],cams[index]);
              },
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return buildItem(data.elementAt(index));
              })),

    ));
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
    fetchAnalytics("Last 7 days","All Cameras");
  }

  void logout() {
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/login');
  }

  void fetchAnalytics(String type,String camera) async{
    var response;
//    print("Called: "+type);
//    print("email: "+candidate.email);
//    print("Camera: "+camera);
    intervals[currentIndex] = type;
    cams[currentIndex] = camera;
    print("API Key: "+profileInfo.apiKey);

    try{
      response = await http.post(
          MyApp.getURL() +'/api/get_user_analytics/',
          body: {'email': candidate.email,'type':type,'api_key':profileInfo.apiKey,'camera_obj':camera});
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        print(responseBody.toString());
        print("Status: "+responseBody['status'].toString());
        if(responseBody['status']== 200){
          List<dynamic> labels = responseBody['data'][0];
          List<dynamic> values = responseBody['data'][1];
          setData(labels, values);
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
      data[currentIndex] = newData;
    });
  }

  Widget topBar() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
        width: 0.2,
        color: Colors.greenAccent,
      ))),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Container(
            width: 40.0,
            height: 40.0,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 4),
                      child:
                          Text(candidate.name, style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Text(
                      candidate.email,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(List<ChartData> data) {
    analyticsChart = AnalyticsChart(
      data: data,
      yText: "Presence Count",
      viewPortNo: 7,
      email: candidate.email,
      fetchAnalytics: fetchAnalytics,
      cameraList: widget.cameraList,
      content: "user",
    );
    return Card(
        color: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
            margin: EdgeInsets.all(16),
            child: Column(children: <Widget>[
              analyticsChart,
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 16),
                child:Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: 15,
                    itemBuilder: (BuildContext context, int index) {
                      return _listItemTile();
                    },
                  ),
                ),
              ),),
              topBar(),
            ])));
  }

  Widget _listItemTile() {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        width: 0.2,
        color: Colors.greenAccent,
      ))),
      child: Row(
        children: <Widget>[
          Container(
            child: Text(
              "Friday",
            ),
          ),
          Spacer(),
          Text(
            "13:15",
          ),
        ],
      ),
    );
  }
}
