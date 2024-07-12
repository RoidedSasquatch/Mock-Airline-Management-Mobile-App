import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class AirplanePage extends StatefulWidget {
  const AirplanePage({super.key, required this.title});
  final String title;

  @override
  State<StatefulWidget> createState() => _AirplanePageState();
}

class _AirplanePageState extends State<AirplanePage> {
  @override
  void initState() {
    super.initState();
  }

  Widget controlPanel(Size size) {
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
        const Row(
          children: [
            Padding(
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
              width: 200,
              height: 20,
              child: TextField(),
            ),
          ],
        ),
        const Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: Text(
                "Manufacturer: ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Satoshi",
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 200,
              height: 20,
              child: TextField(),
            ),
          ],
        ),
        const Row(
          children: [
            Padding(
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
              width: 177,
              height: 20,
              child: TextField(),
            ),
          ],
        ),
        const Row(
          children: [
            Padding(
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
              width: 214,
              height: 20,
              child: TextField(),
            ),
          ],
        ),
        const Row(
          children: [
            Padding(
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
              width: 214,
              height: 20,
              child: TextField(),
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
              Container(
                width: width - 20,
                height: height - 45,
              ),
            ],
          ),
        )
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
                    Expanded(child: controlPanel(size)),
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
                    Expanded(child: controlPanel(size)),
                    Expanded(child: listView((size.width / 2) - 25, size.height - 55)),
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
