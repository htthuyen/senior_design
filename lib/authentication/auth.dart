
import 'dart:async';
import 'dart:html';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../webpages/allgrants.dart';
import '../webpages/company_donor/companyprofilepage.dart';
import '../webpages/company_donor/donorprofile.dart';
import '../webpages/company_donor/myeventspage.dart';
import '../webpages/np/eventnp.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../webpages/np/npprofilepage.dart';

// Create an instance of FirebaseAuth, and add a few more variables
final FirebaseAuth _auth = FirebaseAuth.instance;

String? uid;
String? name;
String? userEmail;

// authenticating using email and password

Future<User?> registerWithEmailPassword(BuildContext context,String email, String password,
 String userType, String name, String phone) async {
  await  Firebase.initializeApp();

  User? user;
  DateTime signUpDate = DateTime.parse(DateTime.now().toIso8601String());
  int memberSince = signUpDate.year;

  // register a new user you van use the method
try {
  UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );
  user = userCredential.user;

  if(user != null) {
    uid = user.uid;
    userEmail = user.email;
      DatabaseReference userRef = FirebaseDatabase.instance.ref().child('users').child(user.uid);
        userRef.set({
          'email': user.email,
          'name': name,
          'userType': userType,
          'phoneNumber': phone,
          'memberSince': memberSince.toString(),
          'subscriptions': [],
          'uid': uid,
        });

  }
return user;
} on FirebaseAuthException catch (e) {
  if (e.code == 'weak-password'){
    showSnackBar(context, 'The passsword is too weak');
  } else if (e.code == 'email-already-in-use') {
    showSnackBar(context, 'The account already exists for that email.');
  }
} catch(e){
   print(e);
}
return null;

}
void showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message, style: GoogleFonts.oswald(fontSize: 16, color: Colors.red),),
    duration: Duration(seconds: 10),
    backgroundColor: Colors.blue[50],
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
// login for existed user
Future<void> signInWithEmailAndPassword(BuildContext context,String email, String password) async {
  await Firebase.initializeApp();
  User? user;

  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    user = userCredential.user;

    if(user != null){  
      uid = user.uid;
      userEmail = user.email;

    }

    String? userType = await getUserTypeFromDatabase(userCredential.user!.uid);
    // Navigate based on user type
    if (userType != null) {
      switch (userType.trim().toLowerCase()) {
        case 'individual donor':
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DonorProfilePage())); // Navigate to donor page
          break;
        case 'company':
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CompanyProfilePage())); // Navigate to company page
          break;
        case 'nonprofit organization':
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => NPProfilePage())); // Navigate to np profile page
          break;
        default:
          // Handle unknown user types
          break;
      }
    }

    

  } on FirebaseAuthException catch (e) {
    
    if (e.code == "invalid-credential") {
       showSnackBar(context, 'The account does not exists or incorrect password');
    } 
  } 

}


// signing out
Future<String> signOut() async {
  await _auth.signOut();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('auth', false);
  uid = null;
  userEmail = null;
  return 'Signed out';
  
}


Future<void> getUser() async {
  try {
    // Initialize Firebase if not already initialized
    await Firebase.initializeApp();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool authSignedIn = prefs.getBool('auth') ?? false;

    final User? user = _auth.currentUser;
    if (authSignedIn && user != null) {
      uid = user.uid;
      name = user.displayName;
      userEmail = user.email;
    }
  } catch (e) {
    // Handle errors
    print('Error in getUser(): $e');
  }
}


