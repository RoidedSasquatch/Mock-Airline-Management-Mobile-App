import 'Customer.dart';
import 'Flight_Temp.dart';

class Reservation {
  final String id;
  final Customer customer;
  final Flight flight;
  final DateTime date;

  Reservation({
    required this.id,
    required this.customer,
    required this.flight,
    required this.date,
  });
}
