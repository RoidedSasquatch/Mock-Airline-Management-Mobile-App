import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FlightPage extends StatefulWidget {

  const FlightPage({super.key, required this.title});

  final String title;

  @override
  State<FlightPage> createState() => FlightPageState();
}

class FlightPageState extends State<FlightPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "TEMP APP BAR TITLE",
          style: const TextStyle(
            color: Colors.white,
            fontFamily: "Satoshi",
            fontSize: 20,
            fontWeight: FontWeight.bold
          )
        ),
      ),
    );
  }
}