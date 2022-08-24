import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

import '../Services/FireBaseService.dart';
import '../models/Message.dart';
import '../providers/app_provider.dart';
import 'AnimatedTextFooter.dart';


class Tablefooter extends StatefulWidget {
    
    late  Message message ;
     Tablefooter({Key? key, required this.message, }) : super(key: key);
  @override

  State<Tablefooter> createState() => _TablefooterState();
}

class _TablefooterState extends State<Tablefooter> {
late  bool loading=false;
 // late  Message  msg=Message(message: "الشركة الجهوية للنقل بمدنين تتمنى لحرفائها الكرام سفرة ممتعة");
  final messageFormInput=  TextEditingController();
  late AppProvider _appProvider;
  

  messageInput(ctx) {
        messageFormInput.text=widget.message.message;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: const Text("MESSAGE"),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Form(
                      child: Column(
                        /* mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,*/
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: TextFormField(
                              //autovalidate: true,
 minLines: 6, // any number you need (It works as the rows for the textarea)
   keyboardType: TextInputType.multiline,
   maxLines: null,
                              controller: messageFormInput,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Message",
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
                      if (messageFormInput.text.isEmpty ) {
                      } else {
                  _updateMessage({"message":messageFormInput.text.trim()},widget.message.key,ctx);
                        Navigator.of(context).pop();
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
  
getmessage() async {
      _appProvider = Provider.of<AppProvider>(context, listen: false);
        setState(() {
          loading = true;
        });
    await FireBaseService(appProvider: _appProvider)
        .getMessage().then((response) {
 if (response?.statusCode == 200) {
  setState(() {
          loading = false;
        });
        var data = json.decode(response!.body);
          print("response footer ${data}");

   /*     for (var item in data.keys) {
   
 setState(() {
//msg= Message(message: data[item]["message"], key:item );
 });

        }
        */
      }
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


  _updateMessage(data, key, ctx) async {
    setState(() {
      loading = true;
    });
    print("data ${data} key $key");
    await FireBaseService(appProvider: _appProvider)
        .putMessage(data, key)
        .then((value) => {
          print("${value.body}"),
              setState(() {
                loading = false;
              }),
              if (value!.statusCode == 200)
                {
                 setState(() {
widget.message=Message(message: data["message"],key: key);
              }),
                  
                       }
            })
        .catchError((err) => {
              showError(err, ctx),
            });
            
  }



@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getmessage();

  }

  @override
  Widget build(BuildContext context) {
    return  
        GestureDetector(
        onTap: () {       
    messageInput(context);
        },
        child: Container(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,  
                    child:
                    buildAnimatedTextFooter(widget.message.message.trim(),context),
                   /*  Container(
                    color: Colors.amberAccent,height: 40,
                    width: MediaQuery.of(context).size.width,
                    child: Text(msg.message),
                    ),*/
                  ),
                
              ),
            ),
      
      );
        
  }
}