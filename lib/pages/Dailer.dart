import 'package:dailer/components/NumberPad.dart';
import 'package:flutter/material.dart';

class Dailer extends StatefulWidget {
  Dailer({Key key}) : super(key: key);

  @override
  _DailerState createState() => _DailerState();
}

class _DailerState extends State<Dailer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(0.0),
        child: NumberPad(),
      ),
    );
  }
}
