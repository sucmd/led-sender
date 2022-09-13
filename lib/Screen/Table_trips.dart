import 'dart:async';
import 'dart:convert';

import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:srtm/Widget/Footer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:srtm/models/service.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../Services/FireBaseService.dart';
import '../Widget/updateDialog.dart';
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

  double cl1width = 0.05;

  double cl2width = 0.2;
  double cl3width = 0.2;
  double cl4width = 0.1;

  double cl5width = 0.1;
  double cl6width = 0.1;
  double cl7width = 0.1;
  double cl8width = 0.1;

  bool showActionBar = false;
//////////////// update controllers ///////////////
  final updateFormKey = GlobalKey<FormState>();
  final updateFormBus = TextEditingController();
  final TextEditingController updateFormDepart = TextEditingController();
  final updateFormVoyage = TextEditingController();
  final updateFormFrVoyage = TextEditingController();

  final updateFormStatusFr = TextEditingController();

  final updateFormStatus = TextEditingController();

  final updateFormArrive = TextEditingController();
/////////////////// add controllers ////////////////
  final addFormKey = GlobalKey<FormState>();
  final addFormbus = TextEditingController();
  final addFormvoyage = TextEditingController();
  final addFormvoyage_fr = TextEditingController();

  Service addService = Service(
    Friday: false,
    Monday: false,
    Saturday: false,
    Sunday: false,
    Thursday: false,
    Tuesday: false,
    Wednesday: false,
  );

  final TextEditingController addFormDepart = TextEditingController();
  final TextEditingController addFormArrive = TextEditingController();

  final TextEditingController addFormStatus = TextEditingController();

  final TextEditingController addFormStatus_fr = TextEditingController();

