import 'dart:io';

import 'package:file_picker/src/platform_file.dart';
import 'package:flutter/material.dart';

Widget Showfile({
  List<PlatformFile>? files,
}) {
  return Scaffold(
    body: ListView.builder(
        itemCount: files!.length,
        itemBuilder: (context, index) {
          final file = files[index];
          return buildFile(file);
        }),
  );
}

Widget buildFile(PlatformFile file) {
  final kb = file.size / 1024;
  final mb = kb / 1024;
  final size =
      (mb >= 1) ? '${mb.toStringAsFixed(2)} MB' : '${kb.toStringAsFixed(2)} KB';
  return SizedBox(
    width: 100,
    height: 100,
    child: InkWell(
      onTap: () => null,
      child: SizedBox(
        width: 200,
        height: 200,
        child: ListTile(
          leading: (file.extension == 'jpg' ||
                  file.extension == 'png' ||
                  file.extension == 'jpeg')
              ? Image.file(
                  File(file.path.toString()),
                  width: 80,
                  height: 80,
                )
              : const SizedBox(
                  width: 80,
                  height: 80,
                ),
          title: Text(file.name),
          subtitle: Text('${file.extension}'),
          trailing: Text(
            size,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    ),
  );
}
