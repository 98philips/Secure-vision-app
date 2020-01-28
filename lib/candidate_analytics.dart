import 'package:flutter/material.dart';
import 'package:vision/analytics_chart.dart';
import 'package:vision/candidate_class.dart';
import 'package:vision/chart_data.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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
  final List<ChartData> data = [
    ChartData(
      x: "Sun",
      y: 2,
      barColor: charts.ColorUtil.fromDartColor(Colors.green),
    ),
    ChartData(
      x: "Mon",
      y: 6,
      barColor: charts.ColorUtil.fromDartColor(Colors.green),
    ),
    ChartData(
      x: "Tue",
      y: 10,
      barColor: charts.ColorUtil.fromDartColor(Colors.green),
    ),
    ChartData(
      x: "Wed",
      y: 7,
      barColor: charts.ColorUtil.fromDartColor(Colors.green),
    ),
    ChartData(
      x: "Thu",
      y: 8,
      barColor: charts.ColorUtil.fromDartColor(Colors.green),
    ),
    ChartData(
      x: "Fri",
      y: 12,
      barColor: charts.ColorUtil.fromDartColor(Colors.green),
    ),
    ChartData(
      x: "Sat",
      y: 5,
      barColor: charts.ColorUtil.fromDartColor(Colors.green),
    ),
  ];
  PageController pageController;
  Candidate candidate;

  @override
  void initState() {
    super.initState();
    candidate = widget.candidate;
    pageController = PageController(
      initialPage: widget.index,
      viewportFraction: 0.92,
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:Container(
          margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
        child:PageView.builder(
          controller: pageController,
          itemCount: widget.candidateList.length,
          onPageChanged: (int index) {
            setState(() {
              candidate = widget.candidateList.elementAt(index);
            });
          },
          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return buildItem(data);
          })),
    ));
  }

  Widget topBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 0.2,
            color: Colors.greenAccent,
          )
        )
      ),
      padding: EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    image: DecorationImage(
                      image: new NetworkImage(candidate.imageUrl),
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
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.only(bottom: 4),
                            child: Text(candidate.name,
                                style: TextStyle(fontSize: 16)),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Text(
                            candidate.id,
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16)
      ),
      child:Container(
      padding: EdgeInsets.all(8),
        child: Column(children: <Widget>[
          AnalyticsChart(
            data: data,
          ),
          Spacer(
            flex: 1,
          ),
          topBar(),
        ])));
  }
}
