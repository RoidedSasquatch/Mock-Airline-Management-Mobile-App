import 'package:cst2335_group_project/airplane_data_repository.dart';
import 'package:cst2335_group_project/utils.dart';
import 'package:cst2335_group_project/validation.dart';
import 'package:flutter/material.dart';

import 'AppLocalizations.dart';
import 'airplane.dart';
import 'airplane_database.dart';

/// Flutter widget representing the Airplane Page, managing airplane data.
class AirplanePage extends StatefulWidget {

  /// Constructs the [AirplanePage] widget.
  /// [title]: The title of the page.
  const AirplanePage({super.key, required this.title});

  /// The title of the page.
  final String title;

  @override
  State<StatefulWidget> createState() => _AirplanePageState();
}

/// State class for [AirplanePage], manages state and logic.
class _AirplanePageState extends State<AirplanePage> {
  late TextEditingController insertTypeCont;
  late TextEditingController insertPassengerCont;
  late TextEditingController insertSpeedCont;
  late TextEditingController insertRangeCont;
  late TextEditingController detailsTypeCont;
  late TextEditingController detailsPassengerCont;
  late TextEditingController detailsSpeedCont;
  late TextEditingController detailsRangeCont;
  late Validation validation;
  late List<Airplane> airplanes;
  late final db;
  late final airplaneDAO;
  late bool noValidationErrors;
  late bool rowSelected;
  late int selectedRow;
  late Airplane selectedAirplane;
  String appBarTitle = "";

  ///Initializes page, variables and loads data from EncryptedSharedPrefs
  @override
  void initState() {
    super.initState();
    insertTypeCont = TextEditingController();
    insertPassengerCont = TextEditingController();
    insertSpeedCont = TextEditingController();
    insertRangeCont = TextEditingController();
    detailsTypeCont = TextEditingController();
    detailsPassengerCont = TextEditingController();
    detailsSpeedCont = TextEditingController();
    detailsRangeCont = TextEditingController();
    validation = Validation();
    airplanes = [];
    noValidationErrors = true;
    rowSelected = false;
    selectedRow = -1;
    initDatabase();
    AirplaneDataRepository.loadData();
    insertTypeCont.text = AirplaneDataRepository.airplaneType;
    insertPassengerCont.text = AirplaneDataRepository.maxPassengers;
    insertSpeedCont.text = AirplaneDataRepository.maxSpeed;
    insertRangeCont.text = AirplaneDataRepository.maxRange;
  }

  ///Dispose of unused resources
  @override
  void dispose() {
    insertTypeCont.dispose();
    insertPassengerCont.dispose();
    insertSpeedCont.dispose();
    insertRangeCont.dispose();
    detailsTypeCont.dispose();
    detailsPassengerCont.dispose();
    detailsSpeedCont.dispose();
    detailsRangeCont.dispose();
    super.dispose();
  }

  String translate(String key) {
    return AppLocalizations.of(context)?.translate(key)??"No Translation Available";
  }

  /// Initializes the database and loads airplane data.
  void initDatabase() async {
    db = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    airplaneDAO = db.airplaneDao;
    List<Airplane> result = await airplaneDAO.findAllListItems();
    setState(() {
      airplanes.addAll(result);
    });
  }

  /// Validates and inserts a new airplane into the database. Then displays a SnackBar asking if the user would
  /// like to save the data they just entered for future use to EncryptedSharedPreferences
  insertAirplane() {
    setState(() {
      if (!validation.validateType(insertTypeCont.value.text)) {
        noValidationErrors = false;
        createErrorSnackBar(translate("errorAirplaneTypeEmpty"));
      }
      if (!validation.validatePassengers(insertPassengerCont.value.text)) {
        noValidationErrors = false;
        createErrorSnackBar(translate("errorMaxPassengersEmpty"));
      }
      if (!validation.validateSpeed(insertSpeedCont.value.text)) {
        noValidationErrors = false;
        createErrorSnackBar(translate("errorMaxSpeedEmpty"));
      }
      if (!validation.validateRange(insertRangeCont.value.text)) {
        noValidationErrors = false;
        createErrorSnackBar(translate("errorMaxRangeEmpty"));
      }
      if (noValidationErrors) {
        Airplane airplane = Airplane(
            Utils.id++,
            insertTypeCont.value.text,
            int.parse(insertPassengerCont.value.text),
            double.parse(insertSpeedCont.value.text),
            double.parse(insertRangeCont.value.text));
        airplaneDAO.insertList(airplane);
        airplanes.add(airplane);
        AirplaneDataRepository.airplaneType = insertTypeCont.value.text;
        AirplaneDataRepository.maxPassengers = insertPassengerCont.value.text;
        AirplaneDataRepository.maxSpeed = insertSpeedCont.value.text;
        AirplaneDataRepository.maxRange = insertRangeCont.value.text;
        insertTypeCont.text = "";
        insertPassengerCont.text = "";
        insertSpeedCont.text = "";
        insertRangeCont.text = "";
        SnackBar snackBar = SnackBar(
            showCloseIcon: true,
            content: Text(translate("saveDataPrompt")),
            action: SnackBarAction(
                label: translate("yes"),
                onPressed: () {
                  AirplaneDataRepository.saveData();
                  AirplaneDataRepository.loadData();
                  insertTypeCont.text = AirplaneDataRepository.airplaneType;
                  insertPassengerCont.text =
                      AirplaneDataRepository.maxPassengers;
                  insertSpeedCont.text = AirplaneDataRepository.maxSpeed;
                  insertRangeCont.text = AirplaneDataRepository.maxRange;
                }));
        Future.delayed(const Duration(seconds: 1)).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      }

      noValidationErrors = true;
    });
  }

