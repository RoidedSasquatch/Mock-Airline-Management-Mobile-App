import 'package:cst2335_group_project/AppLocalizations.dart';
import 'package:cst2335_group_project/flight.dart';
import 'package:cst2335_group_project/flight_dao.dart';
import 'package:cst2335_group_project/flight_data_repository.dart';
import 'package:cst2335_group_project/flight_database.dart';
import 'package:cst2335_group_project/flight_utils.dart';
import 'package:flutter/material.dart';

///FlightPage is a StatefulWidget that manages flight operations.
class FlightPage extends StatefulWidget {
  const FlightPage({super.key, required this.title});

  ///The page title.
  final String title;

  @override
  State<FlightPage> createState() => FlightPageState();
}

///State information for the FlightPage.
class FlightPageState extends State<FlightPage> {

  ///A [List] holding a local copy of all available flights.
  List<Flight> flightList = [];

  ///The Data Access Object for [Flight].
  late FlightDao flightDao;

  ///The currently selected [Flight].
  Flight? selectedFlight;

  ///The [TextEditingController] that manages the origin [TextField]
  late TextEditingController _originController;

  ///The [TextEditingController] that manages the destination [TextField]
  late TextEditingController _destinationController;

  ///The [TextEditingController] that manages the departure [TextField]
  late TextEditingController _departureController;

  ///The [TextEditingController] that manages the arrival [TextField]
  late TextEditingController _arrivalController;

  ///A [List] of all supported locales
  List<Locale> locales = [const Locale("en", "CA"), const Locale("ja")];

  ///An [Integer]  storing the index of the currently in use [Locale]
  var currentLocIndex = 0;

  ///A [bool] that controls whether or not to show the add flight panel
  bool addingFlight = false;

  ///A [bool] that controls whether or not to show the update flight panel
  bool updatingFlight = false;

  /// Translates a key to the current locale's string.
  ///
  /// @param key The key value for the text at a specific location.
  /// @returns String The corresponding translation for the current language
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

  /// Loads flight data from the database and initializes the FlightDao.
  void loadFlights() async {
    final database =
    await $FloorAppDatabase.databaseBuilder("flightT2_db").build();
    flightDao = database.flightDao;
    updateFlights();
  }

  /// Initializes the text controllers with existing flight data.
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

  /// Updates the flight list from the database.
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

  ///Verifies that user input has been provided and shows a snack bar if it has not.
  ///
  /// @param input A [String] of user input.
  /// @returns bool Whether or not the input is empty.
  bool validateInput(String input) {
    if (input.isNotEmpty) {
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

  ///Adds a new [Flight] to the database.
  ///
  /// @param origin The origin of the flight.
  /// @param destination The destination of the flight.
  /// @param departure The departure time of the flight.
  /// @param arrival The arrival time of the flight.
  void addFlight(
      String origin, String destination, String departure, String arrival) {
    Flight newFlight =
        Flight(FlightUtils.id++, origin, destination, departure, arrival);
    flightDao.insertFlight(newFlight);
    updateFlights();
  }

  ///Updates the details of an existing [Flight] in the database.
  ///
  /// @param updatedFlight A [Flight] with the updated details.
  void updateFlightDetails(Flight updatedFlight) async {
    await flightDao.updateFlight(updatedFlight);
    updateFlights();
  }

  ///Removes a [Flight] from the database.
  ///
  /// @param delFlight The [Flight] to be removed from the database.
  void removeFlight(Flight delFlight) async {
    await flightDao.deleteFlight(delFlight);
    updateFlights();
  }

  ///Wraps a [Widget] in a [SizedBox] with [height] and [width] parameters.
  ///
  /// @param original The original [Widget] to be wrapped.
  /// @param height The height of the box.
  /// @param width The width of the box.
  /// @returns Widget A [SizedBox] with the provided child and dimensions.
  Widget wrapInBox(Widget original, double height, double width) {
    return SizedBox(height: height, width: width, child: original);
  }

  ///Returns a [SizedBox] containing a text labelled [TextField]
  ///
  /// Takes a [TextEditingController] and a [String] as a label to create a
  /// formatted [SizedBox] with [Text] and a [TextField].
  /// @param controller The [TextEditingController] corresponding to the [TextField].
  /// @param label The [String] label that corresponds to the [TextField].
  /// @returns Widget A [SizedBox] containing a formatted [TextField].
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

  ///Returns a padded [Widget] with four [TextField]s used to add and update fights.
  ///
  /// @param height The height available for use.
  /// @param width The width available for use.
  /// @returns Widget A [Padding] widget containing the flight details [TextField]s.
  Widget flightDetails(double height, double width) {
    return Padding(
        padding: const EdgeInsets.all(10),
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

  /// Creates a formatted widget with the buttons to add a flight.
  ///
  /// @returns Widget a [Widget] with the [ElevatedButton]s used in the add flight page.
  Widget addFlightButtons() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
              MaterialStateColor.resolveWith((states) => Colors.black38),
              foregroundColor:
              MaterialStateColor.resolveWith((states) => Colors.black38),
              overlayColor:
              MaterialStateColor.resolveWith((states) => Colors.black12)),
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
              MaterialStateColor.resolveWith((states) => Colors.black38),
              foregroundColor:
              MaterialStateColor.resolveWith((states) => Colors.black38),
              overlayColor:
              MaterialStateColor.resolveWith((states) => Colors.black12)),
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

  ///Creates a formatted [Widget] with the buttons to update or remove a flight.
  ///
  ///@returns Widget a [Widget] with the [ElevatedButton]s used in the selected flight page.
  Widget selectedFlightButtons() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
              MaterialStateColor.resolveWith((states) => Colors.black38),
              foregroundColor:
              MaterialStateColor.resolveWith((states) => Colors.black38),
              overlayColor:
              MaterialStateColor.resolveWith((states) => Colors.black12)),
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
              MaterialStateColor.resolveWith((states) => Colors.black38),
              foregroundColor:
              MaterialStateColor.resolveWith((states) => Colors.black38),
              overlayColor:
              MaterialStateColor.resolveWith((states) => Colors.black12)),
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

