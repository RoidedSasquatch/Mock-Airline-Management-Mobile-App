import 'package:cst2335_group_project/CustomerDAO.dart';
import 'package:cst2335_group_project/CustomerItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'AppDatabase.dart';

class Customers extends StatefulWidget {
  @override
  State<Customers> createState() => _CustomersState();

}

class _CustomersState extends State<Customers> {
  List<Map<String, String>> _customers = [];

  Map<String, String>? _selectedCustomer;

  List<CustomerItem> customers = [];
  late CustomerDAO customerDAO;
  Customers? selectedItem;




  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _passportController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  static int ID = 100;

  final _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadLatestCustomer();
    _nameController.addListener(_saveLatestCustomer);
    _firstNameController.addListener(_saveLatestCustomer);
    _passportController.addListener(_saveLatestCustomer);
    _budgetController.addListener(_saveLatestCustomer);
    intDataBase();
  }

  intDataBase () async {
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    customerDAO = database.CustomerDao;
  }

  void loadData() async {
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    customerDAO = database.CustomerDao as CustomerDAO;
    var listToCopy = await customerDAO.findAllToDoItems();
    setState(() {
      customers.addAll(listToCopy);
    });
  }

  @override
  void dispose() {
    _nameController.removeListener(_saveLatestCustomer);
    _firstNameController.removeListener(_saveLatestCustomer);
    _passportController.removeListener(_saveLatestCustomer);
    _budgetController.removeListener(_saveLatestCustomer);
    _nameController.dispose();
    _firstNameController.dispose();
    _passportController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _loadLatestCustomer() async {
    String? name = await _storage.read(key: 'latestCustomerName');
    String? firstName = await _storage.read(key: 'latestCustomerFirstName');
    String? passport = await _storage.read(key: 'latestCustomerPassport');
    String? budget = await _storage.read(key: 'latestCustomerBudget');

    if (name != null && firstName != null && passport != null && budget != null) {
      setState(() {
        _nameController.text = name;
        _firstNameController.text = firstName;
        _passportController.text = passport;
        _budgetController.text = budget;
      });
    }
  }

  Future<void> _saveLatestCustomer() async {
    await _storage.write(key: 'latestCustomerName', value: _nameController.text);
    await _storage.write(key: 'latestCustomerFirstName', value: _firstNameController.text);
    await _storage.write(key: 'latestCustomerPassport', value: _passportController.text);
    await _storage.write(key: 'latestCustomerBudget', value: _budgetController.text);
  }

  void _addCustomer() {
    if (_nameController.text.isNotEmpty &&
        _firstNameController.text.isNotEmpty &&
        _passportController.text.isNotEmpty &&
        _budgetController.text.isNotEmpty) {
      setState(() {
        _customers.add({
          'name': _nameController.text,
          'firstName': _firstNameController.text,
          'passport': _passportController.text,
          'budget': _budgetController.text,
        });

        final customer = CustomerItem(ID++, _nameController.text, _firstNameController.text,
            int.parse(_budgetController.text), int.parse(_budgetController.text) );
        customerDAO.insertCustomerItem(customer);
        customers.add(customer);


        _nameController.clear();
        _firstNameController.clear();
        _passportController.clear();
        _budgetController.clear();
      });




      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Customer added successfully!'),
        ),
      );

      _saveLatestCustomer();
    }
  }

  void _showCustomerDetails(int index, bool isWideScreen) {
    final customer = _customers[index];
    if (isWideScreen) {
      setState(() {
        _selectedCustomer = customer;
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Customer Details'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Name: ${customer['name']}'),
                  Text('First Name: ${customer['firstName']}'),
                  Text('Passport: ${customer['passport']}'),
                  Text('Budget: ${customer['budget']}'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Delete'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteCustomer(index);
                },
              ),
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }



  void _deleteCustomer(int index) {
    setState(() {
      _customers.removeAt(index);
      _selectedCustomer = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Customer deleted successfully!'),
      ),
    );
  }

  void _showInstructions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Instructions'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('1. Enter customer details in the text fields.'),
                Text('2. Hit the "Add" button to add the customer.'),
                Text('3. Long press on a customer entry for details.'),
                Text('4. After a long press, you can delete the customer entry.'),
                Text('5. You can navigate to other pages by pressing the shortcuts bellow the add button'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCustomerDetails() {
    if (_selectedCustomer == null) {
      return Center(
        child: Text('Select a customer to view details'),
      );
    }
    final customer = _selectedCustomer!;
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Name: ${customer['name']}', style: TextStyle(fontSize: 16)),
            Text('First Name: ${customer['firstName']}', style: TextStyle(fontSize: 16)),
            Text('Passport: ${customer['passport']}', style: TextStyle(fontSize: 16)),
            Text('Budget: ${customer['budget']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final index = _customers.indexOf(customer);
                _deleteCustomer(index);
              },
              child: Text('Delete'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customers'),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: _showInstructions,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 600;
          return Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Enter customer name',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          labelText: 'Enter customer first name',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _passportController,
                        decoration: InputDecoration(
                          labelText: 'Enter passport number',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _budgetController,
                        decoration: InputDecoration(
                          labelText: 'Enter budget',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _addCustomer,
                        child: Text('Add'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                          textStyle: TextStyle(fontSize: 18),
                        ),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _customers.length,
                          itemBuilder: (context, index) {
                            final customer = _customers[index];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 5.0),
                              child: GestureDetector(
                                onLongPress: () => _showCustomerDetails(index, isWideScreen),
                                child: ListTile(
                                  title: Text('${customer['name']} ${customer['firstName']}'),
                                  subtitle: Text('Passport: ${customer['passport']}, Budget: ${customer['budget']}'),
                                ),
                              ),
                            );
                          },
                        ),

                      ),
                    ],
                  ),
                ),
              ),
              if (isWideScreen)
                Expanded(
                  child: _buildCustomerDetails(),
                ),
            ],
          );
        },
      ),
    );
  }
}
