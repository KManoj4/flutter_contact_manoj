import 'package:flutter/material.dart';
import 'edit_contact_fill_screen.dart';
import 'database_helper.dart';
import 'contact_details.dart';
import 'contact_fill_screen.dart';
import 'main.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  late List<ContactDetails> _contactDetailsList;

  @override
  void initState() {
    super.initState();
    getAllContactDetails();
  }

  getAllContactDetails() async {
    _contactDetailsList = <ContactDetails>[];

    var contactDetails =
    await dbHelper.queryAllRows(DatabaseHelper.contactDetailsTable);

    //var contactDetails =
    //await dpHelper.queryAllRows(DatabaseHelper.contactDetailsTable);


    contactDetails.forEach((contact) {
      setState(() {
        print(contact['_id']);
        print(contact['_name']);
        print(contact['_mobileNumber']);
        print(contact['_email']);
        print(contact['_address']);

        var contactDetailsModel = ContactDetails(
           contact['_id'],
            contact['_name'],
            contact['_mobileNumber'],
            contact['_email'],
            contact['_address']);

        _contactDetailsList.add(contactDetailsModel);
      });
    });
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact Details',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              new Expanded(
                  child: new ListView.builder(
                      itemCount: _contactDetailsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            print('------------> List view Clicked $index');
                            print('------------> Edit or Delete: Send Data');
                            print(_contactDetailsList[index].id);
                            print(_contactDetailsList[index].name);
                            print(_contactDetailsList[index].mobileNumber);
                            print(_contactDetailsList[index].email);
                            print(_contactDetailsList[index].address);
                            
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditContactFillScreen(),
                            settings: RouteSettings(
                              arguments: _contactDetailsList[index],
                            )));
                            },

                          child: Text(_contactDetailsList[index].name +
                              '\n' +
                              _contactDetailsList[index].mobileNumber +
                              '\n' +
                              _contactDetailsList[index].email +
                              '\n' +
                              _contactDetailsList[index].address +
                              '\n'),
                        );
                      }))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('------------> FAB Clicked');
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ContactFillScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
