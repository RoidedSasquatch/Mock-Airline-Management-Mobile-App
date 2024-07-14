import 'package:cst2335_group_project/airplane_data_repository.dart';
import 'package:cst2335_group_project/utils.dart';
import 'package:cst2335_group_project/validation.dart';
import 'package:flutter/material.dart';

import 'airplane.dart';
import 'airplane_database.dart';

class AirplanePage extends StatefulWidget {
  const AirplanePage({super.key, required this.title});
  final String title;

  @override
  State<StatefulWidget> createState() => _AirplanePageState();
}

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
  late String appBarTitle;

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
    appBarTitle = "Airplane Operations";
    initDatabase();
    AirplaneDataRepository.loadData();
    insertTypeCont.text = AirplaneDataRepository.airplaneType;
    insertPassengerCont.text = AirplaneDataRepository.maxPassengers;
    insertSpeedCont.text = AirplaneDataRepository.maxSpeed;
    insertRangeCont.text = AirplaneDataRepository.maxRange;
  }

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

  void initDatabase() async {
    db = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    airplaneDAO = db.airplaneDao;
    List<Airplane> result = await airplaneDAO.findAllListItems();
    setState(() {
      airplanes.addAll(result);
    });
  }

  insertAirplane() {
    setState(() {
      if (!validation.validateType(insertTypeCont.value.text)) {
        noValidationErrors = false;
        createErrorSnackBar("Error: Airplane Type cannot be empty.");
      }
      if (!validation.validatePassengers(insertPassengerCont.value.text)) {
        noValidationErrors = false;
        createErrorSnackBar(
            "Error: Max. Passengers cannot be empty, and must be an integer.");
      }
      if (!validation.validateSpeed(insertSpeedCont.value.text)) {
        noValidationErrors = false;
        createErrorSnackBar(
            "Error: Max. Speed cannot be empty, and must be numeric.");
      }
      if (!validation.validateRange(insertRangeCont.value.text)) {
        noValidationErrors = false;
        createErrorSnackBar(
            "Error: Max. Range cannot be empty, and must be numeric.");
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
        AirplaneDataRepository.airplaneType =
            insertTypeCont.value.text;
        AirplaneDataRepository.maxPassengers =
            insertPassengerCont.value.text;
        AirplaneDataRepository.maxSpeed = insertSpeedCont.value.text;
        AirplaneDataRepository.maxRange = insertRangeCont.value.text;
        insertTypeCont.text = "";
        insertPassengerCont.text = "";
        insertSpeedCont.text = "";
        insertRangeCont.text = "";
        SnackBar snackBar = SnackBar(
            showCloseIcon: true,
            content: const Text("Save data for next entry?"),
            action: SnackBarAction(
                label: "Yes",
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

  deleteAirplane() {
    setState(() {
      airplanes.remove(airplanes[selectedRow]);
      airplaneDAO.delete(selectedRow);
      selectedRow = -1;
      rowSelected = false;
      appBarTitle = "Airplane Operations";
      Navigator.pop(context);
    });
  }

  createErrorSnackBar(String errorMsg) {
    SnackBar snackBar = SnackBar(content: Text(errorMsg), showCloseIcon: true);
    Future.delayed(const Duration(seconds: 1)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  Widget controlPanel(Size size, double textFieldScalar, double vertPadding) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 25, vertical: vertPadding),
              child: const Text(
                "Airplane Type: ",
                textAlign: TextAlign.center,
                style: TextStyle(
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
              child: const Text(
                "Max. Passengers: ",
                textAlign: TextAlign.center,
                style: TextStyle(
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
              child: const Text(
                "Max. Speed: ",
                textAlign: TextAlign.center,
                style: TextStyle(
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
              child: const Text(
                "Max. Range: ",
                textAlign: TextAlign.center,
                style: TextStyle(
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
                    MaterialStateColor.resolveWith((states) => Colors.black38),
                foregroundColor:
                    MaterialStateColor.resolveWith((states) => Colors.black38),
                overlayColor:
                    MaterialStateColor.resolveWith((states) => Colors.black12)),
            child: const SizedBox(
                width: 150,
                height: 30,
                child: Row(children: [
                  Icon(
                    Icons.add,
                    color: Colors.greenAccent,
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                  Text("Add Airplane",
                      style:
                          TextStyle(color: Colors.white, fontFamily: "Satoshi"))
                ])),
          ),
        ),
      ],
    );
  }

  Widget listView(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.black54),
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              "Airplane Inventory",
              textAlign: TextAlign.center,
              style: TextStyle(
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
                          appBarTitle = "Airplane Details";
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
                    appBarTitle = "Airplane Operations";
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
              child: const Text(
                "Airplane Type: ",
                textAlign: TextAlign.center,
                style: TextStyle(
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
              child: const Text(
                "Max. Passengers: ",
                textAlign: TextAlign.center,
                style: TextStyle(
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
              child: const Text(
                "Max. Speed: ",
                textAlign: TextAlign.center,
                style: TextStyle(
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
              child: const Text(
                "Max. Range: ",
                textAlign: TextAlign.center,
                style: TextStyle(
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
                    MaterialStateColor.resolveWith((states) => Colors.black38),
                foregroundColor:
                    MaterialStateColor.resolveWith((states) => Colors.black38),
                overlayColor:
                    MaterialStateColor.resolveWith((states) => Colors.black12)),
            child: const SizedBox(
                width: 150,
                height: 30,
                child: Row(children: [
                  Icon(
                    Icons.add,
                    color: Colors.greenAccent,
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                  Text("Update Airplane",
                      style:
                          TextStyle(color: Colors.white, fontFamily: "Satoshi"))
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
                  title: const Text('Confirm Delete'),
                  content:
                      const Text('Do you really want to delete this airplane?'),
                  actions: <Widget>[
                    ElevatedButton(
                        onPressed: deleteAirplane, child: const Text("Yes")),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel")),
                  ],
                ),
              );
            },
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateColor.resolveWith((states) => Colors.black38),
                foregroundColor:
                    MaterialStateColor.resolveWith((states) => Colors.black38),
                overlayColor:
                    MaterialStateColor.resolveWith((states) => Colors.black12)),
            child: const SizedBox(
                width: 150,
                height: 30,
                child: Row(children: [
                  Icon(
                    Icons.delete,
                    color: Colors.greenAccent,
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 7)),
                  Text("Delete Airplane",
                      style:
                          TextStyle(color: Colors.white, fontFamily: "Satoshi"))
                ])),
          ),
        ),
      ],
    );
  }

  Widget portraitWidget(Size size) {
    Widget widget;
    if (!rowSelected) {
      widget = controlPanel(size, 200, 10);
      return Column(
        children: [
          Expanded(child: widget),
          Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: listView(size.width - 50, (size.height / 2)))
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
                        title: const Text('Usage Guide'),
                        content: const Text(
                            'Add airplanes to the database by entering values into '
                            'the text fields. Click the add button to add an airplane. '
                            'Once an airplane is added, it will appear in the airplane '
                            'inventory list. Click on a list item to view details about it. '
                            'When viewing details, values can be modified by simply modifying '
                            'the values in the fields and clicking the update button. '
                            'Items can also be deleted by clicking the delete button. '
                            'Click the "X" button to leave the details screen. \n\nValidation:'
                            '\nAirplane Type cannot be empty.\n\nMax. Passengers cannot be empty '
                            'and must be an integer\n\nMax. Speed cannot be empty and must be '
                            'numeric\n\nMax. Range cannot be empty and must be numeric.'),
                        actions: <Widget>[
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Close")),
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
