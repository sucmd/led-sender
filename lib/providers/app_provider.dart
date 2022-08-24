import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:srtm/models/trips.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/User.dart';

class AppProvider with ChangeNotifier {
  late  String  _firebaseUrl="trips";
  late bool isLoggedIn = false;
  User? _user;
  List<dynamic> _files = [];

  bool _offline = false;

  late AccessCredentials? _AccessCredentials = null;
  late bool deleteOption = false;
  List<Trips> _trips = [];
  bool loadingPub = false;
  late String _messageUrl ="message";
  late String _nameDisplayer= "Medenine";

  Future setLoggedIn({required bool status}) async {
    isLoggedIn = status;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setBool('isLoggedin', status);
  }

  Future getLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    isLoggedIn = sharedPreferences.getBool('isLoggedin') ?? isLoggedIn;
    return Future.value(isLoggedIn);
  }

  setUser({required User newUser}) {
    _user = newUser;
    notifyListeners();
  }

  get getUser => _user;

  AccessCredentials? getApiCredential() => _AccessCredentials;

  setApiCredential({required AccessCredentials AccessCredentials}) {
    _AccessCredentials = AccessCredentials;
    notifyListeners();
  }

  List<dynamic> getFiles() => _files;

  setFiles(List<dynamic> file) {
    _files = file;
    notifyListeners();
  }

  removeFile(id) {
    _files.removeWhere((element) => element['id'] == id);
    notifyListeners();
  }

  List<Trips> getTrips() => _trips;

  addTrip(trip) {
    _trips.add(trip);
    _trips.sort((a, b) => (a.depart.toString()).compareTo(b.depart.toString()));

    notifyListeners();
  }

  updateTrip(key, trip) {
    var i = _trips.indexWhere((element) => element.key == key);
    if (i != -1) {
      {
        _trips[i] = trip;
      }
      _trips
          .sort((a, b) => (a.depart.toString()).compareTo(b.depart.toString()));

      notifyListeners();
    }
  }

  setTrips(List<Trips> trips) {
    trips.sort((a, b) => (a.depart.toString()).compareTo(b.depart.toString()));

    _trips = trips;
    notifyListeners();
  }

  removeTrip(key) {
    _trips.removeWhere((element) => element.key == key);

    notifyListeners();
  }

  setdeleteOption({required res}) {
    deleteOption = res;
    notifyListeners();
  }

  getdeleteOption() {
    return deleteOption;
  }

  showLoading() {
    loadingPub = true;
    notifyListeners();
  }

  hideLoading() {
    loadingPub = false;
    notifyListeners();
  }

  setOffline(bool offline) {
    _offline = offline;
    notifyListeners();
  }

setFirebaseUrl()
 {
  if( _nameDisplayer == "Medenine")
  {
    print("mednenine");
    _firebaseUrl= "trips";
    setmessageUrl("message");
    //    setDisplyername("Medenine");

  }
  if(_nameDisplayer == "Jerba")
  {

    _firebaseUrl="jerbaTrips";
    setmessageUrl("jerbaMessage");
  //  setDisplyername("Jerba");

  }
      notifyListeners();

 }

setmessageUrl(url){
  _messageUrl= url;
}
get messageurl => _messageUrl;
get firebaseUrl => _firebaseUrl;
  get offline => _offline;

  setDisplyername(name){
_nameDisplayer = name;
notifyListeners();
  }
  get displayerName => _nameDisplayer;
}
