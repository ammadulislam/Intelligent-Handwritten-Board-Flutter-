import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../Global.dart';
import '../Screen/writing_pad.dart';
import 'package:http/http.dart' as http;

class Images extends StatefulWidget {

  final List<Uint8List> screenshotImages;
  final List<SlideData> slidesData;
  final String selectedSubject;
  final String selectedLectureNo;
  final int selectedSection;
  final int id;/////////////////////////it is pending for adding Remember it


  Images({required this.slidesData,required this.selectedSubject, required this.selectedLectureNo, required this.selectedSection,required this.screenshotImages,required this.id});



  @override
  _ImagesState createState() => _ImagesState();
}class _ImagesState extends State<Images> {
  TextEditingController titleController=TextEditingController();
  List<Segment> allSegments = [];

  @override
  void initState() {
    super.initState();
    _initializeAllSegments();
  }

  void _initializeAllSegments() {
    // Clear the list before adding segments
    allSegments.clear();

    // Concatenate segments from all slides
    for (var slideData in widget.slidesData) {
      allSegments.addAll(slideData.segments);
    }
  }

  Future<void> _sendSelectedImagesToApi(int teacherId) async {
    // Ensure at least one image is selected
    if (_selectedIndices.isEmpty) {
      print("No image Selected");
      return;
    }

    // Create a list to store base64-encoded image strings
    // Show dialog for entering the title
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Title For Document'),
          content: TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Do something with the entered title
                String enteredTitle = titleController.text;
                print('Entered Title: $enteredTitle');

                // Close the dialog
                Navigator.of(context).pop();

                // Continue with your API call using the entered title
                await _continueApiCall(teacherId, enteredTitle);
              },
              child: Text('Send'),
            ),
          ],
        );
      },
    );
  }

    Future<void> _continueApiCall(int userid, String enteredTitle) async {
      final apiUrl = '${Globals.ipAddress}/getAllData';
      List<String> base64Images = [];

      // Populate the list with your base64-encoded image strings
      for (var index in _selectedIndices) {
        final Uint8List imageBytes = widget.screenshotImages[index];
        final base64Image = base64Encode(imageBytes);
        base64Images.add(base64Image);
      }

      // Convert allSegments to a list of dictionaries
    List<Map<String, dynamic>> allSegmentData =
    allSegments.map((segment) => segment.toJson()).toList();
    print('Debug: allSegmentData before sending to API: $allSegmentData');
    print("Image path :$base64Images");
    print("session id ${widget.id}");
    // Prepare the request data as a JSON object
    final requestData = {
      'UserID': userid,
      'SectionID': widget.selectedSection,
      'Title': enteredTitle,
      'Course': widget.selectedSubject,
      'Lecture': widget.selectedLectureNo,
      'Images': base64Images,
      'AllSegments': allSegmentData,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        // Images and data were successfully sent to the API
        print('Data sent to API successfully.');
        // Handle the response from the API if needed
      } else {
        // Handle error cases
        print(
            'Failed to send data to API. Status code: ${response.statusCode}');
        // Check the response for more information on the error
        final responseText = response.body;
        print('Response body: $responseText');
      }
    } catch (e) {
      print('Error sending data to API: $e');
    }
  }

  List<int> _selectedIndices = [];

  void _toggleSelectionMode(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
      } else {
        _selectedIndices.add(index);
      }
    });
  }

  void _deleteSelectedImages() {
    setState(() {
      _selectedIndices.sort((a, b) => b.compareTo(a));
      for (var index in _selectedIndices) {
        widget.screenshotImages.removeAt(index);
      }
      _selectedIndices.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: _selectedIndices.isNotEmpty
            ? Text('${_selectedIndices.length} selected')
            : Center(child: Text('Screenshot Images')),
        automaticallyImplyLeading: false,
      ),
      body: StaggeredGridView.countBuilder(
        crossAxisCount: 2,
        itemCount: widget.screenshotImages.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _toggleSelectionMode(index);
            },
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  margin: EdgeInsets.all(8),
                  child: Hero(
                    tag: 'image_$index',
                    child: Image.memory(
                      widget.screenshotImages[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: _selectedIndices.contains(index)
                        ? Colors.blue.withOpacity(0.6)
                        : Colors.black.withOpacity(0.6),
                    child: _selectedIndices.contains(index)
                        ? Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    )
                        : Text(
                      'Image ${index + 1}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        staggeredTileBuilder: (index) => StaggeredTile.fit(1),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delete),
            label: 'Delete',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.send),
            label: 'Send',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => WritingPad()),
            // );
          } else if (index == 1) {
            _deleteSelectedImages();
          } else if (index == 2) {
            int userid = 32;
            int sectionid = 4;
            String title = "Bist2A,lecc_5_6,";
            String course="DSA" ;
            String lecture = "Lec_5_6";
            _sendSelectedImagesToApi(userid);
          }
        },
      ),
    );
  }
}

