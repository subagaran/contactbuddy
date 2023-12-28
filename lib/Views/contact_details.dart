
import 'package:flutter/material.dart';

class ContactDetails extends StatefulWidget {
  const ContactDetails({Key? key,required this.contactId, required this.contactDetails}):super(key: key);
  final int contactId;
  final Map<String, dynamic> contactDetails;
  @override
  State<ContactDetails> createState() => _ContactDetailState();
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Update Contact',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const ContactDetailPage(title: 'Update Contact', index: 'id',),
    );
  }
}

class ContactDetailPage extends StatefulWidget {
  const ContactDetailPage({super.key, required this.title, required this.index});
  final String title;
  final String index;

  @override
  State<ContactDetails> createState() => _ContactDetailState();
}

class _ContactDetailState extends State<ContactDetails> {
  List<Map<String, dynamic>> dataList = [];
  late Map<String, dynamic> contactDetails;

  @override
  void initState() {
    contactDetails = widget.contactDetails;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Contact Details'),
        titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold, // Set the font weight to bold
            fontSize:20
        ),
        foregroundColor: Colors.white,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Centered user icon
          Center(
            child: CircleAvatar(
              radius: 50,
              // You can use an actual user image or an icon here
              child: Icon(Icons.person, size: 50),
            ),
          ),
          SizedBox(height: 20),
          // Details displayed in text boxes
          _buildCenteredDetailTextField('Name', contactDetails['Name']),
          _buildCenteredDetailTextField('Telephone No', contactDetails['TelephoneNo']),
          _buildCenteredDetailTextField('Email', contactDetails['Email']),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  // ...

  Widget _buildCenteredDetailTextField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(8),
            width: 300, // Set the desired width
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.withOpacity(0.2),
            ),
            child: Text(
              value,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}