import 'package:dailer/models/Contact.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List<String> languageStore1 = ['Hindi', 'English', 'Arabic'];
  List<String> languageStore2 = [
    'Hindi',
    'Urdu',
    'Bengali',
    'Malayalam',
    'Sinhala',
    'Arabic',
    'Tamil',
    'Telungu',
    'English'
  ];

  List<Country> countriesStore = [
    Country(key: "00973", value: "Bahrain (+973)"),
    Country(key: "00880", value: "Bangladesh (+880)"),
    Country(key: "0086", value: "China (+86)"),
    Country(key: "0091", value: "India (+91)"),
    Country(key: "0062", value: "Indonesia (+62)"),
    Country(key: "00965", value: "Kuwait (+965)"),
    Country(key: "00977", value: "Nepal (+977)"),
    Country(key: "00968", value: "Oman (+968)"),
    Country(key: "0092", value: "Pakistan (+92)"),
    Country(key: "0063", value: "Philippines (+63)"),
    Country(key: "00974", value: "Qatar (+974)"),
    Country(key: "00966", value: "Saudi Arabia (+966)"),
    Country(key: "0094", value: "Sri Lanka (+94)"),
  ];

  List<String> cardProvidersStore = ['Du (Hello Card)', 'Etisalat (Five Card)'];

  List<String> languageList;

  var _cardNumberController = new TextEditingController();
  int cardProvider;
  String country;
  int language;

  getCallSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      cardProvider = prefs.getInt('cardProvider');
      if (cardProvider == null) {
        cardProvider = 0;
      }
      if (cardProvider == 0) {
        languageList = languageStore1;
      } else {
        languageList = languageStore2;
      }
      _cardNumberController.text = prefs.getString('cardNumber');
      if (_cardNumberController.text == null) {
        _cardNumberController.text = '';
      }
      country = prefs.getString('userCountryCode');
      if (country == null) {
        country = '0091';
      }
      language = prefs.getInt('userLanguage');
      if (language == null) {
        language = 0;
      }
    });
  }

  @override
  void initState() {
    languageList = languageStore1;
    getCallSettings();
    super.initState();
  }

  _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cardProvider', cardProvider);
    await prefs.setString('cardNumber', _cardNumberController.text);
    await prefs.setString('userCountryCode', country);
    await prefs.setInt('userLanguage', language);

    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Settings Saved Successfully"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 0),
                child: Text('Select Provider',
                    style: TextStyle(fontSize: 15, color: Colors.black45)),
              ),
              Container(
                width: double.infinity,
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: cardProvider,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 20,
                  elevation: 16,
                  style: TextStyle(color: Colors.black54, fontSize: 18),
                  underline: Container(
                    height: 1,
                    color: Colors.black54,
                  ),
                  onChanged: (int newValue) {
                    setState(() {
                      cardProvider = newValue;
                      if (cardProvider == 0) {
                        languageList = languageStore1;
                        language = 0;
                      } else {
                        languageList = languageStore2;
                        language = 0;
                      }
                    });
                  },
                  items: cardProvidersStore
                      .map<DropdownMenuItem<int>>((String value) {
                    return DropdownMenuItem<int>(
                      value: cardProvidersStore.indexOf(value),
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 0),
                child: Text('Enter Card No.',
                    style: TextStyle(fontSize: 15, color: Colors.black45)),
              ),
              TextField(
                controller: _cardNumberController,
                decoration: InputDecoration(
                  hintText: 'Number',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 0),
                child: Text('Country',
                    style: TextStyle(fontSize: 15, color: Colors.black45)),
              ),
              Container(
                width: double.infinity,
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: country,
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
                      country = newValue;
                    });
                  },
                  items: countriesStore
                      .map<DropdownMenuItem<String>>((countryFromStore) {
                    return DropdownMenuItem<String>(
                      value: countryFromStore.key,
                      child: Text(countryFromStore.value),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 0),
                child: Text('Language',
                    style: TextStyle(fontSize: 15, color: Colors.black45)),
              ),
              Container(
                width: double.infinity,
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: language,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 20,
                  elevation: 16,
                  style: TextStyle(color: Colors.black54, fontSize: 18),
                  underline: Container(
                    height: 1,
                    color: Colors.black54,
                  ),
                  onChanged: (int newValue) {
                    setState(() {
                      language = newValue;
                    });
                  },
                  items:
                      languageList.map<DropdownMenuItem<int>>((String value) {
                    return DropdownMenuItem<int>(
                      value: languageList.indexOf(value),
                      child: Text(value),
                    );
                  }).toList(),
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
                          padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                          child: Text('Save Settings',
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
    );
  }
}
