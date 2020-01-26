import 'package:flutter/material.dart';
import 'package:vision/chart_data.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AnalyticsChart extends StatelessWidget {
  final List<ChartData> data;

  AnalyticsChart({@required this.data});

  @override
  Widget build(BuildContext context) {
    print(data.length);
    List<charts.Series<ChartData, String>> series = [
      charts.Series(
          id: "Analytics",
          data: data,
          domainFn: (ChartData series, _) => series.x,
          measureFn: (ChartData series, _) => series.y,
          colorFn: (ChartData series, _) => series.barColor)
    ];

    return Container(
      padding: EdgeInsets.all(16),
      child: Card(
        child:Container(
          height: 400,
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
      ),),
    );
  }
}
