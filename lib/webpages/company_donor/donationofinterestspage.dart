import 'package:flutter/material.dart';
import '../connectionspage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:givehub/authentication/auth.dart';
import 'companyprofilepage.dart';
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


class DonationOfInterestsPage extends StatefulWidget {
  const DonationOfInterestsPage({super.key});

  @override
  _DonationOfInterestsPageState createState() => _DonationOfInterestsPageState();
}

class _DonationOfInterestsPageState extends State<DonationOfInterestsPage> {
    late SharedPreferences _prefs;
  Set<String> selectedInterests = {};
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadSelectedInterests();
  }

  Future<void> _loadSelectedInterests() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedInterests = _prefs.getStringList('selectedInterests')?.toSet() ?? {};
    });
  }

  void toggleSelection(String need) {
    setState(() {
      if (selectedInterests.contains(need)) {
        selectedInterests.remove(need);
      } else {
        selectedInterests.add(need);
      }
      _prefs.setStringList('selectedInterests', selectedInterests.toList());
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
  void dispose() {
    // Clear selected interests when the page is disposed
    _prefs.remove('selectedInterests');
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
     return Scaffold(
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
            ),
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
                        onTap: () {
                          final isValid = _formKey.currentState!.validate();
                               
                            String? userType = getUserTypeFromDatabase(uid!) as String?;
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
                          Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                            EventSignUpPage())
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
                          Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                            GrantApp())
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
                      Navigator.push(context, new MaterialPageRoute(
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
                      /* Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                            new SubscriptionsPage())
                       );*/
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
      body: Column(
        children: [
          Expanded(
            flex: 0,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: Text(
                'Please Select What Your Current Interests Are',
                style: GoogleFonts.oswald(
                  color: const Color(0x555555).withOpacity(1),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: const Color(0x00caebf2).withOpacity(1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Buttons for needs
                      _buildNeedButton(Icons.car_rental, 'Vehicles', 'vehicles'),
                      _buildNeedButton(Icons.chair, 'Furniture', 'furniture'),
                      _buildNeedButton(Icons.volunteer_activism, 'Volunteer', 'volunteer'),
                      _buildNeedButton(Icons.paid, 'Monetary', 'monetary'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNeedButton(Icons.checkroom, 'Clothing', 'clothing'),
                      _buildNeedButton(Icons.food_bank, 'Non-Perishables', 'non-perishables'),
                      _buildNeedButton(Icons.local_hospital, 'Medical', 'medical'),
                      _buildNeedButton(Icons.sentiment_satisfied_alt, 'Other', 'other'),
                    ],
                  ),
                  // Continue button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xAAD1DA).withOpacity(1),
                    ),
                    onPressed: () {
                       Navigator.push(context, new MaterialPageRoute(
                                                builder: (context) =>
                                                  ConnectionsPage())
                                                );
                    },
                    child: Text(
                      'Continue',
                      style: GoogleFonts.oswald(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Color(0x555555).withOpacity(1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeedButton(IconData icon, String label, String need) {
    final isSelected = selectedInterests.contains(need);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: GoogleFonts.oswald(
            color: const Color(0x555555).withOpacity(1),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          height: 140,
          width: 170,
          child: ElevatedButton(
            onPressed: () {
              toggleSelection(need);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return isSelected ? Color(0xAAD1DA).withOpacity(1) : Colors.white.withOpacity(1);
                  }
                  return isSelected ? Color(0xAAD1DA).withOpacity(1) : Colors.white.withOpacity(1);
                },
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Color(0xAAD1DA).withOpacity(1),
              size: 55,
            ),
          ),
        ),
      ],
    );
  }

}