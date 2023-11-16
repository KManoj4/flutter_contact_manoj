import 'package:flutter/material.dart';
import 'package:flutter_contact_manoj/contact_list_screen.dart';
import 'package:flutter_contact_manoj/database_helper.dart';
import 'package:flutter_contact_manoj/main.dart';


class ContactFillScreen extends StatefulWidget {
  const ContactFillScreen({super.key});

  @override
  State<ContactFillScreen> createState() => _ContactFillScreenState();
}

class _ContactFillScreenState extends State<ContactFillScreen> {
  var _nameController = TextEditingController();
  var _mobilenumberController = TextEditingController();
  var _mailController = TextEditingController();
  var _addressController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact Details Form',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: SizedBox(
                  height: 40,
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
                  height: 70,
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
                    print('-----------------> Save Clicked');
                    _save();
                  },
                  child: Text('Save'))
            ],
          ),
        ),
      ),
    );
  }

  void _save() async {
    print('-------------------> Save');
    print('------------------->  Name: ${_nameController.text}');
    print(
        '-------------------> Mobile Number : ${_mobilenumberController.text}');
    print('-------------------> E-Mail : ${_mailController.text}');
    print('-------------------> Address : ${_addressController.text}');

    Map<String, dynamic> row = {
      DatabaseHelper.columnName: _nameController.text,
      DatabaseHelper.columnNumber : _mobilenumberController.text,
      DatabaseHelper.columnMail : _mailController.text,
      DatabaseHelper.columnAddress : _addressController.text,
    };

    final result =
        await dbHelper.insert(row, DatabaseHelper.contactDetailsTable);

    print('-----------------> Insert Result : $result');


    if(result > 0){
      Navigator.pop(context);
      _showSuccessSnackBar(context, 'Saved');
    }

    setState(() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ContactListScreen()));
    });
  }


  void _showSuccessSnackBar(BuildContext context, String message){
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: new Text(message)));
  }
}
