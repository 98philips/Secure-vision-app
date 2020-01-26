import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';

class ChartData {
  final String x;
  final int y;
  final charts.Color barColor;

  ChartData(
      {@required this.x,
      @required this.y,
      @required this.barColor});
}