import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
  
  void getUserInfo(){
     final String? currentUserUid = uid; 
     if (currentUserUid != null) {
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
        member = 'Member Since: ' + '$userMembership';
        phone = '$userPhone';
        companyInfo = 'Company Info';

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

  void _showEditProfileDialog() {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
        title: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/welcome');
          },
          child: Text(
            'GiveHub',
            style: GoogleFonts.oswald(
              fontSize: 30,
            ),
          ),
        ),
        centerTitle: false,
        backgroundColor: const Color(0xFFFF3B3F),
        actions: [
          IconButton(
            onPressed: () {
              
            },
            icon: Icon(Icons.search, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              _scaffoldKey.currentState!.openEndDrawer();
            },
            icon: Icon(Icons.menu, color: Colors.white),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5, 
          child: Container(
            color: const Color(0xFFFF3B3F), 
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          _showEditProfileDialog();
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
                          Navigator.push(context, MaterialPageRoute(
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
                          'My Grants',
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                            MyGrants())
                          );
                        },
                      ),
                      ListTile(
                        title: Text(
                          'View Applications',
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                           Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                            NPSelectionPage())
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
                            SubscriptionPage()));
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
      ),
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
                          member,
                          style: GoogleFonts.oswald(fontSize: 28),
                        ),
                        SizedBox(height: 30), 
                        Text(
                          companyInfo,
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