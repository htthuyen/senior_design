import 'package:flutter/material.dart';
import 'package:givehub/webpages/np/grantstatus.dart';
import 'package:google_fonts/google_fonts.dart';

import '../authentication/auth.dart';
import 'company_donor/companyprofilepage.dart';
import 'company_donor/donorcompanydonationhistory.dart';
import 'company_donor/donorprofile.dart';
import 'np/createevent.dart';
import 'np/eventnp.dart';
import 'np/grantapp.dart';
import 'np/needs.dart';
import 'np/npdonationreview.dart';
import 'np/npprofilepage.dart';



class GrantS {
  String grantName;
  String donorName;
  String grantAmount;
  String furtherRequirements;
  String eligibility;
  String paymentDetails;
  String grantDeadline;
  //final df = DateFormat('MM-dd-yyyy hh:mm a');

  GrantS({
    required this.furtherRequirements, 
    required this.paymentDetails, 
    required this.grantName, 
    required this.donorName, 
    required this.grantAmount, 
    required this.eligibility, 
    required this.grantDeadline});

  Map<String, dynamic> toJson() {
    return {
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
class AllGrantsPage extends StatefulWidget {
  final String userId;

  AllGrantsPage({required this.userId});

  @override
  _AllGrantsPageState createState() => _AllGrantsPageState();
}

class _AllGrantsPageState extends State<AllGrantsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<GrantS> grants = []; 
  bool isFavorite = false;
  final _formKey = GlobalKey<FormState>();
  

 Future<void> fetchGrants(String userId) async {
    String? userType = await getUserTypeFromDatabase(userId);

    if (userType != null) {
      List<GrantS>? fetchedGrants = (await getGrantsFromDatabase(userId))!.cast<GrantS>();

      if (fetchedGrants != null) {
        setState(() {
          grants = fetchedGrants;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No grants found.'),
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
        fetchGrants(widget.userId); // Pass the actual user ID obtained from authentication
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
              color: Color.fromARGB(0, 18, 11, 11).withOpacity(1), 
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
          child: Row(
            children: [
              Text(
                'GiveHub',
                style: GoogleFonts.oswald(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
            ],
          ),
        ),
        centerTitle: false,
        backgroundColor: const Color(0xFFFF3B3F),
        actions: [
          IconButton(
            onPressed: () {
              
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
                                                  EventsNP())
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
                              'GRANTS',
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
                              mainAxisExtent: 400,
                            ),
                            itemBuilder: (context, index) {
    
                              return MakeBoxGrant(
                                grantName: grants[index].grantName,
                                donorName: grants[index].donorName,
                                grantAmount: grants[index].grantAmount,
                                furtherRequirements: grants[index].furtherRequirements,
                                eligibility: grants[index].eligibility,
                                paymentDetails: grants[index].paymentDetails,
                                grantDeadline: grants[index].grantDeadline
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

class MakeBoxGrant extends StatelessWidget {
  String grantName;
  String donorName;
  String  grantAmount;
  String furtherRequirements;
  String eligibility;
  String paymentDetails;
  String grantDeadline;
  //final df = DateFormat('MM-dd-yyyy hh:mm a');

  MakeBoxGrant({
    Key? key,
    required this.furtherRequirements, 
    required this.paymentDetails, 
    required this.grantName, 
    required this.donorName, 
    required this.grantAmount, 
    required this.eligibility, 
    required this.grantDeadline, 
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
                      grantName,
                      style: GoogleFonts.kreon(
                        color: const Color(0x555555).withOpacity(1),
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      donorName,
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
                      'Amount: ',
                      style: GoogleFonts.kreon(
                        color: const Color(0x555555).withOpacity(1),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 30, // Adjust height as needed
                      child: Text(
                        '\$' + grantAmount,
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
                      'Deadline: ',
                      style: GoogleFonts.kreon(
                        color: const Color(0x555555).withOpacity(1),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 30, 
                      child: Text(
                        grantDeadline,
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
                      'Eligibility: ',
                      style: GoogleFonts.kreon(
                        color: const Color(0x555555).withOpacity(1),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 30, 
                      child: Text(
                        eligibility,
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
                      'Payment Details: ',
                      style: GoogleFonts.kreon(
                        color: const Color(0x555555).withOpacity(1),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 30, 
                      child: Text(
                        paymentDetails,
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
                      'Further Requirements: ',
                      style: GoogleFonts.kreon(
                        color: const Color(0x555555).withOpacity(1),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 60, 
                      child: Text(
                        furtherRequirements,
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
                            Navigator.push(context, MaterialPageRoute(builder: (context) => GrantApp()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xCAEBF2).withOpacity(1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Apply for Grant',
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