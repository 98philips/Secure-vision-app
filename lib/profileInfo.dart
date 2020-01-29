import 'dart:convert'show json;

class ProfileInfo {
  final String username;
  final String email;
  final String name;
  final String imageUrl;

  ProfileInfo({this.username, this.email, this.name, this.imageUrl});

  factory ProfileInfo.fromJson(String responseString) {
    Map<String, dynamic> data = json.decode(responseString);
    return ProfileInfo(
      username: data['username'],
      email: data['email'],
      name: data['name'],
      imageUrl: data['image_url'],
    );
  }
}
