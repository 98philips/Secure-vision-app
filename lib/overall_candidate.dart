class OverallCandidate{
  String imageUrl,name,email,count;
  OverallCandidate({this.name,this.email,this.imageUrl,this.count});

  factory OverallCandidate.fromJson(Map<String, dynamic> data) {
    print(data.toString());
    return OverallCandidate(
      email: data['email'],
      name: data['name'],
      imageUrl: data['image_url'],
      count: data['count'].toString(),
    );
  }


}