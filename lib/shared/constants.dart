import 'package:flutter/material.dart';

import '../models/user_model.dart';

List<UserModel> users = [];

Widget buildRequestItem(List<UserModel> users, int index) {
  return Container(
    height: 100,
    width: double.infinity,
    child: Row(
      children: [
        Text(users[index].fullName),
        SizedBox(
          width: 20,
        ),
        Text(users[index].phone),
      ],
    ),
  );
}
