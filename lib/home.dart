import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeState();
  }
}

class HomeState extends State<Home> {
  final _controller = PageController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Overall Analytics"),
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(30))),
        centerTitle: true,
      ),
      body: Center(
        child: PageView.builder(
          controller: _controller,
            itemCount: 3,
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return buildItem(index);
            }),
      ),
    );
  }

  Widget buildItem(int index) {
    return Center(
      child: Card(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Text("Page " + index.toString()),
        ),
      ),
    );
  }
}
