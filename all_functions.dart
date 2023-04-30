//@dart=2.9


//excel imports
import 'dart:io';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:excel/excel.dart';

import 'globals.dart';
import 'main.dart';


//functions regarding initial list set up

//function to import all players from excel sheet into a list
//signed in parameter is to generate all members or only signed in members
allMembersFromExcel(signedIn) {
  //initiate file connection
  var file = "C:/Users/johnl/Documents/BNH/bnh_app/databases/members.xlsx";
  var bytes = File(file).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  //map containing all players sorted by level
  var membersList = [];
  var sheet;
  if (signedIn) {
    //import players from all members list for signed in list, to retain player objs
    sheet = excel['Signed In'];

    for (var player in allMembersList) {
      if (findPlayer('Signed In', player) != null) {
        player.signedIn = true;
        membersList.add(player);
      }
    }

    return membersList;
  }

  else {
    sheet = excel['Members'];
    //create list of all members
    for (var row in sheet.rows) {
      if (row[0].toString() != 'Name') {
        String name = row[0];
        String gender = row[2];

        int age;
        int level;


        if (row[1] is String) {
          age = int.parse(row[1]);
        }
        else {
          age =  row[1];
        }

        if (row[3] is String) {
          level = int.parse(row[3]);
        }
        else { 
          level = row[3];
        }
        
        var p = Player(name, age, gender, level);

        if (signedIn) {
          p.signIn();
        }

        membersList.add(p);
      }
    }

    return membersList;

  }
}

//function to transpose players from list into a map with levels as keys
levelListGenerator() {
  var signedInMembers = allMembersFromExcel(true);
  var levelList = {};

  for (var player in signedInMembers) {
    if (levelList.keys.contains(player.level)) {
      levelList[player.level].add(player);
    }
    else {
      levelList[player.level] = [player];
    }
  }
  return levelList;
}

//functions regarding excel interactions

//function to find player row in database
findPlayer(sheetName, player) {
  //initiate file connection
  var file = "C:/Users/johnl/Documents/BNH/bnh_app/databases/members.xlsx";
  var bytes = File(file).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  var sheet = excel[sheetName];
  int rowNum = 0;

  for (var row in sheet.rows) {
    if (row[0] == player.name && (row[1] == player.age.toString() || row[1] == player.age) && row[2] == player.gender && (row[3] == player.level.toString())  || row[3] == player.level) {
      return rowNum;
    }
    rowNum ++;
  }

  return null;
}

//function to delete player from databases, action = sign out or remove
removePlayer(action, player) {
  //initiate file connection
  var file = "C:/Users/johnl/Documents/BNH/bnh_app/databases/members.xlsx";
  var bytes = File(file).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  //remove player from members database if chosen
  if (action == 'remove') {
    String sheetName = 'Members';
    excel[sheetName].removeRow(findPlayer(sheetName, player));
  
    //remove player from all members list
    allMembersList.remove(player);
  }

  //remove player from being signed in if they are
  if (player.signedIn) {
    player.signOut();

    //sign out if player is signed in
    String sheetName = 'Signed In';
    int playerRow = findPlayer(sheetName, player);
    excel[sheetName].removeRow(playerRow);

  }  

  String outputFile = "C:/Users/johnl/Documents/BNH/bnh_app/databases/members.xlsx";
  excel.encode().then((onValue) {
    File(join(outputFile))
      ..createSync(recursive: true)
      ..writeAsBytesSync(onValue);
  });
}

