import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class LocalitySearch extends StatefulWidget {
  @override
  _LocalitySearchState createState() => _LocalitySearchState();
}

class _LocalitySearchState extends State<LocalitySearch> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  GlobalKey<AutoCompleteTextFieldState<String>> _searchKey = GlobalKey();
  List<String> _localities = [];
  String? _selectedLocality;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    fetchLocalities();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> fetchLocalities() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('localitiesCollection')
        .get();

    final localities = snapshot.docs.map((doc) => doc['name'].toString()).toList();

    setState(() {
      _localities = localities;
    });
  }

  Future<void> saveData() async {
    final name = _nameController.text;
    final address = _addressController.text;
    final locality = _selectedLocality;

    final User? user = FirebaseAuth.instance.currentUser;
    final String userId = user!.uid;

    // Check if the locality is available
    if (_localities.contains(locality)) {
      // Save the data to Firestore under the user's ID
      await FirebaseFirestore.instance.collection('userCollection').doc(userId).set({
        'name': name,
        'address': address,
        'locality': locality,
      });
    }
    // Clear the input fields
    _nameController.clear();
    _addressController.clear();
    _selectedLocality = null;

    Navigator.pushReplacementNamed(context, '/');
  }

  Future<void> notifyUnavailableLocality() async {
    final name = _nameController.text;
    final address = _addressController.text;
    final locality = _selectedLocality;

    final User? user = FirebaseAuth.instance.currentUser;
    final String userId = user!.uid;

    await FirebaseFirestore.instance.collection('waitingListCollection').doc(userId).set({
      'name': name,
      'address': address,
      'locality': locality,
    });
    // Clear the input fields
    _nameController.clear();
    _addressController.clear();
    _selectedLocality = null;
    ScaffoldMessenger(child: Text("We will get back to you soon"));
  }

  @override
  Widget build(BuildContext context) {
    final bool isLocalityAvailable = _localities.contains(_selectedLocality);
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Address',
              ),
            ),
            SizedBox(height: 10),
            SimpleAutoCompleteTextField(
              key: _searchKey,
              controller: _selectedLocality != null ? TextEditingController(text: _selectedLocality) : TextEditingController(),
              suggestions: _localities,
              textChanged: (value) {
                setState(() {
                  _selectedLocality = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Search Locality',
              ),
            ),
            SizedBox(height: 16),
            if (!isLocalityAvailable)
              ElevatedButton(
                onPressed: notifyUnavailableLocality,
                child: Text('Notify the Team'),
              ),
            if (isLocalityAvailable)
              ElevatedButton(
                onPressed: saveData,
                child: Text('Save and Proceed'),
              ),
          ],
        ),
      ),
    );
  }
}
