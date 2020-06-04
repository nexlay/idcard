class User {
  String id;
  User({this.id});
}

class UserData {
  String id;
  bool shared;
  String token;
  String font;
  String image;
  int color;
  String name;
  String job;
  String phone;
  String mail;
  String link;
  String location;
  String twitter;
  String facebook;
  String instagram;
  String github;

  UserData(
      {this.id,
      this.shared,
      this.token,
      this.font,
      this.image,
      this.color,
      this.name,
      this.job,
      this.phone,
      this.mail,
      this.link,
      this.location,
      this.twitter,
      this.facebook,
      this.instagram,
      this.github});
}
