import 'package:flutter/material.dart';
import 'Customer.dart';
import 'Flight_Temp.dart';
import 'Reservation.dart';

class AddReservationPage extends StatefulWidget {
  final List<Reservation> reservations;
  final int nextId;

  const AddReservationPage({super.key, required this.reservations, required this.nextId});

  @override
  _AddReservationPageState createState() => _AddReservationPageState();
}

class _AddReservationPageState extends State<AddReservationPage> {
  Customer? selectedCustomer;
  Flight? selectedFlight;
  DateTime selectedDate = DateTime.now();

  List<Customer> customers = [
    Customer(name: 'John Doe'),
    Customer(name: 'Jane Smith'),
    Customer(name: 'Rocky Balboa'),
    Customer(name: 'Bruce Wayne'),
    Customer(name: 'Joshua Barrett'),
    Customer(name: 'Darth Vader'),
    Customer(name: 'Luke Skywalker'),
  ];

  List<Flight> flights = [
    Flight(
      flightNumber: 'AC 123',
      departCity: 'Toronto',
      arriveCity: 'Vancouver',
      departTime: '09:00 AM',
      arriveTime: '11:30 AM',
    ),
    Flight(
      flightNumber: 'AC 456',
      departCity: 'Toronto',
      arriveCity: 'Vancouver',
      departTime: '12:00 PM',
      arriveTime: '3:30 PM',
    ),
    Flight(
      flightNumber: 'AC 789',
      departCity: 'Toronto',
      arriveCity: 'Vancouver',
      departTime: '04:00 PM',
      arriveTime: '07:30 PM',
    ),
    Flight(
      flightNumber: 'AC 112',
      departCity: 'Ottawa',
      arriveCity: 'New York',
      departTime: '08:00 AM',
      arriveTime: '01:00 PM',
    ),
    Flight(
      flightNumber: 'AC 113',
      departCity: 'Ottawa',
      arriveCity: 'New York',
      departTime: '11:30 AM',
      arriveTime: '04:30 PM',
    ),
    Flight(
      flightNumber: 'AC 125',
      departCity: 'Ottawa',
      arriveCity: 'Los Angeles',
      departTime: '01:00 PM',
      arriveTime: '08:30 PM',
    ),
    Flight(
      flightNumber: 'AC 268',
      departCity: 'Ottawa',
      arriveCity: 'New York',
      departTime: '05:00 PM',
      arriveTime: '10:00 PM',
    ),
  ];

  void handleDateChanged(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  Future<void> _showSaveDialog(Reservation newReservation) async {
    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Save Reservation'),
          content: const Text('Would you like to save this reservation?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (shouldSave == true) {
      setState(() {
        widget.reservations.add(newReservation);
      });
      Navigator.pop(context, widget.reservations);
    }
  }

  void addReservation() {
    if (selectedCustomer != null && selectedFlight != null) {
      final newReservation = Reservation(
        id: widget.nextId.toString(),
        customer: selectedCustomer!,
        flight: selectedFlight!,
        date: selectedDate,
      );

      _showSaveDialog(newReservation);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both a customer and a flight')),
      );
    }
  }

  Future<void> _showInstructionsDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Instructions'),
          content: const Text(
              'On this page, you can add a reservation through a list of pre-determined options, '
                  'by selecting a customer, a flight, and a date. '
                  'Once you have made your selections, click the "Add Reservation" button. '
                  'You will be prompted to save the reservation. If you choose to save, '
                  'the reservation will be added to the list and saved for future sessions.'
                  ' If you choose to not save, the reservation will not be added to the list.'
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Reservation'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showInstructionsDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<Customer>(
              value: selectedCustomer,
              onChanged: (Customer? value) {
                setState(() {
                  selectedCustomer = value;
                });
              },
              items: customers.map((Customer customer) {
                return DropdownMenuItem<Customer>(
                  value: customer,
                  child: Text(customer.name),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Select Customer',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Flight>(
              value: selectedFlight,
              onChanged: (Flight? value) {
                setState(() {
                  selectedFlight = value;
                });
              },
              items: flights.map((Flight flight) {
                return DropdownMenuItem<Flight>(
                  value: flight,
                  child: Text('${flight.flightNumber} - ${flight.departCity} to ${flight.arriveCity} (${flight.departTime})'),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Select Flight',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Select Date:'),
              subtitle: Text('${selectedDate.year}-${selectedDate.month}-${selectedDate.day}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null && picked != selectedDate) {
                  handleDateChanged(picked);
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: addReservation,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue,
              ),
              child: const Text('Add Reservation'),
            ),
          ],
        ),
      ),
    );
  }
}