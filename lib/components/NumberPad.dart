import 'package:contact_picker/contact_picker.dart';
import 'package:dailer/database/FavouritesDatabase.dart';
import 'package:dailer/database/LogsDatabase.dart';
import 'package:dailer/pages/PickContact.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class NumberPad extends StatefulWidget {
  @override
  _NumberPadState createState() => _NumberPadState();
}

class _NumberPadState extends State<NumberPad> {
  static const platform = const MethodChannel('com.example.dailer/makeCall');
  String phoneNumber = '';
  String cardNumber1 = '80043556';
  String cardNumber2 = '800505';

  int cardProvider;
  String selectedCardNumber = '';
  String userCardNumber = '';
  String userCountryCode = '';
  int userLanguage;

  var phoneController = new TextEditingController();

  final ContactPicker _contactPicker = new ContactPicker();
  Contact _contact;

  getCallSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      cardProvider = prefs.getInt('cardProvider');
      if (cardProvider == 0) {
        selectedCardNumber = cardNumber1;
      } else {
        selectedCardNumber = cardNumber2;
      }
      userCardNumber = prefs.getString('cardNumber');
      userCountryCode = prefs.getString('userCountryCode');
      userLanguage = prefs.getInt('userLanguage') != null
          ? prefs.getInt('userLanguage') + 1
          : 0;
    });
  }

  @override
  void initState() {
    super.initState();
    getCallSettings();
  }

  _initCall() async {
    String callTo = '';
    if (phoneNumber != null) {
      if (userCardNumber == null || userCardNumber == '') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Oops!'),
            content: const Text(
                'You haven\'t added card settings yet. Please add your card settings.'),
            actions: <Widget>[
              FlatButton(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      } else {
        if (cardProvider == 0) {
          callTo = selectedCardNumber +
              ',,' +
              userLanguage.toString() +
              ',' +
              userCardNumber +
              '#,' +
              userCountryCode +
              phoneNumber +
              '#';
        } else {
          callTo = selectedCardNumber +
              ',' +
              userLanguage.toString() +
              ',' +
              userCardNumber +
              '#,,' +
              userCountryCode +
              phoneNumber +
              '#';
        }

        print(callTo);
        callTo = Uri.encodeComponent(callTo);

        launch("tel://$callTo");
        _insert('Bob', phoneNumber);
        // await new CallNumber().callNumber(callTo);
        // _makeCall();
      }
    }
  }

  final dbHelper = LogsDatabase.instance;

  void _insert(name, phone) async {
    // row to insert
    Map<String, dynamic> row = {
      LogsDatabase.columnName: name.toString(),
      LogsDatabase.columnPhone: phone.toString(),
      LogsDatabase.columnTime: DateFormat('kk:mm | dd-MM-yyyy').format(DateTime.now()),
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
     
  }

  void _pickContact() async {
    // final PermissionHandler _permissionHandler = PermissionHandler();
    // var result =
    //     await _permissionHandler.requestPermissions([PermissionGroup.contacts]);
    // if (result[PermissionGroup.contacts] == PermissionStatus.granted) {
    //   String result = await Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => PickContact()),
    //   );
    //   if (result != null) {
    //     if (result.length > 10) {
    //       result = result.trim().replaceAll(new RegExp(r'[^0-9]'), '');

    //       result = result.substring(result.length - 10);
    //     }
    //     setState(() {
    //       phoneNumber = result;
    //       phoneController.text = phoneNumber;
    //     });
    //   } else {
    //     Scaffold.of(context).showSnackBar(SnackBar(
    //       content: Text("Phone number not found"),
    //     ));
    //   }
    // }

    Contact contact = await _contactPicker.selectContact();
    setState(() {
         _contact = contact;
         var result = _contact.phoneNumber.toString();
         result = result.trim().replaceAll(new RegExp(r'[^0-9]'), '');
          print(result);
         phoneNumber = result;
         phoneController.text = phoneNumber;
                 
  });

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Center(
                child: Container(
                  child: TextField(
                    maxLines: 1,
                    showCursor: false,
                    textAlign: TextAlign.center,
                    focusNode: FirstDisabledFocusNode(),
                    style: TextStyle(fontSize: 22, color: Colors.black87),
                    controller: phoneController,
                    onChanged: (value) {
                      setState(() {
                        phoneNumber = value;
                      });
                    },
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: 32.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Table(
                children: <TableRow>[
                  TableRow(
                    children: ['1', '2', '3']
                        .map<Widget>((char) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RawMaterialButton(
                                elevation: 0,
                                fillColor: Colors.white,
                                padding: const EdgeInsets.all(18),
                                child: Text(char,
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54)),
                                onPressed: () {
                                  setState(() {
                                    phoneNumber = phoneNumber + char;
                                    phoneController.text = phoneNumber;
                                  });
                                },
                              ),
                            ))
                        .toList(),
                  ),
                  TableRow(
                    children: ['4', '5', '6']
                        .map<Widget>((char) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RawMaterialButton(
                                elevation: 0,
                                fillColor: Colors.white,
                                padding: const EdgeInsets.all(18),
                                child: Text(char,
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54)),
                                onPressed: () {
                                  setState(() {
                                    phoneNumber = phoneNumber + char;
                                    phoneController.text = phoneNumber;
                                  });
                                },
                              ),
                            ))
                        .toList(),
                  ),
                  TableRow(
                    children: ['7', '8', '9']
                        .map<Widget>((char) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RawMaterialButton(
                                elevation: 0,
                                fillColor: Colors.white,
                                padding: const EdgeInsets.all(18),
                                child: Text(char,
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54)),
                                onPressed: () {
                                  setState(() {
                                    phoneNumber = phoneNumber + char;
                                    phoneController.text = phoneNumber;
                                  });
                                },
                              ),
                            ))
                        .toList(),
                  ),
                  TableRow(
                    children: ['*', '0', '#']
                        .map<Widget>((char) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RawMaterialButton(
                                elevation: 0,
                                fillColor: Colors.white,
                                padding: const EdgeInsets.all(18),
                                child: Text(char,
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54)),
                                onPressed: () {
                                  setState(() {
                                    phoneNumber = phoneNumber + char;
                                    phoneController.text = phoneNumber;
                                  });
                                },
                              ),
                            ))
                        .toList(),
                  ),
                  TableRow(children: [
                    FloatingActionButton(
                        heroTag: '_pickContact',
                        backgroundColor: Colors.green,
                        child: Icon(Icons.contacts),
                        onPressed: () => _pickContact()),
                    FloatingActionButton(
                        heroTag: '_initCall',
                        child: Icon(Icons.phone),
                        onPressed: () => _initCall()),
                    FloatingActionButton(
                        heroTag: '_deleteChar',
                        backgroundColor: Colors.red,
                        child: Icon(Icons.backspace),
                        onPressed: () {
                          if (phoneNumber.length > 0) {
                            setState(() {
                              phoneNumber = phoneNumber.substring(
                                  0, phoneNumber.length - 1);
                              phoneController.text = phoneNumber;
                            });
                          }
                        }),
                  ]),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Delete button for phone number
class DeleteButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.backspace),
      onPressed: () => {},
    );
  }
}

class FirstDisabledFocusNode extends FocusNode {
  @override
  bool consumeKeyboardToken() {
    return false;
  }
}

/// Displays the entered phone number
class NumberReadout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        // border: BorderDirectional(bottom: BorderSide(color: darkBlue)),
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: <Widget>[
          DeleteButton(),
        ],
      ),
    );
  }
}
