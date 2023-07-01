import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:volunteer_app/firebase/firebase_helper.dart';
import 'package:volunteer_app/models/Request.dart';

import '../../models/user_model.dart';

class RequestList extends StatefulWidget {
  @override
  State<RequestList> createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  // final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Request> users = [];

  Future getData() async {
    // users.clear();
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("Requests").get().then((queryList) {
      for (var doc in queryList.docs) {
        setState(() {
          users.add(Request.fromJson(doc.data()));
          print(users[0].blindData.nationalId);
          print(users.length);
        });
      }
      print(users.length);
    }).catchError((e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print(e);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: users == null || users.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.separated(
                itemBuilder: (context, index) {
                  return buildRequestItem(users, index);
                },
                separatorBuilder: (context, index) => Container(
                  width: double.infinity,
                  color: Colors.grey,
                ),
                itemCount: users.length,
              ));
  }

  Widget buildRequestItem(List<Request> users, int index) {
    return Container(
      height: 100,
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Container(
              child: Expanded(
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
                          Text(users[index].blindData.fullName),
                          const SizedBox(
                            width: 20,
                          ),
                          Text("${users[index].blindData.nationalId}"),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          height: 40,
                          width: 110,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: MaterialButton(
                            onPressed: () {},
                            child: Text("Accept"),
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
                            onPressed: () {},
                            child: Text("View on Map"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
