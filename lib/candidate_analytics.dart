import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vision/analytics_chart.dart';
import 'package:vision/candidate_class.dart';
import 'package:vision/chart_data.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'package:vision/main.dart';
import 'dart:convert' show json;

class CandidateAnalytics extends StatefulWidget {
  final Candidate candidate;
  final List<Candidate> candidateList;
  final int index;
  CandidateAnalytics(this.candidate, this.candidateList, this.index);

  @override
  State<StatefulWidget> createState() {
    return CandidateState();
  }
}

class CandidateState extends State<CandidateAnalytics> {
  List<ChartData> data;
  PageController pageController;
  Candidate candidate;

  @override
  void initState() {
    super.initState();
    data = [];
    candidate = widget.candidate;
    pageController = PageController(
      initialPage: widget.index,
      viewportFraction: 0.92,
    );
    fetchAnalytics();

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
                });
                //fetchAnalytics();
              },
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return buildItem(data);
              })),

    ));
  }

  void fetchAnalytics() async{
    var response;
    print("email: "+candidate.email);
    try{
      response = await http.post(
          MyApp.getURL() +'/api/get_user_analytics/',
          body: {'email': candidate.email});
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
      data = newData;
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
    return Card(
        color: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
            margin: EdgeInsets.all(16),
            child: Column(children: <Widget>[
              AnalyticsChart(
                data: data,
                yText: "Presence Count",
                viewPortNo: 7,
                email: candidate.email,
              ),
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
