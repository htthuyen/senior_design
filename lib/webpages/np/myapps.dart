import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../authentication/auth.dart';
import 'package:givehub/webcomponents/np_topbar.dart';
import 'package:givehub/webcomponents/usertopbar.dart';
import '../company_donor/companyprofilepage.dart';
import '../company_donor/donationofinterestspage.dart';
import '../company_donor/donorcompanydonationhistory.dart';
import '../company_donor/donorpaymentpage.dart';
import '../company_donor/donorprofile.dart';
import '../company_donor/eventhistory.dart';
import '../company_donor/eventsignuppage.dart';
import '../company_donor/grantcreationpage.dart';
import '../company_donor/myeventspage.dart';
import '../company_donor/nonmondon.dart';
import '../notificationspage.dart';
import 'grantapp.dart';
import 'npprofilepage.dart';

class Application {
  String contactEmail;
  String contactName;
  String contactPhone;
  String nonprofitName;
  String response;
  String website;
  String grantKey;

  Application({required this.grantKey, required this.contactEmail, required this.contactName, required this.contactPhone, required this.nonprofitName, required this.response, required this.website});

  Map<String, dynamic> toJson() {
    return {
      'contactEmail': contactEmail,
      'contactName': contactName,
      'contactPhone': contactPhone,
      'nonprofitName': nonprofitName,
      'response': response,
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
  List<List<Application>> apps = [];
  List<Grant> grants = [];
   List<List<Application>> newApps = [];
  List<Grant> newGrants = [];
  bool isFavorite = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    
    getUser().then((_) {
      if (uid != null) {
        getGrantsFromDatabase().then((_) {
          for (int i = 0; i < grants.length; i++) {
            Grant g = grants[i];
            getAppsFromDatabase(uid!, g.grantKey, i).then((_) {
              for (int j = 0; j < grants.length; j++) {
                if (apps[j].isNotEmpty) {
                  if (newApps.contains(apps[j]) || newGrants.contains(grants[j])) {
                    continue;
                  }
                  newApps.add(apps[j]);
                  newGrants.add(grants[j]);
                }
              }
            }
          );
          }
        });
      } else {
        
        showSnackBar(context, 'User ID not found. Please log in again.');
        Navigator.pushReplacementNamed(context, '/login'); 
      }
    });
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

  Future<void> getAppsFromDatabase(String userId, String g, int i) async {
    try {
      List<Map<dynamic, dynamic>>? userApps = await fetchAppsFromDatabase(userId, g);
      print("UserApps: " + userApps.toString());
      if (userApps != null) {
        setState(() {
          apps.add(userApps.map((appData) => Application (
            grantKey : appData['grantKey'],
            contactEmail: appData['contactEmail'],
            contactName : appData['contactName'],
            contactPhone : appData['contactPhone'],
            nonprofitName : appData['nonprofitName'],
            response :  appData['response'],
            website : appData['website'],
          )).toList());
        });
      } else {
        apps.add([]);
        print('No apps found for the user.');
      }
    } catch (e) {
      print('Error fetching user apps: $e');
      showSnackBar(context, 'Error fetching user apps. Please try again later.');
    }
  }
  Future<List<Map<String, dynamic>>?> fetchAppsFromDatabase(String userId, String grantId) async {
    final ref = FirebaseDatabase.instance.reference();

    try {
      var snapshot = await ref.child('grants/$grantId/applicants').once();

      if (snapshot.snapshot.value != null) {
        Map<dynamic, dynamic>? data = snapshot.snapshot.value as Map<dynamic, dynamic>;

        if (data != null) {
          List<Map<String, dynamic>> appsList = [];
          data.forEach((key, data) {
            if (data != null) { 
              String contactEmail = data['contactEmail'] ?? '';
              String contactName = data['contactName'] ?? '';
              String contactPhone = data['contactPhone'] ?? '';
              String nonprofitName = data['nonprofitName'] ?? '';
              String response = data['response'] ?? '';
              String website = data['website'] ?? '';

              Map<String, dynamic> appData = {
                'grantKey': grantId,
                'contactEmail': contactEmail,
                'contactName': contactName ,
                'contactPhone': contactPhone,
                'nonprofitName': nonprofitName,
                'response': response,
                'website': website,
              };
              if (key == userId) {
                appsList.add(appData);
              }
            }
          });
          print("Appslist: " + appsList.toString());
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
                                'My Applications',
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
                              itemCount: newApps.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 225, 
                                crossAxisSpacing: 20, 
                                mainAxisSpacing: 20, 
                                mainAxisExtent: 400
                              ),
                              itemBuilder: (context, index) {
                                return makeBox( grant: newGrants[index], apps: newApps[index][0],);
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
  Grant grant;
  Application apps;

  makeBox({required this.grant, required this.apps});

  void _showEditGrantDialog(BuildContext context, String eventId) {
    TextEditingController contactEmailController = TextEditingController(text: apps.contactEmail);
    TextEditingController contactNameController = TextEditingController(text: apps.contactName);
    TextEditingController contactPhoneController = TextEditingController(text: apps.contactPhone);
    TextEditingController nonProfitNameController = TextEditingController(text: apps.nonprofitName);
    TextEditingController responseController = TextEditingController(text: apps.response);
    TextEditingController websiteController = TextEditingController(text: apps.website);
    
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
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Color(0xCAEBF2).withOpacity(1),
                        title: Center(
                          child: Text(
                          "Are you sure you would like to withdraw this application?",
                          style: GoogleFonts.kreon(
                              color: const Color(0x555555).withOpacity(1),
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                              child: Text(
                                'Yes',
                                style: GoogleFonts.kreon(
                                  color: Colors.green,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              onPressed:() {
                                  final ref = FirebaseDatabase.instance.ref();
                                  ref.child('grants/${grant.grantKey}/applicants/$uid').remove().then((_) {
                                    showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: Color(0xCAEBF2).withOpacity(1),
                                      title: Center(child: Text(
                                        "Your application has been withdrawn",
                                        style: GoogleFonts.kreon(
                                            color: Colors.green.shade400,
                                            fontSize: 25,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                  })
                                  .catchError((error) {
                                    showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: Color(0xCAEBF2).withOpacity(1),
                                      title: Center(child: Text(
                                        "Failed to withdraw application. Please try again",
                                        style: GoogleFonts.kreon(
                                            color: Colors.green.shade400,
                                            fontSize: 25,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                    );
                                  });
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyApps()));
                              },
                          ),
                          TextButton(
                              child: Text(
                                'No',
                                style: GoogleFonts.kreon(
                                  color: Colors.red,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              onPressed:() {
                                Navigator.pop(context);
                              }
                          ),
                        ]
                      ),
                    ); 
                  },
                  child: Text(
                    'Withdraw',
                    style: GoogleFonts.oswald(
                      color: Color(0xFF3B3F).withOpacity(1),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
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
                      // Update application information in the database
                      _updateApplication(
                        grantKey: apps.grantKey,
                        newContactEmail: contactEmailController.text,
                        newContactName: contactNameController.text,
                        newContactPhone: contactPhoneController.text,
                        newNonProfitName: nonProfitNameController.text,
                        newResponse: responseController.text,
                        newWebsite: websiteController.text,
                      );
                      Navigator.push(context, new MaterialPageRoute(builder: (context) => MyApps()));
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
  Future<void> _updateApplication({
    required String grantKey,
      required String newContactEmail,
      required String newContactName,
      required String newContactPhone,
      required String newNonProfitName,
      required String newResponse,
      required String newWebsite,
    }) async {
    try {
      // Get a reference to the event node in the database
      DatabaseReference grantRef = FirebaseDatabase.instance.ref().child('grants/${grant.grantKey}/applicants/$uid');

      // Fetch existing event data from the database
      //grantRef.once().then((DataSnapshot snapshot) {
        //if (snapshot.value != null) {
          Map<String, dynamic> grantData = {
          'contactEmail': newContactEmail,
          'contactName': newContactName,
          'contactPhone': newContactPhone,
          'nonprofitName': newNonProfitName,
          'response': newResponse,
          'website': newWebsite,
        };

          // Update only the fields that are provided by the user
         /* if (newContactEmail.isNotEmpty) grantData['contactEmail'] = newContactEmail;
          if (newContactName.isNotEmpty) grantData['contactName'] = newContactName;
         if (newContactPhone.isNotEmpty) grantData['contactPhone'] = newContactPhone;
          if (newNonProfitName.isNotEmpty) grantData['nonprofitName'] = newNonProfitName;
          if (newResponse.isNotEmpty) grantData['response'] = newResponse;
          //if (newDescription.isNotEmpty) eventData['location'] = newDescription;
          if (newWebsite.isNotEmpty) grantData['website'] = newWebsite;
        */
          // Update the event information
          await grantRef.update(grantData).then((_) {
            // Event information updated successfully
            print('app information updated successfully');
          }).catchError((error) {
            // An error occurred while updating event information
            print('Error updating app information: $error');
          });
        //} else {
          // Event data not found
        //  print('app data not found');
      //  }
      //} as FutureOr Function(DatabaseEvent value).catchError((error) {
        // An error occurred while fetching event data
       // print('Error fetching app data: $error');
    //  });
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
        width: 300,
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
                    grant.getGrantName(),
                    textAlign: TextAlign.left,
                    style: GoogleFonts.kreon(
                      color: const Color(0x555555).withOpacity(1),
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    grant.getDonorName(),
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
    SizedBox(width: 300, height: 345,
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
                        '\t\t' + apps.nonprofitName,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Contact ',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        '\t\t' + apps.contactName,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 5),
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
                        '\t\t' + apps.contactPhone,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        'Email ',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        '\t\t' + apps.contactEmail,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Response: ',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                        ),
                        SizedBox(
                          width: 175,
                        child : Text(
                        '\t\t' + apps.response,
                        maxLines: 2,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                        ),
                        const SizedBox(height: 5),
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
                          height: 30,
                        child: Text(
                        '\t\t' + apps.website,
                        maxLines: 3,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                        ),
                        ),
                        const SizedBox(height: 15)
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
                            _showEditGrantDialog(context, grant.grantKey);
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