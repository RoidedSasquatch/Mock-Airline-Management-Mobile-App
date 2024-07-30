import 'package:flutter/material.dart';
import 'Reservation.dart';

class ReservationDetailsPage extends StatelessWidget {
  final Reservation reservation;
  final void Function(Reservation) onDelete;

  const ReservationDetailsPage({
    Key? key,
    required this.reservation,
    required this.onDelete,
  }) : super(key: key);

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete the reservation for ${reservation.customer.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      onDelete(reservation);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation Details'),
        automaticallyImplyLeading: !isLandscape, // Remove back button in landscape mode
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmationDialog(context),
          ),
        ],
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
