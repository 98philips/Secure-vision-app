import 'dart:convert'show json;

class ProfileInfo {
  final String username;
  final String email;
  final String name;
  final String imageUrl,phNo;
  final int orgId;

  ProfileInfo({this.username, this.email, this.name, this.imageUrl,this.orgId,this.phNo});

  factory ProfileInfo.fromJson(String responseString) {
    Map<String, dynamic> data = json.decode(responseString);
    return ProfileInfo(
      username: data['username'],
      email: data['email'],
      name: data['name'],
      imageUrl: data['image_url'],
      orgId: data['org_id'],
      phNo:  data['phone'],
    );
  }
}
