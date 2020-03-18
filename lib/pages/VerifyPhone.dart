
import 'package:dailer/components/BoxShadowInput.dart';
import 'package:dailer/components/CustomRaisedButton.dart';
import 'package:dailer/pages/ManageProfile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerifyPhone extends StatefulWidget {
  VerifyPhone({Key key}) : super(key: key);

  @override
  _VerifyPhoneState createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String url =
      'https://trumpetstechnologies.in/mobileapps/api/dailer/sendsms.php';

  Future<String> sendOTP() async {
    String ph = Uri.encodeComponent(phoneNumber);
    final response = await http.get('$url?phone=$ph');
    print(response.body);
    return json.decode(response.body)['otp'].toString();
  }

  String phoneNumber = '';
  String otp = '';
  String actualCode;
  bool error = false;
  String errorMessage = '';

  PageController pageController = PageController();

  _savePhoneVerified() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('phoneVerified', true);
    await prefs.setString('verifiedPhoneNumber', phoneNumber);
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ManageProfile()),
    );
  }

  void verifyPhoneNumber() async {
    this.actualCode = await sendOTP();
    pageController.animateToPage(1,
        duration: Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  void _checkOtpAndVerifyPhone(context, otpinput) {
    if (actualCode == otpinput) {
      _savePhoneVerified();
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Incorrect OTP!"),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Verify Phone'),
      ),
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: pageController,
              children: <Widget>[
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text('Enter your mobile number',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600))),
                        Container(
                            margin: EdgeInsets.only(top: 20),
                            child: BoxShadowInput(
                                hintText: 'Ex. +9719922123456',
                                inputType: TextInputType.phone,
                                hasError: error,
                                onChangeTrigger: (value) {
                                  setState(() {
                                    phoneNumber = value;
                                  });
                                })),
                        SizedBox(height: 15),
                        CustomRaisedButton(
                          buttonText: 'Send OTP',
                          onPressedTrigger: () {
                            if (phoneNumber == '' || phoneNumber.length < 10) {
                              setState(() {
                                error = true;
                              });
                            } else {
                              setState(() {
                                error = false;
                              });
                              verifyPhoneNumber();
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text('Enter verification OTP',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600))),
                          Container(
                              margin: EdgeInsets.only(top: 20),
                              child: BoxShadowInput(
                                  hintText: 'Ex. 123456',
                                  inputType: TextInputType.phone,
                                  hasError: false,
                                  onChangeTrigger: (value) {
                                    otp = value;
                                  })),
                          if (errorMessage != '')
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              child: Text(errorMessage,
                                  style: TextStyle(color: Colors.red)),
                            ),
                          SizedBox(height: 15),
                          CustomRaisedButton(
                            buttonText: 'Verify OTP',
                            onPressedTrigger: () {
                              _checkOtpAndVerifyPhone(context, this.otp);
                            },
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 10),
                            child: GestureDetector(
                              child: Text('Resend OTP',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromRGBO(26, 107, 217, 1),
                                      fontWeight: FontWeight.w600)),
                              onTap: () {
                                pageController.animateToPage(0,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeOut);
                              },
                            ),
                          )
                        ],
                      )),
                )
              ]),
        ),
      ),
    );
  }
}
