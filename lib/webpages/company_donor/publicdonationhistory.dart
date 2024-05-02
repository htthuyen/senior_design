import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:givehub/webpages/np/grantstatus.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../authentication/auth.dart';
import '../notificationspage.dart';
import '../np/createevent.dart';
import '../np/eventnp.dart';
import '../np/grantapp.dart';
import '../np/needs.dart';
import '../np/npdonationreview.dart';
import '../np/npprofilepage.dart';
import 'companyprofilepage.dart';
import 'donationofinterestspage.dart';
import 'donorcompanydonationhistory.dart';
import 'donorpaymentpage.dart';
import 'donorprofile.dart';
import 'eventhistory.dart';
import 'eventsignuppage.dart';
import 'grantcreationpage.dart';
import 'myeventspage.dart';
import 'nonmondon.dart';


class PublicDonationHistory extends StatefulWidget {
  final String userId;

  PublicDonationHistory({required this.userId});

  @override
  State<PublicDonationHistory> createState() => _PublicDonationHistoryState();
}

class _PublicDonationHistoryState extends State<PublicDonationHistory> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<dynamic,dynamic>> donations = [];
  StreamSubscription? _stream;
  
  late String? _userID;

  
  @override
void initState() {
  super.initState();
  // Call a separate method to initialize donation data
  _userID = widget.userId;
  initializeData(_userID);
}
Future<void> initializeData(String? userId) async {
  // Fetch user type
  String? userType = await getUserTypeFromDatabase(userId!);
  // Read donation data
  readDonationData();
}

  void readDonationData(){ 
    if (widget.userId !=null){
      DatabaseReference ref = FirebaseDatabase.instance.ref('accepted_donations');
      ref.orderByChild('donorcomID').equalTo(widget.userId).onValue.listen((DatabaseEvent event) { 
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
  return FutureBuilder<String?>(
    future: getUserTypeFromDatabase(uid!),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
        String? userType = snapshot.data;
        
        Widget endDrawer;
        if (userType == 'Individual Donor' || userType == 'Company') {
          endDrawer = DonorEndDrawer();
        } else {
          endDrawer = NPEndDrawer();
        }
        
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: false,
          ),
          home: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: GestureDetector(
                onTap: () {},
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
              centerTitle: false,
              backgroundColor: const Color(0xFFFF3B3F),
              actions: [
                IconButton(
                  onPressed: () {},
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
            endDrawer: endDrawer,
            body: donations.isEmpty
                ? buildNoEventsWidget(context)
                : ListView(
                    children: <Widget>[
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
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 1440,
                        height: 779,
                        child: DataTable(
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(170, 209, 218, 1)),
                          dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                            return Color.fromRGBO(170, 209, 218, 1);
                          }),
                          headingRowColor:
                              MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                            return Color.fromRGBO(202, 235, 242, 0.90);
                          }),
                          showBottomBorder: true,
                          columns: [
                            DataColumn(
                              label: Text(
                                'Date',
                                style: GoogleFonts.oswald(
                                  color: Color.fromRGBO(169, 169, 169, 1),
                                  fontSize: 27,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Receiver',
                                style: GoogleFonts.oswald(
                                  color: Color.fromRGBO(169, 169, 169, 1),
                                  fontSize: 27,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Donation',
                                style: GoogleFonts.oswald(
                                  color: Color.fromRGBO(169, 169, 169, 1),
                                  fontSize: 27,
                                ),
                              ),
                            ),
                          ],
                          rows: donations.map((donation) {
                            return DataRow(cells: [
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
                        ),
                      ),
                    ],
                  ),
          ),
        );
      }
    },
  );
}

 Widget buildNoEventsWidget(BuildContext context) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You have no donation history.',
             style: GoogleFonts.oswald(fontSize: 40, color: Color(0x555555).withOpacity(1))
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xCAEBF2).withOpacity(1), 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0), 
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DonorPaymentPage()),
                );
              },
              child: Text(
                'Make A Donation',
                style: GoogleFonts.oswald(fontSize: 30, color: Colors.white),
              ),
            ),

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

