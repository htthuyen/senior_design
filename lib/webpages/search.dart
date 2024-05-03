import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:givehub/donorprofilesearch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth.dart';
import 'companyprofilesearch.dart';
import 'npprofilesearch.dart';
import 'donorprofilesearch.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPage createState() => _SearchPage();
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
      //'isFavorite': isFavorite,
      //'userId': userId
    };
  }
}
class _SearchPage extends State<SearchPage> {
  bool isFavorite = false;
  List<User> _foundUsers = [];
  final DatabaseReference _database = FirebaseDatabase.instance.reference();


  @override
  void initState() {
    //_foundUsers = _allUsers;
    super.initState();
    getUser().then((_) {
      if (uid != null) {
        //getGrantsFromDatabase(uid!); 
        getUsersFromDatabase(uid!);
      } else {
        showSnackBar(context, 'User ID not found. Please log in again.');
        Navigator.pushReplacementNamed(context, '/login'); 
      }
    });
  }
  Future<void> getUsersFromDatabase(String userId) async {
    try {
      List<Map<dynamic, dynamic>>? users = await fetchUsersFromDatabase(userId);

      if (users != null) {
        setState(() {
          _foundUsers = users.map((userData) => User(
            userId: userData['userId'],
            userName: userData['userName'],
            email: userData['email'],
            //aboutUs: userData['aboutUs'],
            userType: userData['userType'],
            isFavorite: false,
            //userId: userData['userId']
          )).toList();
        });
      } else {
        print('could not find users.');
      }
    } catch (e) {
      print('Error fetching users: $e');
      showSnackBar(context, 'Error fetching users. Please try again later.');
    }
  }
  Future<List<Map<String, dynamic>>?> fetchUsersFromDatabase(String userId) async {
    final ref = FirebaseDatabase.instance.reference();

    try {
      var snapshot = await ref.child('users').once();

      if (snapshot.snapshot.value != null) {
        Map<dynamic, dynamic>? data = snapshot.snapshot.value as Map<dynamic, dynamic>;

        if (data != null) {
          List<Map<String, dynamic>> allUsersList = [];
          data.forEach((key, userData) {
            //print('Data for user with key $key: $data');
            // Ensure that userData is not null
            if (userData != null) {
              String userName = userData['name'] ?? '';
              String userType = userData['userType'] ?? '';
              String email = userData['email'] ?? '';

              Map<String, dynamic> allUserData = {
                'userId': key,
                'userName': userName,
                'userType': userType,
                'email': email
              };

              allUsersList.add(allUserData);
            }
          });
          print(userId);
          return allUsersList;
        }
      }
    } catch (e) {
      print('Error retrieving all users: $e');
    }

    return null; 
  }


  void _runFilter(String entry) {
    List<User> results = [];

    if (entry.isEmpty) {
      
      getUsersFromDatabase(uid!);
    } else {
      results = _foundUsers.where((user) {
        
        final normalizedUserName = user.userName.toLowerCase();
         final normalizedUserNameEntry = entry.toLowerCase();
        final normalizedUserType = user.userType.toLowerCase();
        final normalizedUserEntry = entry.toLowerCase();

        
        return normalizedUserType.contains(normalizedUserEntry) ||
            normalizedUserEntry.contains(normalizedUserType) || 
            normalizedUserNameEntry.contains(normalizedUserName) || 
            normalizedUserName.contains(normalizedUserNameEntry);
      }).toList();

      setState(() {
        _foundUsers = results;
      });
    }
  }

  void createSubscriptionAndPutInDatabase({
  required String name,
  required String email,
}) {
  final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

  if (currentUserUid != null) {
    final updateSubData = {
      'orgName': name,
      'orgEmail': email,
      'type': 'user subscription',
      'userId': uid,
      // Add any additional subscription data fields here
    };

    // Get a reference to the subscriptions table in the database
    final subscriptionsRef = _database.child('subscriptions');

    // Use the userId as the unique key for the subscription
    final subscriptionRef = subscriptionsRef.push();

    // Update the subscription data in the subscriptions table
    subscriptionRef.set(updateSubData)
      .then((_) {
        print('Subscription added successfully.');

        // Now, you can perform additional actions if needed
        createNotification(userId: currentUserUid, orgName: name);
      })
      .catchError((error) {
        print('Error adding subscription: $error');
      });
  }
}


void createNotification({
  required String userId, // Assuming you have the userId
  // required String type,
  // required String detail,
  required String orgName,
}) {
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
        appBar:UserTopBar(),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
             TextField(
                onChanged: (value) {
                  _runFilter(value);
                },
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _foundUsers.length,
                  itemBuilder: (context, index) => SizedBox(
                    height: 125,
                    child: Card(
                        key: ValueKey(_foundUsers[index].userId),
                        color: const Color.fromRGBO(202, 235, 242, 1),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                  height: 75,
                                  width: 75,
                                  child: CircleAvatar(
                                    backgroundColor:
                                        const Color.fromRGBO(217, 217, 217, 1),
                                    child: Text(
                                      'P',
                                      style: GoogleFonts.oswald(
                                        color:
                                            const Color.fromRGBO(85, 85, 85, 1),
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )),
                              SizedBox(
                                height: 125,
                                width: 100,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(_foundUsers[index].userName,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.oswald(
                                    color: const Color.fromRGBO(85, 85, 85, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  )),

                                ),
                              ),
                              SizedBox(
                                height: 125,
                                width: 100,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                      _foundUsers[index].userType,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.oswald(
                                        color:
                                            const Color.fromRGBO(85, 85, 85, 1),
                                        fontSize: 20,
                                      )),
                                ),
                              ),
                              
                              SizedBox(
                                height: 125,
                                width: 50,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: IconButton(
                                  icon: Icon(
                                    _foundUsers[index].isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: _foundUsers[index].isFavorite
                                        ? Colors.red // Change color to red for favorite
                                        : null,
                                    size: 50,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      // Toggle favorite status for the corresponding user
                                      _foundUsers[index].isFavorite = !_foundUsers[index].isFavorite;

                                      // If the user is now marked as favorite, subscribe to the nonprofit
                                      if (_foundUsers[index].isFavorite) {
                                        createSubscriptionAndPutInDatabase(
                                          name: _foundUsers[index].userName, // Assuming userName represents the nonprofit name
                                          email: _foundUsers[index].email,
                                        );
                                      }
                                    });
                                  },
                                ),
                                ),
                              ),
                              SizedBox(
                                  height: 125,
                                  width: 100,
                                  child: TextButton(
                                  child: Text(
                                    'Visit Profile >>',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.oswald(
                                      color: const Color.fromRGBO(85, 85, 85, 1),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  onPressed: () {
                                    // Retrieve the user from _foundUsers
                                    User user = _foundUsers[index];

                                    // Determine the user type
                                    String userType = user.userType.toLowerCase();

                                    // Navigate to the corresponding profile page based on user type
                                    if (userType == 'individual donor') {
                                      Navigator.push( context,MaterialPageRoute(
                                        builder: (context) => DonorProfileSearchPage(userId: user.userId),
                                      ),);
                                    } else if (userType == 'nonprofit organization') {
                                      Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NPProfileSearchPage(userId: user.userId),
                                      ),
                                    );
                                    } else if (userType == 'company'){
                                      
                                      Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CompanyProfileSearchPage(userId: user.userId),
                                      ),
                                    );
                                    }
                                  },
                                ),
                                ),
                            ])),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
