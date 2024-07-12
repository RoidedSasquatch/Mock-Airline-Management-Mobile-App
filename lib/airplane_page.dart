import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  Widget controlPanel() {
    return const Column(
      children: [
        Padding(
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
            Text("Airplane Type: "),
            Text("Max. Passengers: ")
          ],)
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
                    Expanded(child: controlPanel()),
                    // Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: flightList(size.width - 100, size.height / 2, 45,8))
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
                    Expanded(child: controlPanel()),
                    // Expanded(child: flightList((size.width / 2) - 25, size.height - 55, 80, 10)),
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
