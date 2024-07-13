class Validation {

  bool validateType(String airplaneType) {
    return airplaneType.isNotEmpty;
  }

  bool validatePassengers(String maxPassengers) {
    RegExp regExp = RegExp(r'^[0-9]+$');
    return regExp.hasMatch(maxPassengers);
  }

  bool validateSpeed(String maxSpeed) {
    RegExp regExp = RegExp(r'^(0|[1-9]\d*)(\.\d+)?$');
    return regExp.hasMatch(maxSpeed.toString());
  }

  bool validateRange(String maxRange) {
    RegExp regExp = RegExp(r'^(0|[1-9]\d*)(\.\d+)?$');
    return regExp.hasMatch(maxRange.toString());
  }
}