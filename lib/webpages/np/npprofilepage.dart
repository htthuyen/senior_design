import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:givehub/webcomponents/np_topbar.dart';
import 'package:givehub/webcomponents/usertopbar.dart';
import 'package:givehub/webpages/np/grantstatus.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../authentication/auth.dart';
import '../../webcomponents/profilepicture.dart';
import 'npdonationhistory.dart';


class NPProfilePage extends StatefulWidget {
  @override
  _NPProfilePageState createState() => _NPProfilePageState();
}

class _NPProfilePageState extends State<NPProfilePage> {

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

  @override
  void initState() {
    super.initState();
    getUserInfo();
    getUser(); 
  }
  void getUserInfo() async {
    final String? currentUserUid = uid; 
    String? np = await getUserTypeFromDatabase(currentUserUid!);

    if (currentUserUid != null && np?.toLowerCase().trim() == 'nonprofit organization') {
      _stream = _database.child('users').child(currentUserUid).onValue.listen((event) {
        if (event.snapshot.value != null) {
          final data = Map<String, dynamic>.from(event.snapshot.value as dynamic);
          final userEmail = data['email'] as String? ?? '';
          final userNeeds = data['selectedNeeds'];
          final userAbout = data['aboutUs'];
          final userWebsite = data['website'];
          final memberSince = data['memberSince'] as String? ?? ''; // Provide a default value if null
          String userWeAreSeeking = '';

          // Convert the "needs" data to a string if it's a list or array
          if (userNeeds is List) {
            //userWeAreSeeking = userNeeds.join(', ');
            //String trimmedUserWeAreSeeking = userWeAreSeeking.replaceAll('{', '').replaceAll('}', '').replaceAll(': true', '').trim(); 
            userWeAreSeeking = userNeeds.join(', ');
          } else if (userNeeds != null) {
            
            //String trimmedUserWeAreSeeking = userWeAreSeeking.replaceAll('{', '').replaceAll('}', '').replaceAll(': true', '').trim(); 
            userWeAreSeeking = userNeeds.toString(); 
          }
          String trimmedUserWeAreSeeking = userWeAreSeeking.replaceAll('{', '').replaceAll('}', '').replaceAll(': true', '').trim(); 
          final userName = data['name'] as String? ?? '';
          
          setState(() {
            name = userName;
            email = userEmail;
            aboutUs = userAbout;
            weAreSeeking = 'We are currently seeking: ' + trimmedUserWeAreSeeking;
            member =  memberSince;
            website = userWebsite;
          });
        }
      });
    }
  }

