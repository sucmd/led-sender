import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class FullScreenImage extends StatelessWidget {
  final image;
  const FullScreenImage({Key? key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(image['thumbnailLink']);
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: image['name'],
            child: Image.network(image['thumbnailLink']
                .substring(0, image['thumbnailLink'].indexOf("="))),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
