import 'package:flutter/material.dart';

import 'Customer.dart';
import 'Flight.dart';

class AddReservationPage extends StatefulWidget {
  const AddReservationPage({Key? key}) : super(key: key);

  @override
  _AddReservationPageState createState() => _AddReservationPageState();
}

class _AddReservationPageState extends State<AddReservationPage> {
  Customer? selectedCustomer;
  Flight? selectedFlight;
  DateTime selectedDate = DateTime.now();

  List<Customer> customers = [
    Customer(name: 'John Doe', id: '1'),
    Customer(name: 'Jane Smith', id: '2'),
    // Add more customers as needed
  ];

  List<Flight> flights = [
    Flight(
      flightNumber: 'AC 123',
      departCity: 'Toronto',
      arriveCity: 'Vancouver',
      departTime: '09:00 AM',
    ),
    Flight(
      flightNumber: 'AC 456',
      departCity: 'Toronto',
      arriveCity: 'Vancouver',
      departTime: '12:00 PM',
    ),
    // Add more flights as needed
  ];

  void handleDateChanged(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Reservation'),
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
              decoration: InputDecoration(
                labelText: 'Select Customer',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
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
              decoration: InputDecoration(
                labelText: 'Select Flight',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text('Select Date:'),
              subtitle: Text('${selectedDate.year}-${selectedDate.month}-${selectedDate.day}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (picked != null && picked != selectedDate) {
                  handleDateChanged(picked);
                }
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle reservation submission here
                if (selectedCustomer != null && selectedFlight != null) {
                  // Save reservation logic goes here
                  // For example, you could use a database or store it in memory
                  // Then navigate back to the reservations page or show confirmation
                  Navigator.pop(context); // Go back to previous screen after saving
                } else {
                  // Show error message or prompt to select both customer and flight
                }
              },
              child: Text('Add Reservation'),
            ),
          ],
        ),
      ),
    );
  }
}
