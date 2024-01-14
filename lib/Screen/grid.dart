import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class TouchCoordinatesScreen extends StatelessWidget {
  final List<Offset> touchCoordinates;

  TouchCoordinatesScreen({required this.touchCoordinates});

  @override
  Widget build(BuildContext context) {
    // Build your screen here, and you can use the touchCoordinates list as needed.
    // Display or process the touch coordinates on this screen.
    return Scaffold(
      appBar: AppBar(
        title: Text('Touch Coordinates'),
      ),
      body: ListView.builder(
        itemCount: touchCoordinates.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('X: ${touchCoordinates[index].dx}, Y: ${touchCoordinates[index].dy}'),
          );
        },
      ),
    );
  }
}

