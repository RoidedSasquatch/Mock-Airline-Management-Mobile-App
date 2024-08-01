import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class FlightDataRepository {

  static String origin = "";

  static String destination = "";

  static String departure = "";

  static String arrival = "";

  static EncryptedSharedPreferences storedData = EncryptedSharedPreferences();

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

  static void saveFlightData() {
    storedData.setString("origin", origin);
    storedData.setString("destination", destination);
    storedData.setString("departure", departure);
    storedData.setString("arrival", arrival);
  }
}