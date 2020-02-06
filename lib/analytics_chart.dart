import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vision/chart_data.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

import 'package:vision/main.dart';

class AnalyticsChart extends StatefulWidget {
  List<ChartData> data;
  String yText,email;
  int viewPortNo;
  Function fetchAnalytics;
  List<dynamic> cameraList;

  AnalyticsChart({@required this.data,@required this.yText, @required this.viewPortNo, @required this.email,@required this.fetchAnalytics,@required this.cameraList});
@override
  State<StatefulWidget> createState() {
    return AnalyticsState();
  }

}

class AnalyticsState extends State<AnalyticsChart>{
  
  String interval,cam;
  List<String> cameras = [];

  @override
  void initState() {
    super.initState();
    interval = "Last 7 days";
    cam = "All Cameras";
    print(widget.yText);
//    if( widget.fetchAnalytics != null){
//      widget.fetchAnalytics(interval,cam);
//      print("Sadhanam ind");
//    }else{
//      print("Sadhanam Illa");
//    }
    //sendRequest(interval);
  }

  @override
  Widget build(BuildContext context) {


    print(widget.data.length);
    List<charts.Series<ChartData, String>> series = [
      charts.Series(
          id: "Analytics",
          data: widget.data,
          domainFn: (ChartData series, _) => series.x,
          measureFn: (ChartData series, _) => series.y,
          colorFn: (ChartData series, _) => series.barColor)
    ];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
      child:Column(
      children: <Widget>[
        chartControls(),
        Container(

          child: Text(widget.yText),
        ),
        chart(series),
      ],
    ),
    );
  }

  void sendRequest(String type) async{
    var response;
    print("sendRequest");
    try{
      print("here before if:::");
      response = await http.post(
          MyApp.getURL() +'/api/get_user_analytics/',
          body: {'email': widget.email,'type':type});
      print(type);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        print(responseBody.toString());
        print("Status: "+responseBody['status'].toString());
        if(responseBody['status']== 200){
          List<dynamic> labels = responseBody['data'][0];
          List<dynamic> values = responseBody['data'][1];
          print("In try");
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
    print("Here");
    for( int i = 0 ; i < labels.length ; i++ ){
      ChartData chd = ChartData(
        x: labels.elementAt(i).toString(),
        y: values.elementAt(i),
        barColor: charts.ColorUtil.fromDartColor(Colors.green),
      );
      newData.add(chd);
    }
    setState(() {
      widget.data = newData;
    });
  }

  Widget chartControls(){
    print("CameraList: "+cameras.toString());
    return Container(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(children:<Widget>[
            Row(
            children: <Widget>[
              Expanded(
                child:Container(
                  margin: EdgeInsets.all(4),
                child: DropdownButton<String>(
                  isDense: true,
                  value: cam,
                items: widget.cameraList.map((dynamic value) {
                  return new DropdownMenuItem<String>(
                    value: value.toString(),
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (String s) {
                  widget.fetchAnalytics(interval,s);
                  setState(() {
                    cam = s;
                  });
                },
              ),),),
              Expanded(
                child:Container(
                  margin: EdgeInsets.all(4),
                child: DropdownButton<String>(
                  isDense: true,
                  value: interval,
                items: <String>['Last 8 hrs', 'Last 7 days', 'Last 6 months'].map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (String s) {
                    widget.fetchAnalytics(s,cam);
                  setState(() {
                    interval = s;
                  });
                },
              ),),)
            ],
          ),
          ]),
        );
  }

  Widget chart(List<charts.Series<ChartData, String>> series){
    return Container(
          height: 300,
          padding: EdgeInsets.all(16),
        child: charts.BarChart (
          series,
          animate: true,
          defaultRenderer: new charts.BarRendererConfig(
              cornerStrategy: const charts.ConstCornerStrategy(30)),
          domainAxis: new charts.OrdinalAxisSpec(
            renderSpec: new charts.SmallTickRendererSpec(
              minimumPaddingBetweenLabelsPx: 0,
              labelStyle:
                  new charts.TextStyleSpec(color: charts.MaterialPalette.white),
            ),
            viewport: charts.OrdinalViewport('viewPort',widget.viewPortNo),
          ),
          primaryMeasureAxis: new charts.NumericAxisSpec(
            renderSpec: new charts.GridlineRendererSpec(
              labelStyle:
                  new charts.TextStyleSpec(color: charts.MaterialPalette.white),
            ),
          ),
          behaviors: [
            charts.SlidingViewport(),
            charts.PanAndZoomBehavior(),
          ],
        ),
    );
  }

  void getData(){
    widget.fetchAnalytics(interval,cam);
  }


}
