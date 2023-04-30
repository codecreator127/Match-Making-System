//@dart=2.9


//login in form widget with validation
import 'package:flutter/material.dart';

import 'globals.dart';
import 'members_page.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key key}) : super(key: key);

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  int courts;
  final userController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: Column(
          children: <Widget>[

            //logo
            Center(
              child: SizedBox(
                width: 400,
                height: 250,
                child: Image.asset('images/bnh-logo.jfif')
                ),
              ),

            //username input
            Padding(
              padding: const EdgeInsets.only(left:15.0,right: 15.0, top:0, bottom: 10),
              child: SizedBox(
                width: 400,
                child: TextFormField(

                  //input validation
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter a valid username';
                    }
                    return null;
                  },

                  controller: userController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User',
                    hintText: 'Enter username'
                    ),
                  ),
                ),
              ),
            
            //password input
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 0, bottom: 10),
              child: SizedBox(
                width: 400,
                child: TextFormField(

                  //input validation
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter a valid password';
                    }
                    return null;
                  },
                  
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter password'
                    ),
                  ), 
                ),
              ),

            //num of courts input
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 0, bottom: 10),
              child: SizedBox(
                width: 400,
                child: DropdownButtonFormField<String>(

                    //input validation
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Select a valid number of courts';
                      }
                      return null;
                    },

                    onChanged:(value) {
                      courts = int.parse(value);
                    },

                    decoration: const InputDecoration(
                    ),

                    hint: const Text('Select Number of Courts'),
                    items: <String>['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }
                  ).toList(),
                ),
              ),
            ),

            //add a forgot password button here?

            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20)
              ),
              child: ElevatedButton(
                child: const Text('Login'),
                onPressed: () {
                  //Add authentication function here??
                  //String username = userController.text;
                  //String password = passwordController.text;

                  if (_formKey.currentState.validate()) {
                    COURTS = courts;
                    Navigator.push(
                      context, MaterialPageRoute(builder: (context) => MembersPage()),
                      );
                  }
                  },
                ),
              )
            ],
          )
        ),
    );
  }

}
