import 'package:flutter/material.dart';
import '../Screen/writing_pad.dart';

class EventScreen extends StatefulWidget {
  final List<SlideData> slidesData;
  final String selectedSubject;
  final String selectedLectureNo;
  final int selectedSection;
  EventScreen({required this.slidesData,required this.selectedSubject, required this.selectedLectureNo, required this.selectedSection,});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    List<Segment> allSegments = [];

    // Concatenate segments from all slides
    for (var slideData in widget.slidesData) {
      allSegments.addAll(slideData.segments);
    }

    return Scaffold(
      appBar: AppBar(title: Text("Events")),
      body: Container(
        color: Colors.white, // Set the background color to white
        child: Column(
          children: [
            // Display the stored stroke information
            Expanded(
              child: ListView.builder(
                itemCount: allSegments.length,
                itemBuilder: (context, index) {
                  final segment = allSegments[index];
                  final start = segment.startPoint; // Get the start point

                  return Column(
                    children: [
                      ListTile(
                        title: Text('Slide ${segment.slideNumber + 1}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Stroke ID:${segment.id}'),
                            Text('Start Point: (${start.dx}, ${start.dy})'),
                            Text('Color: ${segment.color.toString()}'),
                            Text('Thickness: ${segment.thickness}'),
                            Text('Subject: ${widget.selectedSubject}'),
                            Text('Lec: ${widget.selectedLectureNo}'),
                            Text('Section : ${widget.selectedSection}'),

                            //Text('Font Size: ${segment.fontSize}'), // Display the font size
                          ],
                        ),
                      ),
                      Divider(), // Add a divider between list tiles
                    ],
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
