import 'dart:async';
import 'package:volunteer_app/modules/requests/MapScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:volunteer_app/models/Request.dart';

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
                        onTap: () {
                          if (!isAccepted) {
                            acceptRequest(users[index].blindData.nationalId, index);
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
                            if (isAccepted) {
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
                            }
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
