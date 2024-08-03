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
  CustomerItem? _selectedCustomer;

  List<CustomerItem> customers = [];
  late CustomerDAO customerDAO;
  Customers? selectedItem;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _passportController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();

  final _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadLatestCustomer();
    _nameController.addListener(_saveLatestCustomer);
    _firstNameController.addListener(_saveLatestCustomer);
    _passportController.addListener(_saveLatestCustomer);
    _budgetController.addListener(_saveLatestCustomer);

    WidgetsBinding.instance.addPostFrameCallback((s) {
      intDataBase();
    });
  }

  intDataBase() async {
    final database =
    await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    customerDAO = database.CustomerDao;
    loadData();
  }

  void loadData() async {
    // final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    // customerDAO = database.CustomerDao as CustomerDAO;
    var listToCopy = await customerDAO.findAllToDoItems();

    print(await customerDAO.findAllToDoItems());
    print(listToCopy);
    customers.clear();
    customers.addAll(listToCopy);

    setState(() {});
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

    if (name != null &&
        firstName != null &&
        passport != null &&
        budget != null) {
      setState(() {
        _nameController.text = name;
        _firstNameController.text = firstName;
        _passportController.text = passport;
        _budgetController.text = budget;
      });
    }
  }

  Future<void> _saveLatestCustomer() async {
    await _storage.write(
        key: 'latestCustomerName', value: _nameController.text);
    await _storage.write(
        key: 'latestCustomerFirstName', value: _firstNameController.text);
    await _storage.write(
        key: 'latestCustomerPassport', value: _passportController.text);
    await _storage.write(
        key: 'latestCustomerBudget', value: _budgetController.text);
  }

  Future<void> _updateCustomer() async {
    if (_nameController.text.isNotEmpty &&
        _firstNameController.text.isNotEmpty &&
        _passportController.text.isNotEmpty &&
        _budgetController.text.isNotEmpty) {
      final customer = customers[_selectedEditIndex];
      var updatedCustomer = CustomerItem(
          customer.id,
          _nameController.text,
          _firstNameController.text,
          int.parse(_budgetController.text),
          int.parse(_budgetController.text));
      var result = await customerDAO.updateCustomerItem(updatedCustomer);
      print(result);

      customers[_selectedEditIndex] = updatedCustomer;

      _selectedEditIndex = null;
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Customer updated successfully!'),
        ),
      );
    }
  }

  Future<void> _addCustomer() async {
    if (_nameController.text.isNotEmpty &&
        _firstNameController.text.isNotEmpty &&
        _passportController.text.isNotEmpty &&
        _budgetController.text.isNotEmpty) {
      final customer = CustomerItem(
          null,
          _nameController.text,
          _firstNameController.text,
          int.parse(_passportController.text),
          int.parse(_budgetController.text));
      var result = await customerDAO.insertCustomerItem(customer);
      print(result);

      customers.add(CustomerItem(
          result,
          _nameController.text,
          _firstNameController.text,
          int.parse(_passportController.text),
          int.parse(_budgetController.text)));

      _nameController.clear();
      _firstNameController.clear();
      _passportController.clear();
      _budgetController.clear();

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Customer added successfully!'),
        ),
      );

      _saveLatestCustomer();
    }
  }

  void _clearFields() {
    _nameController.clear();
    _firstNameController.clear();
    _passportController.clear();
    _budgetController.clear();
  }

  void _showCustomerDetails(int index, bool isWideScreen) {
    final customer = customers[index];
    if (isWideScreen) {
      print("ss");
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
                  Text('Name: ${customer.firstName}'),
                  Text('First Name: ${customer.lastName}'),
                  Text('Address: ${customer.passportNumber}'),
                  Text('Birthday: ${customer.budget}'),
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
                child: Text('Edit'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _editCustomer(index);
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

  var _selectedEditIndex = null;

  void _editCustomer(int index) {
    _selectedEditIndex = index;




    prepoluateEditData();
    setState(() {});
  }

  void prepoluateEditData() {
    _nameController.text = customers[_selectedEditIndex].firstName;
    _firstNameController.text = customers[_selectedEditIndex].lastName;
    _passportController.text =
    "${customers[_selectedEditIndex].passportNumber}";
    _budgetController.text = "${customers[_selectedEditIndex].budget}";
  }

  Future<void> _deleteCustomer(int index) async {
    print("Callign delete");
    print(customers[index].id);

    if (customers[index].id != -1) {
      var it = await customerDAO.deleteToDoItem(customers[index].id ?? -1);
      print(it);
      customers.removeAt(index);
      _selectedCustomer = null;

      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Customer deleted successfully!'),
        ),
      );
    }
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
                Text(
                    '4. After a long press, you can delete the customer entry.'),
                Text(
                    '5. You can navigate to other pages by pressing the shortcuts bellow the add button'),
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
            Text('Name: ${customer.firstName}', style: TextStyle(fontSize: 16)),
            Text('First Name: ${customer.lastName}',
                style: TextStyle(fontSize: 16)),
            Text('Address: ${customer.passportNumber}',
                style: TextStyle(fontSize: 16)),
            Text('Birthday: ${customer.budget}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final index = customers.indexOf(customer);
                _deleteCustomer(index);
              },
              child: Text('Delete'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final index = customers.indexOf(customer);
                _editCustomer(index);
              },
              child: Text('Edit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
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
                  child: SingleChildScrollView(
                    physics: isWideScreen
                        ? AlwaysScrollableScrollPhysics()
                        : NeverScrollableScrollPhysics(),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Enter customer name',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              labelText: 'Enter customer first name',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: _passportController,
                            decoration: InputDecoration(
                              labelText: 'Enter customer address',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: _budgetController,
                            decoration: InputDecoration(
                              labelText: 'Enter Customer Birthday',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10.0),
                            ),
                          ),
                          SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: _selectedEditIndex == null
                                    ? _addCustomer
                                    : _updateCustomer,
                                child: Text(
                                    _selectedEditIndex == null ? 'Add' : 'Edit'),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 30.0),
                                  textStyle: TextStyle(fontSize: 18),
                                ),
                              ),
                              SizedBox(width: 16), // Add some space between buttons
                              ElevatedButton(
                                onPressed: _clearFields,
                                child: Text('Clear'),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                                  textStyle: TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 20),
                          Expanded(
                            child: ListView.builder(
                              itemCount: customers.length,
                              // physics: isWideScreen
                              //     ? NeverScrollableScrollPhysics()
                              //     : AlwaysScrollableScrollPhysics(),
                              // shrinkWrap: isWideScreen ? true : false,
                              itemBuilder: (context, index) {
                                final customer = customers[index];
                                return Card(
                                  margin: EdgeInsets.symmetric(vertical: 5.0),
                                  child: GestureDetector(
                                    onLongPress: () => _showCustomerDetails(
                                        index, isWideScreen),
                                    child: ListTile(
                                      title: Text(
                                          '${customer.firstName} ${customer.lastName}'),
                                      subtitle: Text(
                                          'Address: ${customer.passportNumber}, Birthday: ${customer.budget}'),
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
