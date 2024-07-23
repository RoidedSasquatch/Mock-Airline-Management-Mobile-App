import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'AddReservationPage.dart';
import 'Customer.dart';
import 'Flight.dart';
import 'Reservation.dart';
import 'ReservationDetailsPage.dart';

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({Key? key}) : super(key: key);

  @override
  _ReservationsPageState createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  List<Reservation> reservations = [];
  Reservation? selectedReservation;
  DateTime selectedDate = DateTime.now();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController flightNumberController = TextEditingController();
  final TextEditingController departCityController = TextEditingController();
  final TextEditingController arriveCityController = TextEditingController();
  final TextEditingController departTimeController = TextEditingController();
  final TextEditingController arriveTimeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  int _reservationIdCounter = 0;

  @override
  void initState() {
    super.initState();
    _loadReservations();
    dateController.text = _formatDate(selectedDate);
  }

  void _loadReservations() async {
    final sp = await EncryptedSharedPreferences().getInstance();
    final savedReservations = sp.getString('reservations') ?? '';
    setState(() {
      reservations = _parseReservations(savedReservations);
      _updateIdCounter();
    });
  }

  void _saveReservations() async {
    final sp = await EncryptedSharedPreferences().getInstance();
    final reservationsText = _formatReservations(reservations);
    sp.setString('reservations', reservationsText);
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
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
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
        id: (_reservationIdCounter + 1).toString(),
        customer: Customer(name: customerName),
        flight: Flight(
          flightNumber: flightNumber,
          departCity: departCity,
          arriveCity: arriveCity,
          departTime: departTime,
          arriveTime: arriveTime,
        ),
        date: selectedDate,
      );

      _showSaveDialog(newReservation);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  void _showSaveDialog(Reservation newReservation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Reservation'),
          content: const Text('Would you like to save this reservation for next time?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  reservations.add(newReservation);
                  _reservationIdCounter++;
                  _saveReservations();
                  customerNameController.clear();
                  flightNumberController.clear();
                  departCityController.clear();
                  arriveCityController.clear();
                  departTimeController.clear();
                  arriveTimeController.clear();
                  dateController.clear();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _handleDelete(Reservation reservation) {
    setState(() {
      reservations.remove(reservation);
      if (selectedReservation == reservation) {
        selectedReservation = null;
      }
      _saveReservations();
    });
  }

  List<Reservation> _parseReservations(String text) {
    final lines = text.split('\n');
    return lines.where((line) => line.isNotEmpty).map((line) {
      final parts = line.split('|');
      return Reservation(
        id: parts[0],
        customer: Customer(name: parts[1]),
        flight: Flight(
          flightNumber: parts[2],
          departCity: parts[3],
          arriveCity: parts[4],
          departTime: parts[5],
          arriveTime: parts[6],
        ),
        date: DateTime.parse(parts[7]),
      );
    }).toList();
  }

  String _formatReservations(List<Reservation> reservations) {
    return reservations.map((res) {
      return '${res.id}|${res.customer.name}|${res.flight.flightNumber}|${res.flight.departCity}|${res.flight.arriveCity}|${res.flight.departTime}|${res.flight.arriveTime}|${res.date.toIso8601String()}';
    }).join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservations'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 800;

          return Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Input fields
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
                                setState(() {
                                  selectedReservation = reservations[index];
                                });
                                if (!isWideScreen) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReservationDetailsPage(
                                        reservation: reservations[index],
                                        onDelete: _handleDelete,
                                      ),
                                    ),
                                  );
                                }
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
                                nextId: _reservationIdCounter + 1,
                              ),
                            ),
                          );
                          if (updatedReservations != null) {
                            setState(() {
                              reservations = updatedReservations;
                              _updateIdCounter();
                              _saveReservations();
                            });
                          }
                        },
                        child: Text('Add Reservation via Form'),
                      ),
                    ],
                  ),
                ),
              ),
              if (isWideScreen && selectedReservation != null)
                Expanded(
                  child: ReservationDetailsPage(
                    reservation: selectedReservation!,
                    onDelete: _handleDelete,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
