//@dart=2.9

//default imports
import 'package:flutter/material.dart';

//firebase fireflutter imports
//import 'package:firebase_core/firebase_core.dart';

import 'all_functions.dart';
import 'globals.dart';
import 'login_page.dart';

//members class for a Player object
class Player {
  String name;
  String gender;
  int age;
  int level;
  int rounds = 0;

  bool signedIn = false;
  
  Player(this.name, this.age, this.gender, this.level);

  incrementRounds() {
    rounds ++;
  }

  signIn() {
    signedIn = true;
    allSignedInList.insert(0, this);

    if (signedInLevelList.keys.contains(level)) {
      signedInLevelList[level].add(this);
    }
    else {
      signedInLevelList[level] = [this];
    }
  }

  signOut() {
    signedIn = false;
    allSignedInList.remove(this);
    signedInLevelList[level].remove(this);
  }

  confirmPlayer(name, age, gender, level) {
    if (this.name == name && this.age == age && this.gender == gender && this.level == level) {
      return true;
    }
    return false;
  }

  @override
  String toString() {
    return 'Player: $name level: $level'; 
  }

}

//Main function, runs whole thing
void main() {

  //add firebase firestore flutterfire things for authentication later
  //WidgetsFlutterBinding.ensureInitialized();
  //FirebaseApp defaultApp = Firebase.app();

  //clear current matches excel sheet
  clearMatches();
  //shuffle the players list so that the initial arrangement isn't whats displayed
  for (int level in signedInLevelList.keys) {
    signedInLevelList[level].shuffle();
  }

  //run app widget 
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Login(),
  ));
}

/* authentication function?? flutterfire not configuring
passwordCheck() {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

}
*/

//MyApp stateless widget that updates, runs the login widget page
class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Login(),
    );
  }
}
