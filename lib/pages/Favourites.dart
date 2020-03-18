
import 'package:contact_picker/contact_picker.dart';
import 'package:dailer/database/FavouritesDatabase.dart';
import 'package:dailer/database/LogsDatabase.dart';
import 'package:dailer/models/Favourite.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


class Favourites extends StatefulWidget {
  const Favourites({Key key}) : super(key: key);

  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  String phoneNumber;
  final dbHelper = FavouritesDatabase.instance;
  final dbHelperLogs = LogsDatabase.instance;
  List<Favourite> favourites;

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

  void _insertLog(name, phone) async {
    // row to insert
    Map<String, dynamic> row = {
      LogsDatabase.columnName: name.toString(),
      LogsDatabase.columnPhone: phone.toString(),
      LogsDatabase.columnTime: DateFormat('kk:mm | dd-MM-yyyy').format(DateTime.now()),
    };
    final id = await dbHelperLogs.insert(row);
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
        _insertLog('Bob', phoneNumber);
        launch("tel://$callTo");
        // _makeCall();
      }
    }
  }

  final ContactPicker _contactPicker = new ContactPicker();
  Contact _contact;

  void _pickContact() async {
    Contact contact = await _contactPicker.selectContact();
    setState(() {
         _contact = contact;
         var result = _contact.phoneNumber.toString();
         result = result.trim().replaceAll(new RegExp(r'[^0-9]'), '');
          print(result);
         phoneNumber = result;
        _insert(_contact.fullName.toString(), _contact.phoneNumber.toString());           
  });
  }

  void _insert(name, phone) async {
    // row to insert
    Map<String, dynamic> row = {
      FavouritesDatabase.columnName: name.toString(),
      FavouritesDatabase.columnPhone: phone.toString()
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(name.toString() + " added to Favourites"),
        ));
  }

  @override
  void initState() {
   getCallSettings();
    super.initState();
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
                favourites = snapshot.data.reversed.toList();
                return ListView.builder(
                  itemCount: favourites == null ? 0 : favourites.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        _initCall(favourites[index].phone.toString());
                      },
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            trailing: IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () {
                              dbHelper.delete(favourites[index].id);
                              setState(() {
                                favourites.removeAt(index);
                              });
                               Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text("Contact removed from Favourites"),
                              ));
                                                    
                              
                            }),
                            leading: CircleAvatar(
                            backgroundColor: Colors.blueGrey,
                            child: Icon(Icons.person),
                          ),
                          title: Text(favourites[index].name.toString(), style: TextStyle(
                              fontSize: 18
                            ),),
                            subtitle: Text(favourites[index].phone.toString(), style: TextStyle(
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
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              _pickContact();
            }),
      ),
    );
  }
}
