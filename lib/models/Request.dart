import 'package:cloud_firestore/cloud_firestore.dart';

import 'user_model.dart';
import 'UserLocation.dart';

class Request {
  UserModel blindData;
  UserLocation blindLocation;
  String state;
  String? volunteerId;
  Timestamp date;

  Request({
    required this.blindData,
    required this.blindLocation,
    this.state = "waiting",
    this.volunteerId,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'blindData': blindData.toMap(),
      'blindLocation': blindLocation.toMap(),
      'state': state,
      'volunteerId': volunteerId,
      'date': date,
    };
  }

  static Request fromJson(Map<String, dynamic> json) {
    return Request(
      blindData: UserModel.fromJson(json['blindData']),
      blindLocation: UserLocation.fromJson(json['blindLocation']),
      state: json['state'],
      volunteerId: json['volunteerId'],
      date: json['date'],
    );
  }

  DateTime _fromTimeStamp() {
    return DateTime.fromMicrosecondsSinceEpoch(date.microsecondsSinceEpoch);
  }
}

class UserLocation {
  double latitude;
  double longitude;

  UserLocation({required this.latitude, required this.longitude});

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  static UserLocation fromJson(Map<String, dynamic> json) {
    return UserLocation(
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
    );
  }
}
