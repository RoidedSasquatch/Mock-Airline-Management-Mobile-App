import 'package:flutter/material.dart';
import 'Reservation.dart';

class ReservationDetailsPage extends StatelessWidget {
  final Reservation reservation;

  const ReservationDetailsPage({Key? key, required this.reservation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer: ${reservation.customer.name}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Flight: ${reservation.flight.flightNumber}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Departure City: ${reservation.flight.departCity}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Destination City: ${reservation.flight.arriveCity}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Departure Time: ${reservation.flight.departTime}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Arrival Time: ${reservation.flight.arriveTime}', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
