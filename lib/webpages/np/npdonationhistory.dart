import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:givehub/webcomponents/np_topbar.dart';
import 'package:givehub/webcomponents/usertopbar.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../authentication/auth.dart';



class NPHistory extends StatefulWidget {
  const NPHistory({super.key});


  @override
  State<NPHistory> createState() => _NPHistoryState();
}

class _NPHistoryState extends State<NPHistory> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<dynamic,dynamic>> donations = [];
  StreamSubscription? _stream;


  @override
  void initState(){
    super.initState();
    getUser();
    readDonationData();
  }

  Future<void> readDonationData() async { 
    if (uid!=null){
      DatabaseReference ref = FirebaseDatabase.instance.ref('accepted_donations');
      final String? userName = await getUserNameFromDatabase(uid!);
      ref.orderByChild('recipient').equalTo(userName).onValue.listen((DatabaseEvent event) { 
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      List<Map<dynamic, dynamic>> donationList = [];
      data.forEach((key, value) {
         if(value['donationType'] == null) { 
            donationList.add({
              //'pendingDonationID': data.keys.first,
              'date': value['date'],
              'sender': value['sender'],
              //'recipient': value['recipient'],
              //'recipientEmail': value['recipientEmail']
              //if('donation')
              //'donationType': value['donationType'],
              'amount': value['amount']
            });
          }
          if(value['amount'] == null){
              donationList.add({
                //'pendingDonationID': data.keys.first,
                'date': value['date'],
                'sender': value['sender'],
                //'recipient': value['recipient'],
                //'recipientEmail': value['recipientEmail']
                //if('donation')
                'donationType': value['donationType'],
                //'amount': value['amount']
              });
          }
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
      endDrawer: NpTopBar(),
      
      

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
                          'Donor',
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
                      Text(donation['sender'].toString())
                      //: Text(donation['recipientEmail'].toString()),

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