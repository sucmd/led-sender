import 'package:flutter/material.dart';

class Nointernet extends StatelessWidget {
  const Nointernet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Center(child: Image.asset('assets/images/nointernet.gif')));
  }
}
