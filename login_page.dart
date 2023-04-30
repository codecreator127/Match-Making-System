//@dart=2.9

//login widget page, its state is determined by loginstate()
import 'package:flutter/material.dart';

import 'login_form.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

//the widgets inside of the login, the main stuff on the login page
class _LoginState extends State<Login> {
  
  @override
  //widget builder
  Widget build(BuildContext context) {
    
    //scaffold of widget
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar (
        title: const Text("Login Page"),
      ),

    //main body of the login  widget
    body: const SingleChildScrollView(
      child: LoginForm()
      )
    );
  }
}