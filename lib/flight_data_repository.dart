import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

/// A repository for managing flight data using encrypted shared preferences.
class FlightDataRepository {
  /// The origin location of the flight.
  static String origin = "";

  /// The destination location of the flight.
  static String destination = "";

  /// The departure time of the flight.
  static String departure = "";

  /// The arrival time of the flight.
  static String arrival = "";

  /// Instance of [EncryptedSharedPreferences] to store encrypted data.
  static EncryptedSharedPreferences storedData = EncryptedSharedPreferences();

  /// Loads flight data from the encrypted shared preferences.
  ///
  /// Retrieves the origin, destination, departure, and arrival times and assigns them to the respective static variables.
  static void loadFlightData() {
    storedData.getString("origin").then((value) {
      origin = value;
    });

    storedData.getString("destination").then((value) {
      destination = value;
    });

    storedData.getString("departure").then((value) {
      departure = value;
    });

    storedData.getString("arrival").then((value) {
      arrival = value;
    });
  }

  /// Saves flight data to the encrypted shared preferences.
  ///
  /// Stores the current values of origin, destination, departure, and arrival times.
  static void saveFlightData() {
    storedData.setString("origin", origin);
    storedData.setString("destination", destination);
    storedData.setString("departure", departure);
    storedData.setString("arrival", arrival);
  }
}
