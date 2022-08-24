import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:srtm/Widget/Footer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../Services/FireBaseService.dart';
import '../models/Message.dart';
import '../models/trips.dart';
import '../providers/app_provider.dart';

import 'package:form_field_validator/form_field_validator.dart';

class Tabletrips extends StatefulWidget {
  const Tabletrips({Key? key}) : super(key: key);

  @override
  State<Tabletrips> createState() => _TabletripsState();
}

class _TabletripsState extends State<Tabletrips> {
  late AppProvider _appProvider;

  late List<Trips> _trips = [];
  double cl0width = 0.1;
  double cl1width = 0.15;
  double cl2width = 0.15;
  double cl3width = 0.3;
  double cl4width = 0.3;

  bool showActionBar = false;
//////////////// update controllers ///////////////
  final updateFormKey = GlobalKey<FormState>();
  final updateFormLigne = TextEditingController();
  final TextEditingController updateFormDepart = TextEditingController();
  final updateFormArDestination = TextEditingController();
  final updateFormFrDestination = TextEditingController();
/////////////////// add controllers ////////////////
  final addFormKey = GlobalKey<FormState>();
  final addFormLigne = TextEditingController();
  final addFormArDestination = TextEditingController();
  final addFormFrDestination = TextEditingController();

  final TextEditingController addFormDepart = TextEditingController();
/////////////////////////////////////////////////////
  late int addStartTimeTimeStamp = 0;
  late int updateStartTimeTimeStamp = 0;

  bool _isMedenine = true;

  late Message msg = Message(
      message: "الشركة الجهوية للنقل بمدنين تتمنى لحرفائها الكرام سفرة ممتعة");
      
       late   int? switchIndex =0;
///////////////////////////////////////////////////

  getTime(int? timeStamp) {
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(timeStamp!);
    String formattedTime = DateFormat('HH:mm').format(date);
    return formattedTime;
  }

  var _timer;
  var loading = false;
  late DateFormat dateformat;

  getmessage() async {
    _appProvider = Provider.of<AppProvider>(context, listen: false);
    setState(() {
      loading = true;
    });
    await FireBaseService(appProvider: _appProvider)
        .getMessage()
        .then((response) {
      if (response?.statusCode == 200) {
        setState(() {
          loading = false;
        });
        var data = json.decode(response!.body);

        for (var item in data.keys) {
          setState(() {
            msg = Message(message: data[item]["message"], key: item);
          });
        }
      }
    });
  }

  getTripsHandler() async {
    _appProvider = Provider.of<AppProvider>(context, listen: false);

    setState(() {
      loading = true;
    });

    await FireBaseService(appProvider: _appProvider)
        .getDataFromFireBase()
        .then((response) {
      setState(() {
        loading = false;
      });
      if (response?.statusCode == 200) {
        _trips = [];
        var data = json.decode(response!.body);
        for (var item in data.keys) {
          var e = Trips(
              key: item,
              ligne: data[item]['ligne'],
              depart: data[item]['depart'],
              arDestination: data[item]['arDestination'],
              frDestination: data[item]['frDestination']);
          _trips.add(e);
        }
      }
      _appProvider.setTrips(_trips);
    });
  }

  @override
  void initState() {
    super.initState();
    addFormDepart.text = "";
    updateFormDepart.text = "";
    updateFormArDestination.text = '';
    updateFormFrDestination.text = '';

    getTripsHandler();
    getmessage();
    startTimer();
  }