// Function to retrieve user type from the database
Future<String?> getUserTypeFromDatabase(String userId) async {
  final ref = FirebaseDatabase.instance.ref();
  final snap = await ref.child('users/$userId').get();
  final data = snap.value as Map<dynamic, dynamic>?;
    if (data != null && data.containsKey('userType')) {
      // Extract userType from the user data
      String? userType = data['userType'];

      // Return the userType
      return userType;
    } else {
      // User data not found or missing userType
      return null;
        
  }
}
Future<String?> getUserNameFromDatabase(String userId) async {
  final ref = FirebaseDatabase.instance.ref();
  final snap = await ref.child('users/$userId').get();
  final data = snap.value as Map<dynamic, dynamic>?;
    if (data != null && data.containsKey('name')) {
      // Extract userName from the user data
      String? userName = data['name'];

      // Return the userName
      return userName;
    } else {
      // User data not found or missing name
      return null;   
  }
}
Future<String?> getUserUIDFromDatabase(String userId) async {
  final ref = FirebaseDatabase.instance.ref();
  final snap = await ref.child('users').get();
  final data = snap.value as Map<dynamic, dynamic>?;
    if (data != null && data.containsKey('name')) {
      // Extract userName from the user data
      String? userName = data['name'];
      print(userId);
      print(uid);
      // Return the userName
      return userName;
    } else {
      // User data not found or missing name
      return null;   
  }
}

Future<void> registerEvent(BuildContext context, String organizationName, String eventName, String date, String time, String location, String contact, String eventDescription) async {
  try {
    // Initialize Firebase if not already initialized
    await Firebase.initializeApp();
    
    // Reference to the 'events' node in the database
    DatabaseReference eventRef = FirebaseDatabase.instance.ref().child('events');

    // Push a new child node under 'events' with auto-generated key
    DatabaseReference newEventRef = eventRef.push();

    // Set the event data under the new child node
   //String formattedDateTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.parse(dateTime));
  await newEventRef.set({
    'contact': contact,
    'date': date, 
    'time': time,
    'eventDescription': eventDescription,
    'eventName': eventName,
    'location': location,
    'orgName': organizationName,
  });

      String message = 'Subscription: $organizationName created a new event: $eventName.';
      sendNotificationsToSubscribers(message, organizationName);
    // Show success message or perform any other necessary actions
    // For example:
    showSnackBar(context, 'Event registered successfully!');
  } catch (e) {
    // Handle errors
    print('Error registering event: $e');
    showSnackBar(context, 'Error registering event. Please try again later.');
    throw e; // Re-throw the error to propagate it to the caller
  }
}



Future<List<EventforNP>?> getEventsFromDatabase(String uid) async {
  final ref = FirebaseDatabase.instance.reference();
  List<EventforNP> events = [];

  try {
    String? username = await getUserNameFromDatabase(uid);

    if (username != null) {
      var snapshot = await ref.child('events').orderByChild('orgName').equalTo(username).once();

      if (snapshot.snapshot.value != null) {
        Map<dynamic, dynamic>? data = snapshot.snapshot.value as Map<dynamic, dynamic>?;

        if (data != null) {
          data.forEach((key, eventData) {
            // Check if eventData or its properties are null before accessing them
            if (eventData != null ) {
              // Parse the date and time string using tryParse to handle potential parsing errors
              //DateTime? dateTime = DateTime.tryParse(eventData['dateTime']);
              
              //if (dateTime != null) {
                EventforNP event = EventforNP(
                  eventName: eventData['eventName'] ?? '',
                  orgName: eventData['orgName'] ?? '',
                  date: eventData['date'] ?? '',
                  time: eventData['time'] ?? '',
                  location: eventData['location'] ?? '',
                  contact: eventData['contact'] ?? '',
                  description: eventData['eventDescription'] ?? '',
                );
                events.add(event);
              } else {
                print('Error parsing date time string: ${eventData['dateTime']}');
              //}
            }
          });
        }
      }
    }
  } catch (e) {
    print('Error retrieving events: $e');
    return null;
  }

  return events.isEmpty ? null : events;
}
Future<String?> getEventId(String orgName, String eventName) async {
  try {
    final ref = FirebaseDatabase.instance.reference();
    final snapshot = await ref.child('events').once();

    final data = snapshot.snapshot.value as Map<dynamic, dynamic>?;

    if (data != null) {
      // Loop through each event
      for (var key in data.keys) {
        var eventData = data[key] as Map<dynamic, dynamic>;
        if (eventData['orgName'] == orgName && eventData['eventName'] == eventName) {
          print('Found matching event ID: $key'); // Print matching event ID
          return key; // Return the unique event ID
        }
      }
    }

    // If no matching event found after looping through all events or if data is null, print message and return null
    print('No matching event found');
    return null;
  } catch (e) {
    // Handle errors
    print('Error getting event ID: $e');
    return null;
  }
}
Future<String?> getUserId(String userName) async {
  try {
    final ref = FirebaseDatabase.instance.reference();
    final snapshot = await ref.child('users').once();

    final data = snapshot.snapshot.value as Map<dynamic, dynamic>?;

    if (data != null) {
      // Loop through each event
      for (var key in data.keys) {
        var eventData = data[key] as Map<dynamic, dynamic>;
        if (eventData['name'] == userName) {
          print('Found matching event ID: $key'); // Print matching event ID
          return key; // Return the unique event ID
        }
      }
    }

    // If no matching event found after looping through all events or if data is null, print message and return null
    print('No matching event found');
    return null;
  } catch (e) {
    // Handle errors
    print('Error getting event ID: $e');
    return null;
  }
}