/////////////////////////////////////////////////////
  late int addStartTimeTimeStamp = 0;
  late int updateStartTimeTimeStamp = 0;

  bool _isMedenine = true;
  bool lundi = false;
  late Message msg = Message(
      message: "الشركة الجهوية للنقل بمدنين تتمنى لحرفائها الكرام سفرة ممتعة");

  late int? switchIndex = 0;

  late int updateEndTimeTimeStamp = 0;

  late int addArriveTimeTimeStamp = 0;

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
            bus: data[item]['bus'],
            service: Service(
                Friday: data[item]["services"]["Friday"],
                Monday: data[item]["services"]["Monday"],
                Saturday: data[item]["services"]["Saturday"],
                Sunday: data[item]["services"]["Sunday"],
                Thursday: data[item]["services"]["Thursday"],
                Tuesday: data[item]["services"]["Tuesday"],
                Wednesday: data[item]["services"]["Wednesday"]),
            status: data[item]["status"],
            status_fr: data[item]["status_fr"],
            t_arrivee: data[item]["t_arrivee"],
            t_depart: data[item]["t_depart"],
            voyage: data[item]["voyage"],
            voyage_fr: data[item]["voyage_fr"],
          );
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
    updateFormVoyage.text = '';
    updateFormFrVoyage.text = '';

    getTripsHandler();
    getmessage();
    startTimer();
  }

  showAlert(BuildContext context, id) {
    var length = _appProvider.getTrips().length;
    print("len $length");
    if (length > 1) {
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
                      if (length > 1) _deleteTrip(id, context);
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
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('SUPPRESSION'),
              content:
                  const Text("Vous ne pouvez pas supprimer le dernier voyage"),
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
    updateFormBus.text = item.bus;
    updateFormVoyage.text = item.voyage;
    updateFormFrVoyage.text = item.voyage_fr;
    updateFormDepart.text = getTime(item.t_depart);
    updateFormArrive.text = getTime(item.t_arrivee);
    updateFormStatus.text = item.status;
    updateFormStatusFr.text = item.status_fr;
    // monday = item.service.Monday;
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
                            Accordion(children: [
                              AccordionSection(
                                  isOpen: true,
                                  header: const Text("Voyage"),
                                  content: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: TextFormField(
                                          //autovalidate: true,
                                          controller: updateFormBus,
                                          textInputAction: TextInputAction.next,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: "bus",
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
                                          controller: updateFormFrVoyage,
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
                                          controller: updateFormVoyage,
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
                                              hintText: getTime(item
                                                  .t_depart) //label text of field
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
                                            TimeOfDay? pickedTime =
                                                await showTimePicker(
                                              initialTime: TimeOfDay.now(),
                                              cancelText: "Annuler",
                                              confirmText: "OK",
                                              helpText:
                                                  "Selectionner l'heure de depart",
                                              hourLabelText: "Heure",
                                              context: context,
                                            );

                                            if (pickedTime != null) {
                                              print(
                                                  "pickedTimeFormat:${pickedTime.format(context)}");

                                              DateTime parsedTime =
                                                  DateFormat.Hm().parse(
                                                      pickedTime
                                                          .format(context)
                                                          .toString());
                                              //converting to DateTime so that we can further format on different pattern.
                                              print("parsedTime:$parsedTime");

                                              updateStartTimeTimeStamp = DateFormat
                                                      .Hm()
                                                  .parse(pickedTime
                                                      .format(context))
                                                  .microsecondsSinceEpoch; //output 1970-01-01 22:53:00.000
                                              String formattedTime =
                                                  DateFormat('HH:mm')
                                                      .format(parsedTime);
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
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: TextFormField(
                                          controller: updateFormArrive,
                                          textInputAction: TextInputAction
                                              .next, //editing controller of this TextField
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              //icon of text field
                                              labelText: "Arrivee",
                                              hintText: getTime(item
                                                  .t_arrivee) //label text of field
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
                                            TimeOfDay? pickedTime =
                                                await showTimePicker(
                                              initialTime: TimeOfDay.now(),
                                              cancelText: "Annuler",
                                              confirmText: "OK",
                                              helpText:
                                                  "Selectionner l'heure de depart",
                                              hourLabelText: "Heure",
                                              context: context,
                                            );

                                            if (pickedTime != null) {
                                              print(
                                                  "pickedTimeFormat:${pickedTime.format(context)}");

                                              DateTime parsedTime =
                                                  DateFormat.Hm().parse(
                                                      pickedTime
                                                          .format(context)
                                                          .toString());
                                              //converting to DateTime so that we can further format on different pattern.
                                              print("parsedTime:$parsedTime");

                                              updateEndTimeTimeStamp = DateFormat
                                                      .Hm()
                                                  .parse(pickedTime
                                                      .format(context))
                                                  .microsecondsSinceEpoch; //output 1970-01-01 22:53:00.000
                                              String formattedTime =
                                                  DateFormat('HH:mm')
                                                      .format(parsedTime);
                                              print(
                                                  "formattedTime:$formattedTime"); //output 14:59:00
                                              //DateFormat() is from intl package, you can format the time on any pattern you need.

                                              setState(() {
                                                updateFormArrive.text =
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
                                          controller: updateFormStatus,
                                          textInputAction: TextInputAction.next,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: "Status",
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
                                          controller: updateFormStatusFr,
                                          textInputAction: TextInputAction.next,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: "Status  fr ",
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
                              AccordionSection(
                                  headerBackgroundColor: Colors.red,
                                  headerBackgroundColorOpened: Colors.red,
                                  contentBorderColor: Colors.red,
                                  header: const Text("Service"),
                                  content: StatefulBuilder(
                                      builder: (context, setState) {
                                    return Wrap(
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Text("Lundi"),
                                                Checkbox(
                                                  value: item.service.Monday,
                                                  onChanged: (value) {
                                                    print("value is $value");
                                                    setState(() => {
                                                          item.service.Monday =
                                                              value!
                                                        });
                                                  },
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Text("Mardi"),
                                                Checkbox(
                                                  value: item.service.Tuesday,
                                                  onChanged: (value) {
                                                    print("value is $value");
                                                    setState(() => {
                                                          item.service.Tuesday =
                                                              value!
                                                        });
                                                  },
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Text("Mercredi"),
                                                Checkbox(
                                                  value: item.service.Wednesday,
                                                  onChanged: (value) {
                                                    print("value is $value");
                                                    setState(() => {
                                                          item.service
                                                                  .Wednesday =
                                                              value!
                                                        });
                                                  },
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Text("Jeudi"),
                                                Checkbox(
                                                  value: item.service.Thursday,
                                                  onChanged: (value) {
                                                    print("value is $value");
                                                    setState(() => {
                                                          item.service
                                                              .Thursday = value!
                                                        });
                                                  },
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Text("Vendredi"),
                                                Checkbox(
                                                  value: item.service.Friday,
                                                  onChanged: (value) {
                                                    print("value is $value");
                                                    setState(() => {
                                                          item.service.Friday =
                                                              value!
                                                        });
                                                  },
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Text("Samedi"),
                                                Checkbox(
                                                  value: item.service.Saturday,
                                                  onChanged: (value) {
                                                    print("value is $value");
                                                    setState(() => {
                                                          item.service
                                                              .Saturday = value!
                                                        });
                                                  },
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Text("Dimanche"),
                                                Checkbox(
                                                  value: item.service.Sunday,
                                                  onChanged: (value) {
                                                    print("value is $value");
                                                    setState(() => {
                                                          item.service.Sunday =
                                                              value!
                                                        });
                                                  },
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    );
                                  }))
                            ])
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
                        if (updateFormBus.text.isEmpty ||
                            updateFormDepart.text.isEmpty ||
                            updateFormArrive.text.isEmpty ||
                            updateFormVoyage.text.isEmpty ||
                            updateFormFrVoyage.text.isEmpty ||
                            updateFormStatus.text.isEmpty ||
                            updateFormStatusFr.text.isEmpty) {
                          print('FormUpdateIsEmpty');
                        } else {
                          var timestamp = item.t_depart;
                          var arrivee = item.t_arrivee;

                          var tripData = {
                            'bus': updateFormBus.text,
                            't_depart': updateStartTimeTimeStamp == 0
                                ? timestamp
                                : updateStartTimeTimeStamp,
                            't_arrivee': updateEndTimeTimeStamp == 0
                                ? arrivee
                                : updateEndTimeTimeStamp,
                            'status': updateFormStatus.text,
                            'status_fr': updateFormStatusFr.text,
                            'voyage_fr': updateFormFrVoyage.text,
                            'voyage': updateFormVoyage.text,
                            'services': {
                              "Monday": item.service.Monday,
                              "Tuesday": item.service.Tuesday,
                              "Wednesday": item.service.Wednesday,
                              "Thursday": item.service.Thursday,
                              "Friday": item.service.Friday,
                              "Saturday": item.service.Saturday,
                              "Sunday": item.service.Sunday
                            }
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
                      t_depart: data["depart"],
                      bus: data['bus'],
                      voyage: data["voyage"],
                      voyage_fr: data["voyage_fr"],
                      status: data["status"],
                      status_fr: data["status_fr"],
                      t_arrivee: data["t_arrive"],

                      ///////////// update this methode //////////
                      service: data['services'],
                    ),
                  ),
                  updateFormBus.clear(),
                  updateFormDepart.clear(),
                  updateFormVoyage.clear(),
                  updateFormFrVoyage.clear(),
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
                        children: [
                          Accordion(
                            children: [
                              AccordionSection(
                                isOpen: true,
                                header: const Text("Voyage"),
                                content: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: TextFormField(
                                        //autovalidate: true,
                                        controller: addFormbus,
                                        textInputAction: TextInputAction.next,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: "bus ",
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
                                        controller: addFormvoyage_fr,
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
                                        controller: addFormvoyage,
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
                                            labelText:
                                                "Depart" //label text of field
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
                                          TimeOfDay? pickedTime =
                                              await showTimePicker(
                                            initialTime: TimeOfDay.now(),
                                            cancelText: "Annuler",
                                            confirmText: "OK",
                                            helpText:
                                                "Selectionner l'heure de depart",
                                            hourLabelText: "Heure",
                                            context: context,
                                          );

                                          if (pickedTime != null) {
                                            print(
                                                "pickedTimeFormat:${pickedTime.format(context)}");

                                            DateTime parsedTime =
                                                DateFormat.Hm().parse(pickedTime
                                                    .format(context)
                                                    .toString());
                                            //converting to DateTime so that we can further format on different pattern.
                                            print("parsedTime:$parsedTime");
                                            addStartTimeTimeStamp = DateFormat
                                                    .Hm()
                                                .parse(
                                                    pickedTime.format(context))
                                                .microsecondsSinceEpoch; //output 1970-01-01 22:53:00.000
                                            String formattedTime =
                                                DateFormat('HH:mm')
                                                    .format(parsedTime);
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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: TextFormField(
                                        controller: addFormArrive,
                                        textInputAction: TextInputAction
                                            .next, //editing controller of this TextField
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            //icon of text field
                                            labelText:
                                                "Arrive" //label text of field
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
                                          TimeOfDay? pickedTime =
                                              await showTimePicker(
                                            initialTime: TimeOfDay.now(),
                                            cancelText: "Annuler",
                                            confirmText: "OK",
                                            helpText:
                                                "Selectionner l'heure de depart",
                                            hourLabelText: "Heure",
                                            context: context,
                                          );

                                          if (pickedTime != null) {
                                            print(
                                                "pickedTimeFormat:${pickedTime.format(context)}");

                                            DateTime parsedTime =
                                                DateFormat.Hm().parse(pickedTime
                                                    .format(context)
                                                    .toString());
                                            //converting to DateTime so that we can further format on different pattern.
                                            print("parsedTime:$parsedTime");
                                            addArriveTimeTimeStamp = DateFormat
                                                    .Hm()
                                                .parse(
                                                    pickedTime.format(context))
                                                .microsecondsSinceEpoch; //output 1970-01-01 22:53:00.000
                                            String formattedTime =
                                                DateFormat('HH:mm')
                                                    .format(parsedTime);
                                            print(
                                                "formattedTime:$formattedTime"); //output 14:59:00
                                            //DateFormat() is from intl package, you can format the time on any pattern you need.

                                            setState(() {
                                              addFormArrive.text =
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
                                        controller: addFormStatus,
                                        textInputAction: TextInputAction.next,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: "Status",
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
                                        controller: addFormStatus_fr,
                                        textInputAction: TextInputAction.next,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: "Status FR ",
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
                              AccordionSection(
                                  headerBackgroundColor: Colors.red,
                                  headerBackgroundColorOpened: Colors.red,
                                  contentBorderColor: Colors.red,
                                  header: const Text("Service"),
                                  content: StatefulBuilder(
                                      builder: (context, setState) {
                                    return Wrap(
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Text("Lundi"),
                                                Checkbox(
                                                  value: addService.Monday,
                                                  onChanged: (value) {
                                                    setState(() => {
                                                          addService.Monday =
                                                              value!
                                                        });
                                                  },
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Text("Mardi"),
                                                Checkbox(
                                                  value: addService.Tuesday,
                                                  onChanged: (value) {
                                                    setState(() => {
                                                          addService.Tuesday =
                                                              value!
                                                        });
                                                  },
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Text("Mercredi"),
                                                Checkbox(
                                                  value: addService.Wednesday,
                                                  onChanged: (value) {
                                                    print("value is $value");
                                                    setState(() => {
                                                          addService.Wednesday =
                                                              value!
                                                        });
                                                  },
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Text("Jeudi"),
                                                Checkbox(
                                                  value: addService.Thursday,
                                                  onChanged: (value) {
                                                    setState(() => {
                                                          addService.Thursday =
                                                              value!
                                                        });
                                                  },
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Text("Vendredi"),
                                                Checkbox(
                                                  value: addService.Friday,
                                                  onChanged: (value) {
                                                    setState(() => {
                                                          addService.Friday =
                                                              value!
                                                        });
                                                  },
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Text("Samedi"),
                                                Checkbox(
                                                  value: addService.Saturday,
                                                  onChanged: (value) {
                                                    print("value is $value");
                                                    setState(() => {
                                                          addService.Saturday =
                                                              value!
                                                        });
                                                  },
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Text("Dimanche"),
                                                Checkbox(
                                                  value: addService.Sunday,
                                                  onChanged: (value) {
                                                    print("value is $value");
                                                    setState(() => {
                                                          addService.Sunday =
                                                              value!
                                                        });
                                                  },
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    );
                                  }))
                            ],
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
                      if (addFormbus.text.isEmpty ||
                          addFormDepart.text.isEmpty ||
                          addFormvoyage.text.isEmpty ||
                          addFormvoyage_fr.text.isEmpty ||
                          addFormArrive.text.isEmpty ||
                          addFormStatus.text.isEmpty ||
                          addFormStatus_fr.text.isEmpty) {
                      } else {
                        var tripData = {
                          'bus': addFormbus.text,
                          't_depart': addStartTimeTimeStamp,
                          'voyage_fr': addFormvoyage_fr.text,
                          'voyage': addFormvoyage.text,
                          "t_arrivee": addArriveTimeTimeStamp,
                          "status_fr": addFormStatus.text,
                          'status': addFormStatus_fr.text,
                          "services": {
                            "Monday": addService.Monday,
                            'Tuesday': addService.Tuesday,
                            "Wednesday": addService.Wednesday,
                            "Thursday": addService.Thursday,
                            "Friday": addService.Friday,
                            "Saturday": addService.Saturday,
                            "Sunday": addService.Sunday
                          }
                        };

                        sendTrips(tripData, context);
                        Navigator.of(context).pop();

                        addFormbus.clear();
                        addFormDepart.clear();
                        addFormvoyage.clear();
                        addFormvoyage_fr.clear();
                        addFormArrive.clear();
                        addFormStatus.clear();
                        addFormStatus_fr.clear();
                        addService = Service(
                            Friday: false,
                            Monday: false,
                            Saturday: false,
                            Sunday: false,
                            Thursday: false,
                            Tuesday: false,
                            Wednesday: false);
                        addArriveTimeTimeStamp = 0;
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
    print(" add $data");

    print("service ${data['services']}");

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
                        t_depart: data["t_depart"],
                        bus: data['bus'],
                        voyage: data["voyage"],
                        voyage_fr: data["voyage_fr"],
                        status: data["status"],
                        status_fr: data["status_fr"],
                        t_arrivee: data["t_arrivee"],
                        service: Service(
                          Friday: data["services"]['Friday'],
                          Monday: data["services"]['Monday'],
                          Saturday: data["services"]['Saturday'],
                          Sunday: data["services"]['Sunday'],
                          Thursday: data["services"]['Thursday'],
                          Tuesday: data["services"]['Tuesday'],
                          Wednesday: data["services"]['Wednesday'],
                        )),
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
                        child: const Text("bus",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * cl2width,
                        child: const Text("DESTINATION FR ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * cl3width,
                        child: const Text("DESTINATION AR",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * cl4width,
                        child: const Text("DEPART",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * cl5width,
                        child: const Text("ARRIVEE",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * cl6width,
                        child: const Text("STATUS",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * cl7width,
                        child: const Text("STATUS FR",
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
                      builder: (_, data, __) => Stack(children: [
                        ListView.builder(
                          itemCount: data.getTrips().length,
                          itemBuilder: (context, i) {
                            return Row(children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    cl0width,
                                child: PopupMenuButton<String>(
                                    onSelected: (String item) async {
                                      if (item == "edit") {
                                        editTrip(data.getTrips()[i]);
                                        /*                                    
Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>  UpdateDialog(item:data.getTrips()[i] )),
  );*/

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
                                  child: Text(data.getTrips()[i].bus.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          letterSpacing: 1,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255)))),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      cl2width,
                                  child: Text(
                                      data.getTrips()[i].voyage_fr.toString(),
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
                                  data.getTrips()[i].voyage.toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    letterSpacing: 1,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 14, 235, 32),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    cl4width,
                                child: Text(
                                  getTime(data.getTrips()[i].t_depart),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    letterSpacing: 1,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 14, 235, 32),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    cl5width,
                                child: Text(
                                  getTime(data.getTrips()[i].t_arrivee),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    letterSpacing: 1,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 14, 235, 32),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    cl6width,
                                child: Text(
                                  data.getTrips()[i].status.toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    letterSpacing: 1,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 14, 235, 32),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    cl7width,
                                child: Text(
                                  data.getTrips()[i].status_fr.toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    letterSpacing: 1,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 14, 235, 32),
                                  ),
                                ),
                              ),
                            ]);
                          },
                        ),
                        if (data.getTrips().isEmpty)
                          const Center(
                            child: Text("il n'y a pas de voyages"),
                          )
                      ]),
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
