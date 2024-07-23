import 'package:flutter/material.dart';
import 'AddReservationPage.dart';
import 'Customer.dart';
import 'Flight.dart';
import 'Reservation.dart';
import 'ReservationDetailsPage.dart';

class ReservationsPage extends StatefulWidget {
  final List<Reservation> reservations;
  const ReservationsPage({Key? key, required this.reservations}) : super(key: key);

  @override
  _ReservationsPageState createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  List<Reservation> reservations = [];
  DateTime selectedDate = DateTime.now();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController flightNumberController = TextEditingController();
  final TextEditingController departCityController = TextEditingController();
  final TextEditingController arriveCityController = TextEditingController();
  final TextEditingController departTimeController = TextEditingController();
  final TextEditingController arriveTimeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  int _reservationIdCounter = 0; // Counter for generating IDs

  @override
  void initState() {
    super.initState();
    reservations = widget.reservations;
    dateController.text = _formatDate(selectedDate); // Initialize with the current date
    _updateIdCounter();
  }

  void _updateIdCounter() {
    if (reservations.isNotEmpty) {
      _reservationIdCounter = reservations.map((r) => int.parse(r.id)).reduce((a, b) => a > b ? a : b);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(), // Prevent selecting past dates
      lastDate: DateTime.now().add(Duration(days: 365)), // Allow selecting dates within one year
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = _formatDate(selectedDate);
      });
    }
  }

  void addReservationFromInput() {
    final customerName = customerNameController.text;
    final flightNumber = flightNumberController.text;
    final departCity = departCityController.text;
    final arriveCity = arriveCityController.text;
    final departTime = departTimeController.text;
    final arriveTime = arriveTimeController.text;
    final date = dateController.text;

    if (customerName.isNotEmpty &&
        flightNumber.isNotEmpty &&
        departCity.isNotEmpty &&
        arriveCity.isNotEmpty &&
        departTime.isNotEmpty &&
        arriveTime.isNotEmpty &&
        date.isNotEmpty) {
      final newReservation = Reservation(
        id: (_reservationIdCounter + 1).toString(), // Assign ID
        customer: Customer(name: customerName), // Empty ID for Customer
        flight: Flight(
          flightNumber: flightNumber,
          departCity: departCity,
          arriveCity: arriveCity,
          departTime: departTime,
          arriveTime: arriveTime,
        ),
        date: selectedDate,
      );

      setState(() {
        reservations.add(newReservation);
        _reservationIdCounter++; // Increment the ID counter
      });

      customerNameController.clear();
      flightNumberController.clear();
      departCityController.clear();
      arriveCityController.clear();
      departTimeController.clear();
      arriveTimeController.clear();
      dateController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input fields for adding reservations
            TextField(
              controller: customerNameController,
              decoration: InputDecoration(labelText: 'Customer Name'),
            ),
            TextField(
              controller: flightNumberController,
              decoration: InputDecoration(labelText: 'Flight Number'),
            ),
            TextField(
              controller: departCityController,
              decoration: InputDecoration(labelText: 'Departure City'),
            ),
            TextField(
              controller: arriveCityController,
              decoration: InputDecoration(labelText: 'Arrival City'),
            ),
            TextField(
              controller: departTimeController,
              decoration: InputDecoration(labelText: 'Departure Time'),
            ),
            TextField(
              controller: arriveTimeController,
              decoration: InputDecoration(labelText: 'Arrival Time'),
            ),
            TextField(
              controller: dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Date',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: _selectDate,
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: addReservationFromInput,
              child: Text('Add Reservation'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('ID: ${reservations[index].id} - ${reservations[index].customer.name} - ${reservations[index].flight.flightNumber}'),
                    subtitle: Text('Date: ${reservations[index].date.year}-${reservations[index].date.month}-${reservations[index].date.day}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReservationDetailsPage(reservation: reservations[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final updatedReservations = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddReservationPage(
                      reservations: reservations,
                      nextId: _reservationIdCounter + 1, // Pass the updated ID counter
                    ),
                  ),
                );
                if (updatedReservations != null) {
                  setState(() {
                    reservations = updatedReservations;
                    _updateIdCounter(); // Update the ID counter based on the updated list
                  });
                }
              },
              child: Text('Add Reservation via Form'),
            ),
          ],
        ),
      ),
    );
  }
}