Future<String?> getSubId(String userId, String orgName, String orgEmail) async {
  try {
    final ref = FirebaseDatabase.instance.reference();
    final snapshot = await ref.child('subscriptions').once();

    final data = snapshot.snapshot.value as Map<dynamic, dynamic>?;

    if (data != null) {
      // Loop through each event
      for (var key in data.keys) {
        var subData = data[key] as Map<dynamic, dynamic>;
        if (subData['userId'] == userId) {
          print('Found matching sub ID: $key'); // Print matching event ID
          return key; // Return the unique event ID
        }
      }
    } else {
      print('No data found in snapshot');
    }
    // If no matching event found, return null
    print('No matching sub found');
    return null;
  } catch (e) {
    // Handle errors
    print('Error getting sub ID: $e');
    return null;
  }
}
Future<void> userRegisterEvent(
  BuildContext context,
  String fullName,
  String email,
  String phoneNumber,
  String dateAvailable,
  String timeAvailable,
  String eventName,
  String orgName,
  bool optSubOut
) async {
  try {
    final ref = FirebaseDatabase.instance.reference();
    
    // Get the unique event ID using the getEventId function
    String? eventId = await getEventId(orgName, eventName);

    if (eventId != null) {
      DatabaseReference eventRef = ref.child('events').child(eventId);
      DatabaseReference attendeesRef = eventRef.child('attendees');

      // Create a map to hold attendee data
      Map<String, dynamic> attendeeData = {
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'dateAvailable': dateAvailable,
        'timeAvailable': timeAvailable,
        'optSubOut': optSubOut
      };

      attendeesRef.push().set(attendeeData);

      // Show success message or perform any other necessary actions
      showSnackBar(context, 'Event registration successful!');
    } else {
      // Handle case where event ID is not found
      showSnackBar(context, 'Error: Event not found.');
    }
  } catch (e) {
    // Handle errors
    print('Error registering event: $e');
    showSnackBar(context, 'Error registering event. Please try again later.');
    throw e; // Re-throw the error to propagate it to the caller
  }
}
Future<List<EventforUser>?> getUserEventsFromDatabase(String uid) async {
  final ref = FirebaseDatabase.instance.reference();
  List<EventforUser> userEvents = [];

  try {
    // Get the user's full name from the database
    String? username = await getUserNameFromDatabase(uid);

    if (username != null) {
      // Query the "events" node to find events the user has registered for
      var eventsSnapshot = await ref.child('events').once();

      // Check if eventsSnapshot is not null
      if (eventsSnapshot != null) {
        // Convert eventsSnapshot to Map<dynamic, dynamic>
        Map<dynamic, dynamic>? eventData = eventsSnapshot.snapshot.value as Map<dynamic, dynamic>?;

        // Check if eventData is not null
        if (eventData != null) {
          // Iterate through each event
          eventData.forEach((key, eventInfo) async {
            // Check if the event has attendees
            if (eventInfo['attendees'] != null) {
              // Iterate through attendees of this event
              Map<dynamic, dynamic> attendeesData = eventInfo['attendees'];
              attendeesData.forEach((attendeeKey, attendeeInfo) {
                // Check if the attendee matches the user's full name
                if (attendeeInfo['fullName'] == username) {
                  // Create an EventforUser object and add it to the list
                  EventforUser event = EventforUser(
                    eventName: eventInfo['eventName'] ?? '',
                    orgName: eventInfo['orgName'] ?? '',
                    date: eventInfo['date'] ?? '',
                    time: eventInfo['time'] ?? '',
                    location: eventInfo['location'] ?? '',
                    contact: eventInfo['contact'] ?? '',
                    description: eventInfo['eventDescription'] ?? '', 
                    isOptOut: eventInfo['isOptOut'] ?? '', 
                    isNotificationFilled: eventInfo['isNotificationFilled'] ?? ''
                  );
                  userEvents.add(event);
                }
              });
            }
          });
        }
      }
    }
  } catch (e) {
    print('Error retrieving user events: $e');
    return null;
  }

  return userEvents.isEmpty ? null : userEvents;
}
Future<String?> getGrantId(String userId) async {
  try {
    final ref = FirebaseDatabase.instance.reference();
    final snapshot = await ref.child('grants').once();

    final data = snapshot.snapshot.value as Map<dynamic, dynamic>?;

    if (data != null) {
      // Loop through each event
      for (var key in data.keys) {
        var grantData = data[key] as Map<dynamic, dynamic>;
        if (grantData['donorID'] == userId) {
          print('Found matching event ID: $key'); // Print matching event ID
          return key; // Return the unique event ID
        }
      }
    } else {
      print('No data found in snapshot');
    }
    // If no matching event found, return null
    print('No matching grant found');
    return null;
  } catch (e) {
    // Handle errors
    print('Error getting grant ID: $e');
    return null;
  }
}
Future<String?> getGrantNPId(String npUserId) async {
  try {
    final ref = FirebaseDatabase.instance.reference();
    final snapshot = await ref.child('grants').once();

    final data = snapshot.snapshot.value as Map<dynamic, dynamic>?;

    if (data != null) {
      // Loop through each grant
      for (var key in data.keys) {
        var grantData = data[key] as Map<dynamic, dynamic>;
        var applicants = grantData['applicants'] as Map<dynamic, dynamic>?;
        if (applicants != null) {
          // Loop through each applicant in the grant
          for (var applicantKey in applicants.keys) {
            var applicantData = applicants[applicantKey] as Map<dynamic, dynamic>;
            if (applicantData['contactEmail'] == npUserId) {
              print('Found matching grant ID: $key'); // Print matching grant ID
              return key; // Return the unique grant ID
            }
          }
        }
      }
    } else {
      print('No data found in snapshot');
    }
    // If no matching grant found, return null
    print('No matching grant found');
    return null;
  } catch (e) {
    // Handle errors
    print('Error getting grant ID: $e');
    return null;
  }
}
Future<String?> getNotId(String userId) async {
  try {
    final ref = FirebaseDatabase.instance.reference();
    final snapshot = await ref.child('notifications').once();

    final data = snapshot.snapshot.value as Map<dynamic, dynamic>?;

    if (data != null) {
      for (var key in data.keys) {
        var notData = data[key] as Map<dynamic, dynamic>;
        var notificationUserId = notData['userId'] as String?;
        if (notificationUserId == userId) {
          print('Found matching notification ID: $key');
          return key;
        }
      }
    } else {
      print('No data found in snapshot');
    }
    print('No matching notification found');
    return null;
  } catch (e) {
    print('Error getting notification ID: $e');
    return null;
  }
}
Future<String?> getSubscriptionId(String orgName) async {
  try {
    final ref = FirebaseDatabase.instance.reference();
    final snapshot = await ref.child('subscriptions').once();

    final data = snapshot.snapshot.value as Map<dynamic, dynamic>?;

    if (data != null) {
      for (var key in data.keys) {
        var notData = data[key] as Map<dynamic, dynamic>;
        var notificationOrgName = notData['orgName'] as String?;
        if (notificationOrgName == orgName) {
          print('Found matching notification ID: $key');
          return key;
        }
      }
    } else {
      print('No data found in snapshot');
    }
    print('No matching notification found for organization name: $orgName');
    return null;
  } catch (e) {
    print('Error getting notification ID: $e');
    return null;
  }
}

