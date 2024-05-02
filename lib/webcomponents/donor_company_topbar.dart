import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../authentication/auth.dart';
import '../webpages/company_donor/currentevents.dart';
import '../webpages/company_donor/donationofinterestspage.dart';
import '../webpages/company_donor/donorcompanydonationhistory.dart';
import '../webpages/company_donor/donorpaymentpage.dart';
import '../webpages/company_donor/eventhistory.dart';
import '../webpages/company_donor/eventsignuppage.dart';
import '../webpages/company_donor/grantcreationpage.dart';
import '../webpages/company_donor/myeventspage.dart';
import '../webpages/company_donor/nonmondon.dart';
import '../webpages/notificationspage.dart';
import '../webpages/np/grantapp.dart';
import '../webpages/subscription.dart';

class DonorComTopBar extends StatelessWidget implements PreferredSizeWidget {


  @override
  Widget build(BuildContext context) {
       return Drawer(
               child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5, 
        child: Container(
          color: const Color(0xFFFF3B3F), 
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF3B3F),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Menu',
                        style: GoogleFonts.oswald(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      Divider(
                        color: Color(0xFFF3B3F),
                        thickness: .5,
                      ),
                    ],
                  ),
                ),
                ExpansionTile(
                  title: Text(
                    'Account Information',
                    style: GoogleFonts.oswald(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  collapsedIconColor: Colors.white,
                  trailing: Icon(Icons.expand_more, color: Colors.white), 
                  children: [
                    ListTile(
                      title: Text(
                        'Edit Profile',
                        style: GoogleFonts.oswald(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      onTap: () {
                        _showEditProfileDialog(context);
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Update Interests',
                        style: GoogleFonts.oswald(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      onTap: () {
                       Navigator.push(context, new MaterialPageRoute(
                          builder: (context) =>
                            DonationOfInterestsPage())
                          );
                      },
                    ),
                  ],
                ),
                ListTile(
                  title: Text(
                    'Donation History',
                    style: GoogleFonts.oswald(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context, new MaterialPageRoute(
                    builder: (context) =>
                      DonationHistoryDonorCompany())
                    );
                  },
                ),
                ExpansionTile(
                  title: Text(
                    'Payment Center',
                    style: GoogleFonts.oswald(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  collapsedIconColor: Colors.white,
                  trailing: Icon(Icons.expand_more, color: Colors.white), 
                  children: [
                    ListTile(
                      title: Text(
                        'Make a Donation',
                        style: GoogleFonts.oswald(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context, new MaterialPageRoute(
                          builder: (context) =>
                          DonorPaymentPage())
                        );
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Make a Non-Monetary Donation',
                        style: GoogleFonts.oswald(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context, new MaterialPageRoute(
                          builder: (context) =>
                          NonMonDon())
                        );
                      },
                    ),
                  ],
                ),
                ExpansionTile(
                  //expandedIconColor: Colors.blue,
                  title: Text(
                    'Event Center',
                    style: GoogleFonts.oswald(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  collapsedIconColor: Colors.white,
                  trailing: Icon(Icons.expand_more, color: Colors.white), 
                  children: [
                    ListTile(
                      title: Text(
                        'Register for Event',
                        style: GoogleFonts.oswald(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context, new MaterialPageRoute(
                          builder: (context) =>
                          CurrentEventsPage())
                        );
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Your Events',
                        style: GoogleFonts.oswald(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context, new MaterialPageRoute(
                          builder: (context) =>
                          MyEventsPage())
                        );
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Event History',
                        style: GoogleFonts.oswald(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context, new MaterialPageRoute(
                          builder: (context) =>
                          EventHistory())
                        );
                      },
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    'Grant Center',
                    style: GoogleFonts.oswald(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  collapsedIconColor: Colors.white,
                  trailing: Icon(Icons.expand_more, color: Colors.white), 
                  children: [
                    ListTile(
                      title: Text(
                        'Create Grant',
                        style: GoogleFonts.oswald(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      onTap: () {
                         Navigator.push(context, new MaterialPageRoute(
                          builder: (context) =>
                          GrantCreationPage())
                        );
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Your Grants',
                        style: GoogleFonts.oswald(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context, new MaterialPageRoute(
                          builder: (context) =>
                          GrantApp())
                        );
                      },
                    ),
                  ],
                ),
                ListTile(
                  title: Text(
                    'Notifications',
                    style: GoogleFonts.oswald(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context, new MaterialPageRoute(
                          builder: (context) =>
                          NotificationsPage())
                        );
                  },
                ),
                ListTile(
                  title: Text(
                    'Subscriptions',
                    style: GoogleFonts.oswald(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context, new MaterialPageRoute(
                          builder: (context) =>
                          SubscriptionPage())
                     );
                  },
                ),
                ListTile(
                  title: Text(
                    'Logout',
                    style: GoogleFonts.oswald(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    _showLogoutDialog(context);
                  },
                ),
              ],
            ),
          ),
        ),
               ),
             );
      
  }
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

  final _database = FirebaseDatabase.instance.ref();
  String name = '';
  String email = '';
  String phone = '';
  String member = '';
  String companyInfo = '';
  bool isFavorite = false;


  
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

  void _showEditProfileDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController emailController = TextEditingController(text: email);
    TextEditingController phoneController = TextEditingController(text: phone);
    TextEditingController memberSinceController = TextEditingController(text: member);
    TextEditingController companyInfoController = TextEditingController(text: companyInfo);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 800, 
            height: 600,
            color: Color(0xCAEBF2).withOpacity(1),
            child: AlertDialog(
              backgroundColor: Color(0xCAEBF2).withOpacity(1),
              title: Text(
                'Edit Profile',
                style: GoogleFonts.oswald(
                  fontSize: 30,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(labelText: 'Phone'),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: memberSinceController,
                      decoration: InputDecoration(labelText: 'Member Since'),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: companyInfoController,
                      decoration: InputDecoration(labelText: 'Company Info'),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel', style: GoogleFonts.oswald(fontSize: 20, color: Colors.white)),
                ),
                TextButton(
                  onPressed: () {
                    _updateProfile(
                      newName: nameController.text,
                      newEmail: emailController.text,
                      newPhone: phoneController.text,
                      newMember: memberSinceController.text,
                      newCompanyInfo: companyInfoController.text,
                    );

                    Navigator.of(context).pop();
                  },
                  child: Text('Save', style: GoogleFonts.oswald(fontSize: 20, color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
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
                
                signOut().then((_) {
                  
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
    
