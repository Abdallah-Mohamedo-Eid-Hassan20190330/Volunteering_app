
class Response {
  String blindPersonNationalId;
  String volunteerNationalId;
  String volunteerName;
  String volunteerPhone;
  RouteData routeData;

  Response({
    required this.blindPersonNationalId,
    required this.volunteerNationalId,
    required this.volunteerName,
    required this.volunteerPhone,
    required this.routeData,
  });

  Map<String, dynamic> toMap() {
    return {
      'blindPersonNationalId': blindPersonNationalId,
      'volunteerNationalId': volunteerNationalId,
      'volunteerName': volunteerName,
      'volunteerPhone': volunteerPhone,
      'routeData': routeData.toMap(),
    };
  }

  static Response fromJson(Map<String, dynamic> json) {
    return Response(
      blindPersonNationalId: json['blindPersonNationalId'] as String? ?? '',
      volunteerNationalId: json['volunteerNationalId'] as String? ?? '',
      volunteerName: json['volunteerName'] as String? ?? '',
      volunteerPhone: json['volunteerPhone'] as String? ?? '',
      routeData: RouteData.fromJson(json['routeData']),
    );
  }
}

class RouteData {
  double distance;
  double duration;

  RouteData({required this.distance, required this.duration});

  Map<String, dynamic> toMap() {
    return {
      'distance': distance,
      'duration': duration,
    };
  }

  static RouteData fromJson(Map<String, dynamic> json) {
    return RouteData(
      distance: json['distance'] as double? ?? 0,
      duration: json['duration'] as double? ?? 0,
    );
  }
}
