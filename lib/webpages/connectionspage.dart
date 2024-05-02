import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../authentication/auth.dart';
import '../webcomponents/donor_company_topbar.dart';
import '../webcomponents/profilepicture.dart';
import '../webcomponents/usertopbar.dart';


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
      'userName': userName,
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
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
      appBar: UserTopBar(),
        endDrawer: DonorComTopBar(),
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

