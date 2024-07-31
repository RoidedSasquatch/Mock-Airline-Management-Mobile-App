import 'package:cst2335_group_project/AppLocalizations.dart';
import 'package:cst2335_group_project/flight.dart';
import 'package:cst2335_group_project/flight_dao.dart';
import 'package:cst2335_group_project/flight_data_repository.dart';
import 'package:cst2335_group_project/flight_database.dart';
import 'package:cst2335_group_project/flight_utils.dart';
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

  late Widget currentView;
  bool addingFlight = false;
  bool updatingFlight = false;

  String translate(String key) {
    return AppLocalizations.of(context)?.translate(key) ??
        "No Translation Available";
  }

  @override
  void initState() {
    super.initState();
    loadTextControllers();
    loadFlights();
  }

  void loadFlights() async {
    final database =
        await $FloorAppDatabase.databaseBuilder("flightT2_db").build();
    flightDao = database.flightDao;
    updateFlights();
  }

  void loadTextControllers() {
    FlightDataRepository.loadFlightData();

    _originController = TextEditingController();
    _destinationController = TextEditingController();
    _departureController = TextEditingController();
    _arrivalController = TextEditingController();

    _originController.text = FlightDataRepository.origin;
    _destinationController.text = FlightDataRepository.destination;
    _departureController.text = FlightDataRepository.departure;
    _arrivalController.text = FlightDataRepository.arrival;
  }

  void updateFlights() async {
    final result = await flightDao.findAllFlights();
    setState(() {
      flightList = result;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void addFlight(
      String origin, String destination, String departure, String arrival) {
    Flight newFlight =
        Flight(FlightUtils.id++, origin, destination, departure, arrival);
    flightDao.insertFlight(newFlight);
    updateFlights();
  }

  void updateFlightDetails(Flight updatedFlight) async {
    await flightDao.updateFlight(updatedFlight);
    updateFlights();
  }

  void removeFlight(Flight delFlight) async {
    await flightDao.deleteFlight(delFlight);
    updateFlights();
  }

  Widget wrapInBox(Widget original, double height, double width) {
    return SizedBox(height: height, width: width, child: original);
  }

  Widget flightDetails() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(translate("FL_origin")),
            SizedBox(
              width: 100,
              height: 20,
              child: TextField(
                  controller: _originController,
                  style: const TextStyle(color: Colors.black)),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(translate("FL_destination")),
            SizedBox(
              width: 100,
              height: 20,
              child: TextField(
                  controller: _destinationController,
                  style: const TextStyle(color: Colors.black)),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(translate("FL_departure")),
            SizedBox(
              width: 100,
              height: 20,
              child: TextField(
                  controller: _departureController,
                  style: const TextStyle(color: Colors.black)),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(translate("FL_arrival")),
            SizedBox(
              width: 100,
              height: 20,
              child: TextField(
                  controller: _arrivalController,
                  style: const TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ],
    );
  } //End of method flightDetails

  Widget addFlightButtons() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      ElevatedButton(
          onPressed: () {
            addFlight(_originController.text, _destinationController.text,
                _departureController.text, _arrivalController.text);
          },
          child: SizedBox(
              height: 30,
              width: 120,
              child: Row(children: [
                const Icon(
                  Icons.add,
                  color: Colors.greenAccent,
                ),
                Text(translate("FL_add_flight"))
              ]))),
      ElevatedButton(
          onPressed: () {
            _originController.text = "";
            _destinationController.text = "";
            _departureController.text = "";
            _arrivalController.text = "";
          },
          child: SizedBox(
              height: 30,
              width: 120,
              child: Row(children: [
                const Icon(
                  Icons.clear,
                  color: Colors.greenAccent,
                ),
                Text(translate("FL_clear_fields"))
              ]))),
    ]);
  }

  Widget selectedFlightButtons() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      ElevatedButton(
          onPressed: () {
            Flight updatedFlight = Flight(
                selectedFlight!.id,
                _originController.text,
                _destinationController.text,
                _departureController.text,
                _arrivalController.text);
            updateFlightDetails(updatedFlight);
          },
          child: SizedBox(
              height: 30,
              width: 120,
              child: Row(children: [
                const Icon(
                  Icons.arrow_circle_up,
                  color: Colors.greenAccent,
                ),
                Text(translate("FL_update_flight"))
              ]))),
      ElevatedButton(
          onPressed: () {
            removeFlight(selectedFlight!);
          },
          child: SizedBox(
              height: 30,
              width: 120,
              child: Row(children: [
                const Icon(
                  Icons.delete,
                  color: Colors.greenAccent,
                ),
                Text(translate("FL_remove_flight"))
              ]))),
    ]);
  }

  Widget flightListView(double height, double width) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      wrapInBox(
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Text(translate("FL_available_flights")),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    addingFlight = true;
                    updatingFlight = false;
                  });
                },
                child: Icon(Icons.add, color: Colors.greenAccent))
          ]),
          height / 10,
          width),
      wrapInBox(
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            wrapInBox(
                Text(translate("FL_flight_id"), textAlign: TextAlign.center),
                30,
                width / 12),
            wrapInBox(
                Text(translate("FL_flight_origin"),
                    textAlign: TextAlign.center),
                30,
                width / 4),
            wrapInBox(
                Text(translate("FL_flight_destination"),
                    textAlign: TextAlign.center),
                30,
                width / 4),
            wrapInBox(
                Text(translate("FL_flight_departure"),
                    textAlign: TextAlign.center),
                30,
                width / 5),
            wrapInBox(
                Text(translate("FL_flight_arrival"),
                    textAlign: TextAlign.center),
                30,
                width / 5),
          ]),
          height / 10,
          width),
      SizedBox(
          height: height / 3,
          width: width,
          child: ListView.builder(
              itemCount: flightList.length,
              itemBuilder: (context, rowNum) {
                return GestureDetector(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          wrapInBox(
                              Text("${flightList[rowNum].id}",
                                  textAlign: TextAlign.center),
                              30,
                              width / 12),
                          wrapInBox(
                              Text(flightList[rowNum].origin,
                                  textAlign: TextAlign.center),
                              30,
                              width / 4),
                          wrapInBox(
                              Text(flightList[rowNum].destination,
                                  textAlign: TextAlign.center),
                              30,
                              width / 4),
                          wrapInBox(
                              Text(flightList[rowNum].departure,
                                  textAlign: TextAlign.center),
                              30,
                              width / 5),
                          wrapInBox(
                              Text(flightList[rowNum].arrival,
                                  textAlign: TextAlign.center),
                              30,
                              width / 5),
                        ]),
                    onTap: () {
                      setState(() {
                        selectedFlight = flightList[rowNum];
                        updatingFlight = true;
                        addingFlight = false;
                      });
                      _originController.text = selectedFlight!.origin;
                      _destinationController.text = selectedFlight!.destination;
                      _departureController.text = selectedFlight!.departure;
                      _arrivalController.text = selectedFlight!.arrival;
                    });
              }))
    ]);
  }

  Widget addFlightView(double height, double width) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          wrapInBox(
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      addingFlight = false;
                    });
                  },
                  child: Text(translate("FL_back"))),
              50,
              width / 3),
          wrapInBox(
              Text("Add a Flight", textAlign: TextAlign.center), 20, width / 3),
        ]),
        flightDetails(),
        addFlightButtons()
      ],
    );
  }

  Widget updateFlightView(double height, double width) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          wrapInBox(
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      updatingFlight = false;
                    });
                  },
                  child: Text(translate("FL_back"))),
              50,
              width / 3),
          wrapInBox(Text("Update a Flight", textAlign: TextAlign.center,),20,width/3),
        ]),
        flightDetails(),
        selectedFlightButtons()
      ],
    );
  }

  Widget phoneView(double height, double width) {
    Widget finalView = Column();
    if (updatingFlight) {
      finalView = SizedBox(
          width: width - 20,
          height: height - 20,
          child: updateFlightView(height, width));
    } else if (addingFlight) {
      finalView = SizedBox(
          width: width - 20,
          height: height - 20,
          child: addFlightView(height, width));
    } else {
      finalView = SizedBox(
          width: width - 20,
          height: height - 20,
          child: flightListView(height / 2, width - 50));
      ;
    }
    return finalView;
  }

  Widget tabletView(double height, double width) {
    Widget finalView = Column();
    if (updatingFlight) {
      finalView = Row(children: [
        SizedBox(
            width: (width / 2) - 20,
            child: flightListView(height, width / 2 - 20)),
        SizedBox(
            width: (width / 2) - 20,
            child: updateFlightView(height, width / 2 - 20))
      ]);
    } else if (addingFlight) {
      finalView = Row(children: [
        SizedBox(
            width: (width / 2) - 20,
            child: flightListView(height, width / 2 - 20)),
        SizedBox(
            width: (width / 2) - 20,
            child: addFlightView(height, width / 2 - 20))
      ]);
    } else {
      finalView = flightListView(height, width / 2 - 20);
    }
    return finalView;
  }

  Widget selectFinalView() {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    if ((width > height) && width > 720) {
      return tabletView(height, width);
    } else {
      return phoneView(height, width);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(translate("FL_flight_operations"),
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: "Satoshi",
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ),
        body: Center(
            child: Column(
          children: [Expanded(child: selectFinalView())],
        )));
  }
}
