//this class displays all the events a donor/company ha registered for
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../authentication/auth.dart';
import '../notificationspage.dart';
import '../np/npprofilepage.dart';
import '../search.dart';
import '../subscription.dart';
import 'companyprofilepage.dart';
import 'currentevents.dart';
import 'donationofinterestspage.dart';
import 'donorcompanydonationhistory.dart';
import 'donorpaymentpage.dart';
import 'donorprofile.dart';
import 'eventhistory.dart';
import 'grantcreationpage.dart';
import 'nonmondon.dart';
import 'npselectionpage.dart';



class EventforUser {
  String eventName;
  String orgName;
  String date;
  String time;
  String location;
  String contact;
  String description;
  bool isNotificationFilled;
  bool isOptOut;
  
  EventforUser({
    required this.eventName, 
    required this.orgName, 
    required this.date, 
    required this.time, 
    required this.location, 
    required this.contact, 
    required this.description, 
    required this.isNotificationFilled, 
    required this.isOptOut});
}
class MyEventsPage extends StatefulWidget {
  @override
  _MyEventsPageState createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<EventforUser> events = [];
  bool isFavorite = false;
  final _formKey = GlobalKey<FormState>();
  
  @override
  void initState() {
    super.initState();
    
    getUser().then((_) async {
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
      } else {

        print('No events found for the user.');
      }
    } catch (e) {
     
      print('Error fetching user events: $e');
      showSnackBar(context, 'Error fetching user events. Please try again later.');
    }
  }
 
  Future<String?> getAttendId(String eventId, String userId) async {
    try {
      final DatabaseReference attendeesRef = FirebaseDatabase.instance.reference().child('events').child(eventId).child('attendees');
      final DataSnapshot snapshot = (await attendeesRef.once()) as DataSnapshot;

      final attendeesData = snapshot.value as Map<dynamic, dynamic>?;

      if (attendeesData != null) {
      
        for (var attendeeIdKey in attendeesData.keys) {
          final attendeeData = attendeesData[attendeeIdKey] as Map<dynamic, dynamic>;
          final attendeeUserId = attendeeData['fullName'] as String?;
          final String? userName = await getUserNameFromDatabase(userId);
          if (attendeeUserId == userName) {
            print('Found matching attendee ID: $attendeeIdKey');
            return attendeeIdKey.toString();
          }
        }
        print('No matching attendee found for user ID: $userId');
        return null;
      } else {
        print('No attendees found for event: $eventId');
        return null;
      }
    } catch (e) {
      print('Error getting attendee ID: $e');
      return null;
    }
  }

