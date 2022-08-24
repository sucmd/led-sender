class Message {
  late String? key;
  

  String message;
  Message(
      {this.key,
            required this.message

      });

  fromJson(Map<String, dynamic> json) {
    key = key;
    message = message;
  
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['message'] = this.message;
  

    return data;
  }
}
