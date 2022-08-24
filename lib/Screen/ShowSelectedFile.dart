import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/servicemanagement/v1.dart';
import 'package:provider/provider.dart';

import '../Services/googleDriveApi.dart';
import '../providers/app_provider.dart';

class ShowSelectedFiles extends StatefulWidget {
  final List<PlatformFile>? files;
  const ShowSelectedFiles({Key? key, required this.files}) : super(key: key);

  @override
  State<ShowSelectedFiles> createState() =>
      _ShowSelectedFilesState(files: files);
}

class _ShowSelectedFilesState extends State<ShowSelectedFiles> {
  List<PlatformFile>? files;
  late AppProvider _appProvider;
  addFiles(PlatformFile file, context) async {
    _appProvider = Provider.of<AppProvider>(context, listen: false);
    await GoogleDriveService(appProvider: _appProvider)
        .handleUploadData(file, context);
  }

  @override
  _ShowSelectedFilesState({Key? key, required this.files});
  @override
  Widget buildFile(PlatformFile file) {
    final kb = file.size / 1024;
    final mb = kb / 1024;
    final size = (mb >= 1)
        ? '${mb.toStringAsFixed(2)} MB'
        : '${kb.toStringAsFixed(2)} KB';
    return Container(
      width: 100,
      height: 100,
      child: InkWell(
        onTap: () => null,
        child: Container(
          width: 200,
          height: 200,
          child: ListTile(
            leading: (file.extension == 'jpg' ||
                    file.extension == 'png' ||
                    file.extension == 'jpeg' ||
                    file.extension == 'gif')
                ? Image.file(
                    File(file.path.toString()),
                    width: 80,
                    height: 80,
                  )
                : Container(
                    width: 80,
                    height: 80,
                  ),
            title: Text('${file.name}'),
            subtitle: Text('${file.extension}'),
            trailing: Text(
              '$size',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Selected Files',
          style: TextStyle(color: Colors.white),
        ),
        //  backgroundColor: Color(0xFF149cf7),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              addFiles(files![0], context);
            },
            icon: Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
          )
        ],
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: files!.length,
          itemBuilder: (context, index) {
            final file = files![index];
            return buildFile(file);
          }),
    );
  }
}
