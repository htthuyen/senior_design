import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:givehub/authentication/auth.dart';
import 'package:givehub/webcomponents/np_topbar.dart';

import '../../webcomponents/usertopbar.dart';

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
  void acceptedDonation(Map<dynamic,dynamic> donation, String recipient, String sender){

            // Generate a unique ID for the accepted donation
    String donationId = DateTime.now().millisecondsSinceEpoch.toString();
    //String decision = "accepted";
    if (uid!=null) {
      setState(() async {
        String decision = "accepted";
        donations.remove(donation);
        final String? sendId = await getUserID(sender);
        createNotificationS(userId: uid!, orgName: sender, decision: decision);
        createNotification(userId: sendId!, orgName: recipient, decision: decision);
      });

   
      // save the accepted donation  to the accpeted_donation database of non-profit
      DatabaseReference ref = FirebaseDatabase.instance.ref('accepted_donations').push();
      
      ref.set(donation);

      //remove the donation from the pending_donation
      DatabaseReference ref1 = FirebaseDatabase.instance.ref('pending_donations');
      ref1.child(donation['pendingDonationID']).remove();

    }
  }
  // when Cancel button is press
  void unacceptedDonation(Map<dynamic, dynamic> donation, String recipient, String sender){
    String decision = "rejected";
    if (uid != null){
      setState(() async {
        donations.remove(donation);
        final String? sendId = await getUserID(sender);
        createNotificationS(userId: uid!, orgName: sender, decision: decision);
        createNotification(userId: sendId!, orgName: recipient, decision: decision);
      });
      //remove the donation from the pending_donation
      DatabaseReference ref1 = FirebaseDatabase.instance.ref('pending_donations');
      ref1.child(donation['pendingDonationID']).remove();

    }
  }
void createNotification({
  required String userId, // Assuming you have the userId
  // required String type,
  // required String detail,
  required String orgName,
  required String decision
}) {
  try {
    final notificationsRef = FirebaseDatabase.instance.reference().child('notifications');
    
    final notificationData = {
      'type': 'donation $decision',
      'detail': '$orgName has $decision your donation',
      'orgName': orgName,
      'userId': userId,
    };

    notificationsRef.push().set(notificationData).then((_) {
      print('Notification created successfully.');
    }).catchError((error) {
      print('Error creating notification: $error');
    });
  } catch (e) {
    print('Error creating notification: $e');
  }
}
void createNotificationS({
  required String userId, // Assuming you have the userId
  // required String type,
  // required String detail,
  
  required String orgName,
  required String decision
}) {
  try {
    final notificationsRef = FirebaseDatabase.instance.reference().child('notifications');
    
    final notificationData = {
      'type': 'donation $decision',
      'detail': 'You have $decision the donation from $orgName',
      
      'userId': userId,
    };

    notificationsRef.push().set(notificationData).then((_) {
      print('Notification created successfully.');
    }).catchError((error) {
      print('Error creating notification: $error');
    });
  } catch (e) {
    print('Error creating notification: $e');
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
                    DataCell(Text(donation['date'].toString())),
                    DataCell(Text(donation['sender'].toString())),
                    DataCell(Text(donation['senderEmail'].toString())),
                    DataCell(
                      donation['amount'] != null
                       ? Text(donation['amount'].toString()) 
                       :Text(donation['donationType'].toString())
                      
                    ),
                    DataCell(
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              acceptedDonation(donation, donation['recipient'], donation['sender']);
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
                              unacceptedDonation(donation, donation['recipient'], donation['sender']);
                              unacceptedDonation(donation, donation['recipient'], donation['sender']);
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