//function to edit player in databases
editPlayer(player, [newName, newAge, newGender, newLevel]) {
  //initiate file connection
  var file = "C:/Users/johnl/Documents/BNH/bnh_app/databases/members.xlsx";
  var bytes = File(file).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  //check if player signed in and change details

  if (player.signedIn) {

    //change player info in excel sheet
    int playerRowNum = findPlayer('Signed In', player);
    
    //change the cell values in excel sheet
    var nameCell = excel['Signed In'].cell(CellIndex.indexByString('A${playerRowNum + 1}'));
    var ageCell = excel['Signed In'].cell(CellIndex.indexByString('B${playerRowNum + 1}'));
    var genderCell = excel['Signed In'].cell(CellIndex.indexByString('C${playerRowNum + 1}'));
    var levelCell = excel['Signed In'].cell(CellIndex.indexByString('D${playerRowNum + 1}'));

    nameCell.value = newName;
    ageCell.value = newAge;
    genderCell.value = newGender;
    levelCell.value = newLevel;
  }

  //change the details on members excel sheet
  int playerRowNum = findPlayer('Members', player);

  //change the cell values in excel sheet
  var nameCell = excel['Members'].cell(CellIndex.indexByString('A${playerRowNum + 1}'));
  var ageCell = excel['Members'].cell(CellIndex.indexByString('B${playerRowNum + 1}'));
  var genderCell = excel['Members'].cell(CellIndex.indexByString('C${playerRowNum + 1}'));
  var levelCell = excel['Members'].cell(CellIndex.indexByString('D${playerRowNum + 1}'));

  nameCell.value = newName;
  ageCell.value = newAge;
  genderCell.value = newGender;
  levelCell.value = newLevel;

  //update the player obj values
  player.name = newName;
  player.age = int.parse(newAge);
  player.gender = newGender;
  player.level = int.parse(newLevel);

  String outputFile = "C:/Users/johnl/Documents/BNH/bnh_app/databases/members.xlsx";
  excel.encode().then((onValue) {
    File(join(outputFile))
      ..createSync(recursive: true)
      ..writeAsBytesSync(onValue);
  });
}

//function to store current player information into current matches excel sheet
void currentMatchIntoExcel(allCurrentMatches) {

  //initialize file connection
  var file = "C:/Users/johnl/Documents/BNH/bnh_app/databases/current_matches.xlsx";
  var bytes = File(file).readAsBytesSync();  
  var excel = Excel.decodeBytes(bytes);
  
  //add information to each relevant cell in the sheet
  
  for (int court = 0; court < allCurrentMatches.length; court ++) {
    String sheetName = 'court${court + 1}'; 

    for (int playerNum = 0; playerNum < allCurrentMatches[court].length; playerNum ++) {
      String indexString = 'A${playerNum + 2}';

      var cell = excel.tables[sheetName].cell(CellIndex.indexByString(indexString));
      cell.value = allCurrentMatches[court][playerNum].name;
    }
  }

  //saving to the file
  String outputFile = "C:/Users/johnl/Documents/BNH/bnh_app/databases/current_matches.xlsx";
  excel.encode().then((onValue) {
    File(join(outputFile))
      ..createSync(recursive: true)
      ..writeAsBytesSync(onValue);
  });
}

//pulls current matches from excel sheet 
currentMatchFromExcel(sheetName) {
//initiate file connection
  var file = "C:/Users/johnl/Documents/BNH/bnh_app/databases/current_matches.xlsx";
  var bytes = File(file).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  //list containing names of players in current match, list of lists
  var playersTableRows = <TableRow>[];
  
  //create tableRows using information, center widget, text widget
  for (var table in excel.tables.keys) {
    if (table == sheetName) {
      for (var row in excel.tables[table].rows) {
        var tableRow = <Widget>[];
        for (var i = 0; i < row.length; i++) {
          var tableCell = Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Center(child: Text(row[i].toString()))
            );
          tableRow.add(tableCell);
        }
        var tableRowWidget = TableRow(children: tableRow); 
        playersTableRows.add(tableRowWidget);
      }
    }
  }
  //return list of tableRows which can be called later in the table widget
  return playersTableRows;
  
}

