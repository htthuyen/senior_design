

import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:givehub/webcomponents/donor_company_topbar.dart';
import 'package:givehub/webcomponents/usertopbar.dart';
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
        appBar: UserTopBar(),
        endDrawer: DonorComTopBar(),
      
      

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
                      donation['recipient'] != null
                      ? Text(
                        donation['recipient'].toString(),
                        style: GoogleFonts.kreon(
                          color: Color(0x555555).withOpacity(1),
                          fontSize: 17,
                        ),
                      )
                      : Text(
                        donation['recipientEmail'].toString(),
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
