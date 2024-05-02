//this page is to display the events a non-profit created/allow them edit or delete their events
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:givehub/webcomponents/np_topbar.dart';
import 'package:givehub/webcomponents/usertopbar.dart';
import 'package:givehub/webpages/np/grantstatus.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../authentication/auth.dart';
import '../company_donor/companyprofilepage.dart';
import '../company_donor/donorprofile.dart';
import '../notificationspage.dart';
import '../search.dart';
import '../subscription.dart';
import 'createevent.dart';
import 'grantapp.dart';
import 'needs.dart';
import 'npdonationhistory.dart';
import 'npdonationreview.dart';
import 'npprofilepage.dart';



class EventforNP {
  String eventName;
  String orgName;
  String date;
  String time;
  String location;
  String contact;
  String description;
  
  EventforNP({required this.eventName, required this.orgName, required this.date, required this.time, required this.location, required this.contact, required this.description});
}
class EventsNP extends StatefulWidget {
  @override
  _EventsNPState createState() => _EventsNPState();
}

class _EventsNPState extends State<EventsNP> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<EventforNP> events = [];
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
    
    getUser().then((_) {
      if (uid != null) {
        fetchEvents(uid!); 
      } else {
        
        showSnackBar(context, 'User ID not found. Please log in again.');
        Navigator.pushReplacementNamed(context, '/login'); 
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
  final String? contactName;
  final String? contactNum; 
  final String? contactEmail; 

  MakeBoxNP({
    Key? key,
    required this.eventName,
    required this.date,
    required this.time,
    required this.orgName,
    required this.location,
    required this.contact,
    required this.description,
    this.contactName, 
    this.contactNum, 
    this.contactEmail, 
  }) : super(key: key);

  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF4549).withOpacity(1), 
              onPrimary: Color(0x555555).withOpacity(1),
              onSurface: Color(0x555555).withOpacity(1), 
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0x555555).withOpacity(1), 
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
    required String userId, 
    required String orgName,
    required String message
  }) {
    try {
      final notificationsRef = FirebaseDatabase.instance.reference().child('notifications');
      
      final notificationData = {
        'type': 'event edit',
        'detail': message,
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

  void _showEditEventDialog(BuildContext context, String eventId) {
    TextEditingController eventNameController = TextEditingController();
    TextEditingController orgNameController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    TextEditingController timeController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    TextEditingController contactController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 800, 
            height: 600,
            child: AlertDialog(
              iconColor: Color(0xAAD1DA).withOpacity(1),
              backgroundColor: Color(0xCAEBF2).withOpacity(1),
              title: Text(
                'Edit Event',
                style: GoogleFonts.oswald(
                  color: Color(0x555555).withOpacity(1), 
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                   TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Date',
                        labelStyle: GoogleFonts.oswald(fontWeight: FontWeight.w100, color: Color(0x555555).withOpacity(1)),
                      ),
                      style: GoogleFonts.oswald(
                        color: Color(0x555555).withOpacity(1),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      controller: dateController,
                      onTap: () async {
                        DateTime? selectedDate = await _selectDate(context);
                        if (selectedDate != null) {
                          dateController.text = selectedDate.toIso8601String().substring(0, 10);
                        }
                      },
                    ),
                     const SizedBox(height: 20),
                   TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Time',
                        labelStyle: GoogleFonts.oswald(fontWeight: FontWeight.w100, color: Color(0x555555).withOpacity(1)),
                      ),
                      style: GoogleFonts.oswald(
                        color: Color(0x555555).withOpacity(1),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      controller: timeController,
                      onTap: () async {
                        TimeOfDay? selectedTime = await showTimePicker(
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: Color(0xFF4549).withOpacity(1), 
                                  onPrimary: Color(0x555555).withOpacity(1), 
                                  onSurface: Color(0x555555).withOpacity(1), 
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Color(0x555555).withOpacity(1), 
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                          context: context,
                          initialTime: TimeOfDay.now(),
                          initialEntryMode: TimePickerEntryMode.input,
                        );
                        if (selectedTime != null) {
                          
                          String formattedTime = selectedTime.format(context);
                          timeController.text = formattedTime;

                         
                          int hour = selectedTime.hourOfPeriod;
                          int minute = selectedTime.minute;
                          String amPm = selectedTime.period == DayPeriod.am ? 'AM' : 'PM';

                         
                          String formattedMinute = minute < 10 ? '0$minute' : '$minute';

                          timeController.text = '$hour:$formattedMinute $amPm';
                        }

                      },
                      ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Location', labelStyle: GoogleFonts.oswald(fontWeight: FontWeight.w100,color: Color(0x555555).withOpacity(1))),
                      style: GoogleFonts.oswald(
                        color: Color(0x555555).withOpacity(1), 
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      controller: locationController,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Contact', labelStyle: GoogleFonts.oswald(fontWeight: FontWeight.w100,color: Color(0x555555).withOpacity(1))),
                      style: GoogleFonts.oswald(
                        color: Color(0x555555).withOpacity(1), 
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      controller: contactController,
                    ),
                    const SizedBox(height: 30), 

                    TextFormField(
                      decoration: InputDecoration(labelText: 'Description', labelStyle: GoogleFonts.oswald(fontWeight: FontWeight.w100,color: Color(0x555555).withOpacity(1))),
                      style: GoogleFonts.oswald(
                        color: Color(0x555555).withOpacity(1), 
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      controller: descriptionController,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.oswald(
                        color: Color(0x555555).withOpacity(1), 
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    
                    if (
                        dateController.text.isEmpty || timeController.text.isEmpty ||
                        locationController.text.isEmpty ||
                        contactController.text.isEmpty ||
                        descriptionController.text.isEmpty) {
                      // Show dialog if any field is empty
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: const Color(0xFFFF3B3F).withOpacity(1),
                            title: Text('Please Fill in All Fields', style: GoogleFonts.oswald(fontSize: 30, color: Colors.white)),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK', style: GoogleFonts.oswald(fontSize: 20, color: Colors.white)),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      
                      _updateEvent(
                        eventId: eventId,
                        newDate: dateController.text,
                        newTime: timeController.text,
                        newLocation: locationController.text,
                        newContact: contactController.text,
                        newDescription: descriptionController.text,
                      );

                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>
                          EventsNP())
                        );
                    }
                  },
                  child: Text(
                    'Save',
                    style: GoogleFonts.oswald(
                        color: Color(0x555555).withOpacity(1), 
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  void _updateEvent({
    required String eventId,
    required String newDate,
    required String newTime,
    required String newLocation,
    required String newContact,
    required String newDescription,
  }) async {
    try {
     
      DatabaseReference eventRef = FirebaseDatabase.instance.reference().child('events').child(eventId);
      
      
      Map<String, dynamic> eventData = {
        'dateTime': newDate,
        'time': newTime,
        'location': newLocation,
        'contact': newContact,
        'eventDescription': newDescription,
      };
       
      String message = 'You updated event: ${eventData['eventName']}.';
      createNotification(userId: uid!, orgName: orgName, message: message);
      
      
      String attendMessage = 'Subscription: ${eventData['eventName']} was updated by the organizer: ${eventData['orgName']}.';
      await sendNotificationsToAttenders(attendMessage, eventData['orgName'], eventData['eventName']);
     
      await eventRef.update(eventData);
      
      
    } catch (e) {
      
      print('Error updating event information: $e');
    }
  }
 void _removeEvent({
    required String eventId,
    required context,
    required String orgName,
    required String eventName,
    required String userId,
  }) async {
    try {
      
      DatabaseReference eventRef = FirebaseDatabase.instance.reference().child('events').child(eventId);

     String removeMessage = 'You have removed event: $eventName.';
      createNotification(userId: uid!, orgName: orgName, message: removeMessage);
      
      
      String removeAttendMessage = 'Subscription: $orgName removed event: $eventName.';
      await sendNotificationsToAttenders(removeAttendMessage, orgName, eventName);
      await eventRef.remove();
      
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xFFFF3B3F).withOpacity(1),
            title: Text('Event was succesfully removed!', style: GoogleFonts.oswald(fontSize: 30, color: Colors.white)),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> EventsNP()));
                },
                child: Text('OK', style: GoogleFonts.oswald(fontSize: 20, color: Colors.white)),
              ),
            ],
          );
        },
      );
      print('Event removed successfully');
    } catch (e) {
     
      print('Error removing event: $e');
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
                      height: 30, 
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
                            String? eventId = await getEventId(orgName, eventName);
                            _showEditEventDialog(context, eventId!);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xCAEBF2).withOpacity(1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Edit Event',
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
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                        ElevatedButton(
                          onPressed: () async {
                            String? eventId = await getEventId(orgName, eventName);
                           _removeEvent(eventId: eventId!, context: context, orgName: orgName, eventName: eventName, userId: uid!);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xCAEBF2).withOpacity(1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Remove Event',
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