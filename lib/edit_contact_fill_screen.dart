import 'package:flutter/material.dart';
import 'package:flutter_contact_manoj/contact_list_screen.dart';
import 'package:flutter_contact_manoj/database_helper.dart';
import 'package:flutter_contact_manoj/main.dart';

import 'contact_details.dart';

class EditContactFillScreen extends StatefulWidget {
  const EditContactFillScreen({super.key});

  @override
  State<EditContactFillScreen> createState() => _EditContactFillScreenState();
}

class _EditContactFillScreenState extends State<EditContactFillScreen> {
  var _nameController = TextEditingController();
  var _mobilenumberController = TextEditingController();
  var _mailController = TextEditingController();
  var _addressController = TextEditingController();

  bool firstTimeFlag = false;
  int _selectedId = 0;

  @override
  Widget build(BuildContext context) {
    if (firstTimeFlag == false) {
      print('------------------> Once execute');
      firstTimeFlag = true;

      final contactDetailsModal =
          ModalRoute.of(context)!.settings.arguments as ContactDetails;

      print('------------------> Received data');
      print(contactDetailsModal.id);
      print(contactDetailsModal.name);
      print(contactDetailsModal.mobileNumber);
      print(contactDetailsModal.email);
      print(contactDetailsModal.address);

      _selectedId = contactDetailsModal.id!;

      _nameController.text = contactDetailsModal.name;
      _mobilenumberController.text = contactDetailsModal.mobileNumber;
      _mailController.text = contactDetailsModal.email;
      _addressController.text = contactDetailsModal.address;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact Details Form',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem(value: 1, child: Text('Delete')),
            ],
            onSelected: (value) {
              if (value == 1) {
                print('------------------------> Delete - Display Dialog');
                _deleteFormDialog(context);
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: SizedBox(
                  height: 50,
                  width: 400,
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      labelText: 'Name',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: SizedBox(
                  height: 50,
                  width: 400,
                  child: TextFormField(
                    controller: _mobilenumberController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      labelText: 'Contact Number',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: SizedBox(
                  height: 50,
                  width: 400,
                  child: TextFormField(
                    controller: _mailController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide()),
                        labelText: 'E-Mail'),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: SizedBox(
                  height: 50,
                  width: 400,
                  child: TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide()),
                        labelText: 'Address'),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () {
                    print('----------------->Update Clicked');
                    _update();
                  },
                  child: Text('Update'))
            ],
          ),
        ),
      ),
    );
  }

  void _update() async {
    print('-------------------> Update');

    print('--------------> ID: $_selectedId');
    print('------------------->  Name: ${_nameController.text}');
    print(
        '-------------------> Mobile Number : ${_mobilenumberController.text}');
    print('-------------------> E-Mail : ${_mailController.text}');
    print('-------------------> Address : ${_addressController.text}');

    Map<String, dynamic> row = {
      DatabaseHelper.columnId: _selectedId,
      DatabaseHelper.columnName: _nameController.text,
      DatabaseHelper.columnNumber: _mobilenumberController.text,
      DatabaseHelper.columnMail: _mailController.text,
      DatabaseHelper.columnAddress: _addressController.text,
    };

    final result =
        await dbHelper.insert(row, DatabaseHelper.contactDetailsTable);

    print('-----------------> Insert Result : $result');

    if (result > 0) {
      Navigator.pop(context);
      _showSuccessSnackBar(context, 'Updated');
    }

    setState(() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ContactListScreen()));
    });
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(message)));
  }

  _deleteFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  print('---------------------> cancel clicked');
                  Navigator.of(context);
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  print('---------------------> delete clicked');
                  _deleteRow();
                },
                child: Text('Delete'),
              )
            ],
            title: Text('Are you sure you want to delete this?'),
          );
        });
  }

  void _deleteRow() async {
    print('--------> Delete');

    print('-----------> ID: $_selectedId');

    final result =
        await dbHelper.delete(_selectedId, DatabaseHelper.contactDetailsTable);

    print('---------------> Deleted Result: $result');

    if (result > 0) {
      Navigator.pop(context);
      _showSuccessSnackBar(context, 'Deleted');
    }

    setState(() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ContactListScreen()));
    });
  }
}