//function to store new player input information into excel, and add to current signed in players if true
void memberIntoExcel(name, age, gender, level, signedIn) {
  //initiate file connection
  var file = "C:/Users/johnl/Documents/BNH/bnh_app/databases/members.xlsx";
  var bytes = File(file).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  //create new player object, add it to the allmemberslist
  var player = Player(name, int.parse(age), gender, int.parse(level));
  allMembersList.insert(0, player);
  
  excel['Members'].appendRow([name, age, gender, level]);

  if (signedIn) {
    //add to signed in list
    player.signIn();

    //appending info to new line
    excel['Signed In'].appendRow([name, age, gender, level]);

  }

  String outputFile = "C:/Users/johnl/Documents/BNH/bnh_app/databases/members.xlsx";
  excel.encode().then((onValue) {
    File(join(outputFile))
      ..createSync(recursive: true)
      ..writeAsBytesSync(onValue);
  });
}

//show dialog warning function
Future<void> showWarningDialog(BuildContext context, player) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Log In'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('${player.name} is already signed in'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

//function to sign in player
signInPlayer(player, context) {
  //initiate file connection
  var file = "C:/Users/johnl/Documents/BNH/bnh_app/databases/members.xlsx";
  var bytes = File(file).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  //check if player is signed in yet
  if (player.signedIn) {
    //add a pop up msg that player already signed in
    
    return showWarningDialog(context, player);
  }

  player.signIn();

  //make the num rounds the player has played same as everyone else, need to see if it exists first...
  /*if (signedInLevelList[player.level].length > 1) {
    player.rounds = signedInLevelList[0].rounds;
  } */



  //appending info to new line
  excel['Signed In'].appendRow([player.name, player.age.toString(), player.gender, player.level.toString()]);

  String outputFile = "C:/Users/johnl/Documents/BNH/bnh_app/databases/members.xlsx";
  excel.encode().then((onValue) {
    File(join(outputFile))
      ..createSync(recursive: true)
      ..writeAsBytesSync(onValue);
  });
}


//function to clear current matches excel sheet (insert whitespace where players names should be)
void clearMatches() {
  //initialize file connection
  var file = "C:/Users/johnl/Documents/BNH/bnh_app/databases/current_matches.xlsx";
  var bytes = File(file).readAsBytesSync();  
  var excel = Excel.decodeBytes(bytes);
  
  //add information to each relevant cell in the sheet
  for (int court = 0; court < 12; court ++) {
    String sheetName = 'court${court + 1}'; 

    for (int playerNum = 0; playerNum < 4; playerNum ++) {
      String indexString = 'A${playerNum + 2}';

      var cell = excel.tables[sheetName].cell(CellIndex.indexByString(indexString));
      cell.value = '    ';
    }
  }

  //saving to the file
  String outputFile = "C:/Users/johnl/Documents/BNH/bnh_app/databases/current_matches.xlsx";
  excel.encode().then((onValue) {
    File(join(outputFile))
      ..createSync(recursive: true)
      ..writeAsBytesSync(onValue);
  });
}

void signAllOut() {
  //initialize file connection
  var file = "C:/Users/johnl/Documents/BNH/bnh_app/databases/members.xlsx";
  var bytes = File(file).readAsBytesSync();  
  var excel = Excel.decodeBytes(bytes);

  for (int i = 0; i < allSignedInList.length; i ++) {
    allSignedInList[i].signOut();
    i --;
  }

  for (int rowNum = 1; rowNum < excel['Signed In'].rows.length; rowNum ++) {
    excel['Signed In'].removeRow(1);
  }

  //saving to the file
  String outputFile = "C:/Users/johnl/Documents/BNH/bnh_app/databases/members.xlsx";
  excel.encode().then((onValue) {
    File(join(outputFile))
      ..createSync(recursive: true)
      ..writeAsBytesSync(onValue);
  });
}