class NPEndDrawer extends StatelessWidget {

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Logged Out Successfully',
            style: GoogleFonts.oswald(
              color: Color(0x555555).withOpacity(1), 
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Call the signOut method when the user confirms logging out
                signOut().then((_) {
                  // After signing out, navigate to the welcome page
                  Navigator.pushNamed(context, '/welcome');
                });
              },
              child: Text(
                'OK',
                style: GoogleFonts.oswald(
                  color: Color(0x555555).withOpacity(1), 
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleLogout(BuildContext context) {
    _showLogoutDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return  Drawer(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5, 
          child: Container(
            color: const Color(0xFFFF3B3F), 
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
                  ExpansionTile(
                    title: Text(
                      'Account Information',
                      style: GoogleFonts.oswald(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                     collapsedIconColor: Colors.white,
                    trailing: Icon(Icons.expand_more, color: Colors.white), 
                    children: [
                      // ListTile(
                      //   title: Text(
                      //     'Edit Profile',
                      //     style: GoogleFonts.oswald(
                      //       color: Colors.white,
                      //       fontSize: 18,
                      //     ),
                      //   ),
                      //   onTap: () async {
                      //     //final isValid = _formKey.currentState!.validate();
                               
                      //       String? userType = await getUserTypeFromDatabase(uid!);
                      //       print(userType);
                      //       if (userType == 'Nonprofit Organization') {
                      //         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NPProfilePage()));
                      //       } else if (userType == 'Individual Donor') {
                      //         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DonorProfilePage()));
                      //       } else if (userType == 'Company') {
                      //         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CompanyProfilePage()));
                      //       }
                      //   },
                      // ),
                      ListTile(
                        title: Text(
                          'My Profile',
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () async {
                          //final isValid = _formKey.currentState!.validate();
                               
                            String? userType = await getUserTypeFromDatabase(uid!) as String?;
                            if (userType == 'Nonprofit Organization') {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NPProfilePage()));
                            } else if (userType == 'Individual Donor') {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DonorProfilePage()));
                            } else if (userType == 'Company') {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CompanyProfilePage()));
                            }
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Update Needs',
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                         Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                              NeedsPage())
                            );
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: Text(
                      'Donation Center',
                      style: GoogleFonts.oswald(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                     collapsedIconColor: Colors.white,
                    trailing: Icon(Icons.expand_more, color: Colors.white), 
                    children: [
                      ListTile(
                        title: Text(
                          'Donation Requests',
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                           Navigator.push(context, new MaterialPageRoute(
                                                builder: (context) =>
                                                  NPDonationReview()
                           ), ); 
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
                          Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                            DonationHistoryDonorCompany())
                          );
                        },
                      ),
                    ],
                  ), 
                  ExpansionTile(
                    title: Text(
                      'Event Center',
                      style: GoogleFonts.oswald(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                     collapsedIconColor: Colors.white,
                    trailing: Icon(Icons.expand_more, color: Colors.white), 
                    children: [
                      ListTile(
                        title: Text(
                          'Create Event',
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context, new MaterialPageRoute(
                                                builder: (context) =>
                                                  CreateEvent())
                                                );
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Your Events',
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                         Navigator.push(context, new MaterialPageRoute(
                                                builder: (context) =>
                                                  EventsNP())
                                                );
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Edit Event',
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                         Navigator.push(context, new MaterialPageRoute(
                                                builder: (context) =>
                                                  EventsNP())
                                                );
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: Text(
                      'Grant Center',
                      style: GoogleFonts.oswald(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    collapsedIconColor: Colors.white,
                    trailing: Icon(Icons.expand_more, color: Colors.white), 
                    children: [
                      ListTile(
                        title: Text(
                          'Apply for a Grant',
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                           Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                            GrantApp())
                          );
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Application Status',
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                            GrantStatusPage())
                          );
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
                     Navigator.pushNamed(context, '/notifications');
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
                      _showLogoutDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}

class DonorEndDrawer extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  


  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Logged Out Successfully',
            style: GoogleFonts.oswald(
              color: Color(0x555555).withOpacity(1), 
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Call the signOut method when the user confirms logging out
                signOut().then((_) {
                  // After signing out, navigate to the welcome page
                  Navigator.pushNamed(context, '/welcome');
                });
              },
              child: Text(
                'OK',
                style: GoogleFonts.oswald(
                  color: Color(0x555555).withOpacity(1), 
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleLogout(BuildContext context) {
    _showLogoutDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Theme( 
        data: Theme.of(context).copyWith(
        iconTheme: IconThemeData(color: Colors.white), 
      ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5, 
          child: Container(
            color: const Color(0xFFFF3B3F),
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
                  ExpansionTile(
                    title: Text(
                      'Account Information',
                      style: GoogleFonts.oswald(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    collapsedIconColor: Colors.white,
                    trailing: Icon(Icons.expand_more, color: Colors.white), 
                    children: [
                      // ListTile(
                      //   title: Text(
                      //     'Edit Profile',
                      //     style: GoogleFonts.oswald(
                      //       color: Colors.white,
                      //       fontSize: 18,
                      //     ),
                      //   ),
                      //   onTap: () {
                      //     final isValid = _formKey.currentState!.validate();
                               
                      //       String? userType = getUserTypeFromDatabase(uid!) as String?;
                      //       if (userType == 'Nonprofit Organization') {
                      //         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NPProfilePage()));
                      //       } else if (userType == 'Individual Donor') {
                      //         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DonorProfilePage()));
                      //       } else if (userType == 'Company') {
                      //         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CompanyProfilePage()));
                      //       }
                      //   },
                      // ),
                      ListTile(
                        title: Text(
                          'My Profile',
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () async {
                          //final isValid = _formKey.currentState!.validate();
                               
                            String? userType = await getUserTypeFromDatabase(uid!) as String?;
                            if (userType == 'Nonprofit Organization') {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NPProfilePage()));
                            } else if (userType == 'Individual Donor') {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DonorProfilePage()));
                            } else if (userType == 'Company') {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CompanyProfilePage()));
                            }
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Update Interests',
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                         Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                              DonationOfInterestsPage())
                            );
                        },
                      ),
                    ],
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
                      Navigator.push(context, new MaterialPageRoute(
                      builder: (context) =>
                        DonationHistoryDonorCompany())
                      );
                    },
                  ),
                  ExpansionTile(
                    title: Text(
                      'Payment Center',
                      style: GoogleFonts.oswald(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    collapsedIconColor: Colors.white,
                    trailing: Icon(Icons.expand_more, color: Colors.white), 
                    children: [
                      ListTile(
                        title: Text(
                          'Make a Donation',
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                            DonorPaymentPage())
                          );
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Make a Non-Monetary Donation',
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                            NonMonDon())
                          );
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    //expandedIconColor: Colors.blue,
                    title: Text(
                      'Event Center',
                      style: GoogleFonts.oswald(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    collapsedIconColor: Colors.white,
                    trailing: Icon(Icons.expand_more, color: Colors.white), 
                    children: [
                      ListTile(
                        title: Text(
                          'Register for Event',
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                            EventSignUpPage())
                          );
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Your Events',
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                            MyEventsPage())
                          );
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
                          Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                            EventHistory())
                          );
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: Text(
                      'Grant Center',
                      style: GoogleFonts.oswald(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    collapsedIconColor: Colors.white,
                    trailing: Icon(Icons.expand_more, color: Colors.white), 
                    children: [
                      ListTile(
                        title: Text(
                          'Create Grant',
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                           Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                            GrantCreationPage())
                          );
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Your Grants',
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                            GrantApp())
                          );
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
                      Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                            NotificationsPage())
                          );
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
                      /* Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                            new SubscriptionsPage())
                       );*/
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
                      _showLogoutDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      );
  }
  
}