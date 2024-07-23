class Customer {
  final String name;
  final String id;

  Customer({required this.name, required this.id});

  // Factory method to create a customer with an auto-generated ID
  factory Customer.withAutoId({required String name, required String id}) {
    return Customer(name: name, id: id);
  }
}
