import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:givehub/webcomponents/donor_company_topbar.dart';
import 'package:givehub/webcomponents/np_topbar.dart';
import 'package:givehub/webcomponents/usertopbar.dart';
import 'package:givehub/webpages/company_donor/myeventspage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../authentication/auth.dart';
import 'company_donor/companyprofilesearch.dart';
import 'company_donor/donorprofilesearch.dart';
import 'np/npprofilesearch.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPage createState() => _SearchPage();
}
class User {
  String userName;
  //String aboutUs;
  String userId;
  String userType;
  bool isFavorite; 

  User({required this.userName,  required this.userId, required this.userType, required this.isFavorite});

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
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

  String? usertype;
  @override
  void initState() {
    //_foundUsers = _allUsers;
    super.initState();
    getUser().then((_) async {
      if (uid != null) {
        //getGrantsFromDatabase(uid!); 
        getUsersFromDatabase(uid!);
        usertype = await getUserTypeFromDatabase(uid!);
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

              Map<String, dynamic> allUserData = {
                'userId': key,
                'userName': userName,
                'userType': userType
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
      // Add any additional subscription data fields here
    };

    // Get a reference to the user's node in the database
    final userRef = _database.child('users').child(currentUserUid);

    // Generate a unique key for the subscription using push
    final subscriptionRef = userRef.child('subscriptions').push();

    // Update the subscription data in the database
    subscriptionRef.set(updateSubData)
      .then((_) {
        print('Subscription added successfully.');
      })
      .catchError((error) {
        print('Error adding subscription: $error');
      });
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
        endDrawer: (usertype?.toLowerCase() == 'nonprofit organization') ? NpTopBar() : DonorComTopBar(),
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
                                    icon: const Icon(
                                      Icons.calendar_month,
                                      color: Color.fromRGBO(85, 85, 85, 1),
                                      size: 50,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) => MyEventsPage()));
                                    },
                                  ),
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
                                          email: 'nonprofit@example.com', // Replace with the nonprofit's email
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
                                      // Handle other user types or default case
                                      // For example, navigate to a generic profile page
                                      
                                      /*Navigator.pushNamed(
                                        context,
                                        '/companysearch',
                                        arguments: user.userId,
                                      );*/
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
