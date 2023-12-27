import 'package:contactbuddy/Helper/DatabaseHelper.dart';
import 'package:contactbuddy/Views/createContact.dart';
import 'package:contactbuddy/Views/update_contatct.dart';
import 'package:flutter/material.dart';

import 'contact_details.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});


  @override
  State<Contacts> createState() => _ContactsState();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyUpdatePage(title: 'Contacts'),
    );
  }
}

class _ContactsState extends State<Contacts> {
  late DatabaseHelper handler;
  //late Future<List<Contact>> contact;
  List<Map<String, dynamic>> dataList = [];
  final keyword = TextEditingController();

@override
  void initState() {
  _fetchContacts();
    super.initState();
  }

  void _fetchContacts() async {
    List<Map<String, dynamic>> contactList = await DatabaseHelper.getContact();
    setState(() {
      dataList = contactList;
    });
  }

  void _delete(int contactId) async {
    int id = await DatabaseHelper.deleteContact(contactId);
    List<Map<String, dynamic>> updatedata = await DatabaseHelper.getContact();
    setState(() {
      dataList = updatedata;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contact Deleted successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void searchContacts() async {
    List<Map<String, dynamic>> contactList = await DatabaseHelper.searchContacts(keyword.text);
    setState(() {
      dataList = contactList;
    });
  }

  void _showDeleteConfirmationDialog(int contactId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this contact?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _delete(contactId);
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Contacts"),
        titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold, // Set the font weight to bold
            fontSize:20
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed:(){
          Navigator.push(context, MaterialPageRoute(
              builder: (context)=> const CreateContact()
          )

          ).then((value) {
            if(value)
              {
                _fetchContacts();
              }
          });
        } ,
        child: const Icon(Icons.add),
        //child : const Text('Add'),
      ),
      body: Center(


        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.2),
                    borderRadius: BorderRadius.circular(8)),
                child: TextFormField(
                  controller: keyword,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        searchContacts();
                      });
                    } else {
                      setState(() {
                         _fetchContacts();
                      });
                    }
                  },
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.search),
                      hintText: "Search"),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: dataList.isEmpty
                    ? Center(
                  child: Text(
                    'No contacts found.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                )
                  : ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(dataList[index]['Name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${dataList[index]['TelephoneNo']}')
                          ],
                        ),
                        onTap: () {
                          // Navigate to the details page when a contact is tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ContactDetails(contactDetails: dataList[index], contactId: index,),
                            ),
                          );
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UpdateContact(contactId: dataList[index]['id']),
                                    ),
                                  ).then((result) {
                                    if(result == true)
                                    {
                                      _fetchContacts();
                                    }
                                  });
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                )),
                            IconButton(
                              onPressed: () {
                                _showDeleteConfirmationDialog(dataList[index]['id']);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ))
            ],
          ),
        ),
      ),
    );

  }
}
