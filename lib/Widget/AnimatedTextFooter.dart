import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';


 Widget buildAnimatedTextFooter(String text, BuildContext context) {
return Container(
      height: MediaQuery.of(context).size.height* 0.03,
      color: Colors.red,
      child: Marquee(
        text: text, style: const TextStyle(letterSpacing: 1, fontSize: 10,color: Colors.white),
        // style:GoogleFonts.cairo(),
        blankSpace: 100,
        velocity: -20,
        //  pauseAfterRound: Duration(seconds: 2),
      ));
 }