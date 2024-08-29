import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/drawer.dart';
import '../widgets/chatbot.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<String> _categories = [
    'News',
    'Events',
    'Updates',
    'Alerts',
    'Notifications',
    'Reminders'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 28, 25, 106),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () {
              // Handle notification icon tap
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              color: Color.fromARGB(255, 28, 25, 106),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'Announcements',
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Category Slider
                  Container(
                    height: 50.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _categories.asMap().entries.map((entry) {
                        int index = entry.key;
                        String label = entry.value;
                        return categoryChip(index, label);
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Announcement Cards
                  // StreamBuilder<QuerySnapshot>(
                  //   stream: FirebaseFirestore.instance
                  //       .collection('events')
                  //       .where('category',
                  //           isEqualTo: _categories[_selectedIndex])
                  //       .snapshots(),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.hasError) {
                  //       return Center(
                  //         child: Text(
                  //           'Error: ${snapshot.error}',
                  //           style: TextStyle(color: Colors.white),
                  //         ),
                  //       );
                  //     }
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return Center(child: CircularProgressIndicator());
                  //     }

                  //     final events = snapshot.data?.docs ?? [];

                  //     if (events.isEmpty) {
                  //       return Container(
                  //         color: Color.fromARGB(
                  //             255, 28, 25, 106), // Retain background color
                  //         height: MediaQuery.of(context).size.height *
                  //             0.5, // Set a height to ensure the background color is visible
                  //         child: Center(
                  //           child: Text(
                  //             'No data available',
                  //             style: GoogleFonts.roboto(
                  //               textStyle: TextStyle(
                  //                 color: Colors.white,
                  //                 fontSize: 18,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       );
                  //     }

                  //     return Container(
                  //       color: Color.fromARGB(255, 28, 25,
                  //           106), // Ensure background color remains consistent
                  //       child: Column(
                  //         children: events.map((doc) {
                  //           return Padding(
                  //             padding: const EdgeInsets.symmetric(
                  //                 horizontal: 16.0, vertical: 8.0),
                  //             child: announcementCard(doc),
                  //           );
                  //         }).toList(),
                  //       ),
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
          ),
          // Chatbot Floating Action Button
          ChatBot(),
        ],
      ),
    );
  }

  // Helper widget to create category chips
  Widget categoryChip(int index, String label) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () async {
        // Introduce a delay before changing the selected index
        await Future.delayed(Duration(milliseconds: 200));
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isSelected
                  ? [Color(0xFF4C51BF), Color(0xFF6B46C1)]
                  : [Color(0xFF3C3C3C), Color(0xFF3C3C3C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8.0,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      label,
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Active category indicator
              if (isSelected)
                Positioned(
                  right: -10,
                  top: -10,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Colors.deepPurpleAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to create the announcement card
  Widget announcementCard(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Parse and format the date
    DateTime eventDate = (data['event_date'] as Timestamp).toDate();
    String formattedDate = DateFormat('MMMM d, yyyy').format(eventDate);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.2),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 28, 25, 106), // Match the background color
              Color.fromARGB(255, 28, 25, 106)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                data['title'] ?? 'No Title',
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF312E81),
                  ),
                ),
              ),
              SizedBox(height: 8),
              // Description
              Text(
                data['description'] ?? 'No Description',
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 8),
              // Date and Time
              Text(
                '$formattedDate at ${data['event_time'] ?? 'No Time'}',
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[300],
                  ),
                ),
              ),
              SizedBox(height: 8),
              // Location
              Text(
                data['event_location'] ?? 'No Location',
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[300],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
