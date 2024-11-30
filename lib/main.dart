import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for SystemChrome
import 'joystick_screen.dart'; // Import the second screen
import 'buttons.dart'; // Import your custom widget
import 'speed_slider.dart';

// Custom HttpOverrides class to bypass SSL certificate verification
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that Flutter bindings are initialized
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft, // Allow landscape left orientation
    DeviceOrientation.landscapeRight, // Allow landscape right orientation
  ]).then((_) {
    runApp(MyApp()); // Run your app
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arrow Buttons App',
      home: MainScreen(),
    );
  }
}

// Main Screen with Arrow Buttons and Toggle Button
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      /*appBar: AppBar(
        title: Text('Main Screen'),
      ),*/
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start, 
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          // Joystick button
          Padding (
            padding: EdgeInsets.only(top: screenHeight * 0.1 , left: screenWidth / 2.0 - 40),
            child: 
              ElevatedButton( 
                onPressed: () { 
                  Navigator.push(
                    context, MaterialPageRoute(builder:(context)=>JoystickScreen())
                  ); 
                },
                child: Text('Joystick')
              ),
          ),
          // Controls
          Row (
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Up Down buttons
              Column(
                children: [
                  Padding (
                    padding: EdgeInsets.only(top: 10, left: screenWidth * 0.08),
                    child: 
                      CustomGestureButton(
                        cmd: 'F',
                        color: Colors.blue,
                        icon: Icons.arrow_upward,
                      ),
                  ),
                  SizedBox(height: 50),
                  Padding (
                    padding: EdgeInsets.only(left: screenWidth * 0.08),
                    child:
                      CustomGestureButton(
                        cmd: 'B',
                        color: Colors.blue,
                        icon: Icons.arrow_downward,
                      ),
                  ),
                ],
              ),
              // Light switch button
              Padding (
                padding: EdgeInsets.only(top: 70, left: screenWidth * 0.05),
                child: 
                  CustomGestureButton(
                    cmd: 'W',
                    color: Colors.blueGrey,
                    icon: Icons.highlight,
                  ),
              ),
              // Horn & Left Right 
              Column (
                children: [
                  // Horn
                  Padding (
                    padding: EdgeInsets.only(top: 20, left: screenHeight * 0.7),
                    child: 
                      CustomGestureButton(
                        cmd: 'V',
                        color: Colors.lightGreen,
                        icon: Icons.speaker_phone,
                      ),
                  ),
                  // Left Right buttons
                  Row (
                    children: [
                      Padding (
                        padding: EdgeInsets.only(top: screenHeight * 0.5 - 170, left: screenHeight * 0.7),
                        child: 
                          CustomGestureButton(
                            cmd: 'L',
                            color: Colors.blue,
                            icon: Icons.arrow_back,
                          ),
                      ),
                      SizedBox(width: 70),
                      Padding (
                        padding: EdgeInsets.only(top: screenHeight * 0.5 - 170),
                        child: 
                          CustomGestureButton(
                            cmd: 'R',
                            color: Colors.blue,
                            icon: Icons.arrow_forward,
                          ),
                      ),
                    ],
                  ),       
                ],
              ),
            ]
          ), 
          // Speed Slider
          Padding (
            padding: EdgeInsets.only(top: screenHeight * 0.06, left: screenWidth / 2.0 - screenWidth * 0.2),
            child: 
              SizedBox (
                width: screenWidth * 0.4,
                child: ValueSlider(),
              ),
            )
        ]
      ),
    );
  }
}