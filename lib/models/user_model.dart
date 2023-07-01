import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String nationalId = '';
  String fullName = '';
  String phone = '';
  String key = '';

//  String? picture;

  UserModel({
    required this.nationalId,
    required this.fullName,
    required this.phone,
    required this.key,
  });

  UserModel.fromUser();

  Map<String, dynamic> toMap() {
    return {
      'nationalId': nationalId,
      'fullName': fullName,
      'phone': phone,
      'key': key,
    };
  }

  static UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(
      nationalId: json['nationalId'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      key: json['key'] as String? ?? '',
    );
  }

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final json = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      nationalId: json['nationalId'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      key: json['key'] as String? ?? '',
    );
  }
}
