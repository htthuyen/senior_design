
import 'package:flutter/material.dart';
import 'package:givehub/webpages/np/grantstatus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:givehub/authentication/auth.dart';
import 'companyprofilepage.dart';
import '../np/createevent.dart';
import 'donorcompanydonationhistory.dart';
import 'donorprofile.dart';
import '../np/eventnp.dart';
import '../np/grantapp.dart';
import 'myeventspage.dart';
import '../np/needs.dart';
import '../np/npdonationreview.dart';
import '../np/npprofilepage.dart';

class EventHistory extends StatefulWidget {
  const EventHistory({super.key});


  @override
  State<EventHistory> createState() => _EventHistoryState();
}

class _EventHistoryState extends State<EventHistory> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<EventforUser> events = [];

  @override
  void initState() {
    super.initState();
    
    getUser().then((_) {
      if (uid != null) {
        fetchUserEvents(uid!); 
      } else {
        
        showSnackBar(context, 'User ID not found. Please log in again.');
        Navigator.pushReplacementNamed(context, '/login'); 
      }
    });
  }


  Future<void> fetchUserEvents(String userId) async {
    try {
      List<EventforUser>? userEvents = await getUserEventsFromDatabase(userId);

      if (userEvents != null) {
        setState(() {
          events = userEvents;
        });
        print('Events fetched successfully: $events');
      } else {
        print('No events found for the user.');
      }
    } catch (e) {
      print('Error fetching user events: $e');
      showSnackBar(context, 'Error fetching user events. Please try again later.');
    }
  }

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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'GiveHub',
          style: GoogleFonts.oswald(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        centerTitle: false,
        backgroundColor: const Color(0xFFFF3B3F),
        actions: [
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
                      ListTile(
                        title: Text(
                          'Edit Profile',
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () async {
                          //final isValid = _formKey.currentState!.validate();
                               
                            String? userType = await getUserTypeFromDatabase(uid!);
                            print(userType);
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
                                                  MyEventsPage())
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
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            width: 389,
            height: 131,
            child: Text(
              'Event History',
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
                color: Color.fromRGBO(170, 209, 218, 1),
              ),
              dataRowColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                return Color.fromRGBO(170, 209, 218, 1);
              }),
              headingRowColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                return Color.fromRGBO(202, 235, 242, 0.90);
              }),
              showBottomBorder: true,
              columns: [
                DataColumn(
                  label: Text(
                    'Date',
                    style: GoogleFonts.kreon(
                      color: Color.fromRGBO(169, 169, 169, 1),
                      fontSize: 27,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Organization',
                    style: GoogleFonts.kreon(
                      color: Color.fromRGBO(169, 169, 169, 1),
                      fontSize: 27,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Event',
                    style: GoogleFonts.kreon(
                      color: Color.fromRGBO(169, 169, 169, 1),
                      fontSize: 27,
                    ),
                  ),
                ),
              ],
              rows: events.isNotEmpty
                  ? events.map((event) {
                      return DataRow(cells: [
                        DataCell(Text(event.date)),
                        DataCell(Text(event.orgName)),
                        DataCell(Text(event.eventName)),
                      ]);
                    }).toList()
                  : [
                      DataRow(cells: [
                        DataCell(Text('No events found')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                      ]),
                    ], // Show a row with 'No events found' if the list is empty
            ),
          ),
        ],
      ),
    );
  }
}