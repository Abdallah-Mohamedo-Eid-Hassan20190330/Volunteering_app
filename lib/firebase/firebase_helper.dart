import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/user_model.dart';
import '../modules/requests/request_list.dart';
import '../shared/constants.dart';

class FirebaseHelper {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future signUp({
    required String email,
    required String password,
    required context,
    required String nationalId,
    required String fullName,
    required String phone,
    required String key,
  }) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      //////////////////////////
      // getting the key of the current signed up user:
      key = userCredential.user!.uid;
      //storing in the firestore:
      UserModel user = UserModel(
          nationalId: nationalId, fullName: fullName, phone: phone, key: key);

      FirebaseFirestore db = FirebaseFirestore.instance;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RequestList(),
        ),
      );
      await db.collection("Volunteers").add(user.toMap());

      /////////////////////////
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      // print(e.toString());
    }
  }

  static Future login(
      {required String email,
      required String password,
      required context}) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      ///////////
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RequestList(),
        ),
      );
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print(e.toString());
    }
  }

  static Future getData() async {
    users.clear();
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("Requests").get().then((queryList) {
      for (var doc in queryList.docs) {
        users.add(UserModel.fromJson(doc.data()));
      }
      return users;
    });
  }
}
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   get user => _auth.currentUser;
//
//   //SIGN UP METHOD
//   Future signUp({required String email, required String password}) async {
//     try {
//       await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return null;
//     } on FirebaseAuthException catch (e) {
//       return e.message;
//     }
//   }
//
//   //SIGN IN METHOD
//   Future signIn({required String email, required String password}) async {
//     try {
//       await _auth.signInWithEmailAndPassword(email: email, password: password);
//       return null;
//     } on FirebaseAuthException catch (e) {
//       return e.message;
//     }
//   }
//
//   //SIGN OUT METHOD
//   Future signOut() async {
//     await _auth.signOut();
//
//     print('signout');
//   }
// }
