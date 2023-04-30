//@dart=2.9

//login in form widget with validation
import 'package:flutter/material.dart';

import 'add_new_player_form.dart';

//Adding new members page
class AddNewPlayers extends StatefulWidget {
  
  var player;
  bool edit;
  var closedListener;
  
  AddNewPlayers(this.player, this.edit, this.closedListener, {Key key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state, library_private_types_in_public_api
  _AddNewPlayers createState() {
    if (edit) {
      return _AddNewPlayers(player: player, edit: edit, listener: closedListener);
    }
    else {
      return _AddNewPlayers(edit: edit, listener: closedListener);
    }
  }
}

class _AddNewPlayers extends State<AddNewPlayers> {

  var player;
  bool edit;
  String appBarText;
  var listener;

  _AddNewPlayers({this.player, this.edit, this.listener});


  @override
  Widget build(BuildContext context) {
    if (edit) {
      appBarText = 'Edit ${player.name}';
    }
    else {
      appBarText = 'Add New Member';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarText),
        automaticallyImplyLeading: false,
      ),
    //main body of the new member widget
    body: SingleChildScrollView(
      padding: const EdgeInsets.only(top: 40),
      child: AddPlayerForm(player, edit, listener)
      ),
    );
  }
}
