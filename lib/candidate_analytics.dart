import 'package:flutter/material.dart';
import 'package:vision/candidate_class.dart';

class CandidateAnalytics extends StatefulWidget {
  final Candidate candidate;
  CandidateAnalytics(this.candidate);

  @override
  State<StatefulWidget> createState() {
    return CandidateState();
  }
}

class CandidateState extends State<CandidateAnalytics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: topBar(widget.candidate)),
      body: Center(
        child: Text("Analytics"),
      ),
    );
  }
}

Widget topBar(Candidate candidate) {
  return Hero(
    tag: candidate.id,
    child: Container(
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
                  Container(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Text(candidate.name,
                    style: TextStyle(fontSize: 16)
                    ),
                  ),
                  Text(candidate.id,
                  style: TextStyle(fontSize: 16)
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}
