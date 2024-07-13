import 'package:cst2335_group_project/utils.dart';
import 'package:cst2335_group_project/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
        insertTypeCont.text = "";
        insertPassengerCont.text = "";
        insertSpeedCont.text = "";
        insertRangeCont.text = "";
      }

      noValidationErrors = true;
    });
  }

  updateAirplane() {
    setState(() {
      selectedRow = -1;
      rowSelected = false;
    });
  }

  deleteAirplane() {
    setState(() {
      selectedRow = -1;
      rowSelected = false;
    });
  }

  Widget createErrorSnackBar(String errorMsg) {
    return SnackBar(content: Text(errorMsg), showCloseIcon: true);
  }

  Widget controlPanel(Size size, double textFieldScalar) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          child: Text(
            "Airplane Operations",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontFamily: "Satoshi",
                fontSize: 35,
                fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: Text(
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: Text(
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: Text(
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: Text(
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
          padding: const EdgeInsets.symmetric(vertical: 5),
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
            padding: const EdgeInsets.only(top: 10),
            child: SizedBox(
              width: width * 0.9,
              height: height * 0.95,
              child: ListView.builder(
                  itemBuilder: (item, rowNum) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedRow = rowNum;
                          selectedAirplane = airplanes[rowNum];
                          rowSelected = true;
                        });
                      },
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: selectedRow == rowNum
                                  ? Colors.blueAccent
                                  : Colors.black87),
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

  Widget details(Size size, double textFieldScalar) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          child: Text(
            "Details",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontFamily: "Satoshi",
                fontSize: 35,
                fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: Text(
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: Text(
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: Text(
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: Text(
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
          padding: const EdgeInsets.symmetric(vertical: 5),
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
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: ElevatedButton(
            onPressed: deleteAirplane,
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
      widget = controlPanel(size, 200);
      return widget;
    } else {
      widget = details(size, 200);
      detailsTypeCont.text = selectedAirplane.airplaneType;
      detailsPassengerCont.text = selectedAirplane.maxPassengers.toString();
      detailsSpeedCont.text = selectedAirplane.maxSpeed.toString();
      detailsRangeCont.text = selectedAirplane.maxRange.toString();
      return widget;
    }
  }

  Widget landscapeWidget(Size size) {
    Widget widget;
    if (!rowSelected) {
      widget = controlPanel(size, 170);
      return widget;
    } else {
      widget = details(size, 170);
      detailsTypeCont.text = selectedAirplane.airplaneType;
      detailsPassengerCont.text = selectedAirplane.maxPassengers.toString();
      detailsSpeedCont.text = selectedAirplane.maxSpeed.toString();
      detailsRangeCont.text = selectedAirplane.maxRange.toString();
      return widget;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(body: OrientationBuilder(builder: (context, orientation) {
      if (orientation == Orientation.portrait) {
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
                              Colors.black.withOpacity(0.2), BlendMode.dstATop),
                          image: const AssetImage(
                              "assets/images/plane-wing.png"))),
                  child: Column(
                    children: [
                      Expanded(child: portraitWidget(size)),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: listView(size.width - 50, size.height / 2))
                    ],
                  )),
            )
          ],
        );
      } else {
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
                            Colors.black.withOpacity(0.2), BlendMode.dstATop),
                        image:
                            const AssetImage("assets/images/plane-wing.png")),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: landscapeWidget(size)),
                      Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child:
                              listView((size.width / 2) - 35, size.height - 50))
                    ],
                  )),
            )
          ],
        );
      }
    }));
  }
}
