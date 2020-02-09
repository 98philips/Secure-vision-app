import 'dart:convert'show json;

class ProfileInfo {
  String username;
  String email;
  String name;
  String imageUrl, phNo;
  int orgId;
  String apiKey;

  ProfileInfo(
      {this.username, this.email, this.name, this.imageUrl, this.orgId, this.phNo, this.apiKey});

  factory ProfileInfo.fromJson(String responseString) {
    Map<String, dynamic> data = json.decode(responseString);
    return ProfileInfo(
      username: data['username'],
      email: data['email'],
      name: data['name'],
      imageUrl: data['image_url'],
      orgId: data['org_id'],
      phNo: data['phone'],
      apiKey: data['api_key'],
    );
  }

  static Map<String, dynamic> toJson(ProfileInfo instance) {
    return <String, dynamic>{
      'name': instance.name,
      'username': instance.username,
      'email': instance.email,
      'image_url': instance.imageUrl,
      'org_id': instance.orgId,
      'phone': instance.phNo,
      'api_key': instance.apiKey,
    };
  }
}
