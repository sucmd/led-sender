import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:srtm/Services/googleDriveApi.dart';
import 'package:srtm/providers/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:core';
import 'dart:convert';
import 'dart:developer' as developer;

import '../models/Token.dart';
import '../models/User.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AppProvider _appProvider;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  //late bool isOnline = false;

  refrechToken(provider) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final refrech_token = sharedPreferences.getString('refreshToken');
    print("refrech token $refrech_token");
    if (refrech_token.toString() != 'null') {
      await GoogleDriveService(appProvider: _appProvider)
          .refrechToken()
          .then((value) => {
                print("refrech body : ${value?.body}"),
                if (value!.statusCode == 200)
                  {
                    sharedPreferences.setString(
                        'token', "${jsonDecode(value.body)['access_token']}"),
                    initScreen(),
                  }
                else
                  {Navigator.pushNamed(context, '/login')}
              })
          .catchError((err) => {
                showError(err, context),
              });
    } else {
      Navigator.pushNamed(context, '/login');
    }
  }

  showError(err, ctx) {
    showDialog<String>(
      context: ctx,
      builder: (BuildContext context) => AlertDialog(
        title: const Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 36.0,
        ),
        content: Text('$err'),
        actions: <Widget>[
          TextButton(
            onPressed: () => {
              //  print("hola"),
              _appProvider.hideLoading(),
              Navigator.pop(context),
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> initScreen() async {
    _appProvider = Provider.of<AppProvider>(context, listen: false);
    await GoogleDriveService(appProvider: _appProvider)
        .getAbout()
        .then((value) => {
              if (value.statusCode == 200)
                {
                  Navigator.pushNamed(context, '/trips'),
                  _appProvider.setUser(
                      newUser: User(
                          displayName: jsonDecode(value.body)['user']
                              ['displayName'],
                          emailAddress: jsonDecode(value.body)['user']
                              ['emailAddress'],
                          kind: jsonDecode(value.body)['user']['kind'],
                          me: jsonDecode(value.body)['user']['me'],
                          permissionId: jsonDecode(value.body)['user']
                              ['permissionId'],
                          photoLink: jsonDecode(value.body)['user']
                              ['photoLink'])),
                }
              else
                {refrechToken(_appProvider)}
            })
        .catchError((err) => {
              showError(err, context),
            });
  }

  navigate() async {
    getSharedPrefrences().then((data) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Provider.of<AppProvider>(context, listen: false).getLoggedIn();
      });
    });
  }

  Future getSharedPrefrences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    print("shared :: ${sharedPreferences.getString('credentials')}");
    try {
      if (sharedPreferences.getString('credentials') == '' ||
          sharedPreferences.getString('credentials') == null) {
        Navigator.pushNamed(context, '/login');
      } else {
        Navigator.pushNamed(context, '/login');
      }
    } catch (error) {
      print("error Log In");
    }
  }

  @override
  void initState() {
    super.initState();

  //  initConnectivity();

    /*_connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
*/
    initScreen();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    _appProvider = Provider.of<AppProvider>(context, listen: false);

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet) {
      try {
        final check = await InternetAddress.lookup('www.google.com');

        if (check.isNotEmpty && check[0].rawAddress.isNotEmpty) {
          _appProvider.setOffline(false);
        }
      } on SocketException catch (_) {
        _appProvider.setOffline(true);
        initScreen();
      }
    } else {
      _appProvider.setOffline(true);
      initScreen();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppProvider>(
        builder: (BuildContext context, value, Widget? child) {
          return Container(
            color: Colors.white,
            child: Column(
              children: [
                Center(
                  child: value.offline
                      ? Image.asset('assets/images/nointernet.gif')
                      : null,
                ),
                Center(
                    child: value.loadingPub
                        ? const CircularProgressIndicator()
                        : null),
              ],
            ),
          );
        },
      ),
    );
  }
}
