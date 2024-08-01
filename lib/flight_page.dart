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
    FlightDataRepository.saveFlightData();
    super.dispose();
  }

  bool validateInput(String input) {
    if (input.length > 0) {
      return true;
    }
    SnackBar snackBar = SnackBar(
      content: Text(translate("FL_flight_error")),
      action: SnackBarAction(
        label: translate("close"),
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return false;
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

  Widget labelledTextField(TextEditingController controller, String label,
      double height, double width) {
    return SizedBox(
        height: height,
        width: width - 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: wrapInBox(Text(label, style: const TextStyle(color: Colors.white)), height, width / 3))),
            Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                    height: height - 30,
                    width: width / 3,
                    child: TextField(
                        controller: controller,
                        style: const TextStyle(color: Colors.white)))),
          ],
        ));
  }

  Widget flightDetails(double height, double width) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            labelledTextField(
                _originController, translate("FL_origin"), 40, width - 20),
            labelledTextField(_destinationController,
                translate("FL_destination"), 40, width - 20),
            labelledTextField(_departureController, translate("FL_departure"),
                40, width - 20),
            labelledTextField(
                _arrivalController, translate("FL_arrival"), 40, width - 20),
          ],
        ));
  } //End of method flightDetails

  Widget addFlightButtons() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
              WidgetStateColor.resolveWith((states) => Colors.black38),
              foregroundColor:
              WidgetStateColor.resolveWith((states) => Colors.black38),
              overlayColor:
              WidgetStateColor.resolveWith((states) => Colors.black12)),
          onPressed: () {
            SnackBar snackBar = SnackBar(
                content: Text(translate("FL_flight_added")),
                action: SnackBarAction(
                  label: translate("FL_ok"),
                  onPressed: () {},
                ));

            if (validateInput(_originController.text) &&
                validateInput(_destinationController.text) &&
                validateInput(_departureController.text) &&
                validateInput(_arrivalController.text)) {
              addFlight(_originController.text, _destinationController.text,
                  _departureController.text, _arrivalController.text);
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          child: SizedBox(
              height: 30,
              width: 120,
              child: Row(children: [
                const Icon(
                  Icons.add,
                  color: Colors.greenAccent,
                ),
                Text(translate("FL_add_flight"), style: const TextStyle(color: Colors.white))
              ]))),
      ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
              WidgetStateColor.resolveWith((states) => Colors.black38),
              foregroundColor:
              WidgetStateColor.resolveWith((states) => Colors.black38),
              overlayColor:
              WidgetStateColor.resolveWith((states) => Colors.black12)),
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
                Text(translate("FL_clear_fields"), style: const TextStyle(color: Colors.white))
              ]))),
    ]);
  }

  Widget selectedFlightButtons() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
              WidgetStateColor.resolveWith((states) => Colors.black38),
              foregroundColor:
              WidgetStateColor.resolveWith((states) => Colors.black38),
              overlayColor:
              WidgetStateColor.resolveWith((states) => Colors.black12)),
          onPressed: () {
            if (validateInput(_originController.text) &&
                validateInput(_destinationController.text) &&
                validateInput(_departureController.text) &&
                validateInput(_arrivalController.text)) {
              Flight updatedFlight = Flight(
                  selectedFlight!.id,
                  _originController.text,
                  _destinationController.text,
                  _departureController.text,
                  _arrivalController.text);
              updateFlightDetails(updatedFlight);
              updatingFlight = false;
            }
          },
          child: SizedBox(
              height: 30,
              width: 120,
              child: Row(children: [
                const Icon(
                  Icons.arrow_circle_up,
                  color: Colors.greenAccent,
                ),
                Text(translate("FL_update_flight"), style: const TextStyle(color: Colors.white))
              ]))),
      ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
              WidgetStateColor.resolveWith((states) => Colors.black38),
              foregroundColor:
              WidgetStateColor.resolveWith((states) => Colors.black38),
              overlayColor:
              WidgetStateColor.resolveWith((states) => Colors.black12)),
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
                Text(translate("FL_remove_flight"), style: const TextStyle(color: Colors.white))
              ]))),
    ]);
  }

  Widget flightListView(double height, double width) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      wrapInBox(
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Text(translate("FL_available_flights"), style: const TextStyle(color: Colors.white)),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                    WidgetStateColor.resolveWith((states) => Colors.black38),
                    foregroundColor:
                    WidgetStateColor.resolveWith((states) => Colors.black38),
                    overlayColor:
                    WidgetStateColor.resolveWith((states) => Colors.black12)),
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
                Text(translate("FL_flight_id"), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
                30,
                width / 12),
            wrapInBox(Text(translate("FL_origin"), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
                30, width / 4),
            wrapInBox(
                Text(translate("FL_destination"), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
                30,
                width / 4),
            wrapInBox(
                Text(translate("FL_departure"), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
                30,
                width / 5),
            wrapInBox(
                Text(translate("FL_arrival"), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
                30,
                width / 5),
          ]),
          height / 10,
          width),
      SizedBox(
          height: height / 2,
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
                                  textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
                              30,
                              width / 12),
                          wrapInBox(
                              Text(flightList[rowNum].origin,
                                  textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
                              30,
                              width / 4),
                          wrapInBox(
                              Text(flightList[rowNum].destination,
                                  textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
                              30,
                              width / 4),
                          wrapInBox(
                              Text(flightList[rowNum].departure,
                                  textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
                              30,
                              width / 5),
                          wrapInBox(
                              Text(flightList[rowNum].arrival,
                                  textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
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

  void saveFlightDetails() {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                title: Text(translate("FL_save_title")),
                actions: <Widget>[
                  ElevatedButton(
                      onPressed: () {
                        FlightDataRepository.origin = _originController.text;
                        FlightDataRepository.destination =
                            _destinationController.text;
                        FlightDataRepository.departure =
                            _departureController.text;
                        FlightDataRepository.arrival = _arrivalController.text;
                        FlightDataRepository.saveFlightData();
                        setState(() {
                          addingFlight = false;
                        });
                        Navigator.pop(context);
                      },
                      child: Text(translate("FL_save_details"))),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          addingFlight = false;
                        });
                      },
                      child: Text(translate("close"))),
                ]));
  }

  Widget addFlightView(double height, double width) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          wrapInBox(
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                      WidgetStateColor.resolveWith((states) => Colors.black38),
                      foregroundColor:
                      WidgetStateColor.resolveWith((states) => Colors.black38),
                      overlayColor:
                      WidgetStateColor.resolveWith((states) => Colors.black12)),
                  onPressed: () {
                    saveFlightDetails();
                  },
                  child: Text(translate("close"), style: const TextStyle(color: Colors.white))),
              50,
              width / 3),
          wrapInBox(
              Text(translate("FL_add_title"), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
              20,
              width / 3),
        ]),
        flightDetails(height, width),
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
                  style: ButtonStyle(
                      backgroundColor:
                      WidgetStateColor.resolveWith((states) => Colors.black38),
                      foregroundColor:
                      WidgetStateColor.resolveWith((states) => Colors.black38),
                      overlayColor:
                      WidgetStateColor.resolveWith((states) => Colors.black12)),
                  onPressed: () {
                    setState(() {
                      _originController.text = "";
                      _destinationController.text = "";
                      _departureController.text = "";
                      _arrivalController.text = "";
                      updatingFlight = false;
                    });
                  },
                  child: Text(translate("close"), style: const TextStyle(color: Colors.white))),
              50,
              width / 3),
          wrapInBox(
              Text(
                translate("FL_update_title"),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white)
              ),
              20,
              width / 3),
        ]),
        flightDetails(height, width),
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
          child: flightListView(height - 50, width - 50));
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
            iconTheme: const IconThemeData(color: Colors.blueAccent),
            centerTitle: true,
            backgroundColor: Colors.black87,
            toolbarHeight: 50,
            actions: [
              DrawerButton(
                onPressed: () {
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                              title: Text(translate("FL_usage_title")),
                              content: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text(translate("FL_usage_add")),
                                Text(translate("FL_usage_clear")),
                                Text(translate("FL_usage_update")),
                                Text(translate("FL_usage_delete")),
                              ]),
                              actions: <Widget>[
                                Row(children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(translate("close"))),
                                ])
                              ]));
                },
              )
            ]),
        backgroundColor: Colors.blueAccent,
        body: Center(
            child: Column(
          children: [Expanded(child: selectFinalView())],
        )));
  }
}
