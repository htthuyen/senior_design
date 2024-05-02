import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../authentication/auth.dart';
import '../webcomponents/profilepicture.dart';
import 'company_donor/companyprofilepage.dart';
import 'company_donor/donationofinterestspage.dart';
import 'company_donor/donorcompanydonationhistory.dart';
import 'company_donor/donorpaymentpage.dart';
import 'company_donor/donorprofile.dart';
import 'company_donor/eventhistory.dart';
import 'company_donor/eventsignuppage.dart';
import 'company_donor/grantcreationpage.dart';
import 'company_donor/myeventspage.dart';
import 'company_donor/nonmondon.dart';
import 'notificationspage.dart';
import 'np/grantapp.dart';
import 'np/npprofilepage.dart';


class ConnectionsPage extends StatefulWidget {
  const ConnectionsPage({Key? key});

  @override
  _ConnectionsPageState createState() => _ConnectionsPageState();
}
class User {
  String userName;
  //String aboutUs;
  String userId;
  String email;
  String userType;
  bool isFavorite; 

  User({required this.userName,  required this.userId, required this.email, required this.userType, required this.isFavorite});

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': name,
      'email': email,
      //'aboutUs': aboutUs,
      'userType': userType,
      'isFavorite': isFavorite,
      //'userId': userId
    };
  }
}
class _ConnectionsPageState extends State<ConnectionsPage> {
  final _database = FirebaseDatabase.instance.reference();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String? currentUserUid = uid;
  late Set<String> selectedInterests;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name = '';
  bool isFavorite = false;
  List<User> _foundUsers = [];

  @override
  void initState() {
    super.initState();
    getUserTypeFromDatabase(currentUserUid!);
    getUser();
    _loadSelectedInterests();
  }

  Future<void> _loadSelectedInterests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedInterests = prefs.getStringList('selectedInterests')?.toSet() ?? {};
    });
  }

  Future<Map<String, Map<String, dynamic>>> getNonprofitNeeds() async {
    Map<String, Map<String, dynamic>> nonprofitNeeds = {};

    try {
      DataSnapshot snapshot = await _database
          .child('users')
          .orderByChild('userType')
          .equalTo('Nonprofit Organization')
          .once()
          .then((snapshot) => snapshot.snapshot);

      if (snapshot.value != null) {
        (snapshot.value as Map<dynamic, dynamic>).forEach((key, value) async {
          if (value['selectedNeeds'] != null) {
            var needs = value['selectedNeeds'];
            if (needs is List) {
              nonprofitNeeds[key] = {
                'name': value['name'], 
                'needs': List<String>.from(needs.map((e) => e.toString())),
              };
            } else if (needs is String) {
              nonprofitNeeds[key] = {
                'name': value['name'], 
                'needs': needs.split(',').map((e) => e.trim()).toList(),
              };
            }
          }
        });
      }
    } catch (error) {
      print('Error fetching nonprofit needs: $error');
      throw Exception('Failed to fetch nonprofit needs.');
    }

    
    if (nonprofitNeeds.isEmpty) {
      throw Exception('No nonprofit needs found.');
    }

    return nonprofitNeeds;
  }
   Future<void> createSubscriptionAndPutInDatabase({
    required String name,
    required String nonprofitID,
  }) async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserUid != null) {
      final updateSubData = {
        'orgName': name,
        'orgID': nonprofitID,
        'type': 'user subscription',
        'userId': uid,
       
      };
      final subscriptionsRef = _database.child('subscriptions');

      final subscriptionRef = subscriptionsRef.push();

      try {
        
        await subscriptionRef.set(updateSubData);
        print('Subscription added successfully.');

        await createNotification(userId: currentUserUid, orgName: name);
      } catch (error) {
        print('Error adding subscription: $error');
        throw error; 
      }
    }
  }

  Future<void> createNotification({
    required String userId, 
    required String orgName,
  }) async {
    try {
      final notificationsRef = FirebaseDatabase.instance.reference().child('notifications');
      
      final notificationData = {
        'type': 'subscription',
        'detail': 'You have subscribed to $orgName',
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.white, // Change the color here
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
      body: Center(
      child: FutureBuilder<Map<String, Map<String, dynamic>>>(
        future: getNonprofitNeeds(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Map<String, Map<String, dynamic>>? nonprofitNeeds = snapshot.data;
            if (nonprofitNeeds == null || nonprofitNeeds.isEmpty) {
              return Center(child: Text('No data available'));
            } else {
              
              List<MapEntry<String, String>> flattenedNonprofits = [];
              nonprofitNeeds.forEach((nonprofitId, data) {
                List<String> needs = data['needs'] as List<String>;
                String name = data['name'] as String;
                for (String need in needs) {
                  flattenedNonprofits.add(MapEntry<String, String>(need, name));
                }
              });

              return SingleChildScrollView(
                child: _bildInterestSection(flattenedNonprofits, isFavorite),
              );
            }
          }
        },
      ),
    ),
      ); 
  }
  Widget _bildInterestSection(List<MapEntry<String, String>> flattenedNonprofits, bool isFavorite) {
   
    Set<String> displayedInterests = {};

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: flattenedNonprofits.map((entry) {
          String interest = entry.key;
          String nonprofitName = entry.value;
          if (displayedInterests.contains(interest)) {
           
            return SizedBox.shrink();
          }
         
          displayedInterests.add(interest);
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
                Text(
                  interest.replaceAll('{', '').replaceAll('}', '').replaceAll(': true', '').trim(),  
                  style: GoogleFonts.oswald(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: const Color(0x555555).withOpacity(1),
                  ),
                ),
                SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: flattenedNonprofits.where((e) => e.key == interest).map((entry) {
                      String nonprofitName = entry.value;
                      return Column(
                        children: [
                          _buildRecommendationCard(nonprofitName, isFavorite),
                          SizedBox(height: 10),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
  Widget _buildRecommendationCard(String nonprofitName, bool isCurrentlyFavorite) {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        height: 140,
        width: 170,
        margin: EdgeInsets.all(8.0),
        
          decoration: BoxDecoration(
            color: Color(0x00caebf2).withOpacity(1),
            
              borderRadius: BorderRadius.circular(20.0),
            
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Center(
                    child: ProfilePicture(
                      name: 'Profile',
                      radius: 20,
                      fontSize: 10,
                    ),
                  ),
                  Center(
                    child: Text(
                      nonprofitName,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.oswald(
                        color: const Color(0x555555).withOpacity(1),
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(
                    isCurrentlyFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isCurrentlyFavorite ? Colors.red : null,
                  ),
                  onPressed: () async {
                  
                    bool newFavoriteStatus = !isCurrentlyFavorite;

                    
                    final String? nonprofitId = await getUserId(nonprofitName);
                    print(nonprofitId);
                    
                    if (nonprofitId != null) {
                      
                      if (newFavoriteStatus) {
                        await createSubscriptionAndPutInDatabase(
                          name: nonprofitName,
                          nonprofitID: nonprofitId,
                        );
                      }

                    
                      setState(() {
                        isCurrentlyFavorite = newFavoriteStatus;
                      });
                    } else {
                      
                      print('Nonprofit ID not found for $nonprofitName');
                    }
                  },
                ),

              ),
            ],
          ),
        );
    });
  }
}

