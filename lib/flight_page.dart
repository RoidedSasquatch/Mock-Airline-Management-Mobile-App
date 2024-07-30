import 'package:cst2335_group_project/AppLocalizations.dart';
import 'package:cst2335_group_project/flight.dart';
import 'package:cst2335_group_project/flight_dao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FlightPage extends StatefulWidget {

  const FlightPage({super.key, required this.title});

  final String title;

  @override
  State<FlightPage> createState() => FlightPageState();
}

class FlightPageState extends State<FlightPage> {

  List<Flight> flightList = [];

  late FlightDao flightDao;

  Flight? selectedFlight;

  late TextEditingController _originController;
  late TextEditingController _destinationController;
  late TextEditingController _departureController;
  late TextEditingController _arrivalController;

  List<Locale> locales = [Locale("en", "CA"), Locale("ja")];
  var currentLocIndex = 0;

  String translate(String key) {
    return AppLocalizations.of(context)?.translate(key)??"No Translation Available";
  }

  @override
  void initState() {
    super.initState();

    _originController = TextEditingController();
    _destinationController = TextEditingController();
    _departureController = TextEditingController();
    _arrivalController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }



  Widget flightControl() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              translate("FL_origin")
            ),
            SizedBox(
              width: 100,
              height: 20,
              child: TextField(
                  controller: _originController,
                  style: const TextStyle(color: Colors.white)
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
                translate("FL_destination")
            ),
            SizedBox(
              width: 100,
              height: 20,
              child: TextField(
                  controller: _destinationController,
                  style: const TextStyle(color: Colors.white)
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
                translate("FL_departure")
            ),
            SizedBox(
              width: 100,
              height: 20,
              child: TextField(
                  controller: _departureController,
                  style: const TextStyle(color: Colors.white)
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
                translate("FL_arrival")
            ),
            SizedBox(
              width: 100,
              height: 20,
              child: TextField(
                  controller: _arrivalController,
                  style: const TextStyle(color: Colors.white)
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate("FL_flight_operations"),
          style: const TextStyle(
            color: Colors.white,
            fontFamily: "Satoshi",
            fontSize: 20,
            fontWeight: FontWeight.bold
          )
        ),
      ),
      body: Center(
        child: Column(
          children: [
            flightControl()
          ],
        )
      )
    );
  }
}