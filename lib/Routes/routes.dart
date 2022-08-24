
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:srtm/Screen/Select_displayer.dart';
import 'package:srtm/Screen/login.dart';
import 'package:srtm/Screen/noInternet.dart';
import 'package:provider/provider.dart';

import '../Screen/Publicite.dart';
import '../Screen/ShowSelectedFile.dart';
import '../Screen/Splash.dart';
import '../Screen/Table_trips.dart';
import '../Widget/FullScreenImage.dart';
import '../providers/app_provider.dart';

class routeGenerator {
  static Route<dynamic> generateRoute(RouteSettings setting) {
    return PageRouteBuilder(pageBuilder: (context, __, ___) {
      final _appProvider = Provider.of<AppProvider>(context, listen: false);
      if (_appProvider.offline) {
        return Nointernet();
      }

      final args = setting.arguments;
      switch (setting.name) {
        case '/splashScreen':
          return const  SplashScreen();
        case '/ads':
          return const Publicite();
        case '/trips':
          return const Tabletrips();
        case '/login':
          return LoginScreen();
        case '/displayer':
        return const SelectDisplayer();
        case '/showSelectedFile':
          if (args is List<PlatformFile>) {
            return ShowSelectedFiles(
              files: args,
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: Text('Error'),
            ),
            body: Center(
              child: Text('ERROR'),
            ),
          );

        case '/image':
          return FullScreenImage();

        default:
          // If there is no such named route in the switch statement, e.g. /third
          return Scaffold(
            appBar: AppBar(
              title: Text('Error'),
            ),
            body: Center(
              child: Text('ERROR'),
            ),
          );
      }
    });
  }

  _errorRoute() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error'),
      ),
      body: Center(
        child: Text('ERROR'),
      ),
    );
  }
}
