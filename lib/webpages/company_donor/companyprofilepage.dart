import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:givehub/webcomponents/donor_company_topbar.dart';
import 'package:givehub/webcomponents/usertopbar.dart';
import 'package:givehub/webpages/company_donor/currentevents.dart';
import 'package:givehub/webpages/company_donor/mygrants.dart';
import 'package:google_fonts/google_fonts.dart';
import '../subscription.dart';
import 'donationofinterestspage.dart';
import 'donorcompanydonationhistory.dart';
import 'donorpaymentpage.dart';
import 'eventhistory.dart';
import 'grantcreationpage.dart';
import 'myeventspage.dart';
import 'nonmondon.dart';
import '../notificationspage.dart';
import 'package:givehub/webcomponents/profilepicture.dart';
import 'package:givehub/authentication/auth.dart';
import 'npselectionpage.dart';

class CompanyProfilePage extends StatefulWidget {
  @override
  _CompanyProfilePageState createState() => _CompanyProfilePageState();
}

class _CompanyProfilePageState extends State<CompanyProfilePage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _database = FirebaseDatabase.instance.reference();
  String name = '';
  String email = '';
  String phone = '';
  String member = '';
  String companyInfo = '';
  bool isFavorite = false;
  late StreamSubscription _stream;

  @override
  void initState(){
    super.initState();
    getUserInfo();
    getUser(); 
  }
  
  void getUserInfo() async{
     final String? currentUserUid = uid; 
          String? com = await getUserTypeFromDatabase(currentUserUid!);

     if (currentUserUid != null && com?.trim().toLowerCase() == 'company') {
        _stream = _database.child('users').child(currentUserUid).onValue.listen((event) {
        final data = Map<String, dynamic>.from(event.snapshot.value as dynamic);
        final userEmail = data['email'] as String? ?? '';
        final userMembership = data['memberSince'] as String? ?? '';
        final userName = data['name'] as String? ?? '';
        final userPhone = data['phoneNumber'] as String? ?? '';
       
      // Pushing data to database
      setState((){
        name = '$userName';
        email = '$userEmail';
        member = '$userMembership';
        phone = '$userPhone';
        companyInfo = '';

      });
    });
    }
  }
  // Update information in database
  void _updateProfile({
      required String newName,
      required String newEmail,
      required String newPhone,
      required String newMember,
      required String newCompanyInfo,
    }) {
    String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    // Update to new information
    if (currentUserUid != null) {
      Map<String, dynamic> updateData = {
        'name': newName,
        'email': newEmail,
        'phone': newPhone,
        'memberSince': newMember,
        'companyInfo': newCompanyInfo,
      };

      _database.child('users').child(currentUserUid).update(updateData)
        .then((_) {
          print('User information updated successfully.');
        })
        .catchError((error) {
          print('Error updating user information: $error');
        });
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: UserTopBar(),
      endDrawer: DonorComTopBar() ,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              const Row(
                children: [
                  Expanded(
                    child: Center(
                      child: ProfilePicture(
                        name: 'Profile',
                        radius: 100,
                        fontSize: 21,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    width: 600,
                    decoration: BoxDecoration(
                      color: const Color(0xCAEBF2).withOpacity(1),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.oswald(fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 30), 
                        Text(
                          phone,
                          style: GoogleFonts.oswald(fontSize: 28),
                        ),
                        SizedBox(height: 30), 
                        Text(
                          email,
                          style: GoogleFonts.oswald(fontSize: 28),
                        ),
                        SizedBox(height: 30),
                        Text(
                          'Member Since: ' + member,
                          style: GoogleFonts.oswald(fontSize: 28),
                        ),
                        SizedBox(height: 30), 
                        Text(
                          'Company Info: ' + companyInfo,
                          style: GoogleFonts.oswald(fontSize: 28),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : null,
                          ),
                          onPressed: () {
                            setState(() {
                              isFavorite = !isFavorite;
                            });
                          },
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          icon: Icon(Icons.attach_money),
                          onPressed: () {
                           Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                            DonationHistoryDonorCompany())
                          );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.insert_drive_file_outlined),
                          onPressed: () {
                           Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                            MyGrants())
                          );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void deactivate(){
    _stream.cancel();
    super.deactivate();
  }
}
