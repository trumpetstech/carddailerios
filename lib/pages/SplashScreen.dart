import 'dart:async';
import 'package:dailer/pages/MyHomePage.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigatePage);
  }

  navigatePage() {
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyHomePage(title: 'CardDailer')));
  }

  var logoText = new RichText(
    text: new TextSpan(
      style: new TextStyle(
          fontSize: 56,
          fontWeight: FontWeight.w600,
          color: Color.fromRGBO(77, 110, 250, 1)),
      children: <TextSpan>[
        new TextSpan(
            text: 'Card',
            style: new TextStyle(color: Color.fromRGBO(10, 84, 204, 1))),
        new TextSpan(text: 'Dailer', style: new TextStyle(color: Colors.black)),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Center(child: logoText),
      ),
    );
  }
}
