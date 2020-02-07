import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vision/chart_data.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

import 'package:vision/main.dart';

class AnalyticsChart extends StatefulWidget {
  List<ChartData> data;
  String yText,email,content;
  int viewPortNo;
  Function fetchAnalytics;
  List<dynamic> cameraList;
  BuildContext context;

  AnalyticsChart({@required this.data,@required this.yText, @required this.viewPortNo, @required this.email,@required this.fetchAnalytics,@required this.cameraList, @required this.content, this.context});
@override
  State<StatefulWidget> createState() {
    return AnalyticsState();
  }

}

class AnalyticsState extends State<AnalyticsChart>{
  
  String interval,cam,fromDate,toDate;
  List<String> cameras = [];

  @override
  void initState() {
    super.initState();
    interval = "Last 7 days";
    cam = "All Cameras";
    fromDate = DateTime.now().subtract(Duration(days: 7)).toString().substring(0,10);
    toDate  = DateTime.now().toString().substring(0,10);
    print(widget.yText);
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
  

  Widget chartControls(){
    print("CameraList: "+cameras.toString());
    return Container(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(children:<Widget>[
            Row(
            children: <Widget>[
              Expanded(
                flex: 1,
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
                    if(widget.content == "user") {
                      widget.fetchAnalytics(interval, s);
                    }else{
                      widget.fetchAnalytics(s,fromDate,toDate);
                    }
                  setState(() {
                    cam = s;
                  });
                },
              ),),),
              chooseControl(),
            ],
          ),
          ]),
        );
  }

  Widget chooseControl(){
    if(widget.content == "user"){
      return Expanded(
        flex: 1,
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
          ),),);
    }
    return Expanded(
      flex: 2,
      child:Container(
        margin: EdgeInsets.all(4),
        child: Row(
          children: <Widget>[
            Expanded(
            child: Card(
              child: Container(
                padding :EdgeInsets.all(4),
                child: GestureDetector(
                  onTap: (){
                    datePicker("From: ");
                  },
                  child: Text("From: "+fromDate),
                ),
              ),
            ),),
            Expanded(
            child: Card(
              child: Container(
                padding :EdgeInsets.all(4),
                child: GestureDetector(
                  onTap: (){
                    datePicker("To: ");
                  },
                  child: Text("To: "+toDate),
                ),
              ),
            ),),
          ],
        )

      ),);
  }

  void datePicker(String type) async{
    DateTime selectedDate = await showDatePicker(
      context: widget.context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );
    if(selectedDate != null) {
      setState(() {
        if (type == "From: ") {
          fromDate = selectedDate.toString().substring(0,10);
        } else {
          toDate = selectedDate.toString().substring(0,10);
        }
      });
      widget.fetchAnalytics(cam,fromDate,toDate);
    }
    print("Date: "+selectedDate.toString());
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
