//@dart = 2.9
import 'package:flutter/material.dart';

import 'all_functions.dart';
import 'globals.dart';

//Courts page
class CourtsPage extends StatefulWidget {

  const CourtsPage({Key key}) : super(key: key);
  
  @override
  _CourtsPage createState() => _CourtsPage();

}

class _CourtsPage extends State<CourtsPage> {

  _CourtsPage();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Matches'),
      ),
      body: Column(
        children: courtDisplay(COURTS)
      )
    );
  }
}