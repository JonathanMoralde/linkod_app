import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import this for FirebaseAuth
import '../widgets/drawer.dart';

class RequestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current user's UID
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 28, 25, 106), // Background color
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
      ),
      drawer: AppDrawer(),
      backgroundColor: Color.fromARGB(255, 28, 25, 106),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Text
            Center(
              child: Text(
                'Request/Report Status',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            // StreamBuilder to fetch and display request details
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('requests')
                  .where('uid', isEqualTo: uid) // Filter by UID
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No requests found.'));
                }

                // Display each request
                return Column(
                  children: snapshot.data!.docs.map((document) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 8,
                      shadowColor: Colors.black.withOpacity(0.3),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF4C51BF), Color(0xFF6B46C1)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              // Custom Icon (can replace with a logo or another icon)
                              Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.description,
                                  color: Color(0xFF312E81),
                                  size: 30,
                                ),
                              ),
                              SizedBox(width: 16),
                              // Request Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Document Request',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Document: ${document['type'] ?? 'Unknown'}',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white70),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          'Status:',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white70),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(
                                          document['status'] == 'Pending'
                                              ? Icons.pending
                                              : Icons.check_circle,
                                          color: document['status'] == 'Pending'
                                              ? Colors.orange
                                              : Colors.green,
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          document['status'] ?? 'Unknown',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: document['status'] ==
                                                      'Pending'
                                                  ? Colors.orange
                                                  : Colors.green),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Date Requested: ${document['date_requested']?.toDate().toLocal().toString().split(' ')[0] ?? 'Unknown'}',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
