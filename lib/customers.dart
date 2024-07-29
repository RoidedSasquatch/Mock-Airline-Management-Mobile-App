// customers.dart

import 'package:flutter/material.dart';

class Customers extends StatefulWidget {
  @override
  State<Customers> createState() => _CustomersState();

}

class _CustomersState extends State<Customers> {
  final List<String> _customers = [];
  final TextEditingController _controller = TextEditingController();

  void _addCustomer() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _customers.add(_controller.text);
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customers'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Enter customer name',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _addCustomer,
                  child: Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _customers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_customers[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
