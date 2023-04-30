//@dart = 2.9
import 'package:flutter/material.dart';

//timer import
import 'dart:async';

import 'all_functions.dart';
import 'courts_page.dart';
import 'globals.dart';

// Timer class widget
class CountDown extends StatefulWidget {

  const CountDown({Key key}) : super(key: key);

  @override
  _CountDownState createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> {

  _CountDownState();
  
  //initial value
  int count = 0;
  Timer timer;

  //set duration to something user set later
  Duration gameDuration = Duration(minutes: matchTime);

  @override
  void initState() {
    super.initState();
  }

  //function to start timer
  void startTimer(context) {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => setCountDown(context));
  }

  //function to stop timer
  void stopTimer() {
    setState(() => timer.cancel());
  }

  void timerReset() {
    stopTimer();
    //change this to user input timer later!!
    setState(() => gameDuration = Duration(minutes: matchTime));
  }

  void setCountDown(context) {
    const countDownBy = 1;
    setState(() {
      final seconds = gameDuration.inSeconds - countDownBy;
      if (seconds < 0) {
        timer.cancel();
        matchGeneratorMain(COURTS, signedInLevelList);
        Navigator.push(
          context, MaterialPageRoute(builder: (context) => const CourtsPage()),
        );

        
        //startTimer(context);

      } else {
        gameDuration = Duration(seconds: seconds);
      }
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');

    final minutes = strDigits(gameDuration.inMinutes.remainder(60));
    final seconds = strDigits(gameDuration.inSeconds.remainder(60));

    return Row(
      children: [
        //button to start the session
        Padding(
          padding: const EdgeInsets.only(left:15.0,right: 15.0, top:0, bottom: 10),
          child: ElevatedButton(
            onPressed: () {

              if (allSignedInList.length < 4) {
                print('Less than 4 players, cannot initiate algorithm');
                
              }
              else {
                  if (timer == null || !timer.isActive) {
                  startTimer(context);
                  }

                matchGeneratorMain(COURTS, signedInLevelList);
               
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const CourtsPage()),
                );
              }

            },
            child: const Text('Start Round'),
          ),
        ),

        //timer display
        Padding(
          padding: const EdgeInsets.only(left:15.0,right: 15.0, top:0, bottom: 10),
          child: Text('$minutes: $seconds'),
        ),
        
        Padding(
          padding: const EdgeInsets.only(left:15.0,right: 15.0, top:0, bottom: 10),
          child: ElevatedButton(onPressed: () {
          if (timer == null || !timer.isActive) {
            startTimer(context);
          }
          }, child: const Text('Start Timer')),
        ),

        Padding(
          padding: const EdgeInsets.only(left:15.0,right: 15.0, top:0, bottom: 10),
          child: ElevatedButton(
            onPressed: stopTimer,
            child: const Text('Stop Timer')
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left:15.0,right: 15.0, top:0, bottom: 10),
          child: ElevatedButton(
            onPressed: () {timerReset();},
            child: const Text('Reset Timer'))
        )
        ]
      );
  }
}
