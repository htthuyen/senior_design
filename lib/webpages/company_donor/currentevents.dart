import 'package:flutter/material.dart';
import 'package:givehub/webcomponents/donor_company_topbar.dart';
import 'package:givehub/webcomponents/usertopbar.dart';
import 'eventsignuppage.dart';
import 'package:givehub/authentication/auth.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EventSp {
  String eventName;
  String orgName;
  String date;
  String time;
  String location;
  String contact;
  String description;
  String eventKey;

  EventSp({required this.eventName, required this.orgName, required this.date, required this.time, required this.location, required this.contact, required this.description, required this.eventKey});
  final df = DateFormat('MM-dd-yyyy hh:mm a');

  String getEventName() {
    return eventName;
  }

  String getKey() {
    return eventKey;
  }

  String getOrgName() {
    return orgName;
  }

  String getDate() {
    return date;
  }

  String getTime() {
    return time;
  }

  String getDescription() {
    return description;
  }

  String getLocation() {
    return location;
  }

  String getContact() {
    return contact;
  }
  
  
  Map<String, dynamic> toJson() {
    return {
          'eventName': eventName,
          'orgName': orgName,
          'date': date,
          'time': time,
          'location': location,
          'contact': contact,
          'description': description,
          'eventKey': eventKey,
    };
  }
}

class CurrentEventsPage extends StatefulWidget {
  @override
  _CurrentEventsPageState createState() => _CurrentEventsPageState();
}

class _CurrentEventsPageState extends State<CurrentEventsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<EventSp> events = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getEvents();
  }

  Future<void> getEvents() async {
    try {
      List<Map<dynamic, dynamic>>? dbEvents = await fetchEventsFromDatabase();

      if (dbEvents != null) {
        setState(() {
          events = dbEvents.map((grantData) => EventSp(
            eventName: grantData['eventName'],
            orgName: grantData['orgName'],
            date: grantData['date'],
            time: grantData['time'],
            location: grantData['location'],
            contact: grantData['contact'],
            description: grantData['description'],
            eventKey: grantData['eventKey'],
          )).toList();
        });
      } else {
        print('No grants found.');
      }
    } catch (e) {
      print('Error fetching grants: $e');
      showSnackBar(context, 'Error fetching grants. Please try again later.');
    }
  }
  Future<List<Map<String, dynamic>>?> fetchEventsFromDatabase() async {
    final ref = FirebaseDatabase.instance.reference();

    try {
      var snapshot = await ref.child('events').once();

      if (snapshot.snapshot.value != null) {
        Map<dynamic, dynamic>? data = snapshot.snapshot.value as Map<dynamic, dynamic>;

        if (data != null) {
          List<Map<String, dynamic>> grantsList = [];
          data.forEach((key, data) {
            if (data != null) {
              String eventKey = key ?? ' ';  
              String eventName = data['eventName'] ?? '';
              String orgName = data['orgName'] ?? '';
              String date = data['date'] ?? '';
              String time = data['time'] ?? '';
              
              String location = data['location'] ?? '';
              String contact = data['contact'] ?? '';
              String description = data['description'] ?? '';
              

              Map<String, dynamic> grantData = {
                'eventName': eventName,
                'orgName': orgName,
                'date': date,
                'time': time,
                'location': location,
                'contact': contact,
                'description': description,
                'eventKey': eventKey,
              };
              grantsList.add(grantData);
            }
          });
          return grantsList;
        }
      }
    } catch (e) {
      print('Error retrieving grants: $e');
    }
    return null;
  }

  List<EventSp> searchResults = [];
  void onQueryChanged(String query) {
    search = true;
    setState(() {
      searchResults = events.where((item) => item.eventName.toLowerCase().contains(query.toLowerCase())).toList();  
    });
  }
  bool search = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: UserTopBar(),
        endDrawer: DonorComTopBar(),
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
                              'Events',
                              style: GoogleFonts.oswald(
                                color: const Color(0x555555).withOpacity(1),
                                fontSize: 32,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            alignment: Alignment.topRight,
                            padding: EdgeInsets.only(left: 20, right : 20, bottom: 30, top: 60),
                            child: TextField(
                              onChanged: (value) {onQueryChanged(value);},
                              controller: searchController,
                              style: GoogleFonts.kreon(
                                color: const Color(0x555555).withOpacity(1),
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                filled: true,
                                fillColor: const Color(0xD9D9D9).withOpacity(1),
                                hintText: 'Search...',
                                hintStyle: GoogleFonts.kreon(
                                  color: const Color(0x555555).withOpacity(1),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w300,
                                ),
                                contentPadding: EdgeInsets.only(left: 12, bottom: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(color: Color(0xAAD1DA).withOpacity(1), width: 2),
                                  ),
                                ),
                            )
                          ),
                        ),
                        /*Container(
                          alignment: Alignment.topRight,
                          padding: const EdgeInsets.only(left: 20, right : 50, bottom: 10, top: 25),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xAAD1DA).withOpacity(1),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: SizedBox(height: 25, width: 75,
                              child: Text(
                                'Filter',  
                                textAlign: TextAlign.center, 
                                style: GoogleFonts.kreon(
                                  color: const Color(0x555555).withOpacity(1),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),*/
                        const SizedBox(width: 100),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(width: 50),
                        Expanded(
                          child: GridView.builder (
                            itemCount: search ? searchResults.length : events.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 225, crossAxisSpacing: 20, mainAxisSpacing: 20, mainAxisExtent: 275),
                            itemBuilder: (context, index) {
                              return search ? makeBox(event: searchResults[index]): makeBox(event: events[index]);
                            },
                          ),
                        ),
                        const SizedBox(width: 50),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]
        )
    );
  }
}

class makeBox extends StatelessWidget {
final EventSp event;


makeBox({required this.event});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
      SizedBox(
        width: 250,
        height: 55,
        child: DecoratedBox(
        decoration: BoxDecoration(color:Color(0xAAD1DA).withOpacity(1),),
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.eventName,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.kreon(
                      color: const Color(0x555555).withOpacity(1),
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    event.orgName,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.kreon(
                      color: const Color(0x555555).withOpacity(1),
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
     SizedBox(width: 300, height: 350,
      child: DecoratedBox(
        decoration: BoxDecoration(color:Color(0xCAEBF2).withOpacity(1),),
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date: ',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      // get amount
                      Text(
                        event.date,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Time: ',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      // get amount
                      Text(
                        '\n' + event.time,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Location: ',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        ),
                        // get eligibility
                        Text(
                        event.location,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Contact: ',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        ),
                        // get eligibility
                        Text(
                        //df.format(deadline),
                        event.contact,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                        
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row (
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => EventSignUpPage(),
                          settings: RouteSettings(arguments: event,),),);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF3B3F).withOpacity(1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: SizedBox(height: 35, width: 75, 
                          child: Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              'Register',  
                              textAlign: TextAlign.center, 
                              style: GoogleFonts.kreon(
                                color: const Color(0x555555).withOpacity(1),
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ), 
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ), );
  }
}