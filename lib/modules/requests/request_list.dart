import 'dart:async';
import 'package:volunteer_app/modules/requests/MapScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:volunteer_app/models/Request.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RequestList extends StatefulWidget {
  @override
  State<RequestList> createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  List<Request> users = [];

  Future<void> getData() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await db.collection("Requests").get();
    List<Request> requestList = querySnapshot.docs
        .map((doc) => Request.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    setState(() {
      users = requestList;
    });
  }

  Future<void> acceptRequest(String nationalId, int index) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await db
        .collection("Requests")
        .where("blindData.nationalId", isEqualTo: nationalId)
        .get();
    if (querySnapshot.docs.length > 0) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
      String requestId = documentSnapshot.id;

      db.collection('Requests')
          .doc(requestId)
          .update({'state': 'accepted'})
          .then((_) {
        setState(() {
          users[index].state = 'accepted';
        });

        // Show visual feedback for button press
        Timer(const Duration(milliseconds: 200), () {
          setState(() {
            users[index].state = 'accepted';
          });
        });

        Fluttertoast.showToast(
          msg: 'Request accepted successfully!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }).catchError((e) {
        Fluttertoast.showToast(
          msg: 'Failed to accept request. ${e.toString()}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        print(e);
      });
    } else {
      Fluttertoast.showToast(
        msg: 'Request not found!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void sendResponseToServer(double distance, String duration , String blindNationalId) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

    // Get the current user's UID
    String volunteerUserId = auth.currentUser!.uid;

    // Fetch the volunteer's information from Firestore based on their UID
    QuerySnapshot volunteerSnapshot = await db
        .collection('Volunteers')
        .where('key', isEqualTo: volunteerUserId)
        .get();

    if (volunteerSnapshot.docs.isNotEmpty) {
      // Retrieve the volunteer's information
      DocumentSnapshot volunteerDocument = volunteerSnapshot.docs.first;
      String volunteerNationalId = volunteerDocument['nationalId'];
      String volunteerName = volunteerDocument['fullName'];
      String volunteerPhone = volunteerDocument['phone'];

      // Retrieve the blind person's information
      // Replace this with the appropriate logic to retrieve the blind person's information

      // Create a new document in the "Responses" collection
      db.collection('Responses').add({
        'blindId': blindNationalId,
        'volunteerId': volunteerNationalId,
        'volunteerName': volunteerName,
        'volunteerPhone': volunteerPhone,
        'routeData': {
          'distance': distance,
          'duration': duration,
        },
      }).then((value) {
        Fluttertoast.showToast(
          msg: 'Response sent successfully!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }).catchError((error) {
        Fluttertoast.showToast(
          msg: 'Failed to send response. ${error.toString()}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        print(error);
      });
    } else {
      Fluttertoast.showToast(
        msg: 'Volunteer data not found!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }



  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.separated(
        itemCount: users.length,
        separatorBuilder: (context, index) => Container(
          width: double.infinity,
          color: Colors.grey,
        ),
        itemBuilder: (context, index) {
          return buildRequestItem(users, index);
        },
      ),
    );
  }

  Widget buildRequestItem(List<Request> users, int index) {
    bool isAccepted = users[index].state == 'accepted';

    return Container(
      height: 100,
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            // Rest of your code...

            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          users[index].blindData.fullName,
                          overflow: TextOverflow.clip,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          "${users[index].blindData.phone}",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (!isAccepted) {
                            double blindPersonLatitude = users[index].blindLocation.latitude;
                            double blindPersonLongitude = users[index].blindLocation.longitude;

                            var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MapScreen(
                                  blindPersonLatitude: blindPersonLatitude,
                                  blindPersonLongitude: blindPersonLongitude,
                                ),
                              ),
                            );

                            if (result != null && result is Map<String, dynamic>) {
                              acceptRequest(users[index].blindData.nationalId, index);
                              double distance = result['distance'];
                              String eta = result['eta'];
                              sendResponseToServer(distance, eta , users[index].blindData.nationalId);
                            }
                            else {
                              // Handle the case when the result is null or not of the expected type
                              // You can display an error message or perform other actions as needed
                            }
                          }
                        },

                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 40,
                          width: 110,
                          decoration: BoxDecoration(
                            color: isAccepted ? Colors.grey : Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              isAccepted ? 'Accepted' : 'Accept',
                              style: TextStyle(
                                color: isAccepted ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        height: 40,
                        width: 115,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: MaterialButton(
                          onPressed: () {
                            double blindPersonLatitude = users[index].blindLocation.latitude;
                            double blindPersonLongitude = users[index].blindLocation.longitude;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MapScreen(
                                  blindPersonLatitude: blindPersonLatitude,
                                  blindPersonLongitude: blindPersonLongitude,
                                ),
                              ),
                            );
                          },
                          child: Text("View on Map"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
}
