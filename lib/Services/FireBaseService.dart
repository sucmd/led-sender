import 'dart:convert';
import 'dart:developer';

import 'package:googleapis/docs/v1.dart';
import 'package:http/http.dart' as http;
import 'package:srtm/models/trips.dart';
import 'package:srtm/providers/app_provider.dart';

class FireBaseService {
  final AppProvider appProvider;
  final fireBaseClient = http.Client();
  FireBaseService({required this.appProvider});

  Future sendDataToFireBase(data) async {
    http.Response? response;

    try {
      response = await fireBaseClient.post(
          Uri.parse(
           "https://medenineproject-default-rtdb.firebaseio.com/medenineproject-default-rtdb/${appProvider.firebaseUrl}.json",
  // appProvider.firebaseUrl
          ),
          body: json.encode(data));
    } catch (e) {
      throw Exception('Something Went Wrong!');
    }
    return response;
  }

  Future<http.Response?> getDataFromFireBase() async {
    http.Response? response;
    print("url ${appProvider.firebaseUrl}");

    try {
      response = await fireBaseClient.get(
        Uri.parse(
          "https://medenineproject-default-rtdb.firebaseio.com/medenineproject-default-rtdb/${appProvider.firebaseUrl}.json",
          // appProvider.firebaseUrl

        ),
      );
      return response;
    } catch (e) {
      throw Exception('Something Went Wrong!');
    }
  }

  Future putDataInFireBase(data, key) async {
    http.Response? response;

    try {
      response = await fireBaseClient.put(
          Uri.parse(
    //    appProvider.firebaseUrl

           "https://medenineproject-default-rtdb.firebaseio.com/medenineproject-default-rtdb/${appProvider.firebaseUrl}/$key.json",
          ),
          body: json.encode(data));
    } catch (e) {
      throw Exception('Something Went Wrong!');
    }
    return response;
  }

  DeleteDataInFireBase(key) async {
    http.Response? response;

    try {
      response = await fireBaseClient.delete(
        Uri.parse(
          "https://medenineproject-default-rtdb.firebaseio.com/medenineproject-default-rtdb/${appProvider.firebaseUrl}/$key.json",
        ),
      );
    } catch (e) {
      throw Exception('Something Went Wrong!');
    }
    return response;
  }


Future<http.Response?> getMessage () async {
http.Response? response;

    try {
      response = await fireBaseClient.get(
        Uri.parse(
          "https://medenineproject-default-rtdb.firebaseio.com/medenineproject-default-rtdb/${appProvider.messageurl}.json",
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Something Went Wrong!');
    }
}



  Future putMessage(data, key) async {
    http.Response? response;

    try {
      response = await fireBaseClient.put(
          Uri.parse(
            "https://medenineproject-default-rtdb.firebaseio.com/medenineproject-default-rtdb/${appProvider.messageurl}/$key.json",
          ),
          body: json.encode(data));
    } catch (e) {
      throw Exception('Something Went Wrong!');
    }
    return response;
  }

}
