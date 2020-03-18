import 'package:dailer/pages/Dailer.dart';
import 'package:dailer/pages/Favourites.dart';
import 'package:dailer/pages/Logs.dart';
import 'package:dailer/pages/ManageProfile.dart';
import 'package:dailer/pages/ProfileStats.dart';
import 'package:dailer/pages/Settings.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileStats()),
                    );
                  },
                  child: Text("Earn Points", style: TextStyle(fontSize: 18)),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ManageProfile()),
                  );
                },
              )
            ],
            title: Text(widget.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            bottom: TabBar(tabs: [
              Tab(
                icon: Icon(Icons.history),
              ),
              Tab(
                icon: Icon(Icons.dialpad),
              ),
              Tab(
                icon: Icon(Icons.favorite),
              ),
              Tab(
                icon: Icon(Icons.settings),
              )
            ]),
          ),
          body: TabBarView(
            children: <Widget>[Logs(), Dailer(), Favourites(), Settings()],
          )),
      length: 4,
      initialIndex: 1,
    );
  }
}
