import 'package:flutter/material.dart';
import 'dart:async'; // Import Timer
import 'package:http/http.dart' as http;
import 'config.dart';

class CustomGestureButton extends StatefulWidget {
  final String cmd;
  final Color color;
  final IconData icon;

  const CustomGestureButton({
    super.key,
    required this.cmd,
    required this.color,
    required this.icon,
  });

  @override
  _CustomGestureButtonState createState() => _CustomGestureButtonState();
}

class _CustomGestureButtonState extends State<CustomGestureButton> {
  late Color buttonColor;
  bool lightOn = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    buttonColor = widget.color;
  }

  Future<void> _handleButtonClick(String cmd) async {
    if (cmd == 'W') {
      _changeButtonColor(true);
      if (lightOn) {
        cmd = 'w';
        lightOn = false;
      } else {
        lightOn = true;
      }
    }

    print('$cmd button clicked');
    try {
      final response = await http.get(Uri.parse('http://$roboIp:$roboPort/?State=$cmd'));

      if (response.statusCode == 200) {
        print('sent $cmd');
      } else {
        print("Failed to send $cmd");
      }
    } catch (e) {
      
        print('Error occurred: $e');
    }
    if (cmd == 'w') {
      _changeButtonColor(false);
    }
  }

  void _changeButtonColor(bool isPressed) {
    setState(() {
      buttonColor = isPressed ? widget.color.withOpacity(0.7) : widget.color;
    });
  }

    // Function to handle continuous action on long press
  void _startPressing(String cmd) {
    _changeButtonColor(true);
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      print('$cmd button long-pressed');
      _handleButtonClick(cmd);
    });
  }

  // Function to stop continuous action when long press ends
  void _stopPressing(String cmd) {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    _changeButtonColor(false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleButtonClick(widget.cmd),
      onTapDown: (_) => _changeButtonColor(true),
      onTapUp: (_) => _changeButtonColor(false),
      onTapCancel: () => _changeButtonColor(false),
      onLongPressStart: (_) => _startPressing(widget.cmd),
      onLongPressEnd: (_) => _stopPressing(widget.cmd),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: buttonColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          widget.icon,
          size: 40.0,
          color: Colors.white,
        ),
      ),
    );
  }
}