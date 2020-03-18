
import 'package:dailer/pages/VerifyPhone.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileStats extends StatefulWidget {
  const ProfileStats({Key key}) : super(key: key);

  @override
  _ProfileStatsState createState() => _ProfileStatsState();
}

class _ProfileStatsState extends State<ProfileStats> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var data = [0.0, 1.0, 1.5, 2.0, 0.0, 0.0, -0.5, -1.0, -0.5, 0.0, 0.0];
  var data1 = [0.2, 0.3, 0.2, 0.25];
  var data2 = [0.0, 1.0, 0.8, 0.9];
  bool phoneVerified;
  getProfileSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      phoneVerified = prefs.getBool('phoneVerified') ?? false;
      if (!phoneVerified) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VerifyPhone()),
        );
      }
    });
  }

  @override
  void initState() {
    getProfileSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Profile Statistics'),
      ),
      body: Container(
        color: Colors.white,
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Card(
                          elevation: 3,
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 18.0, vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Sparkline(
                                  data: data1,
                                  lineColor: Colors.red,
                                ),
                                SizedBox(height: 12),
                                Text('12',
                                    style: TextStyle(
                                        fontSize: 32,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 8),
                                Text('Ad Views',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black54))
                              ],
                            ),
                          )),
                    ),
                    Expanded(
                      child: Card(
                          elevation: 3,
                          color: Colors.white,
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 18.0, vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Sparkline(
                                    data: data2,
                                    lineColor: Colors.green,
                                  ),
                                  SizedBox(height: 12),
                                  Text('120',
                                      style: TextStyle(
                                          fontSize: 32,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8),
                                  Text('Points Earned',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.black54))
                                ],
                              ))),
                    ),
                  ],
                ),
                SizedBox(height: 14),
                Card(
                    elevation: 3,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Daily Chart',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              Text('Day-wise Earnings Stats',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black38)),
                            ],
                          ),
                          SizedBox(height: 20),
                          Sparkline(
                            data: data,
                            lineColor: Colors.purple,
                            pointsMode: PointsMode.all,
                            pointSize: 0.0,
                            pointColor: Colors.amber,
                            fillMode: FillMode.below,
                            fillColor: Colors.purple[100],
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
