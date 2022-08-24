class Trips {
  late String? key;
  String arDestination;
  String frDestination;

  int? depart;
  String ligne;
  Trips(
      {this.key,
      required this.ligne,
      required this.depart,
      required this.arDestination,
      required this.frDestination});

  fromJson(Map<String, dynamic> json) {
    key = key;
    ligne = ligne;
    depart = depart;
    frDestination = frDestination;
    arDestination = arDestination;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['ligne'] = this.ligne;
    data['depart'] = this.depart;
    data['frDestination'] = this.frDestination;
    data['arDestination'] = this.arDestination;

    return data;
  }
}