Future<String?> getSubscriptionUserId(String orgName, String subId) async {
  try {
    final ref = FirebaseDatabase.instance.reference();
    final snapshot = await ref.child('subscriptions').child(subId).once();

    final data = snapshot.snapshot.value as Map<dynamic, dynamic>?;

    if (data != null) {
      // Check if the orgName matches and return the userId
      if (data['orgName'] == orgName) {
         print('Found matching subuser ID: ${data['userId']}');
        return data['userId'];
      } else {
        print('No matching organization name found for subscription ID: $subId');
        return null;
      }
    } else {
      print('No data found in snapshot for subscription ID: $subId');
      return null;
    }
  } catch (e) {
    print('Error getting subscription user ID: $e');
    return null;
  }
}

Future<bool> isSubscribed(String userId, String orgName) async {
  final ref = FirebaseDatabase.instance.reference();
  try {
    var snapshot = await ref.child('subscriptions').once();
    if (snapshot.snapshot.value != null) {
      Map<dynamic, dynamic>? data = snapshot.snapshot.value as Map<dynamic, dynamic>;
      if (data != null) {
        for (var entry in data.entries) {
          if (entry.value['userId'] == userId) {
            return true;
          }
        }
      }
    }
  } catch (e) {
    print('Error checking subscription: $e');
  }
  return false;
}
Future<void> userApplyGrant(
  BuildContext context, 
  String grantKey,
  String orgName, 
  String website, 
  String contName, 
  String contEmail, 
  String contPhone, 
  String response,
) async {
  try {
    final ref = FirebaseDatabase.instance.ref();
    await getUser();
    if (uid != null) {
      if (grantKey != ' ') {
        DatabaseReference grantRef = ref.child('grants').child(grantKey);
        DatabaseReference applicantsRef = grantRef.child('applicants/$uid');

        // Create a map to hold applicant data
        Map<String, dynamic> applicantData = {
        'nonprofitName': orgName,
        'website': website,
        'contactName': contName,
        'contactEmail': contEmail,
        'contactPhone': contPhone,
        'response': response,
        };

        applicantsRef.set(applicantData);

        // Show success message or perform any other necessary actions
        showSnackBar(context, 'Grant submission successful!');
      } else {
        // Handle case where grant ID is not found
        showSnackBar(context, 'Error: Grant not found.');
      }
    } 
    else {
      // Handle case where user ID is not found
        showSnackBar(context, 'Error: User not found.');
    }
  } catch (e) {
    // Handle errors
    print('Error submitting application: $e');
    showSnackBar(context, 'Error submitting application. Please try again later.');
    throw e; // Re-throw the error to propagate it to the caller
  }
}
Future<List<Map<String, dynamic>>> fetchSubscribers(String subId, String userSubId) async {
  List<Map<String, dynamic>> subscribers = [];

  try {
    // Fetch the data snapshot from the database
    var snapshotEvent = await FirebaseDatabase.instance.reference().child('subscriptions').child(subId).once();
    
    // Access the snapshot from the event
    DataSnapshot snapshot = snapshotEvent.snapshot;

    // Check if there are any subscribers
    if (snapshot.value != null) {
      // Extract subscribers data
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      // Iterate over the children
      data.forEach((key, value) async {
        // Each child corresponds to a subscriber ID
        String subscriberId = key.toString();
        // Add subscriber to the list
        subscribers.add({'subscriberId': subscriberId});
      });
    } else {
      print('No subscribers found.');
    }
  } catch (e) {
    // Handle errors
    print('Error fetching subscribers: $e');
  }

  return subscribers;
}

