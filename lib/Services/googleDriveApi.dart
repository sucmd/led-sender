import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:srtm/providers/app_provider.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pathProvider;

class GoogleDriveService {
  static const String refrechTokenUrl =
      "https://www.googleapis.com/oauth2/v4/token?access_type=offline";
  static const String clientId =
      "327841706108-ufep01nc9ofr3rre8ckgqe98rhl7ill2.apps.googleusercontent.com";
  static const String client_secret = "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";
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final AppProvider appProvider;

  late AccessCredentials credentials;
  final client = http.Client();

  var imagesList = [];

  GoogleDriveService({required this.appProvider});

  void login(context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      credentials = await obtainAccessCredentialsViaUserConsent(
        ClientId(clientId, client_secret),
        ['https://www.googleapis.com/auth/drive'],
        client,
        _prompt,
      );
      sharedPreferences.setString(
          'refreshToken', "${credentials.refreshToken}");
      sharedPreferences.setString('token', credentials.accessToken.data);
      Navigator.pushNamed(context, '/splashScreen');
    } finally {
      client.close();
    }
  }

  void _prompt(String url) {
    _launchInBrowser(Uri.parse(url));
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  Future getAbout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var header = sharedPreferences.getString('token');
    Map<String, String> headers = {"authorization": "Bearer $header"};
    http.Response? response;

    try {
      response = await client.get(
          Uri.parse(
            "https://www.googleapis.com/drive/v3/about?fields=user,storageQuota&key=AIzaSyDZbtMiDpyQzqMSo3cmQKJ6UOQht5VtDBE",
          ),
          headers: headers);
    } catch (e) {
      throw Exception('Something Went Wrong!');
    }
    return response;
  }

  Future<http.Response?> refrechToken() async {
    http.Response? response;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final refrechToken = sharedPreferences.getString('refreshToken');
    try {
      response = await client.post(Uri.parse(refrechTokenUrl), body: {
        "client_id": clientId,
        "client_secret": client_secret,
        "refresh_token": refrechToken,
        "grant_type": "refresh_token"
      });
    } catch (e) {
      throw Exception('Something Went Wrong!');
    }
    return response;
  }

  Future<http.Response?> getFiles() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var header = sharedPreferences.getString('token');
    Map<String, String> headers = {"authorization": "Bearer $header"};
    http.Response? response;

    try {
      response = await client.get(
          Uri.parse(
            "https://www.googleapis.com/drive/v3/files?fields=files&key=AIzaSyDZbtMiDpyQzqMSo3cmQKJ6UOQht5VtDBE&q=mimeType contains 'image/'",
          ),
          headers: headers);
    } catch (e) {
      throw Exception('Something Went Wrong!');
    }
    return response;
  }

  Future delFiles({required fileId, required context}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var header = sharedPreferences.getString('token');
    Map<String, String> headers = {"authorization": "Bearer $header"};
    http.Response? response;

    try {
      response = await client.delete(
          Uri.parse(
            "https://www.googleapis.com/drive/v3/files/" +
                fileId +
                "?key=AIzaSyDZbtMiDpyQzqMSo3cmQKJ6UOQht5VtDBE",
          ),
          headers: headers);
      print("enter to delete  Files: Response ${response.statusCode}");
    } catch (e) {
      throw Exception('Something Went Wrong!');
    }

    return response;

    /*   if (response.statusCode == 204) {
      appProvider.removeFile(fileId);
      appProvider.setdeleteOption(res: false);
      Navigator.of(context).pop();
    } else {
      print("deleting file not authorized");
    }
    */
  }

  Future handleUploadData(PlatformFile fileData, context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var header = sharedPreferences.getString('token');

    final file = File(fileData.path as String);
    final fileLength = file.lengthSync().toString();
    String? sessionUri;

    Uri uri = Uri.parse(
        'https://www.googleapis.com/upload/drive/v3/files?uploadType=resumable');

    String body = json.encode({'name': fileData.name});

    final initialStreamedRequest = http.StreamedRequest('POST', uri)
      ..headers.addAll({
        'Authorization': "Bearer $header",
        'Content-Length': utf8.encode(body).length.toString(),
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Upload-Content-Length': fileLength
      });

    initialStreamedRequest.sink.add(utf8.encode(body));
    initialStreamedRequest.sink.close();

    http.StreamedResponse response = await initialStreamedRequest.send();
    response.stream.transform(utf8.decoder).listen((value) {});

    if (response.statusCode == 200) {
      sessionUri = response.headers['location'];
    }
    Uri sessionURI = Uri.parse(sessionUri!);
    final fileStreamedRequest = http.StreamedRequest('PUT', sessionURI)
      ..headers.addAll({
        'Content-Length': fileLength,
      });
    fileStreamedRequest.sink.add(file.readAsBytesSync());
    fileStreamedRequest.sink.close();

    http.StreamedResponse fileResponse = await fileStreamedRequest.send();
    fileResponse.stream.transform(utf8.decoder).listen((value) async {
      Navigator.of(context).pushNamed("/ads");
    });
  }

  Future<void> download(String url) async {
    List<File?> _displaysImages = [];
    final response = await http.get(Uri.parse(url));

    // Get the image name
    final imageName = path.basename(url);
    // Get the document directory path
    final appDir = await pathProvider.getApplicationDocumentsDirectory();

    // This is the saved image path
    // You can use it to display the saved image later
    final localPath = path.join(appDir.path, imageName);
    final imageFile = File(localPath);

    File(localPath).exists().then((value) async => {
          print("File Exist::$value"),
          if (value == false) await imageFile.writeAsBytes(response.bodyBytes),
        });

    imagesList.add(imageFile);
    // Downloading
  }
}
