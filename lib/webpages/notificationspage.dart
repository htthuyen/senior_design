import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:givehub/webpages/np/grantstatus.dart';
import 'package:google_fonts/google_fonts.dart';

import '../authentication/auth.dart';
import '../webcomponents/profilepicture.dart';
import 'company_donor/companyprofilepage.dart';
import 'company_donor/donorcompanydonationhistory.dart';
import 'company_donor/donorprofile.dart';
import 'np/createevent.dart';
import 'np/eventnp.dart';
import 'np/grantapp.dart';
import 'np/myapps.dart';
import 'np/needs.dart';
import 'np/npdonationreview.dart';
import 'np/npprofilepage.dart';
import 'subscription.dart';


class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}
class MyNotification {
  String detail;
  String orgName;
  String type;
  String userID;
  

  MyNotification({
    required this.detail, 
    required this.orgName,
    required this.type, 
    required this.userID, 
    });

  Map<String, dynamic> toJson() {
    return {
      'detail': detail,
      'orgName': orgName,
      'type': type,
      'userID': userID,
    };
  }
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<MyNotification> notifications = [];
  String detail = '';
  String orgName = '';
  String type = '';
  String userId = '';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

 @override
  void initState() {
    super.initState();
    
    getUser().then((_) {
      if (uid != null) {
        //sendNotificationsToSubscribers(uid!, message);
        getNotificationsFromDatabase(uid!); 
      } else {
        showSnackBar(context, 'User ID not found. Please log in again.');
        Navigator.pushReplacementNamed(context, '/login'); 
      }
    });
  }
Future<void> getNotificationsFromDatabase(String userId) async {
  try {
    List<Map<dynamic, dynamic>>? userNotifications = await fetchNotificationsFromDatabase(userId);

    if (userNotifications != null) {
      setState(() {
        notifications = userNotifications.map((notificationData) => MyNotification(
          detail: notificationData['detail'],
          orgName: notificationData['orgName'],
          type: notificationData['type'],
          userID: notificationData['userId'].toString(), 
        )).toList();
      });
    } else {
      print('No notifications found for the user.');
    }
  } catch (e) {
    print('Error fetching user notifications: $e');
    showSnackBar(context, 'Error fetching user notifications. Please try again later.');
  }
}
Future<List<Map<String, dynamic>>?> fetchNotificationsFromDatabase(String userId) async {
  final ref = FirebaseDatabase.instance.reference();

  try {
    final String? notId = await getNotId(userId);
    var snapshot = await ref.child('notifications').once();

    if (snapshot.snapshot.value != null) {
      Map<dynamic, dynamic>? data = snapshot.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        List<Map<String, dynamic>> notificationsList = [];
        data.forEach((key, data) {
          String detail = data['detail'] ?? '';
          String orgName = data['orgName'] ?? '';
          String type = data['type'] ?? '';
          String notificationUserId = data['userId'] ?? ''; 

          if (notificationUserId == userId) { 
            Map<String, dynamic> notification = {
              'detail': detail,
              'orgName': orgName,
              'type': type,
              'userId': notificationUserId,
            };
            notificationsList.add(notification);
          }
        });
        return notificationsList;
      }
    }
  } catch (e) {
    print('Error retrieving notifications: $e');
  }

  return null;
}

Future<void> removeNotificationFromDatabase(String userId) async {
  final ref = FirebaseDatabase.instance.reference();
  try {
    final String? notId = await getNotId(userId);
    await ref.child('notifications').child(notId!).remove();
    print('Notification removed from the database for userId: $userId');
  } catch (e) {
    print('Error removing notification from the database: $e');
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
      endDrawer: ,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notifications',
                style: GoogleFonts.oswald(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0x555555).withOpacity(1),
                ),
              ),
              SizedBox(height: 20), 
              Expanded(
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(notifications[index].userID.toString()), 
                      direction: DismissDirection.endToStart,
                     onDismissed: (direction) async {
                        try {
                         
                          await removeNotificationFromDatabase(notifications[index].userID);
                          
                         
                          setState(() {
                            notifications.removeAt(index);
                          });
                        } catch (e) {
                          print('Error removing notification from database: $e');
                          
                          showSnackBar(context, 'Error removing notification. Please try again later.');
                        }
                      },

                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20),
                        color: Color(0xAAD1DA).withOpacity(1),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Card(
                          elevation: 3,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xCAEBF2).withOpacity(1),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            padding: EdgeInsets.all(12),
                            child: Row(
                              children: [
                                ProfilePicture(name: 'P', radius: 20, fontSize: 16),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        notifications[index].detail,
                                        style: GoogleFonts.oswald(fontSize: 14, color: Color(0x555555).withOpacity(1)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
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
                      ListTile(
                        title: Text(
                          'Your Applications',
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                            MyApps())
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
                      Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                            SubscriptionPage())
                          );
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
    );
  }
}
