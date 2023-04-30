//@dart=2.9

//login in form widget with validation
import 'package:flutter/material.dart';

import 'settings_form.dart';

//settings page
class SettingsPage extends StatefulWidget {
  const SettingsPage ({Key key}) : super(key: key);

  @override
  _SettingsPage createState() => _SettingsPage();  
}

class _SettingsPage extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        automaticallyImplyLeading: false,
      ),

    //main body of settings page
    
    body: const SingleChildScrollView(
      padding: EdgeInsets.only(top: 40),
      child: SettingsForm()
      ),
    );
  }
}
