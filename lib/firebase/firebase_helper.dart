import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../modules/requests/request_list.dart';

class FirebaseHelper {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future signUp(
      {required String email,
      required String password,
      required context}) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      //////////////////////////
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RequestList(),
        ),
      );
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