  ///Returns a [Widget] with the [ListView] of the flights in the database.
  ///
  /// Formats and displays [Flight] details as a list. Provides access to
  /// adding and updating flights.
  /// @param height The height available for use.
  /// @param width The width available for use.
  /// @returns Widget A [Column] containing the [Flight] list.
  Widget flightListView(double height, double width) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      wrapInBox(
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Text(translate("FL_available_flights"), style: const TextStyle(color: Colors.white)),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStateColor.resolveWith((states) => Colors.black38),
                    foregroundColor:
                    MaterialStateColor.resolveWith((states) => Colors.black38),
                    overlayColor:
                    MaterialStateColor.resolveWith((states) => Colors.black12)),
                onPressed: () {
                  setState(() {
                    addingFlight = true;
                    updatingFlight = false;
                  });
                },
                child: const Icon(Icons.add, color: Colors.greenAccent))
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

  ///An [AlertDialog] that prompts the user to save tentative flight details for later.
  ///
  /// Allows a user to begin inputting flight details and save that information
  /// for later if they need to confirm details before adding a flight.
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

  ///Returns a [Widget] containing the formatting for the page to add a [Flight].
  ///
  /// @param height The height available for use.
  /// @param width The width available for use.
  /// @returns Widget a widget containing the view to add a flight.
  Widget addFlightView(double height, double width) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          wrapInBox(
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.black38),
                      foregroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.black38),
                      overlayColor:
                      MaterialStateColor.resolveWith((states) => Colors.black12)),
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

  ///Returns a [Widget] containing the formatting for the page to update a [Flight].
  ///
  /// @param height The height available for use.
  /// @param width The width available for use.
  /// @returns Widget A [Column] containing the the formatting for the page to update a [Flight]
  Widget updateFlightView(double height, double width) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          wrapInBox(
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.black38),
                      foregroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.black38),
                      overlayColor:
                      MaterialStateColor.resolveWith((states) => Colors.black12)),
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

  ///Returns a [Widget] containing the formatting details for portrait view.
  ///
  /// Calls methods returning [Widget]s containing page details with specific
  /// orientations and parameters for display on a phone.
  /// @param height The height available for use.
  /// @param width The width available for use.
  /// @returns Widget a [Column] containing the phone view of the page.
  Widget phoneView(double height, double width) {
    Widget finalView = const Column();
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
    }
    return finalView;
  }

  ///Returns a [Widget] containing the formatting details for landscape view.
  ///
  /// Calls methods returning [Widget]s containing page details with specific
  /// orientations and parameters for display on a tablet.
  /// @param height The height available for use.
  /// @param width The width available for use.
  /// @returns Widget a [Column] containing the tablet view of the page.
  Widget tabletView(double height, double width) {
    Widget finalView = const Column();
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

  ///Returns a [Widget] containing the formatting details for the current view.
  ///
  /// Uses screen size details to determine which page formatting to use.
  /// @returns Widget A [Widget] containing the page contents formatted to the correct screen size.
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
