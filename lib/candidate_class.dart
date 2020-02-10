

class Candidate{
  String imageUrl,name,email;
  Candidate({this.name,this.email,this.imageUrl});

  factory Candidate.fromJson(Map<String, dynamic> data) {
    print(data.toString());
    return Candidate(
      email: data['username'],
      name: data['name'],
      imageUrl: data['image_url'],
    );
  }


}