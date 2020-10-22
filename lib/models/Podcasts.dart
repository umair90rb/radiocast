class Podcasts {
  List<Records> records;

  Podcasts({this.records});

  Podcasts.fromJson(Map<String, dynamic> json) {
    if (json['records'] != null) {
      records = new List<Records>();
      json['records'].forEach((v) {
        records.add(new Records.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.records != null) {
      data['records'] = this.records.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Records {
  String id;
  String uid;
  String username;
  String title;
  String thumbnail;
  String podcast;
  String upload;

  Records(
      {this.id,
        this.uid,
        this.username,
        this.title,
        this.thumbnail,
        this.podcast,
        this.upload});

  Records.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    username = json['username'];
    title = json['title'];
    thumbnail = json['thumbnail'];
    podcast = json['podcast'];
    upload = json['upload'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['username'] = this.username;
    data['title'] = this.title;
    data['thumbnail'] = this.thumbnail;
    data['podcast'] = this.podcast;
    data['upload'] = this.upload;
    return data;
  }
}
