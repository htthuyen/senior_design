import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:givehub/webcomponents/np_topbar.dart';
import 'package:givehub/webcomponents/usertopbar.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../authentication/auth.dart';
import '../company_donor/companyprofilepage.dart';
import '../company_donor/donationofinterestspage.dart';
import '../company_donor/donorcompanydonationhistory.dart';
import '../company_donor/donorpaymentpage.dart';
import '../company_donor/donorprofile.dart';
import '../company_donor/eventhistory.dart';
import '../company_donor/eventsignuppage.dart';
import '../company_donor/grantcreationpage.dart';
import '../company_donor/myeventspage.dart';
import '../company_donor/mygrants.dart';
import '../company_donor/nonmondon.dart';
import '../notificationspage.dart';
import 'grantapp.dart';
import 'npprofilepage.dart';

class Application {
  String contactEmail;
  String contactName;
  String contactPhone;
  String nonProfitName;
  String Response;
  String website;

  Application({required this.contactEmail, required this.contactName, required this.contactPhone, required this.nonProfitName, required this.Response, required this.website});

  Map<String, dynamic> toJson() {
    return {
      'contactEmail': contactEmail,
      'contactName': contactName,
      'contactPhone': contactPhone,
      'nonprofitName': nonProfitName,
      'response': Response,
      'website': website,
      //.toIso8601String(),
    };
  }
}

class MyApps extends StatefulWidget {
  @override
  _MyAppsState createState() => _MyAppsState();
}

