import 'package:flutter/material.dart';
import '../../authentication/auth.dart';
import 'dart:async';
import '../../webcomponents/usertopbar.dart';

import 'package:givehub/webcomponents/np_topbar.dart';
import 'grantsub.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Grant {
  String grantKey;
  String grantName;
  String donorName;
  String email;
  String phone;
  int grantAmount;
  String furtherRequirements;
  String eligibility;
  String paymentDetails;
  String grantDeadline;

  Grant({required this.email, required this.phone, required this.grantKey, required this.paymentDetails, required this.furtherRequirements, required this.grantName, required this.donorName, required this.grantAmount, required this.eligibility, required this.grantDeadline});
  final df = DateFormat('MM-dd-yyyy hh:mm a');

  String getGrantName() {
    return grantName;
  }

  String getKey() {
    return grantKey;
  }

  String getDonorName() {
    return donorName;
  }

  String getEmail() {
    return email;
  }

  String getPhone() {
    return phone;
  }

  String getAmount() {
    return grantAmount.toString();
  }

  String getFurther() {
    return furtherRequirements;
  }

  String getEligibility() {
    return eligibility;
  }
  String getPayment() {
    return paymentDetails;
  }

  String getDeadline() {
    return grantDeadline;
  }
  
  Map<String, dynamic> toJson() {
    return {
       'grantName': grantName, 
       'donorName':donorName,
       'grantAmount': grantAmount, 
       'furtherRequirements': furtherRequirements,
       'eligibility': eligibility,
       'paymentDetails': paymentDetails,
       'grantDeadline': grantDeadline
    };
  }
}

class GrantApp extends StatefulWidget {
  @override
  _GrantAppState createState() => _GrantAppState();
}

class _GrantAppState extends State<GrantApp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Grant> grants = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getGrantsFromDatabase();
  }

  Future<void> getGrantsFromDatabase() async {
    try {
      List<Map<dynamic, dynamic>>? dbGrants = await fetchGrantsFromDatabase();

      if (dbGrants != null) {
        setState(() {
          grants = dbGrants.map((grantData) => Grant(
            grantKey: grantData['grantKey'],
            donorName: grantData['donorName'],
            email: grantData['donorEmail'],
            phone: grantData['donorPhone'],
            eligibility: grantData['eligibility'],
            furtherRequirements: grantData['furtherRequirements'],
            grantAmount: grantData['grantAmount'],
            grantDeadline: grantData['grantDeadline'],
            grantName: grantData['grantName'],
            paymentDetails: grantData['paymentDetails'],
          )).toList();
        });
      } else {
        print('No grants found.');
      }
    } catch (e) {
      print('Error fetching grants: $e');
      showSnackBar(context, 'Error fetching grants. Please try again later.');
    }
  }
  Future<List<Map<String, dynamic>>?> fetchGrantsFromDatabase() async {
    final ref = FirebaseDatabase.instance.reference();

    try {
      var snapshot = await ref.child('grants').once();

      if (snapshot.snapshot.value != null) {
        Map<dynamic, dynamic>? data = snapshot.snapshot.value as Map<dynamic, dynamic>;

        if (data != null) {
          List<Map<String, dynamic>> grantsList = [];
          data.forEach((key, data) {
            if (data != null) {
              String grantKey = key ?? ' ';  
              String grantName = data['grantName'] ?? '';
              String donorName = data['donorName'] ?? '';
              String donorEmail = data['donorEmail'] ?? '';
              String donorPhone = data['donorPhone'] ?? '';
              int grantAmount = int.tryParse(data['grantAmount'] ?? '') ?? 0;
              String furtherRequirements = data['furtherRequirements'] ?? '';
              String eligibility = data['eligibility'] ?? '';
              String paymentDetails = data['paymentDetails'] ?? '';
              String grantDeadline = data['grantDeadline'] ?? '';

              Map<String, dynamic> grantData = {
                'grantKey': grantKey,
                'grantName': grantName,
                'donorName': donorName,
                'donorEmail': donorEmail,
                'donorPhone': donorPhone,
                'grantAmount': grantAmount,
                'furtherRequirements': furtherRequirements,
                'eligibility': eligibility,
                'paymentDetails': paymentDetails,
                'grantDeadline': grantDeadline,
              };
              grantsList.add(grantData);
            }
          });
          return grantsList;
        }
      }
    } catch (e) {
      print('Error retrieving grants: $e');
    }
    return null;
  }

  List<Grant> searchResults = [];
  void onQueryChanged(String query) {
    search = true;
    setState(() {
      searchResults = grants.where((item) => item.grantName.toLowerCase().contains(query.toLowerCase())).toList();  
    });
  }
  bool search = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: UserTopBar(),
              endDrawer: NpTopBar(),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Center(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(left: 50, bottom: 30, top: 40),
                            child: Text(
                              'Grants',
                              style: GoogleFonts.oswald(
                                color: const Color(0x555555).withOpacity(1),
                                fontSize: 32,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            alignment: Alignment.topRight,
                            padding: EdgeInsets.only(left: 20, right : 20, bottom: 30, top: 60),
                            child: TextField(
                              onChanged: (value) {onQueryChanged(value);},
                              controller: searchController,
                              style: GoogleFonts.kreon(
                                color: const Color(0x555555).withOpacity(1),
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                filled: true,
                                fillColor: const Color(0xD9D9D9).withOpacity(1),
                                hintText: 'Search...',
                                hintStyle: GoogleFonts.kreon(
                                  color: const Color(0x555555).withOpacity(1),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w300,
                                ),
                                contentPadding: EdgeInsets.only(left: 12, bottom: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(color: Color(0xAAD1DA).withOpacity(1), width: 2),
                                  ),
                                ),
                            )
                          ),
                        ),
              
                        const SizedBox(width: 100),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(width: 50),
                        Expanded(
                          child: GridView.builder (
                            itemCount: search ? searchResults.length : grants.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 225, crossAxisSpacing: 20, mainAxisSpacing: 20, mainAxisExtent: 275),
                            itemBuilder: (context, index) {
                              return search ? makeBox(grant: searchResults[index]): makeBox(grant: grants[index]);
                            },
                          ),
                        ),
                        const SizedBox(width: 50),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]
        )
    );
  }
}

