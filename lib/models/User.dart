class User {
  String? kind;
  String displayName;
  String? photoLink;
  bool? me;
  String? permissionId;
  String? emailAddress;

  User(
      {this.kind,
      required this.displayName,
      this.photoLink,
      this.me,
      this.permissionId,
      this.emailAddress});

  fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    displayName = json['displayName'];
    photoLink = json['photoLink'];
    me = json['me'];
    permissionId = json['permissionId'];
    emailAddress = json['emailAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kind'] = this.kind;
    data['displayName'] = this.displayName;
    data['photoLink'] = this.photoLink;
    data['me'] = this.me;
    data['permissionId'] = this.permissionId;
    data['emailAddress'] = this.emailAddress;
    return data;
  }
}
