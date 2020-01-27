import 'package:flutter/material.dart';
import 'package:vision/chart_data.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AnalyticsChart extends StatefulWidget {
  List<ChartData> data;
  AnalyticsChart({@required this.data});
@override
  State<StatefulWidget> createState() {
    return AnalyticsState();
  }
}

class AnalyticsState extends State<AnalyticsChart>{
  
  String interval,cam;

  @override
  void initState() {
    super.initState();
    interval = "Last Week";
    cam = "All Cameras";
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
        chart(series),
      ],
    ),
    );
  }

  Widget chartControls(){
    return Container(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            children: <Widget>[
              Expanded(
                child:Container(
                  margin: EdgeInsets.all(4),
                child: DropdownButton<String>(
                  isDense: true,
                  value: cam,
                items: <String>['All Cameras','Camera 1', 'Camera 2', 'Camera 3'].map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (String s) {
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
                items: <String>['Last Week', 'Last Month', 'Custom'].map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (String s) {
                  setState(() {
                    interval = s;
                  });
                },
              ),),)
            ],
          ),
        );
  }

  Widget chart(List<charts.Series<ChartData, String>> series){
    return Container(
          height: 300,
          padding: EdgeInsets.all(16),
        child: charts.BarChart(
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
          ),
          primaryMeasureAxis: new charts.NumericAxisSpec(
            renderSpec: new charts.GridlineRendererSpec(
              labelStyle:
                  new charts.TextStyleSpec(color: charts.MaterialPalette.white),
            ),
          ),
        ),
    );
  }
}
