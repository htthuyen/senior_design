//this page allows donors/companies to sign up for events created by non-profits
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:givehub/authentication/auth.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../webcomponents/donor_company_topbar.dart';
import '../../webcomponents/usertopbar.dart';
import 'currentevents.dart';

class EventSignUpPage extends StatefulWidget {

  @override
  _EventSignUpPageState createState() => _EventSignUpPageState();
}

class _EventSignUpPageState extends State<EventSignUpPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController dateAvailableController = TextEditingController();
  final TextEditingController timeAvailableController = TextEditingController();
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final  TextEditingController orgNameController = TextEditingController();
  bool optSubOut = false;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final DatabaseReference _database = FirebaseDatabase.instance.reference();


 void createNotification({
    required String userId, 
    required String orgName,
    required String eventName
  }) {
    try { 
      final notificationsRef = FirebaseDatabase.instance.reference().child('notifications');
      
      final notificationData = {
        'type': 'event registration',
        'detail': 'You have registered for $eventName',
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
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate)
      setState(() {
        selectedDate = pickedDate;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null && pickedTime != selectedTime)
      setState(() {
        selectedTime = pickedTime;
      });
  }

  void submitForm(BuildContext context, String orgName, String eventName) {
   
      userRegisterEvent(
        context,
        fullNameController.text,
        emailController.text,
        phoneNumberController.text,
        dateAvailableController.text,
        timeAvailableController.text,
        eventName,
        orgName,
        optSubOut
      );
      createSubscriptionAndPutInDatabase(name: orgName, email: emailController.text, eventName: eventName);
      
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
           
            backgroundColor: Color(0xFFFF3B3F).withOpacity(1),
            content: Text(
              'You have successfully registered for the event!',
              style: GoogleFonts.oswald(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); 
                },
                child: Text('OK', style: GoogleFonts.oswald(
                fontSize: 20,
                color: Colors.white,
              ),),
              ),
            ],
          );
        },
      );
  }
  void createSubscriptionAndPutInDatabase({
    required String name,
    required String email,
    required String eventName
  }) {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserUid != null) {
      final updateSubData = {
        'orgName': name,
        'orgEmail': email,
        'type': 'event subscription',
        'userId': uid,
       
      };

     
      final subscriptionsRef = _database.child('subscriptions');

      
      final subscriptionRef = subscriptionsRef.push();

      
      subscriptionRef.set(updateSubData)
        .then((_) {
          print('Subscription added successfully.');

          
          createNotification(userId: currentUserUid, orgName: name, eventName: eventName);
        })
        .catchError((error) {
          print('Error adding subscription: $error');
        });
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
    final EventSp chosen = ModalRoute.of(context)!.settings.arguments as EventSp;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
      ),
        home: Scaffold(
          key: _scaffoldKey,
          appBar: UserTopBar(),
      endDrawer: DonorComTopBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 75, right: 75, top: 50, bottom: 75),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chosen.getEventName() + ' overview',
                  style: GoogleFonts.oswald(
                    color: const Color(0x555555).withOpacity(1),
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height:10),
                Container(
                  alignment: Alignment.topCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text( 
                        'Organization Name: ' + chosen.getOrgName(),
                        style: GoogleFonts.kreon(
                          color: const Color(0xFF3B3F).withOpacity(1),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text( 
                            'Date: ',
                            style: GoogleFonts.kreon(
                              color: const Color(0x555555).withOpacity(1),
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                            Text( 
                            chosen.getDate(),
                            style: GoogleFonts.kreon(
                              color: const Color(0x555555).withOpacity(1),
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text( 
                            'Time: ',
                            style: GoogleFonts.kreon(
                              color: const Color(0x555555).withOpacity(1),
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text( 
                            chosen.getTime(),
                            style: GoogleFonts.kreon(
                              color: const Color(0x555555).withOpacity(1),
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text( 
                            'Location: ',
                            style: GoogleFonts.kreon(
                              color: const Color(0x555555).withOpacity(1),
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text( 
                            chosen.getLocation(),
                            style: GoogleFonts.kreon(
                              color: const Color(0x555555).withOpacity(1),
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text( 
                            'Contact: ',
                            style: GoogleFonts.kreon(
                              color: const Color(0x555555).withOpacity(1),
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text( 
                            chosen.getContact(),
                            style: GoogleFonts.kreon(
                              color: const Color(0x555555).withOpacity(1),
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text( 
                            'Description: ',
                            style: GoogleFonts.kreon(
                              color: const Color(0x555555).withOpacity(1),
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text( 
                            chosen.getDescription(),
                            style: GoogleFonts.kreon(
                              color: const Color(0x555555).withOpacity(1),
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Register for ' + chosen.getEventName(),
                        style: GoogleFonts.oswald(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height:10),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xCAEBF2).withOpacity(1),
                        ),
                        constraints: const BoxConstraints.expand(
                           height: 575.0,
                          width: 1000.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:[
                            Text(
                              'Name (Company Info)',
                              style: GoogleFonts.kreon(
                                color: const Color(0x555555).withOpacity(1),
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    constraints: BoxConstraints.expand(
                                      height: 55.0,
                                      width: 300.0
                                    ),
                                    child: Column(
                                      children:[
                                        const SizedBox(height: 3),
                                        TextFormField(
                                          controller: fullNameController,
                                          style: GoogleFonts.kreon(
                                            color: const Color(0x555555).withOpacity(1),
                                            fontSize: 17,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: const Color(0xD9D9D9).withOpacity(1),
                                            contentPadding: EdgeInsets.only(left: 12, bottom: 20),
                                            border: const OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Color(0xAAD1DA).withOpacity(1), width: 2),
                                            ),
                                          ),
                                        ),     
                                      ],
                                    ),
                                  ),
                                ),
                                
                                ],
                              ),
                              const SizedBox(height: 25),
                              Text(
                                'Contact Info',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.kreon(
                                  color: const Color(0x555555).withOpacity(1),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Row (
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      constraints: const BoxConstraints.expand(
                                        height: 50.0,
                                        width: 300.0
                                      ),
                                      child: TextFormField(
                                        controller: phoneNumberController,
                                        textAlignVertical: TextAlignVertical.center,
                                        style: GoogleFonts.kreon(
                                          color: const Color(0x555555).withOpacity(1),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w300,
                                        ),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: const Color(0XD9D9D9).withOpacity(1),
                                          hintText: 'Phone',
                                          hintStyle: GoogleFonts.kreon(
                                            color: const Color(0xA9A9A9).withOpacity(1),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          contentPadding: EdgeInsets.only(left: 12, bottom: 20),
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Color(0xAAD1DA).withOpacity(1), width: 2),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      constraints: const BoxConstraints.expand(
                                        height: 50.0,
                                        width: 300.0
                                      ),
                                      child: TextFormField(
                                        controller: emailController,
                                        textAlignVertical: TextAlignVertical.center,
                                        style: GoogleFonts.kreon(
                                          color: const Color(0x555555).withOpacity(1),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w300,
                                        ),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: const Color(0xD9D9D9).withOpacity(1),
                                          hintText: 'Email',
                                          hintStyle: GoogleFonts.kreon(
                                            color: const Color(0xA9A9A9).withOpacity(1),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          contentPadding: EdgeInsets.only(left: 12, bottom: 20),
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: const Color(0xAAD1DA).withOpacity(1), width: 2),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 25),
                              Text(
                                'Additional Info',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.kreon(
                                  color: const Color(0x555555).withOpacity(1),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextFormField(
                                        controller: dateAvailableController,
                                        textAlignVertical: TextAlignVertical.center,
                                        style: GoogleFonts.kreon(
                                          color: const Color(0x555555).withOpacity(1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300,
                                        ),
                                        onTap: () async {
                                              DateTime date = DateTime(1900);
                                              FocusScope.of(context).requestFocus(new FocusNode());
                                              date = (await showDatePicker(
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
                                              ))!;
                                              dateAvailableController.text = date.toIso8601String().replaceRange(10, 23, '');
                                            },
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: const Color(0xD9D9D9).withOpacity(1),
                                              hintText: 'Date Available',
                                              hintStyle: GoogleFonts.kreon(
                                                color: const Color(0xA9A9A9).withOpacity(1),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w300,
                                              ),
                                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                              border: OutlineInputBorder(
                                                
                                                borderSide: BorderSide.none,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                               
                                                borderSide: BorderSide(color: const Color(0xAAD1DA).withOpacity(1), width: 2),
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
                                          TextFormField(
                                            controller: timeAvailableController,
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
                                                String formattedTime = selectedTime.format(context);
                                                timeAvailableController.text = formattedTime;

                                                int hour = selectedTime.hourOfPeriod;
                                                int minute = selectedTime.minute;
                                                String amPm = selectedTime.period == DayPeriod.am ? 'AM' : 'PM';

                                                time = DateTime(1900, 1, 1, hour, minute);
                                                String minuteString = minute < 10 ? '0$minute' : '$minute';
                                                timeAvailableController.text = '${time.hour}:$minuteString $amPm';
                                              }
                                            },
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: const Color(0xD9D9D9).withOpacity(1),
                                            hintText: 'Time Available',
                                            hintStyle: GoogleFonts.kreon(
                                              color: const Color(0xA9A9A9).withOpacity(1),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w300,
                                            ),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(25),
                                              borderSide: BorderSide(color: const Color(0xAAD1DA).withOpacity(1), width: 2),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      
                                      onPressed: () {
                                        submitForm(context, chosen.getOrgName(), chosen.getEventName());
                                        createNotification(userId: uid!, orgName: chosen.getOrgName(), eventName: chosen.getEventName());
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white.withOpacity(1),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: SizedBox(height: 35, width: 150, 
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Text(
                                            'Register',  
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
                                    const SizedBox(width:10), 
                                    ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: const Color(0xFFFF3B3F).withOpacity(1),
                                            title: Text("You did not sign up for the event.", style: GoogleFonts.oswald(
                                              color: Colors.white.withOpacity(1),
                                              fontSize: 17,
                                              fontWeight: FontWeight.w300,
                                            ),),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'OK',
                                                  style: GoogleFonts.oswald(
                                                    color: Color(0x555555).withOpacity(1),
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white.withOpacity(1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: SizedBox(height: 35, width: 50, 
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 5),
                                          child: Text(
                                            'Cancel',  
                                            textAlign: TextAlign.center, 
                                            style: GoogleFonts.oswald(
                                              color: const Color(0xFFFF3B3F).withOpacity(1),
                                              fontSize: 17,
                                              
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                      ), ), ], 
                        ),
                      ), 
                      ],
                    ),
                  ),
        ), ), ), );
  }
}
