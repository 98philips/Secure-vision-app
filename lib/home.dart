import 'package:flutter/material.dart';
import 'package:vision/candidate_analytics.dart';
import 'package:vision/candidate_class.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeState();
  }
}

class HomeState extends State<Home> {
  List<Candidate> candidateList = [
    Candidate("Philip Paul", "ID2727",
        "https://www.evolutionsociety.org/userdata/news_picupload/pic_sid189-0-norm.jpg"),
    Candidate("Sreeraj S", "ID2728",
        "https://www.evolutionsociety.org/userdata/news_picupload/pic_sid189-0-norm.jpg"),
    Candidate("Rahul Mohan K", "ID2729",
        "https://www.evolutionsociety.org/userdata/news_picupload/pic_sid189-0-norm.jpg")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Candidates"),
          // actions: <Widget>[
          //   IconButton(
          //     icon: Icon(Icons.menu),
          //     onPressed: () {},
          //   )
          // ],
        ),
        body: Container(
            padding: EdgeInsets.all(8),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: candidateList.length,
              itemBuilder: (BuildContext context, int index) {
                return candidateTile(
                    candidateList.elementAt(index), context, index);
              },
            )));
  }

  Widget candidateTile(Candidate candidate, BuildContext context, int index) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CandidateAnalytics(candidate, candidateList, index))),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Hero(
          tag: candidate.id,
          child: SingleChildScrollView(
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
                                candidate.id,
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
          ),
        ),
      ),
    );
  }
}
