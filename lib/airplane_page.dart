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
    initDatabase();
  }

  void initDatabase() async {
    db = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    airplaneDAO = db.listDao;
    List<Airplane> result = await airplaneDAO.findAllListItems();
    setState(() {
      airplanes.addAll(result);
    });
  }

  void insertAirplane() {
    if(!validation.validateType(insertTypeCont.value.text)) {
      noValidationErrors = false;
      createErrorSnackBar("Error: Airplane Type cannot be empty.");
    }
    if(!validation.validatePassengers(insertPassengerCont.value.text)) {
      noValidationErrors = false;
      createErrorSnackBar("Error: Max. Passengers cannot be empty, and must be an integer.");
    }
    if(!validation.validateSpeed(insertSpeedCont.value.text)) {
      noValidationErrors = false;
      createErrorSnackBar("Error: Max. Speed cannot be empty, and must be numeric.");
    }
    if(!validation.validateRange(insertRangeCont.value.text)) {
      noValidationErrors = false;
      createErrorSnackBar("Error: Max. Range cannot be empty, and must be numeric.");
    }
    if(noValidationErrors) {
      Airplane airplane = Airplane(Utils.id++, insertTypeCont.value.text, int.parse(insertPassengerCont.value.text), double.parse(insertSpeedCont.value.text), double.parse(insertRangeCont.value.text));
      airplaneDAO.insertList(airplane);
      airplanes.add(airplane);
      insertTypeCont.text = "";
      insertPassengerCont.text = "";
      insertSpeedCont.text = "";
      insertRangeCont.text = "";
    }
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
              child: TextField(controller: insertTypeCont),
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
              child: TextField(controller: insertPassengerCont),
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
              child: TextField(controller: insertSpeedCont),
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
              child: TextField(controller: insertRangeCont),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.black54),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Airplane Inventory",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Satoshi",
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              SizedBox(
                width: width - 20,
                height: height - 45,
              ),
            ],
          ),
        )
      ],
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
                fontSize: 20,
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
              child: TextField(controller: detailsTypeCont),
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
              child: TextField(controller: detailsPassengerCont),
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
              child: TextField(controller: detailsSpeedCont),
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
              child: TextField(controller: detailsRangeCont),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
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
                    Icons.add,
                    color: Colors.greenAccent,
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 7)),
                  Text("Update Airplane",
                      style:
                      TextStyle(color: Colors.white, fontFamily: "Satoshi"))
                ])),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
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
                    Icons.add,
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
                        image:
                            const AssetImage("assets/images/plane-wing.png"))),
                child: Column(
                  children: [
                    Expanded(child: controlPanel(size, 200)),
                    Padding(padding: const EdgeInsets.only(bottom: 10), child: listView(size.width - 50, size.height / 1.8))
                  ],
                ),
              ),
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
                      image: const AssetImage("assets/images/plane-wing.png")),
                ),
                child: Row(
                  children: [
                    Expanded(child: controlPanel(size, 100)),
                    Expanded(child: listView((size.width / 2), size.height - 55)),
                    Expanded(child: details(size, 100))
                  ],
                ),
              ),
            )
          ],
        );
      }
    }));
  }
}
