import 'package:flutter/material.dart';
import 'Customer.dart';
import 'Flight.dart';
import 'Reservation.dart';

class AddReservationPage extends StatefulWidget {
  final List<Reservation> reservations;

  const AddReservationPage({Key? key, required this.reservations}) : super(key: key);

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
    Customer(name: 'Rocky Balboa', id: '3'),
    Customer(name: 'Bruce Wayne', id: '4'),
    Customer(name: 'Joshua Barrett', id: '5'),
    Customer(name: 'Darth Vader', id: '6'),
    Customer(name: 'Luke Skywalker', id: '7'),
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

  void addReservation() {
    if (selectedCustomer != null && selectedFlight != null) {
      final newReservation = Reservation(
        customer: selectedCustomer!,
        flight: selectedFlight!,
        date: selectedDate,
      );

      final updatedReservations = List<Reservation>.from(widget.reservations)
        ..add(newReservation);

      Navigator.pop(context, updatedReservations); // Pass the updated list back
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both a customer and a flight')),
      );
    }
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
              onPressed: addReservation,
              child: Text('Add Reservation'),
            ),
          ],
        ),
      ),
    );
  }
}
