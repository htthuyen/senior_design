


import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:givehub/webpages/np/grantstatus.dart';
import 'package:google_fonts/google_fonts.dart';

import '../authentication/auth.dart';
import '../webpages/company_donor/companyprofilepage.dart';
import '../webpages/company_donor/donorprofile.dart';
import '../webpages/notificationspage.dart';
import '../webpages/np/createevent.dart';
import '../webpages/np/eventnp.dart';
import '../webpages/np/grantapp.dart';
import '../webpages/np/myapps.dart';
import '../webpages/np/needs.dart';
import '../webpages/np/npdonationhistory.dart';
import '../webpages/np/npdonationreview.dart';
import '../webpages/np/npprofilepage.dart';
import '../webpages/subscription.dart';

class NpTopBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return  Drawer(
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
                          'My Profile',
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () async {
                          //final isValid = _formKey.currentState!.validate();
                               
                            String? userType = await getUserTypeFromDatabase(uid!) as String?;
                            if (userType == 'Nonprofit Organization') {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NPProfilePage()));
                            } else if (userType == 'Individual Donor') {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DonorProfilePage()));
                            } else if (userType == 'Company') {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CompanyProfilePage()));
                            }
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Update Needs',
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                         Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                              NeedsPage())
                            );
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: Text(
                      'Donation Center',
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
                          'Donation Requests',
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                           Navigator.push(context, new MaterialPageRoute(
                                                builder: (context) =>
                                                  NPDonationReview()
                           ), ); 
                        },
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
                            NPHistory())
                          );
                        },
                      ),
                    ],
                  ), 
                  ExpansionTile(
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
                          'Create Event',
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context, new MaterialPageRoute(
                                                builder: (context) =>
                                                  CreateEvent())
                                                );
                        },
                      ),
                      ListTile(
                        title: Text(
                          'My Events',
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                         Navigator.push(context, new MaterialPageRoute(
                                                builder: (context) =>
                                                  EventsNP())
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
                          'Apply for a Grant',
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
                      ListTile(
                        title: Text(
                          'My Applications',
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                           Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                            MyApps())
                          );
                        },
                      ),
                      ListTile(
                        title: Text(
                          'My Applications Status',
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                            GrantStatusPage())
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
      );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _database = FirebaseDatabase.instance.reference();
  String name = '';
  String aboutUs = '';
  String weAreSeeking = '';
  String member = '';
  String website = '';
  String email = '';
  bool isFavorite = false;
  late StreamSubscription _stream;


  // void _showEditProfileDialog(BuildContext context) {
  //   TextEditingController aboutUsController = TextEditingController(text: aboutUs);
  //   TextEditingController weAreSeekingController = TextEditingController(text: weAreSeeking);
  //   TextEditingController nameController = TextEditingController(text: name);
  //   TextEditingController memberSinceController = TextEditingController(text: member);
  //   TextEditingController websiteController = TextEditingController(text: website);
  //   TextEditingController emailController = TextEditingController(text: email);

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
        
  //       return Dialog(
  //         child: Container(
  //           width: 800, 
  //           height: 600,
  //           child: AlertDialog(

  //             iconColor: Color(0xAAD1DA).withOpacity(1),
  //             backgroundColor: Color(0xCAEBF2).withOpacity(1),
  //             title: Text(
  //               'Edit Profile',
  //               style: GoogleFonts.oswald(
  //                 color: Color(0x555555).withOpacity(1), 
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 30,
  //               ),
  //             ),
  //             content: SingleChildScrollView(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   TextFormField(
  //                     decoration: InputDecoration(labelText: 'Name', labelStyle: GoogleFonts.oswald(fontWeight: FontWeight.w100, color: Color(0x555555).withOpacity(1))),
  //                     style: GoogleFonts.oswald(
  //                       color: Color(0x555555).withOpacity(1), 
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 20,
  //                     ),
  //                     controller: nameController,
  //                   ),
  //                   const SizedBox(height: 20),
  //                   TextFormField(
  //                     decoration: InputDecoration(labelText: 'Email', labelStyle: GoogleFonts.oswald(fontWeight: FontWeight.w100, color: Color(0x555555).withOpacity(1))),
  //                     style: GoogleFonts.oswald(
  //                       color: Color(0x555555).withOpacity(1), 
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 20,
  //                     ),
  //                     controller: emailController,
  //                   ),
  //                   const SizedBox(height: 20),
  //                   TextFormField(
  //                     decoration: InputDecoration(labelText: 'About Us', labelStyle: GoogleFonts.oswald(fontWeight: FontWeight.w100,color: Color(0x555555).withOpacity(1))),
  //                     style: GoogleFonts.oswald(
  //                       color: Color(0x555555).withOpacity(1), 
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 20,
  //                     ),
  //                     controller: aboutUsController,
  //                   ),
                    
  //                   const SizedBox(height: 20),
  //                   TextFormField(
  //                     decoration: InputDecoration(labelText: 'Member Since', labelStyle: GoogleFonts.oswald(fontWeight: FontWeight.w100,color: Color(0x555555).withOpacity(1))),
  //                     style: GoogleFonts.oswald(
  //                       color: Color(0x555555).withOpacity(1), 
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 20,
  //                     ),
  //                     controller: memberSinceController,
  //                   ),
  //                   const SizedBox(height: 20),
  //                   TextFormField(
  //                     decoration: InputDecoration(labelText: 'Website', labelStyle: GoogleFonts.oswald(fontWeight: FontWeight.w100, color: Color(0x555555).withOpacity(1))),
  //                     style: GoogleFonts.oswald(
  //                       color: Color(0x555555).withOpacity(1), 
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 20,
  //                     ),
  //                     controller: websiteController,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             actions: <Widget>[
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: Text(
  //                   'Cancel',
  //                   style: GoogleFonts.oswald(
  //                       color: Color(0x555555).withOpacity(1), 
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 20,
  //                     ),
  //                 ),
  //               ),
  //               TextButton(
  //                 onPressed: () {
                    
  //                   _updateProfile(
  //                     newName: nameController.text,
  //                     newEmail: 'new@example.com',
  //                     //newPhone: '1234567890',
  //                     newAboutUs: aboutUsController.text,
  //                     //newWeAreSeeking: weAreSeekingController.text,
  //                     newMember: memberSinceController.text,
  //                     newWebsite: websiteController.text
  //                   );

  //                   Navigator.of(context).pop();
  //                 },
  //                 child: Text(
  //                   'Save',
  //                   style: GoogleFonts.oswald(
  //                       color: Color(0x555555).withOpacity(1), 
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 20,
  //                     ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

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

