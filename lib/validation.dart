class Validation {

  bool validateType(String airplaneType) {
    RegExp regExp = RegExp(r'^[a-z][A-Z]+$', caseSensitive: false);
    return regExp.hasMatch(airplaneType);
  }

  bool validatePassengers(int maxPassengers) {
    RegExp regExp = RegExp(r'^[0-9]+$');
    return regExp.hasMatch(maxPassengers.toString());
  }

  bool validateSpeed(int maxSpeed) {
    RegExp regExp = RegExp(r'^(0|[1-9]\d*)(\.\d+)?$');
    return regExp.hasMatch(maxSpeed.toString());
  }

  bool validateRange(int maxRange) {
    RegExp regExp = RegExp(r'^(0|[1-9]\d*)(\.\d+)?$');
    return regExp.hasMatch(maxRange.toString());
  }
}