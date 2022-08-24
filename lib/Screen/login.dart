import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:srtm/Services/googleDriveApi.dart';
import 'package:srtm/providers/app_provider.dart';
import 'package:provider/provider.dart';

import '../Widget/Button.dart';

class LoginScreen extends StatelessWidget {
  late AppProvider _appProvider;
  LoginScreen({Key? key}) : super(key: key);
  late AccessCredentials credentials;

  obtainCredentials(context) async {
    GoogleDriveService(appProvider: _appProvider).login(context);
  }

  @override
  Widget build(BuildContext context) {
    _appProvider = Provider.of<AppProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: const Text("transit Pub"),
      ),
      body: Center(
        child: GoogleSignInButton(
          onPressed: () {
            obtainCredentials(context);
          },
        ),
      ),
    );
  }
}