// Function to send notifications to subscribers
Future<void> sendNotificationsToSubscribers(String message, String orgName) async {
  try {
    // Fetch subscription ID
    final String? subId = await getSubscriptionId(orgName);
    if (subId != null) {
      // Fetch subscribed user ID
      final String? subscribedUserId = await getSubscriptionUserId(orgName, subId);
      if (subscribedUserId != null) {
        // Fetch subscribers from the database
        List<Map<String, dynamic>> subscribers = await fetchSubscribers(subId, subscribedUserId);
        // Send notifications to subscribers
        DatabaseReference notificationRef = FirebaseDatabase.instance.reference().child('notifications').push();
        for (var subscriber in subscribers) {
          String subscriberId = subscriber['subscriberId']; // Corrected key
          await notificationRef.set({'detail': message, 'type': 'subscription', 'orgName': orgName, 'userId': subscribedUserId});// Store message under subscriber ID
        }
      } else {
        print('Subscribed user ID not found');
      }
    } else {
      print('Subscription ID not found');
    }
  } catch (e) {
    // Handle errors
    print('Error sending notifications: $e');
  }
}
Future<String?> getAttendeeId(String fullName, String orgName, String eventName, String eventId) async {
  try {
    final DatabaseReference attendeesRef = FirebaseDatabase.instance.reference().child('events').child(eventId).child('attendees');
    final DataSnapshot dataSnapshot = (await attendeesRef.once()).snapshot;

    final attendeesData = dataSnapshot.value as Map<dynamic, dynamic>?;

    if (attendeesData != null) {
      // Iterate through attendees to find the matching attendee
      for (var attendeeId in attendeesData.keys) {
        final attendee = attendeesData[attendeeId] as Map<dynamic, dynamic>;
        final attendeeFullName = attendee['fullName'] as String?;
        
        if (attendeeFullName == fullName) {
          print('Found matching attendee ID: $attendeeId');
          return attendeeId.toString();
        }
      }
    } else {
      print('No attendees found for event: $eventId');
    }

    print('No matching attendee found for fullName: $fullName, orgName: $orgName, eventName: $eventName, and eventId: $eventId');
    return null;
  } catch (e) {
    print('Error getting attendee ID: $e');
    return null;
  }
  
}