class _MyAppsState extends State<MyApps> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Application> apps = [];
  bool isFavorite = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    
    getUser().then((_) {
      if (uid != null) {
        getAppsFromDatabase(uid!); 
      } else {
        
        showSnackBar(context, 'User ID not found. Please log in again.');
        Navigator.pushReplacementNamed(context, '/login'); 
      }
    });
  }
  Future<void> getAppsFromDatabase(String userId) async {
    try {
      List<Map<dynamic, dynamic>>? userApps = await fetchAppsFromDatabase(userId);

      if (userApps != null) {
        setState(() {
          apps = userApps.map((appData) => Application (
            
            contactEmail: appData['contactEmail'],
            contactName : appData['contactName'],
            contactPhone : appData['contactPhone'],
            nonProfitName : appData['nonPpofitName'],
            Response :  appData['response'],
            website : appData['website'],
          )).toList();
        });
      } else {
        print('No apps found for the user.');
      }
    } catch (e) {
      print('Error fetching user apps: $e');
      showSnackBar(context, 'Error fetching user apps. Please try again later.');
    }
  }
  Future<List<Map<String, dynamic>>?> fetchAppsFromDatabase(String userId) async {
    final ref = FirebaseDatabase.instance.ref();

    try {
      String? grantId = await getGrantNPId(userId);
      var snapshot = await ref.child('grants').child(grantId!).child('applicants').orderByChild(userId).equalTo(uid).once();

      if (snapshot.snapshot.value != null) {
        Map<dynamic, dynamic>? data = snapshot.snapshot.value as Map<dynamic, dynamic>;

        if (data != null) {
          List<Map<String, dynamic>> appsList = [];
          data.forEach((key, data) {
            if (data != null) {
              
              String contactEmail = data['contactEmail'] ?? '';
              
              String contactName = data['contactName'] ?? '';
  
              String contactPhone = data['contactPhone'] ?? '';

              String nonProfitName = data['nonprofitName'] ?? '';

              String Response = data['response'] ?? '';

              String website = data['website'] ?? '';


              Map<String, dynamic> appData = {
                'contactEmail': contactEmail,
            'contactName': contactName ,
             'contactPhone': contactPhone,
             'nonProfitName': nonProfitName,
            'Response': Response,
             'website': website,
              };

            
              appsList.add(appData);
            }
          });
          return appsList;
        }
      }
    } catch (e) {
      print('Error retrieving apps: $e');
    }

    return null;
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: UserTopBar(),
        endDrawer: NpTopBar(),
       body: apps.isEmpty ? buildNoEventsWidget(context) : buildEventsList(context),
        ),
      );
    }
     Widget buildNoEventsWidget(BuildContext context) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You have no applications.',
             style: GoogleFonts.oswald(fontSize: 40, color: Color(0x555555).withOpacity(1))
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xCAEBF2).withOpacity(1),
                
              ),
              onPressed: () {
                Navigator.push(context, new MaterialPageRoute(
                builder: (context) =>
                  GrantApp())
                );
              },
              child: Text('Apply for a grant.', style: GoogleFonts.oswald(fontSize: 20, color: Colors.white)),
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
                                'MY GRANTS',
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
                              itemCount: apps.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 225, 
                                crossAxisSpacing: 20, 
                                mainAxisSpacing: 20, 
                                mainAxisExtent: 400
                              ),
                              itemBuilder: (context, index) {
                                final String contactName = apps[index].contactName;
                                return FutureBuilder<List<dynamic>>(
                                  future: Future.wait([ getGrantNPId(uid!)]),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      
                                      return CircularProgressIndicator();
                                    } else {
                                      
                                      if (snapshot.hasError || snapshot.data == null) {
                                       
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        // Extract eventId and userId from the snapshot data
                                        String grantId = snapshot.data![0] as String;
                                        //String attendeeId = getAttendeeId(events[index].orgName, events[index].eventName, uid!) as String;
                                        //String userId = snapshot.data![1] as String;
                                        print(grantId);
                                        //print(userId);
                                        //String formattedDeadline = DateFormat('yyyy-MM-dd').format(grants[index].deadline);
                                        return makeBox(
                                          contactEmail: apps[index].contactEmail,
                                          contactName : apps[index].contactName,
                                          contactPhone : apps[index].contactPhone,
                                          nonProfitName : apps[index].nonProfitName,
                                          Response :  apps[index].Response,
                                          website : apps[index].website,
                                          //description: grants[index].description,
                                          //eventId: eventId,
                                          //attendeeId: attendeeId,
                                          //userId: userId,
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

class makeBox extends StatelessWidget {
  String contactEmail;
  
  String contactName;

  String contactPhone;

  String nonProfitName;

  String Response;

  String website;

  
  makeBox({required this.contactEmail, required this.contactName, required this.contactPhone, required this.nonProfitName, required this.Response, required this.website});
  
  void _showEditGrantDialog(BuildContext context, String eventId) {
    TextEditingController contactEmailController = TextEditingController();
    TextEditingController contactNameController = TextEditingController();
    TextEditingController contactPhoneController = TextEditingController();
    TextEditingController nonProfitNameController = TextEditingController();
    TextEditingController responseController = TextEditingController();
    TextEditingController websiteController = TextEditingController();
    
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
                'Edit Application',
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
                      decoration: InputDecoration(labelText: 'Contact Email', labelStyle: GoogleFonts.oswald(fontWeight: FontWeight.w100, color: Color(0x555555).withOpacity(1))),
                      style: GoogleFonts.oswald(
                        color: Color(0x555555).withOpacity(1), 
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      controller: contactEmailController,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Contact Name', labelStyle: GoogleFonts.oswald(fontWeight: FontWeight.w100,color: Color(0x555555).withOpacity(1))),
                      style: GoogleFonts.oswald(
                        color: Color(0x555555).withOpacity(1), 
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      controller: contactNameController,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Contact Phone', labelStyle: GoogleFonts.oswald(fontWeight: FontWeight.w100,color: Color(0x555555).withOpacity(1))),
                      style: GoogleFonts.oswald(
                        color: Color(0x555555).withOpacity(1), 
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      controller: contactPhoneController,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Nonprofit Name', labelStyle: GoogleFonts.oswald(fontWeight: FontWeight.w100,color: Color(0x555555).withOpacity(1))),
                      style: GoogleFonts.oswald(
                        color: Color(0x555555).withOpacity(1), 
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      controller: nonProfitNameController,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Response', labelStyle: GoogleFonts.oswald(fontWeight: FontWeight.w100,color: Color(0x555555).withOpacity(1))),
                      style: GoogleFonts.oswald(
                        color: Color(0x555555).withOpacity(1), 
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      controller: responseController,
                    ),
                    const SizedBox(height: 30), // Increased height from 20 to 30

                    TextFormField(
                      decoration: InputDecoration(labelText: 'Website', labelStyle: GoogleFonts.oswald(fontWeight: FontWeight.w100,color: Color(0x555555).withOpacity(1))),
                      style: GoogleFonts.oswald(
                        color: Color(0x555555).withOpacity(1), 
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      controller: websiteController,
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
                    // Check if all fields are filled
                    if (contactEmailController.text.isEmpty ||
                        contactNameController.text.isEmpty ||
                        contactPhoneController.text.isEmpty ||
                        nonProfitNameController.text.isEmpty ||
                        responseController.text.isEmpty ||
                        websiteController.text.isEmpty 
                       ) {
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
                      // Split the date and time from the combined input
                      
                      // Update event information in the database
                      _updateApplication(
                        //grantId: grantId,
                        newContactEmail: contactEmailController.text,
                        newContactName: contactNameController.text,
                        newContactPhone: contactPhoneController.text,
                        newNonProfitName: nonProfitNameController.text,
                        newResponse: responseController.text,
                        newWebsite: websiteController.text,
                        
                      );

                      Navigator.push(context, new MaterialPageRoute(
                                                builder: (context) =>
                                                  MyGrants())
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
  void _updateApplication({
      required String newContactEmail,
      required String newContactName,
      required String newContactPhone,
      required String newNonProfitName,
      required String newResponse,
      required String newWebsite,
    }) {
    try {
      // Get a reference to the event node in the database
      String? grantId = getGrantNPId(uid!) as String?;
      DatabaseReference grantRef = FirebaseDatabase.instance.reference().child('grants').child(grantId!).child('applications').child(uid!);

      // Fetch existing event data from the database
      grantRef.once().then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          Map<String, dynamic> grantData = snapshot.value as Map<String, dynamic>;

          // Update only the fields that are provided by the user
          if (newContactEmail.isNotEmpty) grantData['contactEmail'] = newContactEmail;
          if (newContactName.isNotEmpty) grantData['contactName'] = newContactName;
         if (newContactPhone.isNotEmpty) grantData['contactPhone'] = newContactPhone;
          if (newNonProfitName.isNotEmpty) grantData['nonprofitName'] = newNonProfitName;
          if (newResponse.isNotEmpty) grantData['response'] = newResponse;
          //if (newDescription.isNotEmpty) eventData['location'] = newDescription;
          if (newWebsite.isNotEmpty) grantData['website'] = newWebsite;
        
          // Update the event information
          grantRef.update(grantData).then((_) {
            // Event information updated successfully
            print('app information updated successfully');
          }).catchError((error) {
            // An error occurred while updating event information
            print('Error updating app information: $error');
          });
        } else {
          // Event data not found
          print('app data not found');
        }
      } as FutureOr Function(DatabaseEvent value)).catchError((error) {
        // An error occurred while fetching event data
        print('Error fetching app data: $error');
      });
    } catch (e) {
      // Handle any other errors that occur during the process
      print('Error updating app information: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
   child: Column(
    children: [
      SizedBox(
        width: 250,
      height: 55,
        child: DecoratedBox(
        decoration: BoxDecoration(color:Color(0xCAEBF2).withOpacity(1),),
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contactEmail,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.kreon(
                      color: const Color(0x555555).withOpacity(1),
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    contactName,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.kreon(
                      color: const Color(0x555555).withOpacity(1),
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    SizedBox(width: 250, height: 315,
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
                        'Nonprofit Name ',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      
                      Text(
                        '\t\t' + nonProfitName,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Phone: ',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                        ),
                        
                        Text(
                        '\t\t' +  contactPhone,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Response: ',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                        ),
                        
                        Text(
                        '\t\t' + Response,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                        const SizedBox(height: 10),
                        Text(
                        'Website: ',
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
                        '\t\t' + website,
                        maxLines: 3,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                        ),
                        ),
                        const SizedBox(height: 20)
                        ],
                      ),
                  ),

                    ],
                  ),
                  Row (
                   mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    
                    //mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () async {
                           String? grantId = await getGrantId(uid!);
                            _showEditGrantDialog(context, grantId!);
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
                              'Edit',  
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