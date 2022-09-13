import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:srtm/providers/app_provider.dart';

import '../Services/FireBaseService.dart';
import '../models/service.dart';
import '../models/trips.dart';

class UpdateDialog extends StatefulWidget {
  final  Trips item ;
   UpdateDialog({Key? key, required this.item}) : super(key: key);

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
late AppProvider _appProvider;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
        _appProvider = Provider.of<AppProvider>(context, listen: false);

  }

final updateFormVoyage = TextEditingController();
  final updateFormKey = GlobalKey<FormState>();
  final updateFormBus = TextEditingController();
  final TextEditingController updateFormDepart = TextEditingController();
  final updateFormFrVoyage = TextEditingController();
  final updateFormStatusFr = TextEditingController();
  final updateFormStatus = TextEditingController();
  final updateFormArrive = TextEditingController();

    late int addStartTimeTimeStamp = 0;
  late int updateStartTimeTimeStamp = 0;
  bool showActionBar = false;

  bool? lundi = false;

getTime(int? timeStamp) {
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(timeStamp!);
    String formattedTime = DateFormat('HH:mm').format(date);
    return formattedTime;
  }

 _updateTrip(data, key, ctx) async {
    print("data $data");
    setState(() {
      //loading = true;
    });
    await FireBaseService(appProvider: _appProvider)
        .putDataInFireBase(data, key)
        .then((value) => {
              setState(() {
            //    loading = false;
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
                      status: "jkjk",
                      status_fr: "jghfyt",
                      t_arrivee: 121021,

                      ///////////// update this methode //////////
                      service: Service(
                          Friday: true,
                          Monday: true,
                          Saturday: true,
                          Sunday: true,
                          Thursday: true,
                          Tuesday: true,
                          Wednesday: true),
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
             // showError(err, ctx),
            });
  }


  @override
  Widget build(BuildContext context) {
        return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: const Text("Modifier"),
            content: StatefulBuilder(builder: 
              (context, setState) {
              return SizedBox(
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

 Row(
                                        children: [
                                        const   Text("Lundi"),
                                          Checkbox(
                                            value: lundi,                                        
                                            onChanged: (value) {
                                              print("value is $value");
                                              setState(() => { 
                                                lundi= value,
                                               // widget.item.service.Monday = value
                                                });
                                            },
                                          )
                                        ],
                                      ) ,

                                     
                          ],
                        ),),
                    
                        
                  ],
                ),
              ),
            );
          
            } ,),
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
                          var timestamp = widget.item.t_depart;

                          var tripData = {
                            'bus': updateFormBus.text,
                            'depart': updateStartTimeTimeStamp == 0
                                ? timestamp
                                : updateStartTimeTimeStamp,
                            'status': updateFormStatus.text,
                            'status_fr': updateFormStatusFr.text,
                            'voyage_fr': updateFormFrVoyage.text,
                            'voyage': updateFormVoyage.text
                          };
                          _updateTrip(tripData, widget.item.key, context);

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
      
    
  }
}