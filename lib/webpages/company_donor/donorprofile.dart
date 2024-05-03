import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:givehub/authentication/auth.dart';
import 'package:givehub/webcomponents/donor_company_topbar.dart';
import 'package:givehub/webcomponents/profilepicture.dart';
import 'package:givehub/webcomponents/usertopbar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'donorcompanydonationhistory.dart';
import 'mygrants.dart';

class DonorProfilePage extends StatefulWidget {
  @override
  _DonorProfilePageState createState() => _DonorProfilePageState();
}

class _DonorProfilePageState extends State<DonorProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey1= GlobalKey<ScaffoldState>();

  final _database = FirebaseDatabase.instance.reference();
  String name = '';
  String email = '';
  String phone = '';
  String member = '';
  String companyInfo = '';
  bool isFavorite = false;
   StreamSubscription? _stream;

  @override
  void initState(){
    super.initState();
    getUserInfo();
    getUser();
    
  }
  
  void getUserInfo() async {
  final String? currentUserUid = uid; 
  String? np = await getUserTypeFromDatabase(currentUserUid!);

  if (currentUserUid != null && np?.toLowerCase().trim() == 'individual donor') {
    _stream = _database.child('users').child(currentUserUid).onValue.listen((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value as dynamic);
      final userEmail = data['email'] ?? '';
      final userMembership = data['memberSince' ?? ''];
      final userName = data['name'] ?? '';
      final userPhone = data['phoneNumber'] ?? '';
      final userCompanyInfo = data['companyInfo'] ?? '';

      // Pushing data to database
      setState(() {
        name = userName;
        email = userEmail;
        member = userMembership;
        phone = userPhone;
        companyInfo = userCompanyInfo;
      });
    });
  }
}


  void _updateProfile({
      required String newName,
      required String newEmail,
      required String newPhone,
      
      required String newCompanyInfo,
    }) {
    String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    // Update to new information
    if (currentUserUid != null) {
      Map<String, dynamic> updateData = {
        'name': newName,
        'email': newEmail,
        'phone': newPhone,
        
        'companyInfo': newCompanyInfo,
      };

      _database.child('users').child(currentUserUid).update(updateData)
        .then((_) {
          print('User information updated successfully.');
          setState(() {
            
            name = newName;
            email = newEmail;
            phone = newPhone;
            companyInfo = newCompanyInfo;
          
          });
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
            width: 600, 
            height: 400,
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
                      controller: companyInfoController,
                      decoration: InputDecoration(labelText: 'Company Info (or Additional Info About You)'),
                      //key: ,
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
                      //newMember: memberSinceController.text,
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UserTopBar(),
      endDrawer: DonorComTopBar(),
      body: b(context),
    );
    
    
}

  Widget b(BuildContext context) {
    return 
    SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
                width: 800, 
                height: 600,
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
                      'Memeber since: $member',
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
    );
  }



  @override
  void deactivate(){
    
    super.deactivate();
  }
}