  void _showEditProfileDialog(BuildContext context) {
    TextEditingController aboutUsController = TextEditingController(text: aboutUs);
    //TextEditingController weAreSeekingController = TextEditingController(text: weAreSeeking);
    TextEditingController nameController = TextEditingController(text: name);
    //TextEditingController memberSinceController = TextEditingController(text: member);
    TextEditingController websiteController = TextEditingController(text: website);
    TextEditingController emailController = TextEditingController(text: email);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        
        return Dialog(
          child: Container(
            width: 800, 
            height: 600,
            child: AlertDialog(

              iconColor: Color(0xAAD1DA).withOpacity(1),
              backgroundColor: Color(0xCAEBF2).withOpacity(1),
              title: Text(
                'Edit Profile',
                style: GoogleFonts.oswald(
                  color: Color(0x555555).withOpacity(1), 
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Name', labelStyle: GoogleFonts.oswald(fontWeight: FontWeight.w100, color: Color(0x555555).withOpacity(1))),
                      style: GoogleFonts.oswald(
                        color: Color(0x555555).withOpacity(1), 
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      controller: nameController,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Email', labelStyle: GoogleFonts.oswald(fontWeight: FontWeight.w100, color: Color(0x555555).withOpacity(1))),
                      style: GoogleFonts.oswald(
                        color: Color(0x555555).withOpacity(1), 
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      controller: emailController,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'About Us', labelStyle: GoogleFonts.oswald(fontWeight: FontWeight.w100,color: Color(0x555555).withOpacity(1))),
                      style: GoogleFonts.oswald(
                        color: Color(0x555555).withOpacity(1), 
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      controller: aboutUsController,
                    ),
                    
                    // const SizedBox(height: 20),
                    // TextFormField(
                    //   decoration: InputDecoration(labelText: 'Member Since', labelStyle: GoogleFonts.oswald(fontWeight: FontWeight.w100,color: Color(0x555555).withOpacity(1))),
                    //   style: GoogleFonts.oswald(
                    //     color: Color(0x555555).withOpacity(1), 
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 20,
                    //   ),
                    //   controller: memberSinceController,
                    // ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Website', labelStyle: GoogleFonts.oswald(fontWeight: FontWeight.w100, color: Color(0x555555).withOpacity(1))),
                      style: GoogleFonts.oswald(
                        color: Color(0x555555).withOpacity(1), 
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      controller: websiteController,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.oswald(
                        color: Color(0x555555).withOpacity(1), 
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _updateProfile(
                      newName: nameController.text,
                      newEmail: emailController.text,
                      //newPhone: '1234567890',
                      newAboutUs: aboutUsController.text,
                      //newWeAreSeeking: weAreSeekingController.text,
                      //newMember: memberSinceController.text,
                      newWebsite: websiteController.text
                    );

                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Save',
                    style: GoogleFonts.oswald(
                        color: Color(0x555555).withOpacity(1), 
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _updateProfile({
    required String newName,
      required String newEmail,
      //required String newPhone,
      required String newAboutUs,
      //required String newWeAreSeeking,
      //required String newMember,
      required String newWebsite,
    }) {
    String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserUid != null) {
      Map<String, dynamic> updateData = {
        'name': newName,
        'email': newEmail,
        //'phone': newPhone,
        'aboutUs': newAboutUs,
        //'selectedNeeds': newWeAreSeeking,
        //'memberSince': newMember,
        'website': newWebsite,
      };

      _database.child('users').child(currentUserUid).update(updateData)
        .then((_) {
          print('User information updated successfully.');
          setState(() {
            
            name = newName;
            email = newEmail;
            aboutUs = newAboutUs;
            website = newWebsite;
          
          });
        })
        .catchError((error) {
          print('Error updating user information: $error');
        });
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
      appBar: UserTopBar(),
      endDrawer: NpTopBar(),
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
                          style: GoogleFonts.oswald(fontSize: 30, fontWeight: FontWeight.bold, color:Color(0x555555).withOpacity(1))
                        ),
                        SizedBox(height: 30), 
                        Text(
                          email,
                          style: GoogleFonts.oswald(fontSize: 28, color:Color(0x555555).withOpacity(1))
                        ),
                        SizedBox(height: 30), 
                        Text(
                          aboutUs,
                          style: GoogleFonts.oswald(fontSize: 28, color:Color(0x555555).withOpacity(1))
                        ),
                        SizedBox(height: 30), 
                        Text(
                          weAreSeeking,
                          style: GoogleFonts.oswald(fontSize: 28, color:Color(0x555555).withOpacity(1))
                        ),
                        SizedBox(height: 30),
                        Text(
                          'Member Since: '+ member,
                          style: GoogleFonts.oswald(fontSize: 28, color:Color(0x555555).withOpacity(1))
                        ),
                        SizedBox(height: 30),
                        Text(
                          'Website: ' + website,
                          style: GoogleFonts.oswald(fontSize: 28, color:Color(0x555555).withOpacity(1))
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
                          onPressed: (){
                            _showEditProfileDialog(context);
                          }, 
                          icon: const Icon(Icons.edit),
                        ),
                        
                        SizedBox(width: 10),
                        IconButton(
                          icon: Icon(Icons.attach_money),
                          onPressed: () {
                           Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                            NPHistory())
                          );
                          },
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          icon: Icon(Icons.description_outlined),
                          onPressed: () {
                           Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                            GrantStatusPage())
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
