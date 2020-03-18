
import 'package:dailer/pages/ProfileStats.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageProfile extends StatefulWidget {
  const ManageProfile({Key key}) : super(key: key);

  @override
  _ManageProfileState createState() => _ManageProfileState();
}

class _ManageProfileState extends State<ManageProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> genderOptions = ['Male', 'Female', 'Other'];

  var dateOfBirthController = new TextEditingController();
  var nameController = new TextEditingController();
  String gender;
  String fullname;
  String dateOfBirth;
  bool phoneVerified;

  getProfileSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      gender = prefs.getString('gender') ?? 'Male';
      fullname = prefs.getString('fullname') ?? '';
      nameController.text = fullname;
      dateOfBirth = prefs.getString('dateOfBirth') ?? '';
      dateOfBirthController.text = dateOfBirth;
      phoneVerified = prefs.getBool('phoneVerified') ?? false;
      if (!phoneVerified) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileStats()),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getProfileSettings();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1930, 8),
        lastDate: DateTime.now());
    if (picked != null)
      setState(() {
        dateOfBirth = picked.day.toString() +
            '-' +
            picked.month.toString() +
            '-' +
            picked.year.toString();
        dateOfBirthController.text = dateOfBirth;
      });
  }

  _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('gender', gender);
    await prefs.setString('fullname', fullname);
    await prefs.setString('dateOfBirth', dateOfBirth);

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Profile Settings Saved Successfully"),
    ));

    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileStats()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Manage Profile'),
      ),
      body: Container(
        color: Colors.white,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 0),
                  child: Text('Fullname',
                      style: TextStyle(fontSize: 15, color: Colors.black45)),
                ),
                TextField(
                  controller: nameController,
                  onChanged: (value) {
                    setState(() {
                      fullname = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 0),
                  child: Text('Gender',
                      style: TextStyle(fontSize: 15, color: Colors.black45)),
                ),
                Container(
                  width: double.infinity,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: gender,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 20,
                    elevation: 16,
                    style: TextStyle(color: Colors.black54, fontSize: 18),
                    underline: Container(
                      height: 1,
                      color: Colors.black54,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        gender = newValue;
                      });
                    },
                    items:
                        genderOptions.map<DropdownMenuItem<String>>((gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 0),
                  child: Text('Date of birth',
                      style: TextStyle(fontSize: 15, color: Colors.black45)),
                ),
                TextField(
                  readOnly: true,
                  controller: dateOfBirthController,
                  onTap: () {
                    _selectDate(context);
                  },
                  decoration: InputDecoration(
                    hintText: 'Birthday',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: FlatButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      padding: EdgeInsets.all(12.0),
                      splashColor: Colors.blueAccent,
                      onPressed: () {
                        _saveSettings();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 2.0, bottom: 2.0),
                            child: Text('Save Profile',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
