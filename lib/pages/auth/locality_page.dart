import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocalitySearchPage extends StatefulWidget {
  @override
  _LocalitySearchPageState createState() => _LocalitySearchPageState();
}

class _LocalitySearchPageState extends State<LocalitySearchPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _flatNoController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  String _selectedLocality = '';
  List<String> _localities = ["Vision Starwest Phase 1", "Vision Starwest Phase 2", "Anand Phase 1"];

  GlobalKey<AutoCompleteTextFieldState<String>> localityKey =
  GlobalKey<AutoCompleteTextFieldState<String>>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _phoneNumberController = TextEditingController();
    //fetchLocalities();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  // Future<void> fetchLocalities() async {
  //   final QuerySnapshot snapshot = await FirebaseFirestore.instance
  //       .collection('localitiesCollection')
  //       .get();
  //
  //   final localities = snapshot.docs
  //       .map((doc) => doc.get('name').toString())
  //       .toList();
  //
  //   setState(() {
  //     _localities = localities;
  //   });
  //
  // }


  // this func will contain code to save the data to Waiting List
  // and on recieving this data we can reach out to that location
  // and get the Locality onboard
  void informTeam(){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('This Functionality will be available soon'),
        backgroundColor: Colors.red,
      ),
    );
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> saveData() async {
    final name = _nameController.text;
    final address = _addressController.text;
    final phone = _phoneNumberController.text;
    final locality = _selectedLocality;

    final User? user = FirebaseAuth.instance.currentUser;
    final String userId = user!.uid;

    // Check if the locality is available
    if (_localities.contains(locality) && userId != Null) {
      // Save the data to Firestore under the user's ID
      await FirebaseFirestore.instance.collection('userCollection').doc(userId).set({
        'name': name,
        'address': address,
        'locality': locality,
        'phoneNumber': phone,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No such Locality found'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pushReplacementNamed(context, '/login');
    }

    _nameController.clear();
    _addressController.clear();
    _phoneNumberController.clear();
    setState(() {
      _selectedLocality = '';
      _localities = [];
    });

    // Navigate to the desired screen
    Navigator.pushReplacementNamed(context, '/');
  }

  // Future<void> notifyUnavailableLocality() async {
  //   final name = _nameController.text;
  //   final address = _addressController.text;
  //   final phone = _phoneNumberController.text;
  //   final locality = _selectedLocality;
  //
  //   final User? user = FirebaseAuth.instance.currentUser;
  //   final String userId = user!.uid;
  //
  //   if (_localities.contains(locality)) {
  //     await FirebaseFirestore.instance.collection('waitingListCollection').doc(userId).set({
  //       'name': name,
  //       'address': address,
  //       'locality': locality,
  //       'phoneNumber': phone,
  //     });
  //   }
  //
  //   _nameController.clear();
  //   _addressController.clear();
  //   _phoneNumberController.clear();
  //   setState(() {
  //     _selectedLocality = '';
  //     _localities = [];
  //   });
  //
  //   // Show a success message
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('We will get back to you soon')),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    print(_localities);
    print("\n\n\n"+ _selectedLocality);
    return Scaffold(
      appBar: AppBar(
        title: Text('Locality Search'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 10.0),
            Container(
              child: AutoCompleteTextField<String>(
                  key: localityKey,
                  decoration: InputDecoration(
                    labelText: 'Search Locality',
                  ),
                  controller: TextEditingController(text: _selectedLocality),
                  suggestions: _localities,
                  itemBuilder: (context, suggestion) => ListTile(
                    title: Text(suggestion),
                  ),
                  itemFilter: (suggestion, input) =>
                      suggestion.toLowerCase().contains(input.toLowerCase()),
                  itemSorter: (a, b) => a.compareTo(b),
                  itemSubmitted: (suggestion) {
                    setState(() {
                      _selectedLocality = suggestion;
                    });
                  },
                  clearOnSubmit: false,
                ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: saveData,
              child: Text('Save and Proceed'),
            ),
            TextButton(
              onPressed: informTeam,
              child: Text('Notify Team to reach out your Location'),
            ),
          ],
        ),
      ),
    );
  }
}
