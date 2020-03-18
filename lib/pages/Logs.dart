
import 'package:dailer/database/LogsDatabase.dart';
import 'package:dailer/models/Log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Logs extends StatefulWidget {
  Logs({Key key}) : super(key: key);

  @override
  _LogsState createState() => _LogsState();
}

class _LogsState extends State<Logs> {



  @override
  void initState() {
    getCallSettings();
    super.initState();
  }

  String phoneNumber;
  final dbHelper = LogsDatabase.instance;
  List<Log> logs;

  String cardNumber1 = '80043556';
  String cardNumber2 = '800505';

  int cardProvider;
  String selectedCardNumber = '';
  String userCardNumber = '';
  String userCountryCode = '';
  int userLanguage;

  var phoneController = new TextEditingController();

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
  
  _initCall(phoneNumber) async {
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
        _insert('Bob', phoneNumber);
        launch("tel://$callTo");
        // _makeCall();
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: FutureBuilder(
            future: dbHelper.queryAllRows(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                logs = snapshot.data.reversed.toList();
                return ListView.builder(
                  itemCount: logs == null ? 0 : logs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        _initCall(logs[index].phone.toString());
                      },
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            trailing: IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () {
                              dbHelper.delete(logs[index].id);
                              setState(() {
                                logs.removeAt(index);
                              });
                               Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text("Log removed from call history"),
                              ));
                                                    
                              
                            }),
                            leading: CircleAvatar(
                            backgroundColor: Colors.blueGrey,
                            child: Icon(Icons.call_made),
                          ),
                          title: Text(logs[index].phone.toString(), style: TextStyle(
                              fontSize: 18
                            ),),
                            subtitle: Text(logs[index].time.toString(), style: TextStyle(
                              fontSize: 15, color: Colors.blueGrey
                            )),
                          ),
                          Divider()
                        ],
                      ),
                    );
                  },
                );
              }

              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
       
      ),
    );
  }
}
