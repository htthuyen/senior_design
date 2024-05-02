import 'package:flutter/material.dart';
import 'package:givehub/webcomponents/np_topbar.dart';
import 'package:givehub/webcomponents/usertopbar.dart';
import 'package:givehub/webpages/np/grantstatus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../authentication/auth.dart';
import '../company_donor/companyprofilepage.dart';
import '../company_donor/donorcompanydonationhistory.dart';
import '../company_donor/donorprofile.dart';
import 'createevent.dart';
import 'eventnp.dart';
import 'grantapp.dart';
import 'npdonationreview.dart';
import 'npprofilepage.dart';

class NeedsPage extends StatefulWidget {
  const NeedsPage({Key? key}) : super(key: key);

  @override
  _NeedsPageState createState() => _NeedsPageState();
}

class _NeedsPageState extends State<NeedsPage> {
  late Set<String> selectedNeeds = {};
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void toggleSelection(String need) {
    setState(() {
      if (selectedNeeds.contains(need)) {
        selectedNeeds.remove(need);
      } else {
        selectedNeeds.add(need);
      }
    });
  }

  void _handleContinue() async {
    final DatabaseReference _userRef = await _initializeUserRef();
    _userRef.child('selectedNeeds').set(selectedNeeds.map((need) => {need: true}).toList());
    Navigator.pushNamed(context, '/npprofile');
  }

  Future<DatabaseReference> _initializeUserRef() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    if (_auth.currentUser != null) {
      return FirebaseDatabase.instance.reference().child('users').child(_auth.currentUser!.uid);
    } else {
      throw Exception('User is not authenticated');
    }
  }
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Logged Out Successfully',
            style: GoogleFonts.oswald(
              color: Color(0x555555).withOpacity(1), 
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Call the signOut method when the user confirms logging out
                signOut().then((_) {
                  // After signing out, navigate to the welcome page
                  Navigator.pushNamed(context, '/welcome');
                });
              },
              child: Text(
                'OK',
                style: GoogleFonts.oswald(
                  color: Color(0x555555).withOpacity(1), 
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleLogout(BuildContext context) {
    _showLogoutDialog(context);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: UserTopBar(),
        endDrawer: NpTopBar(),
      body: Column(
        children: [
          Expanded(
            flex: 0,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: Text(
                'Please Select What Your Current Needs Are',
                style: GoogleFonts.oswald(
                  color: const Color(0x555555).withOpacity(1),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: const Color(0x00caebf2).withOpacity(1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                 Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Buttons for needs
                      _buildNeedButton(Icons.car_rental, 'Vehicles', 'vehicles'),
                      _buildNeedButton(Icons.chair, 'Furniture', 'furniture'),
                      _buildNeedButton(Icons.volunteer_activism, 'Volunteer', 'volunteer'),
                      _buildNeedButton(Icons.paid, 'Monetary', 'monetary'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNeedButton(Icons.checkroom, 'Clothing', 'clothing'),
                      _buildNeedButton(Icons.food_bank, 'Non-Perishables', 'non-perishables'),
                      _buildNeedButton(Icons.local_hospital, 'Medical', 'medical'),
                      _buildNeedButton(Icons.sentiment_satisfied_alt, 'Other', 'other'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Continue button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xAAD1DA).withOpacity(1),
            ),
            onPressed: _handleContinue,
            child: Text(
              'Continue',
              style: GoogleFonts.oswald(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Color(0x555555).withOpacity(1),
              ),
            ),
          ),
        ],
      ),
     ),  );
  }

  Widget _buildNeedButton(IconData icon, String label, String need) {
    final isSelected = selectedNeeds.contains(need);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: GoogleFonts.oswald(
            color: const Color(0x555555).withOpacity(1),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          height: 140,
          width: 170,
          child: ElevatedButton(
            onPressed: () {
              toggleSelection(need);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected ? Color(0xAAD1DA).withOpacity(1) : Colors.white.withOpacity(1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Color(0xAAD1DA).withOpacity(1),
              size: 55,
            ),
          ),
        ),
      ],
    );
  }
}