  /// Updates the details of the selected airplane.
  updateAirplane() {
    setState(() {
      airplanes[selectedRow].airplaneType = detailsTypeCont.value.text;
      airplanes[selectedRow].maxPassengers =
          int.parse(detailsPassengerCont.value.text);
      airplanes[selectedRow].maxSpeed =
          double.parse(detailsSpeedCont.value.text);
      airplanes[selectedRow].maxRange =
          double.parse(detailsRangeCont.value.text);
      airplaneDAO.updateList(airplanes[selectedRow]);
      detailsTypeCont.text = airplanes[selectedRow].airplaneType;
      detailsPassengerCont.text =
          airplanes[selectedRow].maxPassengers.toString();
      detailsSpeedCont.text = airplanes[selectedRow].maxSpeed.toString();
      detailsRangeCont.text = airplanes[selectedRow].maxRange.toString();
      // rowSelected = false;
    });
  }

  /// Deletes the selected airplane from the database.
  deleteAirplane() {
    setState(() {
      airplanes.remove(airplanes[selectedRow]);
      airplaneDAO.delete(selectedAirplane.id);
      selectedRow = -1;
      rowSelected = false;
      appBarTitle = translate("airplaneOperations");
      Navigator.pop(context);
    });
  }

  /// Creates and displays an error [SnackBar] with [errorMsg].
  /// [errorMsg]: The error message
  createErrorSnackBar(String errorMsg) {
    SnackBar snackBar = SnackBar(content: Text(errorMsg), showCloseIcon: true);
    Future.delayed(const Duration(seconds: 1)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  /// Widget for the control panel in portrait mode.
  /// [size]: The size of the screen.
  /// [textFieldScalar]: Scalar factor for text fields.
  /// [vertPadding]: Vertical padding between elements.
  Widget controlPanel(Size size, double textFieldScalar, double vertPadding) {
    appBarTitle = translate("airplaneOperations");
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 25, vertical: vertPadding),
              child: Text(
                translate("airplaneType"),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: "Satoshi",
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: textFieldScalar,
              height: 20,
              child: TextField(
                  controller: insertTypeCont,
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 25, vertical: vertPadding),
              child: Text(
                translate("maxPassengers"),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: "Satoshi",
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: textFieldScalar - 23,
              height: 20,
              child: TextField(
                  controller: insertPassengerCont,
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 25, vertical: vertPadding),
              child: Text(
                translate("maxSpeed"),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: "Satoshi",
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: textFieldScalar + 14,
              height: 20,
              child: TextField(
                  controller: insertSpeedCont,
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 25, vertical: vertPadding),
              child: Text(
                translate("maxRange"),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: "Satoshi",
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: textFieldScalar + 14,
              height: 20,
              child: TextField(
                  controller: insertRangeCont,
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: vertPadding),
          child: ElevatedButton(
            onPressed: insertAirplane,
            style: ButtonStyle(
                backgroundColor:
                    WidgetStateColor.resolveWith((states) => Colors.black38),
                foregroundColor:
                    WidgetStateColor.resolveWith((states) => Colors.black38),
                overlayColor:
                    WidgetStateColor.resolveWith((states) => Colors.black12)),
            child: SizedBox(
                width: 180,
                height: 30,
                child: Row(children: [
                  const Icon(
                    Icons.add,
                    color: Colors.greenAccent,
                  ),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                  Text(translate("addAirplane"),
                      style:
                          const TextStyle(color: Colors.white, fontFamily: "Satoshi"))
                ])),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            AirplaneDataRepository.prefs.clear();
            AirplaneDataRepository.airplaneType = "";
            AirplaneDataRepository.maxPassengers = "";
            AirplaneDataRepository.maxSpeed = "";
            AirplaneDataRepository.maxRange = "";
            insertTypeCont.text = "";
            insertPassengerCont.text = "";
            insertSpeedCont.text = "";
            insertRangeCont.text = "";
          },
          style: ButtonStyle(
              backgroundColor:
                  WidgetStateColor.resolveWith((states) => Colors.black38),
              foregroundColor:
                  WidgetStateColor.resolveWith((states) => Colors.black38),
              overlayColor:
                  WidgetStateColor.resolveWith((states) => Colors.black12)),
          child: SizedBox(
              width: 180,
              height: 30,
              child: Row(children: [
                const Icon(
                  Icons.clear,
                  color: Colors.greenAccent,
                ),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                Text(translate("clearFields"),
                    style:
                        const TextStyle(color: Colors.white, fontFamily: "Satoshi"))
              ])),
        ),
      ],
    );
  }

  /// Widget for the list view of airplanes.
  /// [width]: Width of the list view.
  /// [height]: Height of the list view.
  Widget listView(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.black54),
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
                translate("airplaneInventory"),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: "Satoshi",
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 35),
            child: SizedBox(
              width: width * 0.9,
              height: height * 0.9,
              child: ListView.builder(
                  itemBuilder: (item, rowNum) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedRow = rowNum;
                          selectedAirplane = airplanes[rowNum];
                          rowSelected = true;
                          appBarTitle = translate("airplaneDetails");
                        });
                      },
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              gradient: selectedRow == rowNum
                                  ? const LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: <Color>[
                                          Colors.black45,
                                          Colors.blueAccent
                                        ])
                                  : const LinearGradient(
                                      begin: Alignment.centerRight,
                                      end: Alignment.centerLeft,
                                      colors: <Color>[
                                          Colors.black26,
                                          Colors.black54
                                        ])),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                    width: 50,
                                    child: Text(
                                      "${rowNum + 1}.",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )),
                                Text(
                                  airplanes[rowNum].airplaneType,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ])),
                    );
                  },
                  itemCount: airplanes.length),
            ),
          )
        ],
      ),
    );
  }

  /// Widget for displaying details of a selected airplane.
  /// [size]: Size of the screen.
  /// [textFieldScalar]: Scalar factor for text fields.
  /// [vertPadding]: Vertical padding between elements.
  Widget details(Size size, double textFieldScalar, double vertPadding) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: CloseButton(
                color: Colors.black45,
                onPressed: () {
                  setState(() {
                    selectedRow = -1;
                    rowSelected = false;
                    appBarTitle = translate("airplaneOperations");
                  });
                },
              ),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 25, right: 25, top: 5, bottom: vertPadding * 1.5),
              child: Text(
                translate("airplaneType"),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: "Satoshi",
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: textFieldScalar,
              height: 20,
              child: TextField(
                  controller: detailsTypeCont,
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 25, vertical: vertPadding * 1.5),
              child: Text(
                translate("maxPassengers"),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: "Satoshi",
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: textFieldScalar - 23,
              height: 20,
              child: TextField(
                  controller: detailsPassengerCont,
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 25, vertical: vertPadding * 1.5),
              child: Text(
                translate("maxSpeed"),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: "Satoshi",
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: textFieldScalar + 14,
              height: 20,
              child: TextField(
                  controller: detailsSpeedCont,
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 25, vertical: vertPadding * 1.5),
              child: Text(
                translate("maxRange"),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: "Satoshi",
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: textFieldScalar + 14,
              height: 20,
              child: TextField(
                  controller: detailsRangeCont,
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: vertPadding),
          child: ElevatedButton(
            onPressed: updateAirplane,
            style: ButtonStyle(
                backgroundColor:
                    WidgetStateColor.resolveWith((states) => Colors.black38),
                foregroundColor:
                    WidgetStateColor.resolveWith((states) => Colors.black38),
                overlayColor:
                    WidgetStateColor.resolveWith((states) => Colors.black12)),
            child: SizedBox(
                width: 180,
                height: 30,
                child: Row(children: [
                  const Icon(
                    Icons.upload,
                    color: Colors.greenAccent,
                  ),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                  Text(translate("updateAirplane"),
                      style:
                          const TextStyle(color: Colors.white, fontFamily: "Satoshi"))
                ])),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: vertPadding),
          child: ElevatedButton(
            onPressed: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  actionsAlignment: MainAxisAlignment.center,
                  title: Text(translate("confirmDelete")),
                  content:
                      Text(translate("deletePrompt")),
                  actions: <Widget>[
                    ElevatedButton(
                        onPressed: deleteAirplane, child: Text(translate("yes"))),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(translate("cancel"))),
                  ],
                ),
              );
            },
            style: ButtonStyle(
                backgroundColor:
                    WidgetStateColor.resolveWith((states) => Colors.black38),
                foregroundColor:
                    WidgetStateColor.resolveWith((states) => Colors.black38),
                overlayColor:
                    WidgetStateColor.resolveWith((states) => Colors.black12)),
            child: SizedBox(
                width: 180,
                height: 30,
                child: Row(children: [
                  const Icon(
                    Icons.delete,
                    color: Colors.greenAccent,
                  ),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 7)),
                  Text(translate("deleteAirplane"),
                      style:
                          const TextStyle(color: Colors.white, fontFamily: "Satoshi"))
                ])),
          ),
        ),
      ],
    );
  }

  /// Widget to display in portrait mode.
  /// [size]: Size of the screen.
  Widget portraitWidget(Size size) {
    Widget widget;
    if (!rowSelected) {
      widget = controlPanel(size, 200, 10);
      return Column(
        children: [
          Expanded(child: widget),
          Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: listView(size.width - 50, (size.height / 2.1)))
        ],
      );
    } else {
      widget = details(size, 200, 20);
      detailsTypeCont.text = selectedAirplane.airplaneType;
      detailsPassengerCont.text = selectedAirplane.maxPassengers.toString();
      detailsSpeedCont.text = selectedAirplane.maxSpeed.toString();
      detailsRangeCont.text = selectedAirplane.maxRange.toString();
      return Column(
        children: [Expanded(child: widget)],
      );
    }
  }

  /// Widget to display in landscape mode.
  /// [size]: Size of the screen.
  Widget landscapeWidget(Size size) {
    Widget widget;
    if (!rowSelected) {
      widget = controlPanel(size, 170, 10);
      return widget;
    } else {
      widget = details(size, 170, 5);
      detailsTypeCont.text = selectedAirplane.airplaneType;
      detailsPassengerCont.text = selectedAirplane.maxPassengers.toString();
      detailsSpeedCont.text = selectedAirplane.maxSpeed.toString();
      detailsRangeCont.text = selectedAirplane.maxRange.toString();
      return widget;
    }
  }

  ///Builds the page
  ///[context]: The build context
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text(
                appBarTitle,
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: "Satoshi",
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              actions: [
                DrawerButton(
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        scrollable: true,
                        actionsAlignment: MainAxisAlignment.center,
                        title: Text(translate("usageGuideTitle")),
                        content: Text(
                            translate("usageGuideContent")),
                        actions: <Widget>[
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(translate("close"))),
                        ],
                      ),
                    );
                  },
                )
              ],
              iconTheme: const IconThemeData(color: Colors.blueAccent),
              centerTitle: true,
              backgroundColor: Colors.black87,
              toolbarHeight: 50,
            ),
            body: OrientationBuilder(builder: (context, orientation) {
              if (orientation == Orientation.portrait) {
                double physicalWidth = WidgetsBinding
                    .instance.platformDispatcher.views.first.physicalSize.width;
                double physicalHeight = WidgetsBinding.instance
                    .platformDispatcher.views.first.physicalSize.height;
                double devicePixelRatio = WidgetsBinding
                    .instance.platformDispatcher.views.first.devicePixelRatio;
                double width = physicalWidth / devicePixelRatio;
                double height = physicalHeight / devicePixelRatio;
                Size size = Size(width, height);
                return Stack(
                  children: [
                    Align(
                      child: Container(
                          width: size.width,
                          height: size.height,
                          decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.2),
                                      BlendMode.dstATop),
                                  image: const AssetImage(
                                      "assets/images/plane-wing.png"))),
                          child: portraitWidget(size)),
                    )
                  ],
                );
              } else {
                double physicalWidth = WidgetsBinding
                    .instance.platformDispatcher.views.first.physicalSize.width;
                double physicalHeight = WidgetsBinding.instance
                    .platformDispatcher.views.first.physicalSize.height;
                double devicePixelRatio = WidgetsBinding
                    .instance.platformDispatcher.views.first.devicePixelRatio;
                double width = physicalWidth / devicePixelRatio;
                double height = physicalHeight / devicePixelRatio;
                Size size = Size(width, height);
                return Stack(
                  children: [
                    Align(
                      child: Container(
                          width: size.width,
                          height: size.height,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.2),
                                    BlendMode.dstATop),
                                image: const AssetImage(
                                    "assets/images/plane-wing.png")),
                          ),
                          child: Row(
                            children: [
                              Expanded(child: landscapeWidget(size)),
                              Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: listView(
                                      (size.width / 2) - 35, size.height - 100))
                            ],
                          )),
                    )
                  ],
                );
              }
            })));
  }
}
