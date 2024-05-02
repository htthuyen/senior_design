

import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:givehub/authentication/auth.dart';


class DonationHistoryDonorCompany extends StatefulWidget {
  const DonationHistoryDonorCompany({super.key});


  @override
  State<DonationHistoryDonorCompany> createState() => _DonationHistoryDonorCompanyState();
}

class _DonationHistoryDonorCompanyState extends State<DonationHistoryDonorCompany> {
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
    if (uid!=null){
      DatabaseReference ref = FirebaseDatabase.instance.ref('accepted_donations');
      ref.orderByChild('donorcomID').equalTo(uid).onValue.listen((DatabaseEvent event) { 
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      List<Map<dynamic, dynamic>> donationList = [];
      data.forEach((key, value) {
        donationList.add({
          'pendingDonationID': data.keys.first,
          'date': value['date'],
          'recipient': value['recipient'],
           'recipientEmail': value['recipientEmail'],

          'amount': value['amount'],
          'donationType': value['donationType']
        });
      });

      setState(() {
        donations = donationList;
      });


      });
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
      appBar: AppBar(
        title: Container(
          child: GestureDetector(
            onTap: () {
              
            },
            child: Row(
              children: [
                Text(
                  'GiveHub',
                  style: GoogleFonts.oswald(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ],
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
          width: MediaQuery.of(context).size.width * 0.5, // Set the desired width (50% of screen width in this example)
          child: Container(
            color: const Color(0xFFFF3B3F), // Set the color here
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
                  ListTile(
                    title: Text(
                      'Edit Account',
                      style: GoogleFonts.oswald(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    onTap: () {
                      
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
                      
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Upcoming Events',
                      style: GoogleFonts.oswald(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    onTap: () {
                      
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
                      
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Payment Center',
                      style: GoogleFonts.oswald(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    onTap: () {
                      
                    },
                  ),
                  ExpansionTile(
                    title: Text(
                      'Grant Center',
                      style: GoogleFonts.oswald(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    children: [
                      ListTile(
                        title: Text(
                          'Apply',
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                          
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Check Your Status',
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                         
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
                      
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      
      

      body: 
          ListView(
            children: <Widget> [
              SizedBox(
                width: 389,
                height: 131,
                child: Text(
                  'Donation History',
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
                          style: GoogleFonts.oswald(
                            color: Color.fromRGBO(169, 169, 169, 1),
                            fontSize: 27,
                          ),
                        ),
                    ),
                    DataColumn(
                      label: 
                        Text(
                          'Receiver',
                          style: GoogleFonts.oswald(
                            color: Color.fromRGBO(169, 169, 169, 1),
                            fontSize: 27,
                          ),
                        ),
                    ),
                    DataColumn(
                      label: 
                        Text(
                          'Donation',
                          style: GoogleFonts.oswald(
                            color: Color.fromRGBO(169, 169, 169, 1),
                            fontSize: 27,
                          ),
                        ),
                    ),
                ],

                rows:  donations.map((donation){
                  return DataRow(cells:[
                    DataCell(Text(donation['date'].toString())),
                    DataCell(
                      donation['recipient'] != null
                      ? Text(donation['recipient'].toString())
                      : Text(donation['recipientEmail'].toString()),

                    ),
                    DataCell(
                      donation['amount'] != null
                      ? Text(donation['amount'].toString())
                      : Text(donation['donationType'].toString())
                      ),
                  ]);
                }).toList(),
              )
              ),
           


            ],
          ),


      )
    );
  }

    @override
  void deactivate(){
    _stream?.cancel();
    super.deactivate();
  }
}
