// ignore_for_file: unused_import

import 'dart:collection';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class GrantStatusPage extends StatefulWidget {
  const GrantStatusPage({super.key});

  @override
  _GrantStatusPage createState() => _GrantStatusPage();
}

class Grant {
  String contact;
  String grantName;
  String amount;
  String? status;
  String id;

  Grant({required this.id, required this.grantName, required this.contact, required this.amount, /*required*/ this.status});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'grantName': grantName,
      'amount': amount,
      'status': status,
      'contact': contact,
    };
  }
}

class _GrantStatusPage extends State<GrantStatusPage> {
  List<Grant> _grants = [];
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    getGrantsFromDatabase("jAhl9S8Yi0gWsNcAXoSpnwvN2AD2");
    // getUser().then((_) {
    //   if (uid != null) {
    //     getGrantsFromDatabase(uid!); 
    //     //getUsersFromDatabase(uid!);
    //   } else {
    //     showSnackBar(context, 'User ID not found. Please log in again.');
    //     Navigator.pushReplacementNamed(context, '/login'); 
    //   }
    // });
  }
  Future<void> getGrantsFromDatabase(String userID) async {
    try {
      List<Map<dynamic, dynamic>>? users = await fetchGrantsFromDatabase(userID);
      //print(users);

      if (users != null) {
        setState(() {
          _grants = users.map((userData) => Grant(
            id: userData['id'],
            grantName: userData['grantName'],
            amount: userData['amount'],
            status: userData['status'],
            contact: userData['contact']
          )).toList();
        });
      } else {
        print('could not find users.');
      }
    } catch (e) {
      print('Error fetching users: $e');
      //showSnackBar(context, 'Error fetching users. Please try again later.');
    }
  }
  Future<List<Map<String, dynamic>>?> fetchGrantsFromDatabase(String user) async {
    final ref = FirebaseDatabase.instance.reference();

    try {
      var snapshot = await ref.child('grants').once();

      if (snapshot.snapshot.value != null) {
        Map<dynamic, dynamic>? data = snapshot.snapshot.value as Map<dynamic, dynamic>;

        if (data != null) {
          List<Map<String, dynamic>> allUsersList = [];
          data.forEach((key, userData) {
            
            //print('Data for user with key $key: $data');
            // Ensure that userData is not null
            if (userData != null && userData['applicants'] != null) {
              LinkedHashMap<Object?, Object?> applicants = userData['applicants'] as LinkedHashMap<Object?, Object?>;
              Map<String?, dynamic> mappedApplicants = applicants.cast<String?, dynamic>();
              if(mappedApplicants.containsKey(user)){
                Map<String, dynamic> allUserData = {
                  'id': key,
                  'grantName': userData['grantName'],
                  'amount': userData['grantAmount'],
                  'status': mappedApplicants[user]?['status'],
                  'contact': userData['donorEmail'],
                };
              allUsersList.add(allUserData);
              }
            }
          });
          //print(userId);
          return allUsersList;
        }
      }
    } catch (e) {
      print('Error retrieving all users: $e');
    }

    return null; 
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //the upgrade of flutter caused a shadow
      theme: ThemeData(
        useMaterial3: false,
      ),
      home: Scaffold(
        //the top portion of the webpage
        appBar: AppBar(
          backgroundColor: const Color(0xFFFF3B3F),
          elevation: 0,
          actions: [
            //padding can be used to help add space or move items
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  // Handle search button press here
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextButton(
                //control the flow of buttons when pressed
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text(
                  'About Us',
                  //change change the font, size, color, and bold/thinness
                  style: GoogleFonts.oswald(
                    color: Colors.white,
                    fontSize: 16,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/sign_up_page');
                },
                child: Text(
                  'Sign Up',
                  style: GoogleFonts.oswald(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text(
                  'Login',
                  style: GoogleFonts.oswald(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
          title: Align(
            alignment: Alignment.topLeft,
            child: TextButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text(
                'GiveHub',
                style: GoogleFonts.oswald(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 176,
                    child: Text(
                      'Grant/Donor Name',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.oswald(
                        color: const Color.fromRGBO(85, 85, 85, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                      )
                    ),
                  ),
                SizedBox(
                    width: 94,
                    child: Text(
                    'Amount',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.oswald(
                      color: const Color.fromRGBO(85, 85, 85, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    )
                  ),
                ),
                SizedBox(
                    width: 80,
                    child: Text(
                    'Status',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.oswald(
                      color: const Color.fromRGBO(85, 85, 85, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    )
                  ),
                ),
                SizedBox(
                    width: 130,
                    child: Text(
                    'Email Inquiry',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.oswald(
                      color: const Color.fromRGBO(85, 85, 85, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    )
                  ),
                ),
              ]),
              Expanded(
                child: ListView.builder(
                  itemCount: _grants.length,
                  itemBuilder: (context, index) => SizedBox(
                    height: 90,
                    child: Card(
                        key: ValueKey(_grants[index].id),
                        color: const Color.fromRGBO(202, 235, 242, 1),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                height: 90,
                                width: 158,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    _grants[index].grantName,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.oswald(
                                        color:
                                            const Color.fromRGBO(85, 85, 85, 1),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                      )),
                                ),
                              ),
                              SizedBox(
                                height: 90,
                                width: 110,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "\$ ${_grants[index].amount}",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.oswald(
                                        color:
                                            const Color.fromRGBO(85, 85, 85, .75),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      )),
                                ),
                              ),
                              SizedBox(
                                height: 90,
                                width: 100,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color.fromRGBO(217, 217, 217, 1),
                                      
                                      border:  Border.all(
                                        color: const Color.fromRGBO(217, 217, 217, 1),
                                      ),
                                    ),
                                   child: Text(
                                      (_grants[index].status == null) ? 'Pending' : _grants[index].status.toString(),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.oswald(
                                        color: (_grants[index].status.toString() == "Rejected") ? const Color.fromRGBO(255, 59, 63, 1) 
                                             : (_grants[index].status.toString() == "Accepted") ? const Color.fromRGBO(37, 182, 78, 1)
                                             : const Color.fromRGBO(85, 85, 85, 1),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      )),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: 90,
                                  width: 112,
                                  child: TextButton(
                                    child: Text(
                                      'Contact >>',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.oswald(
                                        color:
                                            const Color.fromRGBO(85, 85, 85, 1),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    onPressed: () {
                                      final Uri emailLaunchUri = Uri(
                                        scheme: 'mailto',
                                        path: _grants[index].contact,
                                        query: 'subject=Inquiry about ${_grants[index].grantName}',
                                      );

                                      launchUrl(emailLaunchUri);
                                    },
                                  )),
                            ])),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}