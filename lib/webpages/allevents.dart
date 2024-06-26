import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../authentication/auth.dart';
import '../webcomponents/np_topbar.dart';
import '../webcomponents/usertopbar.dart';
import 'company_donor/eventsignuppage.dart';
import 'np/eventnp.dart';


class EventforUserS {
  String eventName;
  String orgName;
  String date;
  String time;
  String location;
  String contact;
  String description;
  
  EventforUserS({required this.eventName, required this.orgName, required this.date, required this.time, required this.location, required this.contact, required this.description});
}
class AllEventsPage extends StatefulWidget {
  final String userId;

  AllEventsPage({required this.userId});

  @override
  _AllEventsPageState createState() => _AllEventsPageState();
}

class _AllEventsPageState extends State<AllEventsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<EventforNP> events = []; // Initialize with an empty list of events
  bool isFavorite = false;
  final _formKey = GlobalKey<FormState>();
  

 Future<void> fetchEvents(String userId) async {
    String? userType = await getUserTypeFromDatabase(userId);

    if (userType != null) {
      List<EventforNP>? fetchedEvents = await getEventsFromDatabase(userId);

      if (fetchedEvents != null) {
        setState(() {
          events = fetchedEvents;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No events found.'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('User type not found.'),
      ));
    }
  }
  
  @override
  void initState() {
    super.initState();
    // Fetch events when the widget is initialized
    getUser().then((_) {
      if (uid != null) {
        fetchEvents(widget.userId); // Pass the actual user ID obtained from authentication
      } else {
        // Handle the case where user ID is not available
        // For example, show a snackbar or navigate to login screen
        showSnackBar(context, 'User ID not found. Please log in again.');
        Navigator.pushReplacementNamed(context, '/login'); // Navigate to login screen
      }
    });
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                              'EVENTS',
                              style: GoogleFonts.oswald(
                                color: const Color(0x555555).withOpacity(1),
                                fontSize: 32,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  Container(
                        color: const Color(0xD9D9D9).withOpacity(1),
                        padding: EdgeInsets.all(20),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //const SizedBox(width: 50),
                        Flexible(
                          child: GridView.builder(
                            itemCount: events.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 225,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              mainAxisExtent: 400,
                            ),
                            itemBuilder: (context, index) {
    
                              return MakeBoxNP(
                                eventName: events[index].eventName,
                                orgName: events[index].orgName,
                                date: events[index].date,
                                time: events[index].time,
                                location: events[index].location,
                                contact: events[index].contact,
                                description: events[index].description,
                                contactName: '',
                                contactNum: '',
                                contactEmail: '', 
                              );
                            },
                          ),


                        ),
                        //const SizedBox(width: 50),
                      ],
                    ),
                  ),
                  ],
                ),
              ),
            ),
          ]
        )
      ),
    );
  }
}

class MakeBoxNP extends StatelessWidget {
  final String eventName;
  final String date;
  final String time;
  final String orgName;
  final String location;
  final String contact;
  final String description;
  final String? contactName; // Make optional
  final String? contactNum; // Make optional
  final String? contactEmail; // Make optional

  MakeBoxNP({
    Key? key,
    required this.eventName,
    required this.date,
    required this.time,
    required this.orgName,
    required this.location,
    required this.contact,
    required this.description,
    this.contactName, // Add as optional parameter
    this.contactNum, // Add as optional parameter
    this.contactEmail, 
  }) : super(key: key);

  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF4549).withOpacity(1), // header background color
              onPrimary: Color(0x555555).withOpacity(1), // header text color
              onSurface: Color(0x555555).withOpacity(1), // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0x555555).withOpacity(1), // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    return pickedDate;
  }

void createNotification({
  required String userId, // Assuming you have the userId
  // required String type,
  // required String detail,
  required String orgName,
}) {
  try {
    final notificationsRef = FirebaseDatabase.instance.reference().child('notifications');
    
    final notificationData = {
      'type': 'event edit',
      'detail': 'You have edited an event: $eventName',
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

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                color: Color(0xCAEBF2).withOpacity(1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eventName,
                      style: GoogleFonts.kreon(
                        color: const Color(0x555555).withOpacity(1),
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      orgName,
                      style: GoogleFonts.kreon(
                        color: const Color(0x555555).withOpacity(1),
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date',
                      style: GoogleFonts.kreon(
                        color: const Color(0x555555).withOpacity(1),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 30, // Adjust height as needed
                      child: Text(
                        date,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    Text(
                      'Time ',
                      style: GoogleFonts.kreon(
                        color: const Color(0x555555).withOpacity(1),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 30, 
                      child: Text(
                        time,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Location: ',
                      style: GoogleFonts.kreon(
                        color: const Color(0x555555).withOpacity(1),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 30, 
                      child: Text(
                        location,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Contact: ',
                      style: GoogleFonts.kreon(
                        color: const Color(0x555555).withOpacity(1),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 30, 
                      child: Text(
                        contact,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Event Description: ',
                      style: GoogleFonts.kreon(
                        color: const Color(0x555555).withOpacity(1),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 60, 
                      child: Text(
                        description,
                        //maxLines: 3,
                        //overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => EventSignUpPage()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xCAEBF2).withOpacity(1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Register Event',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.kreon(
                              color: const Color(0x555555).withOpacity(1),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
}
