import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Helper/DatabaseHelper.dart';

class UpdateContact extends StatefulWidget {
  const UpdateContact({Key? key,required this.contactId}):super(key: key);
  final int contactId;

  @override
  State<UpdateContact> createState() => _UpdateContatctState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add Contact',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyUpdatePage(title: 'Add Contact'),
    );
  }}

class MyUpdatePage extends StatefulWidget {
  const MyUpdatePage({super.key, required this.title});


  final String title;

  @override
  State<UpdateContact> createState() => _UpdateContatctState();
}

class _UpdateContatctState extends State<UpdateContact> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _telephoneNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void fetchData() async {
    Map<String, dynamic>? data = await DatabaseHelper.getFirstOrderDefault(widget.contactId);
    if(data !=null){
      _nameController.text = data['Name'];
      _telephoneNoController.text = data['TelephoneNo'];
      _emailController.text = data['Email'];
    }
  }
@override
  void initState() {
    fetchData();
      super.initState();
  }

  String? _validateMobileNumber(String value) {
    // Validate that the mobile number has exactly 10 digits
    if (value.length != 10) {
      return 'Mobile number must have be 10 digits';
    }
    return null; // Return null if validation passes
  }

  void _updateContact(BuildContext context) async{
    Map<String, dynamic> data={
      'Name':_nameController.text,
      'TelephoneNo':_telephoneNoController.text,
      'Email':_emailController.text,
    };

    String? mobileNumberValidation = _validateMobileNumber(_telephoneNoController.text);
    if (mobileNumberValidation != null) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mobileNumberValidation),
          duration: Duration(seconds: 2),
        ),
      );
      return;

    }
    int id = await DatabaseHelper.updateContact(widget.contactId,data);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contact Updated Successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.pop(context,true);
  }

@override
  void dispose() {
    _nameController.dispose();
    _telephoneNoController.dispose();
    _emailController.dispose();
      super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Update Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Name'),
            ),
            TextFormField(
              controller: _telephoneNoController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              decoration: const InputDecoration(hintText: 'Mobile No'),
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(hintText: 'Email'),
            ),
            ElevatedButton(onPressed: () {
_updateContact(context);
            },
                child: const Text('Update Contact')
            )
          ],
        ),
      ),
    );
    return const Placeholder();
  }
}
