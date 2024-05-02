import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:givehub/webcomponents/donor_company_topbar.dart';
import 'package:givehub/webcomponents/usertopbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../authentication/auth.dart';
import 'companyprofilepage.dart';
import 'donationofinterestspage.dart';
import 'donorcompanydonationhistory.dart';
import 'donorpaymentpage.dart';
import 'donorprofile.dart';
import 'eventhistory.dart';
import 'eventsignuppage.dart';
import '../np/grantapp.dart';
import 'grantcreationpage.dart';
import 'myeventspage.dart';
import 'nonmondon.dart';
import '../notificationspage.dart';
import '../np/npprofilepage.dart';
import '../../webcomponents/profilepicture.dart';

class Grant {
  String grantKey;
  String grantName;
  String donorName;
  String email;
  String phone;
  int grantAmount;
  String furtherRequirements;
  String eligibility;
  String paymentDetails;
  String grantDeadline;
  //List<Application> applicants;

  Grant({required this.email, required this.phone, required this.grantKey, required this.paymentDetails, required this.furtherRequirements, required this.grantName, required this.donorName, required this.grantAmount, required this.eligibility, required this.grantDeadline});
  final df = DateFormat('MM-dd-yyyy hh:mm a');

  String getGrantName() {
    return grantName;
  }

  String getKey() {
    return grantKey;
  }

  String getDonorName() {
    return donorName;
  }

  String getEmail() {
    return email;
  }

  String getPhone() {
    return phone;
  }

  String getAmount() {
    return grantAmount.toString();
  }

  String getFurther() {
    return furtherRequirements;
  }

  String getEligibility() {
    return eligibility;
  }
  String getPayment() {
    return paymentDetails;
  }

  String getDeadline() {
    return grantDeadline;
  }
  
  Map<String, dynamic> toJson() {
    return {
       'grantName': grantName, 
       'donorName':donorName,
       'grantAmount': grantAmount, 
       'furtherRequirements': furtherRequirements,
       'eligibility': eligibility,
       'paymentDetails': paymentDetails,
       'grantDeadline': grantDeadline
    };
  }
}

class Application {
  String userID;
  String npName;
  String contactName;
  String contactPhone;
  String contactEmail;
  String website;
  String response;
  String status;

  Application({required this.status, required this.userID, required this.npName, required this.contactName, required this.contactPhone, required this.contactEmail, required this.website, required this.response});

  void setUserID(String s) { userID = s; }
  void setNpName(String s) { npName = s; }
  void setContactName(String s) { contactName = s; }
  void setContactPhone(String s) { contactPhone = s; }
  void setContactEmail(String s) { contactEmail = s; }
  void setWebsite(String s) { website = s; }
  void setResponse(String s) { response = s; }

  String getUserID() { return userID; }
  String getNpName() { return npName; }
  String getContactName() { return contactName; }
  String getContactPhone() { return contactPhone; }
  String getContactEmail() { return contactEmail; }
  String getWebsite() { return website; }
  String getResponse() { return response; }
}

class NPSelectionPage extends StatefulWidget {
  @override
  _NPSelectState createState() => _NPSelectState();
}

class _NPSelectState extends State<NPSelectionPage> {
  
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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

  List<String> nps = [];
  List<Grant> grants = [];
  List<List<Application>> apps = [];

