//@dart=2.9
import 'package:flutter/material.dart';
import 'globals.dart';


//settings form
class SettingsForm extends StatefulWidget {
  const SettingsForm({Key key}) : super(key: key);

  @override
  SettingsFormState createState() {
    return SettingsFormState();
  }
}

class SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();

  int courts;
  int timerTime;

  //add a way to change username and password
  final userController = TextEditingController();
  final passwordController = TextEditingController();

  final timerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: Column(
          children: <Widget>[
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

                    hint: Text('Select Number of Courts (Currently: $COURTS)'),
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

            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 0, bottom: 10),
              child: SizedBox(
                width: 400,
                child: TextFormField(

                  //validates that the field is filled in
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      timerTime = matchTime;
                      return null;
                    }
                    else if (int.tryParse(value) < 0 || int.tryParse(value) > 60 || int.parse(value) == null) {
                      return 'Enter a valid time in minutes (less than 1 hr)';
                    }
                    timerTime = int.parse(value);
                    return null;
                  },

                  controller: timerController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Match Time (Currently $matchTime minutes)',
                    hintText: 'Enter Match Time'
                    ),
                  ),
              ),
            ),
            
            //row containing controll buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 0, bottom: 10),
                child: Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: ElevatedButton(
                    child: const Text('Change Settings'),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        COURTS = courts;
                        matchTime = timerTime;
                        Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 0, bottom: 10),
                  child: Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: ElevatedButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              )
            ],
          )
        ),
    );
  }

}