class makeBox extends StatelessWidget {
final Grant grant;

makeBox({required this.grant});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 250,
          height: 55,
          child: DecoratedBox(
          decoration: BoxDecoration(color:Color(0xAAD1DA).withOpacity(1),),
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    grant.grantName,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.kreon(
                      color: const Color(0x555555).withOpacity(1),
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    grant.donorName,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.kreon(
                      color: const Color(0x555555).withOpacity(1),
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ),
        SizedBox(width: 250, height: 210,
        child: DecoratedBox(
          decoration: BoxDecoration(color:Color(0xCAEBF2).withOpacity(1),),
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Amount: ',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.kreon(
                      color: const Color(0x555555).withOpacity(1),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  // get amount
                  Text(
                    '\$' + grant.grantAmount.toString(),
                    textAlign: TextAlign.left,
                    style: GoogleFonts.kreon(
                      color: const Color(0x555555).withOpacity(1),
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Eligibility: ',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.kreon(
                      color: const Color(0x555555).withOpacity(1),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                    ),
                    // get eligibility
                    Text(
                    grant.eligibility,
                    softWrap: true,
                                       
                    textAlign: TextAlign.left,
                    style: GoogleFonts.kreon(
                      color: const Color(0x555555).withOpacity(1),
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                                          ),
                  const SizedBox(height: 10),
                  Text(
                    'Deadline: ',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.kreon(
                      color: const Color(0x555555).withOpacity(1),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                    ),
                    // get eligibility
                    Text(
                    //df.format(deadline),
                    grant.grantDeadline,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.kreon(
                      color: const Color(0x555555).withOpacity(1),
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                    const SizedBox(height: 10),
                      Row (
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => GrantSub(),
                              settings: RouteSettings(arguments: grant,),),);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF3B3F).withOpacity(1),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: SizedBox(height: 35, width: 75, 
                              child: Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  'Apply',  
                                  textAlign: TextAlign.center, 
                                  style: GoogleFonts.kreon(
                                    color: const Color(0x555555).withOpacity(1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ), 
                        ],
                      ),
                    ],
                  ),
            ),
              ),
            ),
          ),
      ],
    );
  }
}