  @override
  void initState() {
    super.initState();
    getUser().then((_) {
      if (uid != null) {
        getGrantsFromDatabase(uid!).then((_) {
          for (int i = 0; i < grants.length; i++) {
            Grant g = grants[i];
            getAppsFromDatabase(g.grantKey, i).then((_) {
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

    Future<void> getAppsFromDatabase(String g, int i) async {
    try {
      List<Map<dynamic, dynamic>>? dbApps = await fetchAppsFromDatabase(g);
      apps.add([]);
      if (dbApps != null) {
        setState(() {
          apps[i] = dbApps.map((appData) => Application(
            userID: appData['userKey'],
            npName: appData['nonprofitName'],
            contactEmail: appData['contactEmail'],
            contactPhone: appData['contactPhone'],
            contactName: appData['contactName'],
            website: appData['website'],
            response: appData['response'],
            status: appData['status'],
          )).toList();
        });
      } else {
        print('No applicants found for the user.');
      }
    } catch (e) {
      print('Error fetching applicants: $e');
      showSnackBar(context, 'Error fetching applicants. Please try again later.');
    }
  }
  Future<List<Map<String, dynamic>>?> fetchAppsFromDatabase(String grantID) async {
    final ref = FirebaseDatabase.instance.reference();

    try {
      var snapshot = await ref.child('grants/$grantID/applicants').once();

      if (snapshot.snapshot.value != null) {
        Map<dynamic, dynamic>? data = snapshot.snapshot.value as Map<dynamic, dynamic>;

        if (data != null) {
          List<Map<String, dynamic>> appsList = [];
          data.forEach((key, data) {
            if (data != null) {
              String contactEmail = data['contactEmail'] ?? ' ';
              String userKey = key ?? ' ';
              String contactName = data['contactName'] ?? '';
              String contactPhone = data['contactPhone'] ?? '';
              String npName = data['nonprofitName'] ?? '';
              String response = data['response'] ?? '';
              String website = data['website'] ?? '';
              String status = data['status'] ?? '';

              Map<String, dynamic> appData = {
                'contactEmail': contactEmail,
                'userKey': userKey,
                'contactName': contactName,
                'contactPhone': contactPhone,
                'nonprofitName': npName,
                'response': response,
                'website': website,
                'status': status,
              };
              appsList.add(appData);
              }
            }
          );
          return appsList;
        }
      }
    } catch (e) {
      print('Error retrieving applications: $e');
    }
    return null;
  }

  Future<void> getGrantsFromDatabase(String userID) async {
    try {
      List<Map<dynamic, dynamic>>? dbGrants = await fetchGrantsFromDatabase(userID);

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
        print('No grants found for the user.');
      }
    } catch (e) {
      print('Error fetching user grants: $e');
      showSnackBar(context, 'Error fetching grants. Please try again later.');
    }
  }
  Future<List<Map<String, dynamic>>?> fetchGrantsFromDatabase(String userId) async {
    final ref = FirebaseDatabase.instance.reference();

    try {
      var snapshot = await ref.child('grants').orderByChild('donorID').equalTo(userId).once();

      if (snapshot.snapshot.value != null) {
        Map<dynamic, dynamic>? data = snapshot.snapshot.value as Map<dynamic, dynamic>;

        if (data != null) {
          List<Map<String, dynamic>> grantsList = [];
          data.forEach((key, data) {
            if (data != null) {
              String donorID = data['donorID'] ?? ' ';
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
                'donorID' : donorID,
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


  @override
  Widget build(BuildContext context) {
    //List<String> nonProfits = List.generate(6, (index) => 'Nonprofit ${index + 1}');

    return Scaffold(
      key: _scaffoldKey,
      appBar: UserTopBar(),
      endDrawer: DonorComTopBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                Text(
                  'Grant Selection',
                  style: GoogleFonts.oswald(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0x555555).withOpacity(1),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Color(0xD9D9D9).withOpacity(1),
                  ),
                  width: 600,
                  child: Column(
                    children: [
                      ListView.builder(
                        itemCount: grants.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return makeBox(apps: apps[index], grant: grants[index]);
                        }
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class makeBox extends StatelessWidget {
  final Grant grant;
  final List<Application> apps;

makeBox({required this.apps, required this.grant});
  @override
  Widget build(BuildContext context) {
    return Padding(
  padding: const EdgeInsets.all(10.0),
      child: ExpansionTile(
        backgroundColor: Color(0xAAD1DA).withOpacity(1),
        title: Text(
          grant.getGrantName(),
          style: GoogleFonts.oswald(fontSize: 30, color: Color(0x55555).withOpacity(1)),
        ),
        children: [
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4, // Changed from 3 to 4
            children: apps.map((nonProfit) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          nonProfit.npName,
                          style: GoogleFonts.oswald(
                            color: const Color(0x555555).withOpacity(1),
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        content: Text(
                          "Status: ${nonProfit.status}\nContact: ${nonProfit.contactName}\nPhone: ${nonProfit.contactPhone}\nEmail: ${nonProfit.contactEmail}\nWebsite: ${nonProfit.website}\nResponse:  ${nonProfit.response}",
                          style: GoogleFonts.kreon(
                              color: const Color(0x555555).withOpacity(1),
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            ),
                        ),
                        actions: [
                          TextButton(
                            child: Text(
                              'Accept',
                              style: GoogleFonts.kreon(
                                color: Colors.green,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: Color(0xCAEBF2).withOpacity(1),
                                  title: Center(
                                    child: Text(
                                    "Are you sure you would like to accept ${nonProfit.getNpName()}'s application?",
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
                                            DatabaseReference grantRef = ref.child('grants').child(grant.getKey());
                                            DatabaseReference applicantsRef = grantRef.child('applicants/${nonProfit.getUserID()}');
                                            Map<String, String> updates = {
                                              'status' : "Accepted",
                                            };
                                            applicantsRef.update(updates);
                                            nonProfit.status = "Accepted";
                                            Navigator.pop(context);
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                backgroundColor: Color(0xCAEBF2).withOpacity(1),
                                                title: Center(child:Text(
                                                  "${nonProfit.getNpName()}'s application has been accepted!",
                                                  style: GoogleFonts.kreon(
                                                      color: Colors.green.shade400,
                                                      fontSize: 25,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
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
                            }
                          ),
                          TextButton(
                            child: Text(
                              'Reject',
                              style: GoogleFonts.kreon(
                                color: Colors.red,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: Color(0xCAEBF2).withOpacity(1),
                                  title: Center(
                                    child: Text(
                                    "Are you sure you would like to reject ${nonProfit.getNpName()}'s application?",
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
                                            DatabaseReference grantRef = ref.child('grants').child(grant.getKey());
                                            DatabaseReference applicantsRef = grantRef.child('applicants/${nonProfit.getUserID()}');
                                            Map<String, String> updates = {
                                              'status' : "Rejected",
                                            };
                                            applicantsRef.update(updates);
                                            nonProfit.status = "Rejected";
                                            Navigator.pop(context);
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                backgroundColor: Color(0xCAEBF2).withOpacity(1),
                                                title: Center(child:Text(
                                                  "${nonProfit.getNpName()}'s application has been rejected.",
                                                  style: GoogleFonts.kreon(
                                                      color: Colors.red.shade200,
                                                      fontSize: 25,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
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
                            }
                          ),
                          TextButton(
                            child: Text(
                              'Close',
                              style: GoogleFonts.kreon(
                                color: const Color(0x555555).withOpacity(1),
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            ),
                        ],
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: 
                    MaterialStateProperty.all(
                      Color(0xCAEBF2).withOpacity(1),
                    ),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.all(12),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      ProfilePicture(
                        name: nonProfit.getNpName(),
                        radius: 49,
                        fontSize: 21,
                      ),
                      SizedBox(height: 5),
                      Text(
                        nonProfit.npName,
                        style: GoogleFonts.oswald(
                          fontSize: 15,
                          color: Color(0x55555).withOpacity(1),
                        ),  
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}