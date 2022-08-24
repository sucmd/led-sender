import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:srtm/Screen/Ads.dart';
import 'package:srtm/Services/googleDriveApi.dart';
import 'package:srtm/models/User.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widget/ShowFile.dart';
import '../providers/app_provider.dart';


class Publicite extends StatefulWidget {
  const Publicite({Key? key}) : super(key: key);

  @override
  State<Publicite> createState() => _PubliciteState();
}

class _PubliciteState extends State<Publicite> {
  late User user;
  late AppProvider _appProvider;
  List<PlatformFile> files = [];

  bool loading = false;

  //late bool loading = false;

  showError(err) {
    showDialog<String>(
      context: context,
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
              /*  setState(() {
                loading = false;
              }),*/
              _appProvider.hideLoading(),
              Navigator.pop(context, 'OK')
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _appProvider = Provider.of<AppProvider>(context, listen: false);

    getAllFiles();
  }

  void openFiles(List<PlatformFile> files) {
    Showfile(files: files);
  }

  getAllFiles() async {
    _appProvider = Provider.of<AppProvider>(context, listen: false);

    // _appProvider.showLoading();

    setState(() {
      loading = true;
    });
    await GoogleDriveService(appProvider: _appProvider)
        .getFiles()
        .then((value) => {
              setState(() {
                loading = false;
              }),
              // _appProvider.hideLoading(),
              //    print("code http ${value!.statusCode}"),
              if (value!.statusCode == 200)
                {
                  print("files ${jsonDecode(value.body)['files']}"),
                  _appProvider.setFiles(jsonDecode(value.body)['files']),
                }
              else
                {print("error")}
            })
        .catchError((err) => {showError(err)});
  }

  @override
  Widget build(BuildContext context) {
    _appProvider = Provider.of<AppProvider>(context, listen: false);
    SharedPreferences preferences;
    return Scaffold(
      appBar: AppBar(
        title: const Text("transit Pub"),
        actions: [
             IconButton(
              onPressed: () async {
                 final result = await FilePicker.platform
                  .pickFiles( type: FileType.image);
              if (result == null) return;
              files = result.files;
              openFiles(files);
              Navigator.pushNamed(context, "/showSelectedFile",
                  arguments: files);
              },
              icon: const Icon(Icons.add))
         /* PopupMenuButton(itemBuilder: (context) {
            return [
              const PopupMenuItem<int>(
                value: 0,
                child: Text("Add"),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text("Remove"),
              ),
            ];
          }, onSelected: (value) async {
            if (value == 0) {
              final result = await FilePicker.platform
                  .pickFiles(allowMultiple: true, type: FileType.image);
              if (result == null) return;
              files = result.files;
              openFiles(files);
              Navigator.pushNamed(context, "/showSelectedFile",
                  arguments: files);
            } else if (value == 1) {
           //   _appProvider.setdeleteOption(res: true);
            }
          }),*/
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (_, data, __) => Stack(
          children: [
                     if(data.getFiles().isNotEmpty)
   Ads(
              ads: data.getFiles(),
              deleteMode: data.getdeleteOption(),
            ),
            
            if (loading)
              const Opacity(
                opacity: 0.8,
                child: ModalBarrier(dismissible: false, color: Colors.black),
              ),
            if (loading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("${_appProvider.getUser?.displayName}"),
              accountEmail: Text("${_appProvider.getUser?.emailAddress}"),
              currentAccountPicture: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).platform == TargetPlatform.iOS
                          ? Colors.blue
                          : Colors.white,
                  backgroundImage:
                      NetworkImage("${_appProvider.getUser?.photoLink}")),
            ),
            Column(children: [
              ListTile(
                leading: const Icon(Icons.directions_bus),
                title: const Text("Tableau des voyages"),
                onTap: () => {Navigator.pushNamed(context, '/trips')},
              ),
              ListTile(
                leading: const Icon(Icons.event_available_rounded),
                title: const Text("Section de Publicité"),
                onTap: () => {Navigator.pushNamed(context, '/ads')},
              ),
               
              ListTile(
                leading: const Icon(Icons.logout_rounded),
                title: const Text("Log out "),
                onTap: () async => {
                   preferences = await SharedPreferences.getInstance(),
await preferences.clear(),
Navigator.pushNamed(context, '/login'),
            },
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