Future<List<Map<String, dynamic>>> fetchEventUnSubscribers(String orgName, String eventName, String userId, String eventId, String atendId) async {
  List<Map<String, dynamic>> unsubscribers = [];

  try {
    // Fetch attendees for the event
    var snapshot = await FirebaseDatabase.instance.reference().child('events').child(eventId).child('attendees').orderByChild(atendId!).once();

    // Check if there are any attendees
    if (snapshot.snapshot.value != null) {
      // Extract attendees data
      Map<dynamic, dynamic> data = snapshot.snapshot.value as Map<dynamic, dynamic>;
      
      // Iterate over the attendees
      data.forEach((key, value) {
        // Check if the attendee has opted out of notifications
        bool optOut = value['optSubOut'] ?? false;
        if (optOut) {
          // Add unsubscribers to the list
          unsubscribers.add({'subscriberId': key.toString()});
        }
      });
    } else {
      print('No attendees found for event: $eventName');
    }
  } catch (e) {
    // Handle errors
    print('Error fetching unsubscribers: $e');
  }

  return unsubscribers;
}

Future<List<Map<String, dynamic>>> fetchAttenders(String userSubId, String orgName, String eventName, String eventId, String atendId) async {
  List<Map<String, dynamic>> subscribers = [];

  try {
    // Fetch the data snapshot from the database
    var snapshotEvent = await FirebaseDatabase.instance.reference().child('events').child(eventId).child('attendees').orderByChild(atendId).once();
    
    // Access the snapshot from the event
    DataSnapshot snapshot = snapshotEvent.snapshot;

    // Check if there are any attendees
    if (snapshot.value != null) {
      // Extract attendees data
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      print(snapshot.value);
      // Iterate over the attendees
      data.forEach((key, value) async {
        // Check if the attendee has opted out of notifications
        bool optOut = value['optSubOut'];
        if (optOut == false && key.toString() != userSubId) {
          // Add the attendee to the list
          subscribers.add({'subscriberId': key.toString()});
        }
      });
    } else {
      print('No attendees found.');
    }
  } catch (e) {
    // Handle errors
    print('Error fetching attendees: $e');
  }

  return subscribers;
}


