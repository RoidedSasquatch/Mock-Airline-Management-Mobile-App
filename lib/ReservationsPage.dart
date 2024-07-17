import 'package:flutter/material.dart';
import 'AddReservationPage.dart';
import 'Reservation.dart';

class ReservationsPage extends StatefulWidget {
  final List<Reservation> reservations;

  const ReservationsPage({Key? key, required this.reservations}) : super(key: key);

  @override
  _ReservationsPageState createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  List<Reservation> reservations = [];

  @override
  void initState() {
    super.initState();
    reservations = List.from(widget.reservations); // Ensure the list is growable
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservations'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final updatedReservations = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddReservationPage(reservations: reservations),
                  ),
                );
                if (updatedReservations != null) {
                  setState(() {
                    reservations = updatedReservations;
                  });
                }
              },
              child: Text('Add Reservation'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${reservations[index].customer.name} - ${reservations[index].flight.flightNumber}'),
                    subtitle: Text('Date: ${reservations[index].date.year}-${reservations[index].date.month}-${reservations[index].date.day}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
