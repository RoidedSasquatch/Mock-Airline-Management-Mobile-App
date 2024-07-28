import 'package:flutter/material.dart';
import 'Customer.dart';
import 'Flight.dart';
import 'Reservation.dart';
import 'AppLocalizations.dart';

class AddReservationPage extends StatefulWidget {
  final List<Reservation> reservations;
  final int nextId;
  final void Function(Locale locale) setLocale;

  const AddReservationPage({Key? key, required this.reservations, required this.nextId, required this.setLocale}) : super(key: key);

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
          title: Text(AppLocalizations.of(context)?.translate('save_reservation') ?? 'Save Reservation'),
          content: Text(AppLocalizations.of(context)?.translate('save_confirmation') ?? 'Would you like to save this reservation?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(AppLocalizations.of(context)?.translate('no') ?? 'No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(AppLocalizations.of(context)?.translate('yes') ?? 'Yes'),
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
        SnackBar(content: Text(AppLocalizations.of(context)?.translate('select_warning') ?? 'Please select both a customer and a flight')),
      );
    }
  }

  Future<void> _showInstructionsDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)?.translate('instructions') ?? 'Instructions'),
          content: Text(AppLocalizations.of(context)?.translate('instructions_content') ??
              'On this page, you can add a reservation through a list of pre-determined options, '
                  'by selecting a customer, a flight, and a date. '
                  'Once you have made your selections, click the "Add Reservation" button. '
                  'You will be prompted to save the reservation. If you choose to save, '
                  'the reservation will be added to the list and saved for future sessions.'
                  ' If you choose to not save, the reservation will not be added to the list.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)?.translate('ok') ?? 'OK'),
            ),
          ],
        );
      },
    );
  }

  void _toggleLanguage() {
    Locale currentLocale = Localizations.localeOf(context);
    Locale newLocale = (currentLocale.languageCode == 'en')
        ? const Locale('fr', '')
        : const Locale('en', '');

    widget.setLocale(newLocale);
    // This ensures the UI rebuilds and applies the new locale
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var appLocalizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations?.translate('title') ?? 'Add Reservation'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.language),
            onPressed: _toggleLanguage,
          ),
          IconButton(
            icon: Icon(Icons.info_outline),
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
              decoration: InputDecoration(
                labelText: appLocalizations?.translate('select_customer') ?? 'Select Customer',
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
                labelText: appLocalizations?.translate('select_flight') ?? 'Select Flight',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text(appLocalizations?.translate('select_date') ?? 'Select Date:'),
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
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: addReservation,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue,
              ),
              child: Text(appLocalizations?.translate('add_reservation') ?? 'Add Reservation'),
            ),
          ],
        ),
      ),
    );
  }
}