Future<void> sendNotificationsToAttenders(String message, String orgName, String eventName) async {
  try {
    // Fetch subscription ID
    final String? subId = await getSubscriptionId(orgName);
    if (subId != null) {
      // Fetch subscribed user ID
      
      final String? subscribedUserId = await getSubscriptionUserId(orgName, subId);
       final String? userName = await getUserNameFromDatabase(subscribedUserId!);
      final String? eventId = await getEventId(orgName, eventName);
      final String? atendId = await getAttendeeId(userName!, orgName, eventName, eventId!);
      //final String? userName = await getUserNameFromDatabase(subscribedUserId);
      if (subscribedUserId != null) {
        // Fetch subscribers from the database
        List<Map<String, dynamic>> subscribers = await fetchAttenders(subscribedUserId, orgName, eventName, eventId!, atendId!);
        List<Map<String, dynamic>> unsubscribers = await fetchEventUnSubscribers(orgName, eventName, subscribedUserId, eventId!, atendId!);
        // Send notifications to subscribers who haven't opted out
        DatabaseReference notificationRef = FirebaseDatabase.instance.reference().child('notifications').push();
        for (var subscriber in subscribers) {
          String subscriberId = subscriber['subscriberId'];
          final String? eventId = await getEventId(orgName, eventName!);
          // Fetch the attendee's notification preference
          
            await notificationRef.set({'detail': message, 'type': 'subscription', 'orgName': orgName, 'userId': subscribedUserId});// Store message under subscriber I
        }
      } else {
        print('Subscribed user ID not found');
      }
    } else {
      print('Subscription ID not found');
    }
  } catch (e) {
    // Handle errors
    print('Error sending notifications: $e');
  }
}

Future<List<GrantS>?> getGrantsFromDatabase(String uid) async {
  final ref = FirebaseDatabase.instance.reference();
  List<GrantS> grants = [];

  try {
    String? username = await getUserNameFromDatabase(uid);
    DateTime defaultDate = DateTime.now(); 

    if (username != null) {
      var snapshot = await ref.child('grants').orderByChild('donorID').equalTo(uid).once();

      if (snapshot.snapshot.value != null) {
        Map<dynamic, dynamic>? data = snapshot.snapshot.value as Map<dynamic, dynamic>?;

        if (data != null) {
          data.forEach((key, grantData) {
            // Check if eventData or its properties are null before accessing them
            if (grantData != null ) {
              // Parse the date and time string using tryParse to handle potential parsing errors
              //DateTime? dateTime = DateTime.tryParse(eventData['dateTime']);
              
              //if (dateTime != null) {
                GrantS grant = GrantS(
                  grantName: grantData['grantName'] ?? '',
                  donorName: grantData['donorName'] ?? '',
                  grantAmount: grantData['grantAmount'] ?? '',
                  furtherRequirements: grantData['furtherRequirements'] ?? '',
                  eligibility: grantData['eligibility'] ?? '',
                  paymentDetails: grantData['paymentDetails'] ?? '',
                  grantDeadline: grantData['grantDeadline'] ?? ''
                );
                grants.add(grant);
              } else {
                print('Error parsing date time string: ${grantData['dateTime']}');
              //}
            }
          });
        }
      }
    }
  } catch (e) {
    print('Error retrieving events: $e');
    return null;
  }

  return grants.isEmpty ? null : grants;
}