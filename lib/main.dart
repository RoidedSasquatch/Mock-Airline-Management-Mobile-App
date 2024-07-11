import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

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
      home: const MyHomePage(title: 'Airline Management'),
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

  void customersPage() {}

  void airplanesPage() {}

  void flightsPage() {}

  void reservationsPage() {}

  Widget controlPanel() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(
              vertical: 25, horizontal: 25),
          child: Text(
            "Poorman's Airlines Flight Management",
            style: TextStyle(
                color: Colors.white,
                fontSize: 35,
                fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(
                vertical: 25, horizontal: 50),
            child: ElevatedButton(
                onPressed: customersPage,
                child: Text("Customer Management"))),
        Padding(
            padding: EdgeInsets.symmetric(
                vertical: 25, horizontal: 50),
            child: ElevatedButton(
                onPressed: airplanesPage,
                child: Text("Airplane Management"))),
        Padding(
            padding: EdgeInsets.symmetric(
                vertical: 25, horizontal: 50),
            child: ElevatedButton(
                onPressed: flightsPage,
                child: Text("Flight Management"))),
        Padding(
            padding: EdgeInsets.symmetric(
                vertical: 25, horizontal: 50),
            child: ElevatedButton(
                onPressed: reservationsPage,
                child: Text("Reservation Management"))),
      ],
    );
  }

  Widget flightList() {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 400,
          height: size.height - 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white70),
          child:
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child:
                Text("Scheduled Flight List",
                    style:
                    TextStyle(
                        fontSize: 20,
                        fontWeight:
                        FontWeight.bold)),),
              Table()],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(),
          Align(
            child: Container(
              width: size.width * 0.8,
              height: size.height * 0.8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blueAccent),
              child: Row(
                children: [
                  Expanded(
                      child: controlPanel()),
                  Expanded(
                      child: flightList()),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
