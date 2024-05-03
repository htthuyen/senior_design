import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:givehub/webcomponents/donor_company_topbar.dart';
import 'package:givehub/webcomponents/usertopbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../authentication/auth.dart';
import 'eventsignuppage.dart';


class MyGrants extends StatefulWidget {
  @override
  _MyGrantsState createState() => _MyGrantsState();
}

class Grant {
  String grantKey;
  String grantName;
  String donorName;
  int grantAmount;
  String furtherRequirements;
  String eligibility;
  String paymentDetails;
  String grantDeadline;
  final df = DateFormat('MM-dd-yyyy hh:mm a');

  Grant({required this.grantKey, required this.furtherRequirements, required this.paymentDetails, required this.grantName, required this.donorName, required this.grantAmount, required this.eligibility, required this.grantDeadline});

  Map<String, dynamic> toJson() {
    return {
      'grantKey' : grantKey,
      'grantName': grantName,
      'donorName': donorName,
      'grantAmount': grantAmount,
      'furtherRequirements': furtherRequirements,
      'eligibility': eligibility,
      'paymentDetails': paymentDetails,
      'grantDeadline': grantDeadline
      //.toIso8601String(),
    };
  }
}

class _MyGrantsState extends State<MyGrants> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Grant> grants = [];
  bool isFavorite = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    
    getUser().then((_) {
      if (uid != null) {
        getGrantsFromDatabase(uid!); 
      } else {
        showSnackBar(context, 'User ID not found. Please log in again.');
        Navigator.pushReplacementNamed(context, '/login'); 
      }
    });
  }

  Future<void> getGrantsFromDatabase(String userId) async {
    try {
      List<Map<dynamic, dynamic>>? userGrants = await fetchGrantsFromDatabase(userId);

      if (userGrants != null) {
        setState(() {
          grants = userGrants.map((grantData) => Grant(
            
            grantKey: grantData['grantKey'],
            donorName: grantData['donorName'],
            eligibility: grantData['eligibility'],
            furtherRequirements: grantData['furtherRequirements'],
            grantAmount: grantData['grantAmount'],
            
            grantDeadline: grantData['grantDeadline'],
          
            grantName: grantData['grantName'],
              paymentDetails: grantData['paymentDetails'],
            //DateTime.parse(grantData['grantDeadline']),
          )).toList();
        });
      } else {
        print('No grants found for the user.');
      }
    } catch (e) {
      print('Error fetching user grants: $e');
      showSnackBar(context, 'Error fetching user grants. Please try again later.');
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
              String grantKey = key ?? ' ';
              String grantName = data['grantName'] ?? '';
              
              String donorName = data['donorName'] ?? '';
  
              int grantAmount = int.tryParse(data['grantAmount'] ?? '') ?? 0;

              String furtherRequirements = data['furtherRequirements'] ?? '';

              String eligibility = data['eligibility'] ?? '';

              String paymentDetails = data['paymentDetails'] ?? '';

              String grantDeadline = data['grantDeadline'] ?? '';

              Map<String, dynamic> grantData = {
                'grantKey': grantKey,
                'grantName': grantName,
                'donorName': donorName,
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
        endDrawer: DonorComTopBar(),
       body: grants.isEmpty ? buildNoEventsWidget(context) : buildEventsList(context),
        ),
      );
    }
     Widget buildNoEventsWidget(BuildContext context) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You have no grants.',
             style: GoogleFonts.oswald(fontSize: 40, color: const Color(0x555555).withOpacity(1)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, new MaterialPageRoute(
                builder: (context) =>
                  GrantCreationPage())
                );
              },
              child: Text('Create a grant.', style: GoogleFonts.oswald(fontSize: 20, color: Colors.white)),
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
                              itemCount: grants.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 225, 
                                crossAxisSpacing: 20, 
                                mainAxisSpacing: 20, 
                                mainAxisExtent: 400
                              ),
                              itemBuilder: (context, index) {
                                    final String donorName = grants[index].donorName;
                                    return FutureBuilder<List<dynamic>>(
                                      future: Future.wait([getGrantId(uid!)]),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text('Error: ${snapshot.error}');
                                        } else if (snapshot.data == null || snapshot.data!.isEmpty || snapshot.data![0] == null) {
                                          
                                          return Text('No grant ID found');
                                        } else {
                                          //debugPrint("${snapshot.data}");
                                          //String grantId = snapshot.data![0] as String;
                                         
                                          return MakeBoxGrant(
                                            //grantId: grantId,
                                            grantId : grants[index].grantKey,
                                            donorName: grants[index].donorName,
                                            eligibility: grants[index].eligibility,
                                            furtherRequirements: grants[index].furtherRequirements,
                                            grantAmount: grants[index].grantAmount,
                                            grantDeadline: grants[index].grantDeadline,
                                            grantName: grants[index].grantName,
                                            paymentDetails: grants[index].paymentDetails,
                                          );
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

class MakeBoxGrant extends StatelessWidget {
  final String grantName;
  final String donorName;
  final int grantAmount;
  final String furtherRequirements;
  final String eligibility;
  final String paymentDetails;
  final String grantDeadline;
  final String grantId;

  MakeBoxGrant({
    required this.grantName,
    required this.donorName,
    required this.grantAmount,
    required this.furtherRequirements,
    required this.eligibility,
    required this.paymentDetails,
    required this.grantDeadline,
    required this.grantId,
  });
    Future<void> _updateGrant({
      required String grantId,
      required String newGrantName,
      required String newDonorName,
      required String newGrantAmount,
      required String newFurtherRequirements,
      required String newEligibility,
      required String newPaymentDetails,
      required String newGrantDeadline,
    }) async {
      try {
        
        DatabaseReference grantRef = FirebaseDatabase.instance.reference().child('grants').child(grantId);

        
        Map<String, dynamic> grantData = {
          'grantName': newGrantName,
          'donorName': newDonorName,
          'grantAmount': newGrantAmount,
          'furtherRequirements': newFurtherRequirements,
          'eligibility': newEligibility,
          'paymentDetails': newPaymentDetails,
          'grantDeadline': newGrantDeadline,
        };

       
        await grantRef.update(grantData);

      
        print('Grant information updated successfully');
      } catch (e) {
        
        print('Error updating grant information: $e');
      }
    }

  void _showEditGrantDialog(BuildContext context, String grantId) {
    TextEditingController grantNameController = TextEditingController(text: grantName);
    TextEditingController donorNameController = TextEditingController(text: donorName);
    TextEditingController amountController = TextEditingController(text: grantAmount.toString());
    TextEditingController descriptionController = TextEditingController(text: furtherRequirements);
    TextEditingController eligibilityController = TextEditingController(text: eligibility);
    TextEditingController paymentController = TextEditingController(text: paymentDetails);
    TextEditingController deadlineController = TextEditingController(text: grantDeadline);

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
                'Edit Grant',
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
                      decoration: InputDecoration(labelText: 'Grant Name', labelStyle: GoogleFonts.oswald(fontWeight: FontWeight.w100, color: Color(0x555555).withOpacity(1))),
                      style: GoogleFonts.oswald(
                        color: Color(0x555555).withOpacity(1),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      controller: grantNameController,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Donor Name', labelStyle: GoogleFonts.oswald(fontWeight: FontWeight.w100, color: Color(0x555555).withOpacity(1))),
                      style: GoogleFonts.oswald(
                        color: Color(0x555555).withOpacity(1),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      controller: donorNameController,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Grant Amount', labelStyle: GoogleFonts.oswald(fontWeight: FontWeight.w100, color: Color(0x555555).withOpacity(1))),
                      style: GoogleFonts.oswald(
                        color: Color(0x555555).withOpacity(1),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      controller: amountController,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Further Details', labelStyle: GoogleFonts.oswald(fontWeight: FontWeight.w100, color: Color(0x555555).withOpacity(1))),
                      style: GoogleFonts.oswald(
                        color: Color(0x555555).withOpacity(1),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      controller: descriptionController,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Eligibility', labelStyle: GoogleFonts.oswald(fontWeight: FontWeight.w100, color: Color(0x555555).withOpacity(1))),
                      style: GoogleFonts.oswald(
                        color: Color(0x555555).withOpacity(1),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      controller: eligibilityController,
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Payment Details', labelStyle: GoogleFonts.oswald(fontWeight: FontWeight.w100, color: Color(0x555555).withOpacity(1))),
                      style: GoogleFonts.oswald(
                        color: Color(0x555555).withOpacity(1),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      controller: paymentController,
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      onTap: () async {
                        DateTime date = DateTime(1900);
                            FocusScope.of(context).requestFocus(new FocusNode());
                            date = ( await showDatePicker(
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
                              lastDate: DateTime(2100)
                            ))!;
                            deadlineController.text = DateFormat('yyyy-MM-dd').format(date);
                      },
                      decoration: InputDecoration(
                        labelText: 'Grant Deadline', 
                        labelStyle: GoogleFonts.oswald(
                          fontWeight: FontWeight.w100, 
                          color: Color(0x555555).withOpacity(1),
                        ),
                        
                      ),
                      style: GoogleFonts.oswald(
                        color: Color(0x555555).withOpacity(1),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      controller: deadlineController,
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
                          "Are you sure you would like to delete this grant?",
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
                                  ref.child('grants').child(grantId).remove().then((_) {
                                    showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: Color(0xCAEBF2).withOpacity(1),
                                      title: Center(child: Text(
                                        "Your grant has been deleted",
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
                                        "Grant failed to delete. Please try again",
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
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyGrants()));
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
                    'Delete',
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
                    if (grantNameController.text.isEmpty ||
                        donorNameController.text.isEmpty ||
                        amountController.text.isEmpty ||
                        descriptionController.text.isEmpty ||
                        eligibilityController.text.isEmpty ||
                        paymentController.text.isEmpty ||
                        deadlineController.text.isEmpty) {
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
                      // Update grant information in the database
                      _updateGrant(
                        newGrantName: grantNameController.text,
                        newDonorName: donorNameController.text,
                        newGrantAmount: amountController.text,
                        newFurtherRequirements: descriptionController.text,
                        newEligibility: eligibilityController.text,
                        newPaymentDetails: paymentController.text,
                        newGrantDeadline: deadlineController.text,
                        grantId: grantId,
                      );

                      Navigator.push(context, MaterialPageRoute(builder: (context) => MyGrants()));
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
              decoration: BoxDecoration(color: Color(0xCAEBF2).withOpacity(1)),
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          grantName,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.kreon(
                            color: const Color(0x555555).withOpacity(1),
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          donorName,
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
                                'Amount ',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.kreon(
                                  color: const Color(0x555555).withOpacity(1),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                '\t\t' + grantAmount.toString(),
                                textAlign: TextAlign.left,
                                style: GoogleFonts.kreon(
                                  color: const Color(0x555555).withOpacity(1),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Description: ',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.kreon(
                                  color: const Color(0x555555).withOpacity(1),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                '\t\t' + furtherRequirements,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.kreon(
                                  color: const Color(0x555555).withOpacity(1),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Eligibility: ',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.kreon(
                                  color: const Color(0x555555).withOpacity(1),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                '\t\t' + eligibility,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.kreon(
                                  color: const Color(0x555555).withOpacity(1),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Payment Details: ',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.kreon(
                                  color: const Color(0x555555).withOpacity(1),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(
                                child: Text(
                                  '\t\t' + paymentDetails,
                                  maxLines: 3,
                                  style: GoogleFonts.kreon(
                                    color: const Color(0x555555).withOpacity(1),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                              //const SizedBox(height: 20),
                              const SizedBox(height: 10),
                              Text(
                                'Deadline: ',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.kreon(
                                  color: const Color(0x555555).withOpacity(1),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(
                                child: Text(
                                  '\t\t' + grantDeadline,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () async {
                            _showEditGrantDialog(context, grantId);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xCAEBF2).withOpacity(1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: SizedBox(
                            height: 35,
                            width: 75,
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
