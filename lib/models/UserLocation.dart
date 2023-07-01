class UserLocation {
  int _latitude, _longitude;

  UserLocation(this._latitude, this._longitude);

  get longitude => _longitude;

  set longitude(value) {
    _longitude = value;
  }

  int get latitude => _latitude;

  set latitude(int value) {
    _latitude = value;
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': _latitude,
      'longitude': _longitude,
    };
  }

  static UserLocation fromJson(Map<String, dynamic> json) {
    return UserLocation(json['latitude'], json['longitude']);
  }
}
