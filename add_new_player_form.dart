//@dart=2.9

//login in form widget with validation
import 'package:flutter/material.dart';

import 'all_functions.dart';

//widget form for adding new players, includes validation
class AddPlayerForm extends StatefulWidget {

  var player;
  bool edit;
  var listener;

  AddPlayerForm(this.player, this.edit, this.listener, {Key key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  AddPlayerFormState createState() {
    if (edit) {
      return AddPlayerFormState(player: player, edit: edit, listener: listener);
    }
    else {
      return AddPlayerFormState(edit: edit, listener: listener);
    }
  }
}

class AddPlayerFormState extends State<AddPlayerForm> {

  var player;
  var listener;
  String currName = 'Name';
  String currAge = 'Age';
  String currGender = 'Gender';
  String currLevel = 'Level';
  String signInTxt = 'Sign In Player?';

  bool edit;

  AddPlayerFormState({this.player, this.edit, this.listener});

  final _formKey = GlobalKey<FormState>();

  final ageController = TextEditingController();
  final nameController = TextEditingController();
  var level;
  var gender;
  bool signedIn = false;
  String changePlayerText;

  Color getColor(Set<MaterialState> states) {
          const Set<MaterialState> interactiveStates = <MaterialState>{
            MaterialState.pressed,
            MaterialState.hovered,
            MaterialState.focused,
          };
          if (states.any(interactiveStates.contains)) {
            return Colors.blue;
          }
          return Colors.green;
        }

  @override
  Widget build(BuildContext context) {
    if (edit) {
      changePlayerText = 'Edit Player';
      currName = player.name;
      currAge = player.age.toString();
      currGender = player.gender;
      currLevel = player.level.toString();
      if (player.signedIn) {
        signInTxt = 'Sign Out Player?';
      }
    }
    else {
      changePlayerText = 'Add New Player';
    }

    return Form(
      key: _formKey,
      child: Center(
        child: Column(
            children: [
              //first row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: Padding(
                      padding: const EdgeInsets.only(left:15.0,right: 15.0, top:0, bottom: 10),
                      child: SizedBox(
                        width: 400,
                        child: TextFormField(

                          //validates that the name field is filled in
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter a name';
                            }
                            return null;
                          },

                          controller: nameController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: currName,
                            hintText: 'Enter Name'
                            ),
                          ),
                        ),
                      ),
                    ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 0, bottom: 10),
                      child: SizedBox(
                        width: 400,
                        child: TextFormField(

                          //validates that the field is filled in
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter an age';
                            }
                            else if (int.tryParse(value) == null) {
                              return 'Enter a valid age';
                            }
                            return null;
                          },

                          controller: ageController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: currAge,
                            hintText: 'Enter the players age'
                            ),
                          ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                      fit: FlexFit.loose,
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left:15.0,right: 15.0, top:0, bottom: 10),
                        child: SizedBox(
                          width: 400,
                          child: DropdownButtonFormField<String>(

                            validator: (value) {
                              if (value == null) {
                                return 'Choose a valid option';
                              }
                              return null;
                            },

                            onChanged:(value) {
                              gender = value;
                            },
                            decoration: const InputDecoration(
                            ),
                            
                            hint: Text(currGender),
                            items: <String>['Male', 'Female', 'Other'].map((String value) {
                            return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),

                          );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                    Flexible(
                      fit: FlexFit.loose,
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left:15.0,right: 15.0, top:0, bottom: 10),
                        child: SizedBox(
                          width: 400,
                          child: DropdownButtonFormField<String>(

                            validator: (value) {
                              if (value == null) {
                                return 'Choose a valid option';
                              }
                              return null;
                            },

                            onChanged:(value) {
                              level = value;
                            },
                            decoration: const InputDecoration(
                            ),

                            hint: Text(currLevel),
                            items: <String>['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'].map((String value) {
                            return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),

                          );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              //row containing checkbox option to sign in player
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text(signInTxt),
                Flexible(
                  fit: FlexFit.loose,
                  flex: 1,
                    child: Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: signedIn,
                      onChanged: (bool value) {
                        setState(() {
                          signedIn = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              //Buttons row at the bottom of the screen
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //button to add new player
                  Container(
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: ElevatedButton(
                      child: Text(changePlayerText),
                      onPressed: () {
                        var age = ageController.text;
                        var name  = nameController.text;
                        
                        //Error handling
                        if (_formKey.currentState.validate()) {
                          //if fields are filled in with valid input
                          //adding player info to the excel sheet

                          if (edit) {
                            if (signedIn && player.signedIn) {
                              player.signOut;
                              removePlayer('sign out', player);
                            }
                            editPlayer(player, name, age, gender, level);
                          }
                          else {
                            memberIntoExcel(name, age, gender, level, signedIn);
                          }
                          //go to members page
                          Navigator.pop(context);
                          listener();
                          }
                        },
                      ),
                    ),
                  //button to cancel and return to members page
                  Container(
                    margin: const EdgeInsets.all(20),
                    height: 50,
                    width: 200,
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
                ],
              ),
            ],
          ),
        ),
    );
  }

}
