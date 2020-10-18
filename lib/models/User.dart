class User {
  String id;
  String username;
  String email;
  String phone;
  String profile;
  String password;

  User(
      {this.id,
        this.username,
        this.email,
        this.phone,
        this.profile,
        this.password});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    profile = json['profile'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['profile'] = this.profile;
    data['password'] = this.password;
    return data;
  }
}
