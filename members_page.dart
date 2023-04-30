//@dart = 2.9

//Members page widget
import 'package:flutter/material.dart';

import 'add_new_players_page.dart';
import 'all_functions.dart';
import 'courts_page.dart';
import 'globals.dart';
import 'settings_page.dart';
import 'timer.dart';

enum MenuItem{
  settings,
  signout
}

class MembersPage extends StatefulWidget {

  MembersPage({Key key}) : super(key: key);

  @override
  _MembersPage createState() => _MembersPage();

}

class _MembersPage extends State<MembersPage> {

  //listener function
  _listener() {
    setState(() {
      
    });
  }

  //context menu stuff
  Offset _tapPosition = Offset.zero;
  // Tap location will be used use to position the context menu
  _getTapPosition(TapDownDetails details, BuildContext context) {
    //final RenderBox referenceBox = context.findRenderObject() as RenderBox; - don't even need this, double check tho
    setState(() {
      _tapPosition = details.globalPosition;
    });
  }

  //function called when right clicked
  void _showContextMenu(BuildContext context, player, signedIn) async {

    final RenderObject overlay = Overlay.of(context).context.findRenderObject();

    var menuItems = <PopupMenuEntry> [];
    
    if (signedIn) {
      menuItems = [
      const PopupMenuItem(
        value: 'edit',
        child: Text('Edit Player')
      ),

      const PopupMenuItem(
        value: 'sign in',
        child: Text('Sign In')
      ),
      
      const PopupMenuItem(
        value: 'delete',
        child: Text('Delete Player')
      )];
    }
    else {
      menuItems = [
      const PopupMenuItem(
        value: 'edit',
        child: Text('Edit Player')
      ),

      const PopupMenuItem(
        value: 'sign out',
        child: Text('Sign Out')
      ),
      
      const PopupMenuItem(
        value: 'delete',
        child: Text('Delete Player')
      )];
    }

    final result = await showMenu(
      context: context,
      //show contxt menu at right click location
      position: RelativeRect.fromRect(
        Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 30, 30),
        Rect.fromLTWH(0, 0, overlay.paintBounds.size.width, overlay.paintBounds.size.height),
      ),
    
    //menu items
    items: menuItems);

    //logic for choices of right click context menu
    switch(result) {
      case 'edit':
        Navigator.push(
          context, MaterialPageRoute(builder: (context) => AddNewPlayers(player, true, _listener)),
        );

        break;

      case 'sign in':
        //sign selected player in
        signInPlayer(player, context);
        setState(() {
        });

        break;

        //sign player out of current session
      case 'sign out':
        removePlayer('sign out', player);
        setState(() {
        });

        break;

      //remove player from all databases
      case 'delete':
        removePlayer('remove', player);
        setState(() {
        });

        break;
    }
  }

  //list of players that are displayed
  List<dynamic> _foundMembers = [];
  List<dynamic> _foundSignedIn = [];

  @override
  initState() {
    //initially all players in database is shown
    _foundMembers = allMembersList;
    _foundSignedIn = allSignedInList;

    super.initState();
  }

  //function called when members search text field is changed
  //will need to add the ability to run the filter on the signed in side too
  void _runFilter(String enteredText, {bool signedIn}) {
    List results = [];

    if (enteredText.isEmpty) {
      if (signedIn) {
        results = allSignedInList;
      }
      else {
        results = allMembersList;
      }
    }
    else {
      //create list of all names that contain the entered text
      if (signedIn) {
        for (var player in allSignedInList) {
          if (player.name.toLowerCase().contains(enteredText.toLowerCase())) {
            results.add(player);
          }
        }
      }
      else {
        for (var player in allMembersList) {
          if (player.name.toLowerCase().contains(enteredText.toLowerCase())) {
            results.add(player);
          }
        }
      }
    }

    //refresh widget state
    setState(() {
      if (signedIn) {
        _foundSignedIn = results;
      }
      else {
        _foundMembers = results;
      }
    });
  }


  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Members page'),
        automaticallyImplyLeading: false,
        
        actions: [
          PopupMenuButton<MenuItem> (
            onSelected: (value) {
              if (value == MenuItem.settings) {
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              }
              else if (value == MenuItem.signout) {
                Navigator.pop(context);
              }
            },

            itemBuilder: (context) => [
              const PopupMenuItem(
                value: MenuItem.settings,
                child: Text('Settings')
                ),
              const PopupMenuItem(
                value: MenuItem.signout,
                child: Text('Sign Out'))
            ],
          )
        ],
      ),
      //column
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //Row with the titles of both databases
            Container(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Row(
                children: <Widget>[
                  //search bar for members side

                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: TextField(
                      onChanged: (value) => _runFilter(value, signedIn: false),
                      decoration: const InputDecoration(
                        labelText: 'Search Members', suffixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                  //search bar for signed in side
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: TextField(
                      onChanged: (value) => _runFilter(value, signedIn: true),
                      decoration: const InputDecoration(
                        labelText: 'Search Signed In', suffixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          //Row with left and right side page split of signed in and members database
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  //members database
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    
                    child: Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: ListView.builder(
                        itemCount: _foundMembers.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onSecondaryTapDown: (details) => _getTapPosition(details, context), 
                            onSecondaryTap: () => _showContextMenu(context, _foundMembers[index], true),

                            child: Card(
                              key: ValueKey(_foundMembers[index]),
                              color: Color.fromARGB(255, 123, 233, 176),
                              elevation: 4,
                              margin: const EdgeInsets.only(top: 10, bottom: 10),

                                child: ListTile(
                                  leading: Text(
                                    _foundMembers[index].level.toString(),
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                  title: Text(_foundMembers[index].name),
                                  subtitle: Text('${_foundMembers[index].age.toString()} years old | ${_foundMembers[index].gender}'),
                                )
                              )
                            );
                        } 
                      ),
                    ),
                  ),

                  //signed in database
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: ListView.builder(
                        itemCount: _foundSignedIn.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onSecondaryTapDown: (details) => _getTapPosition(details, context), 
                            onSecondaryTap: () => _showContextMenu(context, _foundSignedIn[index], false),

                            child: Card(
                              key: ValueKey(_foundSignedIn[index]),
                              color: const Color.fromARGB(255, 180, 137, 6),
                              elevation: 4,
                              margin: const EdgeInsets.only(top: 10, bottom: 10),

                                child: ListTile(
                                  leading: Text(
                                    _foundSignedIn[index].level.toString(),
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                  title: Text(_foundSignedIn[index].name),
                                  subtitle: Text('${_foundSignedIn[index].age.toString()} years old | ${_foundSignedIn[index].gender}'),
                                )
                              )
                            );
                        } 
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          //Row with navigation buttons
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
              Row(
                children: <Widget> [
                    Padding(
                      padding: const EdgeInsets.only(left:15.0,right: 15.0, top:0, bottom: 10),
                      child: ElevatedButton(
                        //go to new player page
                        onPressed: () {
                          Navigator.push(
                            context, MaterialPageRoute(builder: (context) => AddNewPlayers(null, false, _listener)),
                          );
                        },
                        child: const Text('Add New Player'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:15.0,right: 15.0, top:0, bottom: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context, MaterialPageRoute(builder: (context) => const CourtsPage()),
                          );
                        },
                        child: const Text('Current Matches'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:15.0,right: 15.0, top:0, bottom: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          signAllOut();
                          setState(() {
                            
                          });
                        },
                      child: const Text('Sign All Out'),
                      ),
                    ),
                  ]
                ),
                //row with the timer
                const CountDown(),
              ],
            ),
          ),
        ],
      )
    );
  }
}
