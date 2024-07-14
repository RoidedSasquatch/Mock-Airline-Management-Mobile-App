/// Validation class provides methods for validating airplane data inputs.
class Validation {

  /// Validates if the [airplaneType] is not empty.
  /// Returns true if [airplaneType] is not empty; false otherwise.
  bool validateType(String airplaneType) {
    return airplaneType.isNotEmpty;
  }

  /// Validates if the [maxPassengers] is a valid integer.
  /// Returns true if [maxPassengers] is a valid integer; false otherwise.
  bool validatePassengers(String maxPassengers) {
    RegExp regExp = RegExp(r'^[0-9]+$');
    return regExp.hasMatch(maxPassengers);
  }

  /// Validates if the [maxSpeed] is a valid numeric value.
  /// Returns true if [maxSpeed] is a valid numeric value; false otherwise.
  bool validateSpeed(String maxSpeed) {
    RegExp regExp = RegExp(r'^(0|[1-9]\d*)(\.\d+)?$');
    return regExp.hasMatch(maxSpeed.toString());
  }

  /// Validates if the [maxRange] is a valid numeric value.
  /// Returns true if [maxRange] is a valid numeric value; false otherwise.
  bool validateRange(String maxRange) {
    RegExp regExp = RegExp(r'^(0|[1-9]\d*)(\.\d+)?$');
    return regExp.hasMatch(maxRange.toString());
  }
}