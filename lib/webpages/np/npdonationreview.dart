


import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:givehub/webcomponents/np_topbar.dart';
import 'package:givehub/webcomponents/usertopbar.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../authentication/auth.dart';

class NPDonationReview extends StatefulWidget {
  const NPDonationReview({super.key});


  @override
  State<NPDonationReview> createState() => _NPDonationReview();
}

class _NPDonationReview extends State<NPDonationReview> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<dynamic,dynamic>> donations = [];
  StreamSubscription? _stream;


  @override
  void initState(){
    super.initState();
    getUser();
    readDonationData();
  }

  void readDonationData(){ 
    String recipientEmail='';
    String recipient='';
    if (uid!=null){
      //get current user's email
      DatabaseReference currentEmailRef = FirebaseDatabase.instance.ref('users/$uid');
      currentEmailRef.onValue.listen((event) { 
        final data = event.snapshot.value as Map<dynamic, dynamic>;

        recipientEmail = data['email'].toString();
        recipient = data['name'].toString();
       
    
      // get pending_donation 
      DatabaseReference pendingDonationRef = FirebaseDatabase.instance.ref('pending_donations');
      pendingDonationRef.orderByChild('recipientEmail').equalTo(recipientEmail.trim()).onValue.listen((DatabaseEvent event) { 
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      List<Map<dynamic, dynamic>> donationList = [];
      data.forEach((key, value) {
        donationList.add({
          'pendingDonationID': data.keys.first,
          'date': value['date'],
          'sender': value['sender'],
          'recipient': recipient,
          'recipientEmail': value['recipientEmail'],
          'senderEmail': value['senderEmail'],
          'amount': value['amount'],
          'donationType': value['donationType'],
          'messageToRecipient': value['messageToRecipient'], //message from sender
          'donorcomID': value['donorcomID']

        });
      });

      setState(() {
        donations = donationList;
      });
    });
     });
    }
  }

 //  when Accept button is pressed
  void acceptedDonation(Map<dynamic,dynamic> donation, /*String recipient*/){

            // Generate a unique ID for the accepted donation
    String donationId = DateTime.now().millisecondsSinceEpoch.toString();
    String decision = "accepted";
    if (uid!=null) {
      setState(() {
        donations.remove(donation);
        
      });

   
      // save the accepted donation  to the accpeted_donation database of non-profit
      DatabaseReference ref = FirebaseDatabase.instance.ref('accepted_donations').push();
      //createNotification(userId: uid!, orgName: recipient, decision: 'accepted');
      ref.set(donation);

      // //remove the donation from the pending_donation
      // DatabaseReference ref1 = FirebaseDatabase.instance.ref('pending_donations');
      // createNotification(userId: uid!, orgName: recipient, decision: 'rejected');
      // ref1.child(donation['pendingDonationID']).remove();

    }
  }
  // when Cancel button is press
  void unacceptedDonation(Map<dynamic, dynamic> donation, /*String recipient*/){
    
    if (uid != null){
      setState(() {
        donations.remove(donation);
       ;
      });
      //remove the donation from the pending_donation
      DatabaseReference ref1 = FirebaseDatabase.instance.ref('pending_donations');
      ref1.child(donation['pendingDonationID']).remove();

    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
      ),
      home: Scaffold(
      key: _scaffoldKey,
      appBar: UserTopBar(),
      endDrawer: NpTopBar(),
        body: 
          ListView(
            children: <Widget> [
              SizedBox(
                width: 389,
                height: 131,
                child: Text(
                  'Donation Review',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.oswald(
                    color: Color.fromRGBO(85, 85, 85, 1),
                    fontSize: 45,
                    fontWeight: FontWeight.w400, 
                  )    
              ),                    
              ),

              SizedBox(
                width: 1440,
                height: 779, 
                child: DataTable(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(170, 209, 218, 1)
                  ),
                  dataRowColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                    return Color.fromRGBO(170, 209, 218, 1);  
                  }),
                  headingRowColor:
                    MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states){
                      return Color.fromRGBO(202, 235, 242, 0.90);
                    } ),
                  showBottomBorder: true,
                  columns: [
                    DataColumn(
                      label: 
                        Text(
                          'Date',
                          style: GoogleFonts.kreon(
                            color: Color.fromRGBO(169, 169, 169, 1),
                            fontSize: 27,
                          ),
                        ),
                    ),
                    DataColumn(
                      label: 
                        Text(
                          'Sender',
                          style: GoogleFonts.kreon(
                            color: Color.fromRGBO(169, 169, 169, 1),
                            fontSize: 27,
                          ),
                        ),
                    ),
                    DataColumn(
                      label: 
                        Text(
                          'Email',
                          style: GoogleFonts.kreon(
                            color: Color.fromRGBO(169, 169, 169, 1),
                            fontSize: 27,
                          ),
                        ),
                    ),
                    DataColumn(
                      label: 
                        Text(
                          'Contribution',
                          style: GoogleFonts.kreon(
                            color: Color.fromRGBO(169, 169, 169, 1),
                            fontSize: 27,
                          ),
                        ),
                    ),

                    DataColumn(label: Text('')),

                                  
                ],

                rows:  
                donations.map((donation){
                  return DataRow(cells:[
                    DataCell(
                      Text(
                        donation['date'].toString(),
                        style: GoogleFonts.kreon(
                          color: Color(0x555555).withOpacity(1),
                          fontSize: 17,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        donation['sender'].toString(),
                        style: GoogleFonts.kreon(
                          color: Color(0x555555).withOpacity(1),
                          fontSize: 17,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        donation['senderEmail'].toString(),
                        style: GoogleFonts.kreon(
                          color: Color(0x555555).withOpacity(1),
                          fontSize: 17,
                        ),
                      ),
                    ),
                    DataCell(
                      donation['amount'] != null
                       ? Text(
                          donation['amount'].toString(),
                          style: GoogleFonts.kreon(
                            color: Color(0x555555).withOpacity(1),
                            fontSize: 17,
                          ),
                        ) 
                       : Text(
                          donation['donationType'].toString(),
                          style: GoogleFonts.kreon(
                            color: Color(0x555555).withOpacity(1),
                            fontSize: 17,
                          ),
                        ),
                    ),
                    DataCell(
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              acceptedDonation(donation);
                            },
                          style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFD9D9D9),
                          shadowColor: Color(0x3F000000),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          minimumSize: Size(50, 50), 
                          ),
                           child: Text(
                              'Accept',
                              style: GoogleFonts.oswald(
                                fontSize: 20,
                                color: Colors.green[700]
                              ),
                            )
                          ),
                          ElevatedButton(
                            onPressed: () {
                              unacceptedDonation(donation);
                            },
                          style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFD9D9D9),
                          shadowColor: Color(0x3F000000),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                              minimumSize: Size(50, 50), 
                          ),                           
                            child: Text(
                              'Decline',
                              style: GoogleFonts.oswald(
                                fontSize: 20,
                                color: Colors.red
                              ),
                            )
                          )
                        ],
                      )
                    ),
                  ]
                  );
                }).toList(),
              )
            )
          ],
        )
      ),
    ); 
  }

    @override
  void deactivate(){
    _stream?.cancel();
    super.deactivate();
  }
}
