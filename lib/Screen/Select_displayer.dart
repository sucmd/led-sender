import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';

class SelectDisplayer extends StatelessWidget {
  const SelectDisplayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   final _appProvider = Provider.of<AppProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("transit Pub"),
        leading: Container(),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => {

           //     _appProvider.setFirebaseUrl("trips"),
             //   _appProvider.setmessageUrl("message"),
                  Navigator.pushNamed(context, '/trips'),


                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: const Center(
                      child: Image(
                        image: AssetImage(
                          "assets/images/srtmLogo.jpg",
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => {

//_appProvider.setFirebaseUrl("jerbaTrips"),
//_appProvider.setmessageUrl("jerbaMessage"),                             
         Navigator.pushNamed(context, '/trips'),

},
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: const Center(
                      child: Image(
                        image: AssetImage(
                          "assets/images/srtmLogo.jpg",
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
