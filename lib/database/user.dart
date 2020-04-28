class User {
  int id;
  int color;
  String image;
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

  User(
      {this.id,
      this.color,
      this.image,
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

  Map<String, dynamic> addToMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['color'] = color;
    map['image'] = image;
    map['name'] = name;
    map['job'] = job;
    map['phone'] = phone;
    map['mail'] = mail;
    map['link'] = link;
    map['location'] = location;
    map['twitter'] = twitter;
    map['facebook'] = facebook;
    map['instagram'] = instagram;
    map['github'] = github;
    return map;
  }

  User.fromMapObject(Map<String, dynamic> usersMapList) {
    this.id = usersMapList['id'];
    this.color = usersMapList['color'];
    this.image = usersMapList['image'];
    this.name = usersMapList['name'];
    this.job = usersMapList['job'];
    this.phone = usersMapList['phone'];
    this.mail = usersMapList['mail'];
    this.link = usersMapList['link'];
    this.location = usersMapList['location'];
    this.twitter = usersMapList['twitter'];
    this.facebook = usersMapList['facebook'];
    this.instagram = usersMapList['instagram'];
    this.github = usersMapList['github'];
  }
}
