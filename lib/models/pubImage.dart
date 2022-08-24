class PubImage {
  String url;
  String id;
  PubImage({required this.url, required this.id});

  fromJson(Map<String, dynamic> json) {
    url = json['files']['url'];
    id = json['files']['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['files']['url'] = this.url;
    data['files']['id'] = this.id;

    return data;
  }
}
