import 'Customer.dart';
import 'Flight.dart';

class Reservation {
  final Customer customer;
  final Flight flight;
  final DateTime date;

  Reservation({
    required this.customer,
    required this.flight,
    required this.date,
  });
}
