import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../authentication/auth.dart';
import '../../webcomponents/np_topbar.dart';
import '../../webcomponents/usertopbar.dart';
import '../company_donor/myeventspage.dart';
import 'eventnp.dart';


class CreateEvent extends StatefulWidget {
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String registerStatus ='';
  bool _isRegistering = false;
  DateTime _time = DateTime.now();

  void _registerEvent() async {
    if (_formKey.currentState!.validate()) {
      
      setState(() {
        _isRegistering = true;
      });

      try {
       
        await registerEvent(
          context,
          organizationNameController.text,
          eventNameController.text,
          dateController.text,
          timeController.text,
          locationController.text,
          contactController.text,
          eventDescriptionController.text,
        );
       
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: Container(
                padding: EdgeInsets.all(20),
                width: 600,
                height: 500,
                child: AlertDialog(
                  backgroundColor: Color(0xFFFF3B3F).withOpacity(1),
                  content: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      'Event registered successfully!',
                      style: GoogleFonts.oswald(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    Center(
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyEventsPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Continue',
                          style: GoogleFonts.oswald(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Color(0x555555).withOpacity(1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } catch (error) {
        print('Event Registration Error: $error');
        setState(() {
          registerStatus = 'Error occurred while registering event';
          _isRegistering = false;
        });
      }
    } else {
      print('Form is invalid');
      setState(() {
        _isRegistering = false;
      });
    }
  }
  
  void createNotification({
    required String userId, 
    required String orgName,
  }) {
    try {
      final notificationsRef = FirebaseDatabase.instance.reference().child('notifications');
      
      final notificationData = {
        'type': 'event creation',
        'detail': 'You have created a event: ${eventNameController.text}',
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

  TextEditingController organizationNameController = TextEditingController();
  TextEditingController eventNameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController eventDescriptionController = TextEditingController();


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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 75, right: 75, top: 35, bottom: 35),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Create Event',
                    style: GoogleFonts.oswald(
                      color: const Color(0x555555).withOpacity(1),
                      fontSize: 27,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xCAEBF2).withOpacity(1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        constraints: BoxConstraints.expand(
                          height: 485.0,
                          width: 900.0,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                          flex: 1,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Organization Name',
                                  style: GoogleFonts.kreon(
                                    color: const Color(0x555555).withOpacity(1),
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    constraints: BoxConstraints.expand(width: 400, height: 30),
                                    child: TextFormField(
                                      controller: organizationNameController,
                                      style: GoogleFonts.kreon(
                                        color: const Color(0x555555).withOpacity(1),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: const Color(0xD9D9D9).withOpacity(1),
                                        contentPadding: EdgeInsets.only(left: 12, bottom: 20),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(25),
                                          borderSide: BorderSide(width: 4.0, color: const Color(0x555555).withOpacity(1),),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(25),
                                          borderSide: BorderSide(color: Color(0xAAD1DA).withOpacity(1), width: 2),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Event Name',
                                    style: GoogleFonts.kreon(
                                      color: const Color(0x555555).withOpacity(1),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                Expanded(
                                  flex: 1,
                                    child: Container(
                                      constraints: BoxConstraints.expand(width: 400, height: 30),
                                      child: TextFormField(
                                        controller: eventNameController,
                                        style: GoogleFonts.kreon(
                                          color: const Color(0x555555).withOpacity(1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300,
                                        ),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: const Color(0xD9D9D9).withOpacity(1),
                                          contentPadding: EdgeInsets.only(left: 12, bottom: 20),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(25),
                                            borderSide: BorderSide(width: 4.0, color: const Color(0x555555).withOpacity(1),),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(25),
                                            borderSide: BorderSide(color: Color(0xAAD1DA).withOpacity(1), width: 2),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Date',
                                      style: GoogleFonts.kreon(
                                        color: const Color(0x555555).withOpacity(1),
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        constraints: BoxConstraints.expand(width: 400, height: 30),
                                        child:
                                        TextFormField(
                                          controller: dateController,
                                          textAlignVertical: TextAlignVertical.center,
                                          style: GoogleFonts.kreon(
                                            color: const Color(0x555555).withOpacity(1),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          onTap: () async {
                                            DateTime date = DateTime(1900);
                                            FocusScope.of(context).requestFocus(new FocusNode());
                                            date = ( await showDatePicker(
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
                                              lastDate: DateTime(2100)
                                            ))!;
                                            dateController.text = date.toIso8601String().replaceRange(10, 23, '');
                                          },
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: const Color(0xD9D9D9).withOpacity(1),
                                            contentPadding: EdgeInsets.only(left: 12, bottom: 20),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(25),
                                              borderSide: BorderSide(width: 4.0, color: const Color(0x555555).withOpacity(1),),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(25),
                                              borderSide: BorderSide(color: Color(0xAAD1DA).withOpacity(1), width: 2),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                    Text(
                                      'Time',
                                      style: GoogleFonts.kreon(
                                        color: const Color(0x555555).withOpacity(1),
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                      const SizedBox(height: 3),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        constraints: BoxConstraints.expand(width: 400, height: 30),
                                        child:
                                        TextFormField(
                                          controller: timeController,
                                          textAlignVertical: TextAlignVertical.center,
                                          style: GoogleFonts.kreon(
                                            color: const Color(0x555555).withOpacity(1),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          onTap: () async {
                                            DateTime time = DateTime(1900);
                                            FocusScope.of(context).requestFocus(new FocusNode());
                                            TimeOfDay initialTime = TimeOfDay.now();
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
                                              initialTime: initialTime,
                                              initialEntryMode: TimePickerEntryMode.input,
                                            );
                                            if (selectedTime != null) {
                                              // Format the selected time with AM/PM
                                              String formattedTime = selectedTime.format(context);
                                              timeController.text = formattedTime;

                                              
                                              int hour = selectedTime.hourOfPeriod;
                                              int minute = selectedTime.minute;
                                              String amPm = selectedTime.period == DayPeriod.am ? 'AM' : 'PM';

                                              
                                              time = DateTime(1900, 1, 1, hour, minute);
                                              String minuteString = minute < 10 ? '0$minute' : '$minute';
                                              timeController.text = '${time.hour}:$minuteString $amPm';

                                            }
                                          },
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: const Color(0xD9D9D9).withOpacity(1),
                                            contentPadding: EdgeInsets.only(left: 12, bottom: 20),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(25),
                                              borderSide: BorderSide(width: 4.0, color: const Color(0x555555).withOpacity(1),),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(25),
                                              borderSide: BorderSide(color: Color(0xAAD1DA).withOpacity(1), width: 2),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Location',
                                        style: GoogleFonts.kreon(
                                          color: const Color(0x555555).withOpacity(1),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        constraints: BoxConstraints.expand(width: 400, height: 30),
                                        child: TextFormField(
                                          controller: locationController,
                                          style: GoogleFonts.kreon(
                                            color: const Color(0x555555).withOpacity(1),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: const Color(0xD9D9D9).withOpacity(1),
                                            contentPadding: EdgeInsets.only(left: 12, bottom: 20),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(25),
                                              borderSide: BorderSide(width: 4.0, color: const Color(0x555555).withOpacity(1),),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(25),
                                              borderSide: BorderSide(color: Color(0xAAD1DA).withOpacity(1), width: 2),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Contact',
                                      style: GoogleFonts.kreon(
                                        color: const Color(0x555555).withOpacity(1),
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        constraints: BoxConstraints.expand(width: 400, height: 30),
                                        child:
                                        TextFormField(
                                          controller: contactController,
                                          style: GoogleFonts.kreon(
                                            color: const Color(0x555555).withOpacity(1),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: const Color(0xD9D9D9).withOpacity(1),
                                            contentPadding: EdgeInsets.only(left: 12, bottom: 20),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(25),
                                              borderSide: BorderSide(width: 4.0, color: const Color(0x555555).withOpacity(1),),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(25),
                                              borderSide: BorderSide(color: Color(0xAAD1DA).withOpacity(1), width: 2),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 12),
                                    Text(
                                      'Event Description',
                                      style: GoogleFonts.kreon(
                                        color: const Color(0x555555).withOpacity(1),
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    
                                    Expanded(
                                      flex: 5,
                                      child: Container(
                                        constraints: BoxConstraints.expand(width: 400, height: 500),
                                        child: TextFormField(
                                          controller: eventDescriptionController,
                                          maxLines: 12,
                                          style: GoogleFonts.kreon(
                                            color: const Color(0x555555).withOpacity(1),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: const Color(0xD9D9D9).withOpacity(1),
                                            contentPadding: EdgeInsets.only(left: 12, bottom: 20),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(25),
                                              borderSide: BorderSide(width: 4.0, color: const Color(0x555555).withOpacity(1),),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(25),
                                              borderSide: BorderSide(color: Color(0xAAD1DA).withOpacity(1), width: 2),
                                            ),
                                          ),
                                        ),
                                      ),
                                ),
                                
                                ],
                            ),
                          ),
                        ],
                      ),
                  
                  ),
                 
                  Positioned(
                  left: 0,
                  right: 0,
                  bottom: 7,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                        setState(() {
                      _isRegistering = true;
                    });

                  if (_formKey.currentState!.validate()) {
                   
                    try {
                     
                      await registerEvent(
                        context,
                        organizationNameController.text,
                        eventNameController.text,
                        dateController.text,
                        timeController.text,
                        locationController.text,
                        contactController.text,
                        eventDescriptionController.text,
                      );
                    createNotification(userId: uid!, orgName: organizationNameController.text);
                      String message = 'Subscription: ${organizationNameController.text} has created an event: ${eventNameController.text}.';
     
                    sendNotificationsToSubscribers(message, organizationNameController.text);

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Center(
                            child: Container(
                              padding: EdgeInsets.all(20),
                              width: 600,
                              height: 500,
                              child: AlertDialog(
                                backgroundColor: Color(0xFFFF3B3F).withOpacity(1),
                                content: Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Text(
                                    'Event registered successfully!',
                                    style: GoogleFonts.oswald(
                                      fontSize: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                actions: <Widget>[
                                  Center(
                                    child: TextButton(
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EventsNP(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Continue',
                                        style: GoogleFonts.oswald(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0x555555).withOpacity(1),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } catch (error) {
                      print('Event Registration Error: $error');
                      setState(() {
                        registerStatus = 'Error occurred while registering event';
                      });
                    } finally {
                      
                      setState(() {
                        _isRegistering = false;
                      });
                      organizationNameController.clear();
                      eventNameController.clear();
                      dateController.clear();
                      timeController.clear();
                      locationController.clear();
                      contactController.clear();
                      eventDescriptionController.clear();
                    }
                  } else {
                    print('Form is invalid');
                    setState(() {
                      _isRegistering = false;
                    });
                  }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF3B3F).withOpacity(1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: SizedBox(
                    height: 35,
                    width: 150,
                    child: Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        'Post Event',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Event was cancelled"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                              EventsNP())
                            );
                        },
                        child: Text(
                          'OK',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xAAD1DA).withOpacity(1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: SizedBox(
                  height: 35,
                  width: 150,
                  child: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      'Cancel',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.kreon(
                        color: const Color(0x555555).withOpacity(1),
                        fontSize: 17,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        ], ), 
          ],
      ),     
    ),
  ),
), ),);

  }
}
