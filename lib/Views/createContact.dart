import 'package:contactbuddy/Helper/DatabaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateContact extends StatefulWidget {
  const CreateContact({super.key});

  @override
  State<CreateContact> createState() => _CreateContactState();

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
      home: const CreateContactPage(title: 'Add Contact'),
    );
  }

}

class CreateContactPage extends StatefulWidget {
  const CreateContactPage({super.key, required this.title});
  final String title;

  @override
  State<CreateContact> createState() => _CreateContactState();
}

class _CreateContactState extends State<CreateContact> {
  final _nameController = TextEditingController();
  final _telephoneNoController = TextEditingController();
  final _emailController = TextEditingController();

  List<Map<String, dynamic>> dataList = [];

  String? _validateMobileNumber(String value) {
    // Validate that the mobile number has exactly 10 digits
    if (value.length != 10) {
      return 'Mobile number must have be 10 digits';
    }
    return null; // Return null if validation passes
  }

  void _saveData() async {
    final name = _nameController.text;
    final telephoneNo = _telephoneNoController.text;
    final email = _emailController.text;

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

    int insertId = await DatabaseHelper.insertContact(name, telephoneNo, email);

    List<Map<String, dynamic>> updateData = await DatabaseHelper.getContact();
    setState(() {
      dataList = updateData;
    });
    _nameController.text = '';
    _telephoneNoController.text = '';
    _emailController.text = '';

    final snackBar = SnackBar(
      content: Text('Contact Saved Successfully!'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    Navigator.pop(context,true);
  }

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    _nameController.dispose();
    _telephoneNoController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  final db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Create Contact'),
        titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold, // Set the font weight to bold
            fontSize: 20
        ),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Column(
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
                    decoration:
                        const InputDecoration(hintText: 'Mobile Number'),
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(hintText: 'Email'),
                  ),
                  ElevatedButton(
                    onPressed: _saveData,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
