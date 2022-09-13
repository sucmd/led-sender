import 'package:srtm/models/service.dart';

class Trips {
  late String? key;
  String voyage;
  String voyage_fr;
  int? t_depart;
  int? t_arrivee;
  String bus;
  String status_fr;
  String status;
  Service service;
  Trips(
      {
        this.key,
      required this.bus,
      required this.t_arrivee,
      required this.t_depart,
      required this.voyage,
      required this.voyage_fr,
      required this.status,
      required this.status_fr,
      required this.service});

  fromJson(Map<String, dynamic> json) {
    key = key;
    bus = bus;
    t_arrivee = t_arrivee;
    t_depart = t_depart;
    voyage_fr = voyage_fr;
    voyage = voyage;
    service = service;
    status = status;
    status_fr = status_fr;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['bus'] = this.bus;
    data['t_arrivee'] = this.t_arrivee;
    data['t_depart'] = this.t_depart;

    data['voyage_fr'] = this.voyage_fr;
    data['voyage'] = this.voyage;
    data['service'] = this.service;
    data['status'] = this.status;
    data['status_fr'] = this.status_fr;

    return data;
  }
}
