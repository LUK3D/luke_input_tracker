import 'dart:async';

import 'package:flutter/material.dart';
import 'package:luke_input_tracker/luke_input_tracker.dart';

class TrackMouse extends StatefulWidget {
  const TrackMouse({super.key});

  @override
  State<TrackMouse> createState() => _TrackMouseState();
}

class _TrackMouseState extends State<TrackMouse> {
  String logs = "";

  // Event Listner
  final stream = LukeInputTracker.listen();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [FilledButton(onPressed: (){
                //Send the "A" key event each second
                Timer.periodic(Duration(seconds: 1), (t){
                  LukeInputTracker.sendKeyPress(TrackerKey.keyA);
                });
              }, child: Text("Send Mouse event"))],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              // Check Accessibility permissions
              future: LukeInputTracker.isAccessibilityPermissionGranted(),
              builder: (context, asyncSnapshot) {
                if(asyncSnapshot.data != true){
                  return Center(
                    child: Text("Pelase, provide accessibility permission and restart the app")
                  );
                }

                // Stream keyboard events 
                return StreamBuilder(stream: stream, builder: (ctx, snapshot ){
                
                  if(!snapshot.hasData){
                    return Text("No Content");
                  }
                  
                  return Text(snapshot.data?.toString()??"No Content 2");
                });
              }
            ),
          ),
        ],
      ),
    );
  }
}