//functions for match making
//ratio function, calculates ratio of each level line/queue
ratio(levelList) {
  var ratioList = [];

  //change the way min_played is calculated later
  int minPlayed = 99999999;
  var unplayedList = [];
  int totalPlayedGames = 0;

  //calculate ratios of played to unplayed in the current level queue
  for (int level in levelList.keys) {
    for (var player in levelList[level]) {
      if (player.rounds < minPlayed) {
        minPlayed = player.rounds;
      }
      totalPlayedGames += player.rounds;
    }

    double ratio = totalPlayedGames / levelList[level].length;
    ratioList.add([level, ratio]);

    //generate list of players who haven't played current round
    for (var player in levelList[level]) {
      if (player.rounds == minPlayed) {
        unplayedList.add(player);
      }
    }

    //shuffle queues if players left are less than 4
    if (unplayedList.length < 4) {
      for (var player in unplayedList) {
        levelList[level].remove(player);
      }
      levelList[level].shuffle();

      for (var player in unplayedList) {
        levelList[level].insert(0, player);
      }
    }
  }
  return ratioList;
}

//determining which queue to pick next for the next match
determineNextQueue(ratioList) {
  //use ratios to figure out which queue to pick next
  double nextRatio = 100.0;
  int nextQueue = 0;
  for (var ratio in ratioList) {
    if (ratio[0] < nextRatio) {
      nextRatio = ratio[1];
      nextQueue = ratio[0];
    }
  }
  return nextQueue;
}

//function to generate the current/next match to be played
makeMatch(levelList, nextQueue) {
  var currentMatch = [];

  for (int i = 0; i < 4; i++) {

    var currentPlayer = levelList[nextQueue][i];

    currentPlayer.rounds += 1;
    currentMatch.add(currentPlayer);
  }
  //move the players to the back of their queue

  for (var player in currentMatch) {
    levelList[nextQueue].remove(player);
    levelList[nextQueue].add(player);
  }

  return currentMatch;
}

//match generating function, generates the matches for the next round
matchGeneratorMain(numCourts, currentPlayers) {

  var levelList = currentPlayers;
  //a list of all matches that fit in this round with the num of courts available (cuz the excel writing function isnt instant)
  var allCurrentMatches = [];
  
  //change match to a calculatable value
  for (int court = 0; court < numCourts; court ++) {
    //generate list of completion ratios of each level and shuffle queues if necesary
    var ratioList = ratio(levelList);

    //choose next level to be chosen from using ratio list
    var nextQueue = determineNextQueue(ratioList);

    //pick 4 people from this queue to go on current match
    var currentMatch = makeMatch(levelList, nextQueue);

    //append this court to all current matches list
    allCurrentMatches.add(currentMatch);
  }
  currentMatchIntoExcel(allCurrentMatches);
}

//courts function, determines how many courts are displayed on the page, returns a list of rows which are displayed in the columns
courtDisplay(numCourts) {
  var columnChildren = <Widget>[];
  var row1 = <Widget>[];
  var row2 = <Widget>[];
  var row3 = <Widget>[];

  var allCourts = [];

  //if courts less than 5

  for (int i = 0; i < 12; i ++) {
    String sheetName = 'court${i + 1}';

    if (i < numCourts) {
      allCourts.add(
        Flexible(
          fit: FlexFit.tight,
          flex: 1,
          child: SingleChildScrollView(
            child: Container(
              color: Colors.green,
              margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
              child: Table(
                border: TableBorder.all(),
                children: currentMatchFromExcel(sheetName),
              ),
            ),
          ),
        ),
      );
    }
    else {
      allCourts.add(
        Flexible(
          fit: FlexFit.tight,
          flex: 1,
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
              child: Table(
                border: TableBorder.all(),
                children: currentMatchFromExcel(sheetName),
              ),
            ),
          ),
        ),
      );
    }
  }

  //transpose the courts from all courts list into a row widget list
  for (int i = 0; i < allCourts.length; i ++) {
    if (i < 4) {
      row1.add(allCourts[i]);
    }
    else if (i < 8) {
      row2.add(allCourts[i]);
    }
    else {
      row3.add(allCourts[i]);
    }
  }

  columnChildren.add(Row(children: row1));
  columnChildren.add(Row(children: row2));
  columnChildren.add(Row(children: row3));

  return columnChildren;

}
