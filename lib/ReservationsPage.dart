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

  void _showInstructionsDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Instructions'),
          content: const Text(
              'On this page, you can add a reservation manually and view a list of existing reservations. '
                  'To add a new reservation, fill in all the text fields and tap the "Add Reservation" button. '
                  'If done correctly, You will be prompted to save the reservation. If you choose to save, '
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
        title: const Text(
          'Reservations',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: _showInstructionsDialog,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 800;

          return Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Input fields
                      _buildTextField(customerNameController, 'Customer Name'),
                      _buildTextField(flightNumberController, 'Flight Number'),
                      _buildTextField(departCityController, 'Departure City'),
                      _buildTextField(arriveCityController, 'Arrival City'),
                      _buildTextField(departTimeController, 'Departure Time'),
                      _buildTextField(arriveTimeController, 'Arrival Time'),
                      _buildDateField(dateController, _selectDate),
                      SizedBox(height: 16),

                      // Buttons in a row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: addReservationFromInput,
                            child: Text('Add Reservation'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                            ),
                          ),
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
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.green,
                              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      // Reservations list
                      Expanded(
                        child: ListView.builder(
                          itemCount: reservations.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(12),
                                leading: Icon(Icons.flight_takeoff, color: Colors.blue),
                                title: Text(
                                  'ID: ${reservations[index].id} - ${reservations[index].customer.name} - ${reservations[index].flight.flightNumber}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
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
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isWideScreen && selectedReservation != null)
                Expanded(
                  flex: 3,
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

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }

  Widget _buildDateField(TextEditingController controller, Function onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Date',
        ),
        onTap: () => onTap(),
        readOnly: true,
      ),
    );
  }
}