  showAlert(BuildContext context, id) {
var length = _appProvider.getTrips().length;
print("len $length");
if( length > 1 )
 {
     showDialog(
      context: context,
      builder: (BuildContext context) { 
        return AlertDialog(
          title: const Text('SUPPRESSION'),
          content: const Text("Êtes-vous sûr de vouloir supprimer?"),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: const Text("OUI"),
                  onPressed: () {
                    //Put your code here which you want to execute on Yes button click.
                   if(length > 1) 
                    _deleteTrip(id, context);
             
                  },
                ),
                TextButton(
                  child: const Text("ANNULER"),
                  style: TextButton.styleFrom(
                    primary: Colors.red,
                  ),
                  onPressed: () {
                    //Put your code here which you want to execute on Cancel button click.
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
 else {
  showDialog(
      context: context,
      builder: (BuildContext context) { 
       return   AlertDialog(
          title: const Text('SUPPRESSION'),
          content: const Text("Vous ne pouvez pas supprimer le dernier voyage"),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: const Text("OUI"),
                  onPressed: () {
                    //Put your code here which you want to execute on Yes button click.
                   
                   Navigator.pop(context);
                  },
                ),
           
              ],
            ),
          ],
        );
      });

 }
 
  }

  _deleteTrip(key, ctx) async {
    setState(() {
      loading = true;
    });
    await FireBaseService(appProvider: _appProvider)
        .DeleteDataInFireBase(key)
        .then((value) => {
              setState(() {
                loading = false;
              }),
              if (value!.statusCode == 200)
                {
                  Navigator.of(ctx).pop(),
                  _appProvider.removeTrip(key),
                  setState(() {
                    showActionBar = false;
                  }),
                }
            })
        .catchError((err) => {
              showError(err, ctx),
            });
  }

  showError(err, ctx) {
    showDialog<String>(
      context: ctx,
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
              setState(() {
                loading = false;
              }),
              Navigator.pop(ctx),
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  editTrip(Trips item) {
    updateFormLigne.text = item.ligne;
    updateFormArDestination.text = item.arDestination;
    updateFormFrDestination.text = item.frDestination;

    updateFormDepart.text = getTime(item.depart);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: const Text("Modifier"),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Form(
                        key: updateFormKey,
                        child: Column(
                          /* mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,*/
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: TextFormField(
                                controller: updateFormDepart,
                                textInputAction: TextInputAction
                                    .next, //editing controller of this TextField
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    //icon of text field
                                    labelText: "Depart",
                                    hintText: getTime(
                                        item.depart) //label text of field
                                    ),
                                readOnly: true,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                        errorText: "Obligatoire * "),
                                    //  EmailValidator(errorText: "Enter valid email id"),
                                  ],
                                ), //set it true, so that user will not able to edit text
                                onTap: () async {
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    initialTime: TimeOfDay.now(),
                                    cancelText: "Annuler",
                                    confirmText: "OK",
                                    helpText: "Selectionner l'heure de depart",
                                    hourLabelText: "Heure",
                                    context: context,
                                  );

                                  if (pickedTime != null) {
                                    print(
                                        "pickedTimeFormat:${pickedTime.format(context)}");

                                    DateTime parsedTime = DateFormat.Hm().parse(
                                        pickedTime.format(context).toString());
                                    //converting to DateTime so that we can further format on different pattern.
                                    print("parsedTime:$parsedTime");

                                    updateStartTimeTimeStamp = DateFormat.Hm()
                                        .parse(pickedTime.format(context))
                                        .microsecondsSinceEpoch; //output 1970-01-01 22:53:00.000
                                    String formattedTime =
                                        DateFormat('HH:mm').format(parsedTime);
                                    print(
                                        "formattedTime:$formattedTime"); //output 14:59:00
                                    //DateFormat() is from intl package, you can format the time on any pattern you need.

                                    setState(() {
                                      updateFormDepart.text =
                                          formattedTime; //set the value of text field.
                                    });
                                  } else {
                                    print("Heure non selectionnée");
                                  }
                                },
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: TextFormField(
                                //autovalidate: true,
                                controller: updateFormFrDestination,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "DESTINATION FR ",
                                ),
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                        errorText: "Obligatoire * "),
                                    //  EmailValidator(errorText: "Enter valid email id"),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: TextFormField(
                                //autovalidate: true,
                                controller: updateFormArDestination,
                                textInputAction: TextInputAction.next,

                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "DESTINATION AR ",
                                ),
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                        errorText: "Obligatoire * "),
                                    //  EmailValidator(errorText: "Enter valid email id"),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: TextFormField(
                                //autovalidate: true,
                                controller: updateFormLigne,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Ligne",
                                ),
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                        errorText: "Obligatoire * "),
                                    //  EmailValidator(errorText: "Enter valid email id"),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton(
                    onPressed: () async {
                      if (updateFormKey.currentState!.validate()) {
                        if (updateFormLigne.text.isEmpty ||
                            updateFormDepart.text.isEmpty ||
                            updateFormArDestination.text.isEmpty ||
                            updateFormFrDestination.text.isEmpty) {
                          print('FormUpdateIsEmpty');
                        } else {
                          var timestamp = item.depart;

                          var tripData = {
                            'ligne': updateFormLigne.text,
                            'depart': updateStartTimeTimeStamp == 0
                                ? timestamp
                                : updateStartTimeTimeStamp,
                            'frDestination': updateFormFrDestination.text,
                            'arDestination': updateFormArDestination.text
                          };
                          _updateTrip(tripData, item.key, context);

                          Navigator.of(context).pop();
                        }
                      }
                    },
                    child: const Text(
                      "Confirmer",
                      style: TextStyle(color: Colors.blue, fontSize: 18),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Annuler",
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  _updateTrip(data, key, ctx) async {
    print("data $data");
    setState(() {
      loading = true;
    });
    await FireBaseService(appProvider: _appProvider)
        .putDataInFireBase(data, key)
        .then((value) => {
              setState(() {
                loading = false;
              }),
              if (value!.statusCode == 200)
                {
                  _appProvider.updateTrip(
                    key,
                    Trips(
                        depart: data["depart"],
                        ligne: data['ligne'],
                        arDestination: data["arDestination"],
                        frDestination: data["frDestination"]),
                  ),
                  updateFormLigne.clear(),
                  updateFormDepart.clear(),
                  updateFormArDestination.clear(),
                  updateFormFrDestination.clear(),
                  setState(() {
                    showActionBar = false;
                  }),
                  Navigator.pushNamed(
                    context,
                    '/trips',
                  ),

/*Navigator.push(
  context,
  PageRouteBuilder(pageBuilder: (_, __, ___) => Tabletrips()),
)*/
                }
            })
        .catchError((err) => {
              showError(err, ctx),
            });
  }

  addTrip() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: const Text("AJOUTER"),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Form(
                      key: updateFormKey,
                      child: Column(
                        /* mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,*/
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: TextFormField(
                              controller: addFormDepart,
                              textInputAction: TextInputAction
                                  .next, //editing controller of this TextField
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  //icon of text field
                                  labelText: "Depart" //label text of field
                                  ),
                              readOnly: true,
                              validator: MultiValidator(
                                [
                                  RequiredValidator(
                                      errorText: "Obligatoire * "),
                                  //  EmailValidator(errorText: "Enter valid email id"),
                                ],
                              ), //set it true, so that user will not able to edit text
                              onTap: () async {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  initialTime: TimeOfDay.now(),
                                  cancelText: "Annuler",
                                  confirmText: "OK",
                                  helpText: "Selectionner l'heure de depart",
                                  hourLabelText: "Heure",
                                  context: context,
                                );

                                if (pickedTime != null) {
                                  print(
                                      "pickedTimeFormat:${pickedTime.format(context)}");

                                  DateTime parsedTime = DateFormat.Hm().parse(
                                      pickedTime.format(context).toString());
                                  //converting to DateTime so that we can further format on different pattern.
                                  print("parsedTime:$parsedTime");
                                  addStartTimeTimeStamp = DateFormat.Hm()
                                      .parse(pickedTime.format(context))
                                      .microsecondsSinceEpoch; //output 1970-01-01 22:53:00.000
                                  String formattedTime =
                                      DateFormat('HH:mm').format(parsedTime);
                                  print(
                                      "formattedTime:$formattedTime"); //output 14:59:00
                                  //DateFormat() is from intl package, you can format the time on any pattern you need.

                                  setState(() {
                                    addFormDepart.text =
                                        formattedTime; //set the value of text field.
                                  });
                                } else {
                                  print("Heure non selectionnée");
                                }
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: TextFormField(
                              //autovalidate: true,
                              controller: addFormFrDestination,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "DESTINATION FR",
                              ),
                              validator: MultiValidator(
                                [
                                  RequiredValidator(
                                      errorText: "Obligatoire * "),
                                  //  EmailValidator(errorText: "Enter valid email id"),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: TextFormField(
                              //autovalidate: true,
                              controller: addFormArDestination,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "DESTINATION AR ",
                              ),
                              validator: MultiValidator(
                                [
                                  RequiredValidator(
                                      errorText: "Obligatoire * "),
                                  //  EmailValidator(errorText: "Enter valid email id"),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: TextFormField(
                              //autovalidate: true,
                              controller: addFormLigne,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "LIGNE ",
                              ),
                              validator: MultiValidator(
                                [
                                  RequiredValidator(
                                      errorText: "Obligatoire * "),
                                  //  EmailValidator(errorText: "Enter valid email id"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton(
                    onPressed: () async {
                      if (addFormLigne.text.isEmpty ||
                          addFormDepart.text.isEmpty ||
                          addFormArDestination.text.isEmpty ||
                          addFormFrDestination.text.isEmpty) {
                      } else {
                        var tripData = {
                          'ligne': addFormLigne.text,
                          'depart': addStartTimeTimeStamp,
                          'frDestination': addFormFrDestination.text,
                          'arDestination': addFormArDestination.text,
                        };
                        sendTrips(tripData, context);
                        Navigator.of(context).pop();

                        addFormLigne.clear();
                        addFormDepart.clear();
                        addFormArDestination.clear();
                        addFormFrDestination.clear();
                        addStartTimeTimeStamp = 0;
                      }
                    },
                    child: const Text(
                      "Confirmer",
                      style: TextStyle(color: Colors.blue, fontSize: 18),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Annuler",
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  sendTrips(data, ctx) async {
    print("$data");
    setState(() {
      loading = true;
    });
    await FireBaseService(appProvider: _appProvider)
        .sendDataToFireBase(data)
        .then((value) => {
              setState(() {
                loading = false;
              }),
              if (value.statusCode == 200)
                {
                  _appProvider.addTrip(
                    Trips(
                        depart: data["depart"],
                        ligne: data['ligne'],
                        arDestination: data["arDestination"],
                        frDestination: data["frDestination"]),
                  ),
                }
            })
        .catchError((err) => {
              showError(err, ctx),
            });
  }

  void startTimer() {
    /*   var toRemove = [];
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        var now = DateTime.now();
        dateformat = DateFormat("HH:mm");

        var nowHour = dateformat.format(now);
        var trips = _appProvider.getTrips();
        for (var element in trips) {
          if ((element.depart).compareTo(nowHour) == -1) {
            // _appProvider.removeTrip(element.key);
            toRemove.add(element.key);
          }
        }
        toRemove.forEach((element) {
          _appProvider.removeTrip(element);
        });
      },
    );*/
  }

  @override
  Widget build(BuildContext context) {
    SharedPreferences preferences;
    return Scaffold(
      appBar: AppBar(
        title: Consumer<AppProvider>(
          builder: (BuildContext context, value, Widget? child) {
            return Text("Afficheur ${value.displayerName}");
          },
        ),
        actions: [
/*
          ToggleButton(
          width: 200.0,
          height: 150.0,
          toggleBackgroundColor: Colors.bl,
          toggleBorderColor: (Colors.grey[350])!,
          toggleColor: (Colors.indigo[900])!,
          activeTextColor: Colors.white,
          inactiveTextColor: Colors.grey,
          leftDescription: 'FAVORITES',
          rightDescription: 'HISTORY',
          onLeftToggleActive: () {
            print('left toggle activated');
          },
          onRightToggleActive: () {
            print('right toggle activated');
          },
        ),*/

/*
 IconButton(
              onPressed: () {
               // addTrip();
               if(_appProvider.displayerName == "Medenine") {
                print("meddenine");
                 _appProvider.setFirebaseUrl("jerba");
               }
               else {
                                                                print("jerba");

                                _appProvider.setFirebaseUrl("medenine");

               }
                             
              },
              icon: const Icon(Icons.switch_left_sharp)),

      
      */
          /*    Switch(
              value: _isMedenine,
              onChanged: (val) async {
                setState(() => _isMedenine = !_isMedenine);
8

                if (_isMedenine == true) {
                  await _appProvider.setDisplyername("Medenine");
                  await _appProvider.setFirebaseUrl();
                  getTripsHandler();
                  getmessage();

                  // _appProvider.setFirebaseUrl("medenine");

                } else {
                  await _appProvider.setDisplyername("Jerba");
                  await _appProvider.setFirebaseUrl();

                  getTripsHandler();
                  getmessage();

                  //     _appProvider.setFirebaseUrl("jerba");

                }
                // toggle();
              }),

    */

          /*ToggleSwitch(
            minWidth: 90.0,
            cornerRadius: 20.0,
            activeBgColors: [
              [Colors.blue[200]!],
              [Colors.blue[200]!]
            ],
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.blue,
            inactiveFgColor: Colors.white,
            initialLabelIndex: 0,
            totalSwitches: 1,
            labels: const ['Jerba'],
            radiusStyle: true,
            onToggle: (index) {
              if (index == 0) {
                
                _appProvider.setDisplyername("Medenine");
                _appProvider.setFirebaseUrl();
             //    getTripsHandler();
         //     getmessage();
              } /*else {
                _appProvider.setDisplyername("Jerba");
                _appProvider.setFirebaseUrl();
              }
*/             
              getTripsHandler();
              getmessage();
              setState(() {
                  switchIndex = index;
                });
            },
          ),*/

/*
Switch(
              value: _isMedenine,
              onChanged: (val) async {
                setState(() => _isMedenine = !_isMedenine);
                if (_isMedenine == true) {
                  await _appProvider.setDisplyername("Medenine");
                  await _appProvider.setFirebaseUrl();
                  getTripsHandler();
                  getmessage();
                } else {
                  await _appProvider.setDisplyername("Jerba");
                  await _appProvider.setFirebaseUrl();
                  getTripsHandler();
                  getmessage();


                }

              }),

*/
          IconButton(
              onPressed: () {
                addTrip();
              },
              icon: const Icon(Icons.add)),
        ],
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
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.97,
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(color: Colors.black),
                  // padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsetsDirectional.only(start: 50),
                        width: MediaQuery.of(context).size.width * cl0width,
                        child: const Text('#',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * cl1width,
                        child: const Text("DEPART",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * cl2width,
                        child: const Text("LIGNE",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * cl3width,
                        child: const Text("DESTINATION FR ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * cl4width,
                        child: const Text("DESTINATION AR",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.black54,
                    child: Consumer<AppProvider>(
                      builder: (_, data, __) => Stack(
                        children: [
                          ListView.builder(
                          itemCount: data.getTrips().length,
                          itemBuilder: (context, i) {
                            return Row(children: [
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * cl0width,
                                child: PopupMenuButton<String>(
                                    onSelected: (String item) async {
                                      if (item == "edit") {
                                        editTrip(data.getTrips()[i]);
                                      }
                      
                                      if (item == "delete") {
                                        /*  await _deleteTrip(
                                                data.getTrips()[i].key, context);*/
                                        showAlert(
                                            context, data.getTrips()[i].key);
                                      }
                                    },
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry<String>>[
                                          const PopupMenuItem<String>(
                                            value: "edit",
                                            child: Text('Edit'),
                                          ),
                                          const PopupMenuItem<String>(
                                            value: "delete",
                                            child: Text('Supprimer'),
                                          ),
                                        ]),
                                // Text("hellos"),
                              ),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      cl1width,
                                  child: Text(getTime(data.getTrips()[i].depart),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          letterSpacing: 1,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFFFF8C00)))),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      cl2width,
                                  child: Text(data.getTrips()[i].ligne.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          letterSpacing: 1,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255)))),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      cl3width,
                                  child: Text(
                                      data.getTrips()[i].frDestination.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          letterSpacing: 1,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255)))),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      cl4width,
                                  child: Text(
                                      data.getTrips()[i].arDestination.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          letterSpacing: 1,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Color.fromARGB(255, 14, 235, 32)))),
                            ]);
                          },
                        ),
                   
                   if(data.getTrips().isEmpty)
                    const Center(child: Text("il n'y a pas de voyages"),)
                ]  ),
                    ),
                  ),
                ),
                Tablefooter(message: msg),
              ],
            ),
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
    );
  }
}
