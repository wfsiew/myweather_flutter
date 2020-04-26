import 'package:flutter/material.dart';
import 'current.dart';
import 'hourly.dart';
import 'daily.dart';

class Home extends StatelessWidget {
  Home({Key key, this.title}) : super(key: key);

  static const String routeName = '/Home';

  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text(this.title),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.home),
                text: 'Current',
              ),
              Tab(
                icon: Icon(Icons.timer),
                text: 'Hourly'
              ),
              Tab(
                icon: Icon(Icons.calendar_today),
                text: 'Daily'
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Current(title: 'Current Weather'),
            Hourly(title: 'Hourly Weather'),
            Daily(title: 'Daily Weather'),
          ],
        ),
      ),
    );
  }
}