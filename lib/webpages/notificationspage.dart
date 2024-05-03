import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:givehub/webcomponents/donor_company_topbar.dart';
import 'package:givehub/webcomponents/np_topbar.dart';
import 'package:givehub/webcomponents/usertopbar.dart';
import 'package:google_fonts/google_fonts.dart';

import '../authentication/auth.dart';
import '../webcomponents/profilepicture.dart';


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
  String? userType;

 @override
  void initState() {
    super.initState();
    
    getUser().then((_) async {
      if (uid != null) {
        //sendNotificationsToSubscribers(uid!, message);
        getNotificationsFromDatabase(uid!); 
        userType = await getUserTypeFromDatabase(uid!);
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
      endDrawer: (userType?.toLowerCase() == 'nonprofit organization') ? NpTopBar() : DonorComTopBar(),
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
                     key: UniqueKey(), 
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
      
    );
  }
}
