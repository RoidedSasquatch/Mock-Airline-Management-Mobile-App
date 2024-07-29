import 'dart:ui';
//import 'package:cst2335_group_project/airplane_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

// References
// https://www.freepik.com/free-photo/transport-fly-clouds-jet-flying_1103165.htm#fromView=search&page=1&position=8&uuid=cff44ecc-8674-43ac-ac5d-1e48bf541006
//

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Airline Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: "Turbulence Airlines Operations"),
        // '/customer': ,
        //'/airplane': (context) => const AirplanePage(title: "Airplane Management"),
        // '/airplane/details: ,
        // '/flight': ,
        // '/reservation: '
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  Widget controlPanel() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          child: Text(
            "Turbulence Airlines Operations",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontFamily: "Satoshi",
                fontSize: 35,
                fontWeight: FontWeight.bold),
          ),
        ),
        ElevatedButton(
            onPressed: () {Navigator.pushNamed(context, '/customer'); },
            style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith((states) => Colors.black38),
                foregroundColor: MaterialStateColor.resolveWith((states) => Colors.black38),
                overlayColor: MaterialStateColor.resolveWith((states) => Colors.black12)),
            child: const SizedBox(
                width: 250,
                height: 30,
                child: Row(
                    children: [
                      Icon(Icons.person, color: Colors.greenAccent,),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                      Text("Customer Management", style: TextStyle(color: Colors.white, fontFamily: "Satoshi"))]
                )
            )
        ),
        ElevatedButton(
            onPressed: () {Navigator.pushNamed(context, '/airplane'); },
            style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith((states) => Colors.black38),
                foregroundColor: MaterialStateColor.resolveWith((states) => Colors.black38),
                overlayColor: MaterialStateColor.resolveWith((states) => Colors.black12)),
            child: const SizedBox(
                width: 250,
                height: 30,
                child: Row(
                    children: [
                      Icon(Icons.airplanemode_active, color: Colors.greenAccent,),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                      Text("Airplane Management", style: TextStyle(color: Colors.white, fontFamily: "Satoshi"))]
                )
            )
        ),
        ElevatedButton(
            onPressed: () {Navigator.pushNamed(context, '/flight'); },
            style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith((states) => Colors.black38),
                foregroundColor: MaterialStateColor.resolveWith((states) => Colors.black38),
                overlayColor: MaterialStateColor.resolveWith((states) => Colors.black12)),
            child: const SizedBox(
                width: 250,
                height: 30,
                child: Row(
                    children: [
                      Icon(Icons.travel_explore, color: Colors.greenAccent,),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                      Text("Flight Management", style: TextStyle(color: Colors.white, fontFamily: "Satoshi"))]
                )
            )
        ),
        ElevatedButton(
            onPressed: () {Navigator.pushNamed(context, '/reservation'); },
            style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith((states) => Colors.black38),
                foregroundColor: MaterialStateColor.resolveWith((states) => Colors.black38),
                overlayColor: MaterialStateColor.resolveWith((states) => Colors.black12)),
            child: const SizedBox(
                width: 250,
                height: 30,
                child: Row(
                    children: [
                      Icon(Icons.airplane_ticket, color: Colors.greenAccent,),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                      Text("Reservation Management", style: TextStyle(color: Colors.white, fontFamily: "Satoshi"))]
                )
            )
        ),
      ],
    );
  }

  Widget flightList(double width, double height, double colWidth, double fontSize) {
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
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text("Scheduled Flight List",
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: "Satoshi")),
              ),
              InteractiveViewer(child: DataTable(
                headingRowColor: MaterialStateColor.resolveWith((states) => Colors.black54),
                columns: [
                  DataColumn(
                    label: SizedBox(
                        width: colWidth,
                        child:
                        Text("Depart City", style: TextStyle(color: Colors.white, fontSize: fontSize))),),
                  DataColumn(
                    label: SizedBox(
                        width: colWidth,
                        child:
                        Text("Arrive City", style: TextStyle(color: Colors.white, fontSize: fontSize))),),
                  DataColumn(
                    label: SizedBox(
                        width: colWidth,
                        child:
                        Text("Depart Time", style: TextStyle(color: Colors.white, fontSize: fontSize))),)
                ],
                rows: const [

                ],
              ),),
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
                        colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
                        image: const AssetImage("assets/images/plane-wing.png"))),
                child: Column(
                  children: [
                    Expanded(child: controlPanel()),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: flightList(size.width - 100, size.height / 2, 45,8))
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
                      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
                      image: const AssetImage("assets/images/plane-wing.png")),
                ),
                child: Row(
                  children: [
                    Expanded(child: controlPanel()),
                    Expanded(child: flightList((size.width / 2) - 25, size.height - 55, 80, 10)),
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
