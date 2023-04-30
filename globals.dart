//@dart = 2.9

library my_project.globals;

import 'all_functions.dart';

var allMembersList = allMembersFromExcel(false);
var allSignedInList = allMembersFromExcel(true);
var signedInLevelList =  levelListGenerator();
int COURTS;
int matchTime = 10;
bool membersRefresh = false;
