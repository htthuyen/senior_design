import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:givehub/webcomponents/usertopbar.dart';
import 'donationofinterestspage.dart';
import 'donorcompanydonationhistory.dart';
import 'donorpaymentpage.dart';
import 'eventhistory.dart';
import 'eventsignuppage.dart';
import 'grantcreationpage.dart';
import 'myeventspage.dart';
import 'mygrants.dart';
import 'nonmondon.dart';
import '../notificationspage.dart';
import 'publicdonationhistory.dart';
import '../subscription.dart';
import 'package:google_fonts/google_fonts.dart';
import '../allgrants.dart';
import 'package:givehub/webcomponents/profilepicture.dart';
import 'package:givehub/authentication/auth.dart';

class DonorProfileSearchPage extends StatefulWidget {
  final String userId;

  DonorProfileSearchPage({required this.userId});
  @override
  _DonorProfileSearchPageState createState() => _DonorProfileSearchPageState();
}

class _DonorProfileSearchPageState extends State<DonorProfileSearchPage> {

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
    getUserInfo(widget.userId);
    getUser();
  }
  
  void getUserInfo(String userId){
     //final String? currentUserUid = uid; 
      if (userId != null) {
        _stream = _database.child('users').child(userId).onValue.listen((event) {
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
    }
    else {
      print("error with user retriving");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: UserTopBar(),
      endDrawer: DonorEndDrawer(),
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
                          icon: Icon(Icons.attach_money),
                          onPressed: () {
                           Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                            PublicDonationHistory(userId: widget.userId))
                          );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.insert_drive_file_outlined),
                          onPressed: () {
                           Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                            AllGrantsPage(userId: widget.userId))
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