import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:givehub/webcomponents/donor_company_topbar.dart';
import 'package:givehub/webcomponents/usertopbar.dart';
import 'donorcompanydonationhistory.dart';
import 'mygrants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:givehub/webcomponents/profilepicture.dart';
import 'package:givehub/authentication/auth.dart';

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
   StreamSubscription?_stream;

  @override
  void initState(){
    super.initState();
    getUserInfo();
    getUser();
    
  }
  
  void getUserInfo() async{
     final String? currentUserUid = uid; 
     String? donor = await getUserTypeFromDatabase(currentUserUid!);

      if (donor?.toLowerCase() == 'individual donor') {
        _stream = _database.child('users').child(currentUserUid).onValue.listen((event) {
        final data = Map<String, dynamic>.from(event.snapshot.value as dynamic);
        final userEmail = data['email'] as String? ?? '';
        final userMembership = data['memberSince'] as String? ?? '';
        final userName = data['name'] as String? ?? '';
        final userPhone = data['phoneNumber'] as String? ?? '';
        //final userCompanyInfo = data['companyInfo'] as String? ?? '';

        //final userCompanyInfo = data['companyInfo'] as String;
        
        setState((){
          name = '$userName';
          email = '$userEmail';
          member = 'Member Since: ' + '$userMembership';
          phone = '$userPhone';
          companyInfo = 'Company Info: ';

        });
      });
    } else {
      print( 'Errors occured');
    }
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
    );
  }
    
  @override
  void deactivate(){
    _stream?.cancel();
    super.deactivate();
  }
}