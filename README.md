# Luke Input Tracker (LIT)

Welcome to LIT. The perfect Input tracker for you application.

This package allows you to listend and send input events like mouse position, button and keyboard events globally on Linux (x11), MacOS and Windows.


## Getting started

This package uses Rust internally to implement low-level platform specific functionality.

To have the Rust code compiled from source, you need to install Rust through [rustup](https://rustup.rs/). The presence of rustup will be detected during build automatically.

For macOS or Linux, execute the following command in Terminal.
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
For Windows, you can use the [Rust Installer](https://static.rust-lang.org/rustup/dist/x86_64-pc-windows-msvc/rustup-init.exe).

In case you have Rust already installed, make sure to update it to latest version:

```bash
rustup update
```

That is it. The build integration will automatically install required Rust targets and other dependencies (NDK). This also means that first build might take a little bit longer.


## SETUP

### MacOS
 This package uses low level API. In order to work, the your app needs to have access to `Accessibility` API.

 If you're running your app inside Vscode or a Terminal, then Vscode or a the Terminal needs to be added in `System Preferences > Security & Privacy > Privacy > Accessibility`

 ### Linux
 The listen function uses X11 APIs, and so will not work in Wayland or in the Linux kernel virtual console
 You can make it work if you run it with the sudo command.


## Example Usage
 ```dart 
import 'package:flutter/material.dart';
import 'package:luke_input_tracker/luke_input_tracker.dart';

Future<void> main() async {
  await LukeInputTracker.init(); //Initialize LiT
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('flutter_rust_bridge quickstart')),
        body: TrackMouse(),
      ),
    );
  }
}

//---------------------------------------------------------

class TrackMouse extends StatefulWidget {
  const TrackMouse({super.key});

  @override
  State<TrackMouse> createState() => _TrackMouseState();
}

class _TrackMouseState extends State<TrackMouse> {
  String logs = "";

  final stream = LukeInputTracker.listen(); // Get the stream instance

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: FutureBuilder(
        future: LukeInputTracker.isAccessibilityPermissionGranted(),
        builder: (context, asyncSnapshot) {
          if(asyncSnapshot.data != true){
            return Center(
              child: Text("Pelase, provide accessibility permission and restart the app")
            );
          }
          //Listen to the events
          return StreamBuilder(stream: stream, builder: (ctx, snapshot ){
          
            if(!snapshot.hasData){
              return Text("No Content");
            }
            
            return Text(snapshot.data?.toString()??"No Content 2");
          });
        }
      ),
    );
  }
}
 ```
## Credits 
> This project uses the rust [rdev](https://github.com/Narsil/rdev) library.