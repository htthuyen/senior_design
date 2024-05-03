import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  _SubscriptionPage createState() => _SubscriptionPage();
}

class User {
  String userName;
  String userId;
  bool isFavorite; 
  String subscriptionID;

  User({required this.userName,  required this.userId, required this.isFavorite, required this.subscriptionID});

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'isFavorite': isFavorite,
      'subscriptionID': subscriptionID,
    };
  }
}

class _SubscriptionPage extends State<SubscriptionPage> {
  List<User> _subscriptions = [];
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    getUsersFromDatabase();
      getUser().then((_) {
        if (uid != null) {
          //getGrantsFromDatabase(uid!); 
          getUsersFromDatabase();
        } else {
          showSnackBar(context, 'User ID not found. Please log in again.');
          Navigator.pushReplacementNamed(context, '/login'); 
        }
      });
  }
  Future<void> getUsersFromDatabase() async {
    try {
      List<Map<dynamic, dynamic>>? users = await fetchUsersFromDatabase();

      if (users != null) {
        setState(() {
          _subscriptions = users.map((userData) => User(
            userId: userData['userId'],
            userName: userData['userName'],
            isFavorite: userData['isFavorite'],
            subscriptionID: userData['subscriptionID'],
          )).toList();
        });
      } else {
        print('could not find users.');
      }
    } catch (e) {
      print('Error fetching users: $e');
      
    }
  }
  Future<List<Map<String, dynamic>>?> fetchUsersFromDatabase() async {
  final ref = FirebaseDatabase.instance.reference();

  try {
   
    var snapshot = await ref.child('subscriptions').orderByChild('userId').equalTo(uid).once();

    if (snapshot.snapshot.value != null) {
      Map<dynamic, dynamic>? data = snapshot.snapshot.value as Map<dynamic, dynamic>;

      if (data != null) {
        List<Map<String, dynamic>> allUsersList = [];
        data.forEach((key, userData) {
          if (userData != null) {
            String userName = userData['orgName'] ?? '';
            String userID = userData['userId'] ?? '';

            Map<String, dynamic> allUserData = {
              'userId': userID,
              'userName': userName,
              'isFavorite': true,
              'subscriptionID': key,
            };

            allUsersList.add(allUserData);
          }
        });
        //print(userId);
        return allUsersList;
      }
    }
  } catch (e) {
    print('Error retrieving user subscriptions: $e');
  }

  return null; 
}

    Future<void> deleteSubscriptionFromDatabase(String subscriptionID) async {
    final ref = FirebaseDatabase.instance.reference();

    try {
      await ref.child('subscriptions').child(subscriptionID).remove();
      
      
    } catch (e) {
      print('Error deleting subscription: $e');
    }
    }
void createNotification({
      required String userId, 
      required String orgName,
    }) {
      try {
        final notificationsRef = FirebaseDatabase.instance.reference().child('notifications');
        
        final notificationData = {
          'type': 'remove subscription',
          'detail': 'You have unsubscribed to $orgName',
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
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //the upgrade of flutter caused a shadow
      theme: ThemeData(
        useMaterial3: false,
      ),
      home: Scaffold(
        //the top portion of the webpage
        appBar: UserTopBar(),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'Subscriptions',
                style: GoogleFonts.oswald(
                  color: const Color.fromRGBO(85, 85, 85, 1),
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 370,
                  crossAxisSpacing: 30,
                  mainAxisSpacing: 20,
                ),
                itemCount: _subscriptions.length,
                itemBuilder: (context, index) => SizedBox(
                  child: Card(
                    key: ValueKey(_subscriptions[index].userId),
                    color: const Color.fromRGBO(202, 235, 242, 1),
                    elevation: 4,
                    margin: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            padding: const EdgeInsets.only(right: 40),
                            icon: Icon(
                              _subscriptions[index].isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: _subscriptions[index].isFavorite ? Colors.red : null,
                              applyTextScaling: true,
                              size: 40,
                            ),
                            onPressed: () {
                              setState(() {
                                      
                                      _subscriptions[index].isFavorite = !_subscriptions[index].isFavorite;
                                      String subscriptionID = _subscriptions[index].subscriptionID;
                                      if (!_subscriptions[index].isFavorite){
                                        deleteSubscriptionFromDatabase(_subscriptions[index].subscriptionID);
                                      }
                                      _subscriptions = _subscriptions.where((element) => element.subscriptionID != subscriptionID).toList();
                                      createNotification(userId:uid!, orgName: _subscriptions[index].userName);
                                    });
                            },
                          ),
                        ),
                        SizedBox(
                            height: 80,
                            width: 80,
                            child: CircleAvatar(
                              // FIX ME: Take image input as list from database or profile picture??
                              backgroundColor:
                                  const Color.fromRGBO(217, 217, 217, 1),
                              child: Text(
                                'P',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.oswald(
                                  color: const Color.fromRGBO(85, 85, 85, 1),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )),
                        Text(
                          _subscriptions[index].userName,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.oswald(
                            color: const Color.fromRGBO(85, 85, 85, 1),
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]
        ),
      ),
      ),
    );
  }
}