  Future<bool?> fetchIsNotificationFilled(String userId, String orgName, String eventName) async {
    try {
      
      final String? eventId = await getEventId(orgName, eventName);
      final String? userName = await getUserNameFromDatabase(userId);
      final String? attendeeId = await getAttendeeId(userName!, orgName, eventName, eventId!);
      
      final snapshot = await FirebaseDatabase.instance
          .reference()
          .child('events')
          .child(eventId!)
          .child('attendees')
          .child(attendeeId!)
          .child('optSubOut')
          .once();
     
      if (snapshot.snapshot.value != null) {
       
        bool? isNotificationFilled = snapshot.snapshot.value as bool?;
        
        return isNotificationFilled;
      } else {
        
        return null;
      }
    } catch (e) {
      print('Error retrieving isNotificationFilled: $e');
      return null;
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
                
                signOut().then((_) {
                 
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
        appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
        title: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/welcome');
          },
          child: Text(
            'GiveHub',
            style: GoogleFonts.oswald(
              fontSize: 30,
              color: Colors.white
            ),
          ),
        ),
        centerTitle: false,
        backgroundColor: const Color(0xFFFF3B3F),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, new MaterialPageRoute(
                      builder: (context) =>
                        SearchPage())
                      );
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
                        onTap: () {
                          final _formKey = GlobalKey<FormState>();
                          onTap: () async {
                            
                            String? userType = await getUserTypeFromDatabase(uid!);
                            print(userType);
                            if (userType == 'Nonprofit Organization') {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NPProfilePage()));
                            } else if (userType == 'Individual Donor') {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DonorProfilePage()));
                            } else if (userType == 'Company') {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CompanyProfilePage()));
                            }
                          };
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
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                            CurrentEventsPage())
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
                          Navigator.push(context, MaterialPageRoute(
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
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                            NPSelectionPage())
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
                      Navigator.push(context, MaterialPageRoute(
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
                       Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                            SubscriptionPage())
                       );
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
       body: events.isEmpty ? buildNoEventsWidget(context) : buildEventsList(context),
        ),
      );
    }
     Widget buildNoEventsWidget(BuildContext context) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You have no events',
             style: GoogleFonts.oswald(fontSize: 40, color: Color(0x555555).withOpacity(1))
            ),
            ElevatedButton(
               style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xCAEBF2).withOpacity(1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                builder: (context) =>
                  CurrentEventsPage())
                );
              },
              child: Text('Register for events', style: GoogleFonts.oswald(fontSize: 20, color: Colors.white)),
            ),
          ],
        ),
      );
    }
  Widget buildEventsList(BuildContext context) {
    return CustomScrollView(
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
                                'MY EVENTS',
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
                                mainAxisExtent: 400
                              ),
                              itemBuilder: (context, index) {
                            final String orgName = events[index].orgName;
                            return FutureBuilder<List<dynamic>>(
                              future: Future.wait([
                              getEventId(orgName, events[index].eventName),
                              fetchIsNotificationFilled(uid!, orgName, events[index].eventName),
                            ]),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else {
                                  if (snapshot.hasError ||
                                      snapshot.data == null) {
                                    return Text(
                                        'Error: ${snapshot.error}');
                                  } else {
                                    String eventId =snapshot.data![0] as String;
                                    bool? isNotificationFilled = snapshot.data![1] as bool;
                                   
                                    return EventCard(
                                      eventName: events[index].eventName,
                                      orgName: events[index].orgName,
                                      date: events[index].date,
                                      time: events[index].time,
                                      location: events[index].location,
                                      contact: events[index].contact,
                                      description: events[index].description,
                                      eventId: eventId,
                                      isNotificationFilled: isNotificationFilled,
                                      isOptOut: isNotificationFilled,
                                    );
                                  }
                                }
                              },
                            );
                          },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]
        );
   }
  
  }
  class EventCard extends StatefulWidget {
  final String eventName;
  final String orgName;
  final String date;
  final String time;
  final String location;
  final String contact;
  final String description;
  final String eventId;
  final bool isNotificationFilled;
  final bool isOptOut;
 

  EventCard({
    required this.eventName,
    required this.orgName,
    required this.date,
    required this.time,
    required this.location,
    required this.contact,
    required this.description,
    required this.eventId,
    required this.isNotificationFilled,
    required this.isOptOut,
  });

  @override
  _EventCardState createState() => _EventCardState();
}

  class _EventCardState extends State<EventCard> {
    bool isNotificationFilled = true;
    bool isOptOut = false;

  Future<String?> getAtId(String orgName, String eventName, String fullName) async {
    try {
      final String? eventId = await getEventId(orgName, eventName);
      if (eventId == null) {
        print('Event ID not found for orgName: $orgName and eventName: $eventName');
        return null;
      }

      final DatabaseReference eventsRef = FirebaseDatabase.instance.reference().child('events');
      final snapshot = await eventsRef.child(eventId).child('attendees').once();

      final Map<dynamic, dynamic>? eventData = snapshot.snapshot.value as Map<dynamic, dynamic>?;

      if (eventData != null) {
        
        for (var attendeeIdKey in eventData.keys) {
          final attendeeData = eventData[attendeeIdKey] as Map<dynamic, dynamic>;
          final attendeeFullName = attendeeData['fullName'] as String?;
          if (attendeeFullName == fullName) {
            print('Found matching attendee ID: $attendeeIdKey');
            return attendeeIdKey.toString();
          }
        }
      } else {
        print('No attendees found for event: $eventId');
      }

      print('No matching attendee found for full name: $fullName, orgName: $orgName, and eventName: $eventName');
      return null;
    } catch (e) {
      print('Error getting attendee ID: $e');
      return null;
    }
  }
  Future<void> unregisterFromEvent(BuildContext context, String eventId, String attendeeId) async {
    final ref = FirebaseDatabase.instance.reference();

    try {
      
      DatabaseReference attendeeRef = ref.child('events').child(eventId).child('attendees');
      await attendeeRef.remove();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xFF3B3F).withOpacity(1),
            content: Text('You have successfully unregistered from this event.', style: GoogleFonts.oswald(fontSize: 40, color: Colors.white)),
            actions: <Widget>[
              TextButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xAAD1DA).withOpacity(1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                 Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>
                     MyEventsPage())
                    );
                },
                child: Text('OK', style: GoogleFonts.oswald(fontSize: 20, color: Color(0x555555).withOpacity(1))),
              ),
            ],
          );
        },
      );
    } catch (e) {
      
      print('Error unregistering from event: $e');
      showSnackBar(context, 'Error unregistering from event. Please try again later.');
    }
  }
  Future<void> updateOptSubOutValue(String eventName, String userId, String orgName, bool isOptedOut) async {
    try {
      String? fullName = await getUserNameFromDatabase(uid!);
      
      String? eventId = await getEventId(orgName, eventName);
      String? attendeeId = await getAtId(orgName, eventName, fullName!);
      if (attendeeId != null && eventId != null) {
        DatabaseReference attendeeRef = FirebaseDatabase.instance.reference()
          .child('events').child(eventId).child('attendees').child(attendeeId);

        Map<String, dynamic> updatedData = {
          'optSubOut': isOptedOut, 
        };

        await attendeeRef.update(updatedData);

        print('Value updated successfully');
      } else {
        print('Attendee ID or Event ID not found');
      }
    } catch (e) {
      print('Error updating value: $e');
    }
  }

  void createNotification({
    required String userId, 
    required String orgName,
    required String message,
  }) {
    try {
      final notificationsRef = FirebaseDatabase.instance.reference().child('notifications');
      
      final notificationData = {
        'type': 'un-subscribe from event',
        'detail': message,
        'orgName': widget.orgName,
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
     
    return SingleChildScrollView(
      child: Column(
        children: [
          SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            height: 100,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0xCAEBF2).withOpacity(1),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.eventName,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.kreon(
                              color: const Color(0x555555).withOpacity(1),
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            widget.orgName,
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
                    IconButton(
                      icon: Icon(
                        Icons.notifications,
                        color: widget.isNotificationFilled == false ? Color(0xFF3B3F).withOpacity(1) : Colors.grey,
                      ),
                        onPressed: () async {
                          
                          String message = 'You have un-subscribed from ${widget.eventName}';
                          final String? userName = await getUserNameFromDatabase(uid!);
                          final String? eventId = await getEventId(widget.orgName, widget.eventName);
                          final String? atenId = await getAtId(widget.orgName, widget.eventName, userName!);
                         
                          createNotification(userId: uid!, orgName: widget.orgName, message: message);
                          updateOptSubOutValue(widget.eventName, uid!, widget.orgName, isOptOut);
                          setState(() {
                            isNotificationFilled = !widget.isNotificationFilled;
                            
                            isOptOut = !widget.isOptOut;
                            Navigator.push(context, MaterialPageRoute(builder: ((context) => MyEventsPage())));
                          });
                         
                        },

                    ),
                  ],
                ),

              ),
            ),
          ),
          ),
          SizedBox(
            width: 250,
            height: 315,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.white),
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Column(
                  children: [
                    
              Row(
                children: [
                  Expanded(
                 child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date & Time: ',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      
                      Text(
                        '\t\t' + widget.date + '\n\t\t' + widget.time,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Location: ',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                        ),
                        
                        Text(
                        '\t\t' +  widget.location,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Contact: ',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                        ),
                        
                        Text(
                        '\t\t' + widget.contact,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                        const SizedBox(height: 10),
                        Text(
                        'Event Description: ',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                        ),
                        
                        SizedBox(
                          width: 175,
                          height: 60,
                        child: Text(
                        '\t\t' + widget.description,
                        maxLines: 3,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                        ),
                        ),
                        const SizedBox(height: 20),
                        ],
                      ),
                  ),

                    ],
                  ),
                  Row (
                   mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    
                    children: [
                      SizedBox(width: 20),
                      ElevatedButton(
                          onPressed: () async {
                            String? userName = await getUserNameFromDatabase(uid!);
                            String? attendeeId = await getAtId(widget.orgName, widget.eventName, userName!);
                            if (attendeeId != null) {
                              print('Attendee ID: $attendeeId'); 
                              unregisterFromEvent(context, widget.eventId, attendeeId);
                              String message = 'You have un-registered from ${widget.eventName}';
                              createNotification(userId: uid!, orgName: widget.orgName, message: message);
                            } else {
                              print('No attendee ID found for the event.');
                            }
                          },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xCAEBF2).withOpacity(1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: SizedBox(height: 35, width: 75, 
                          child: Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              'Unregister',  
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
        ],
      ),
    );
  }
}
            