import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Event {
  String eventName;
  String orgName;
  DateTime dateTime;
  String location;
  String contactName;
  String contactNum;
  String contactEmail;
  String description;
  
  Event({required this.eventName, required this.orgName, required this.dateTime, required this.location, required this.contactName, required this.contactNum, required this.contactEmail, required this.description});
}
class Events extends StatefulWidget {
  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Event> events = [
    Event(eventName: 'Toy Drive', orgName: 'Richardson Elementary', dateTime: DateTime(2024, 12, 12, 10, 00), location: '123 Learn Dr', contactName: 'John Smith', contactNum: '4355554345', contactEmail: 'school@risd.net', description: 'Come bring gifts for kids just in time for Christmas!'),
    Event(eventName: 'Meals On Wheels', orgName: 'Soup Kitchen', dateTime: DateTime(2024, 11, 17, 18, 00), location: '221 N St', contactName: 'Jeffrey Lewis', contactNum: '2213342345', contactEmail: 'foodie12@gmail.com', description: 'Volunteer to help serve or donate food to give to others'),
    Event(eventName: 'Thanksgiving Feast', orgName: 'Food Bank', dateTime: DateTime(2024, 11, 19, 18, 30), location: '3321 Cheddar Ave', contactName: 'Miranda Cos', contactNum: '8324564543', contactEmail: 'mcos22@yahoo.com', description: 'Feel free to come enjoy a meal, donate food, or help us serve!'),
    Event(eventName: 'Donation Drive', orgName: 'Northeast Clinic', dateTime: DateTime(2024, 9, 8, 9, 00), location: '901 K Ave', contactName: 'Lionel Tee', contactNum: '5554379980', contactEmail: 'lionel@hotmal.com', description: 'In need of supplies. Everything is helpful'),
    Event(eventName: 'Garage Sale', orgName: 'Dallas Museum',dateTime: DateTime(2024, 4, 26, 8, 00), location: '162 Gar Rd', contactName: 'Fiona Li', contactNum: '3210987432', contactEmail: 'fli27@gmail.com', description: 'Selling some prized artifacts to fund a new sector. Come take a look!'),
  ];
  bool isFavorite = false;
 /*final _database = FirebaseDatabase.instance.reference();
  String name = '';
  String email = '';
  String phone = '';
  String member = '';
  String company_info = '';
  late StreamSubscription _stream;

  @override
  void initState(){
    super.initState();
    getUserInfo();
  }
  void getUserInfo(){
    _stream = 
    _database.child('users').onValue.listen((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value as dynamic);
      final userEmail = data['email'] as String;
      final userMembership = data['memberSince'] as String;
      final userName = data['name'] as String;
      final userPhone = data['phone'] as String;
      
      setState((){
        name = '$userName';
        email = '$userEmail';
        member = '$userMembership';
        phone = '$userPhone';

      });
    });
  }
  void addUserInfo() {
    String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserUid != null && (companyInfo != null)) {
      Map<String, dynamic> updateData = {};
      if (company_info != null) {
        updateData['companyInfo'] = companyInfo;
      }
      _database.child('users').child(currentUserUid).update(updateData)
        .then((_) {
          print('User information updated successfully.');
        })
        .catchError((error) {
          print('Error updating user information: $error');
        });
    }
  }

  void _updateProfile(String newName, String newEmail, String newPhone, String companyInfo) {
   
   
  }

  void _showLogoutDialog() {
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
                Navigator.pushNamed(context, '/welcome');
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
 
  void _showEditProfileDialog() {
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController emailController = TextEditingController(text: email);
    TextEditingController phoneController = TextEditingController(text: phone);
    TextEditingController companyInfoController = TextEditingController(text: company_info);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 400, 
            height: 500,
            //color: Color(0xCAEBF2).withOpacity(.50),
            child: AlertDialog(
              iconColor: Color(0xCAEBF2).withOpacity(.50),
              title: Text(
                'Edit Profile',
                style: GoogleFonts.oswald(
                  color: Color(0x555555).withOpacity(1), 
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Name', labelStyle: TextStyle(color: Color(0x555555).withOpacity(1)), ),
                      style: GoogleFonts.oswald(
                        color: Color(0x555555).withOpacity(1), 
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'Email', labelStyle: TextStyle(color: Color(0x555555).withOpacity(1))),
                      style: GoogleFonts.oswald(
                        color: Color(0x555555).withOpacity(1), 
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(labelText: 'Phone', labelStyle: TextStyle(color: Color(0x555555).withOpacity(1))),
                      style: GoogleFonts.oswald(
                        color: Color(0x555555).withOpacity(1), 
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    TextFormField(
                      controller: companyInfoController,
                      decoration: InputDecoration(labelText: 'Company Info', labelStyle: TextStyle(color: Color(0x555555).withOpacity(1))),
                      style: GoogleFonts.oswald(
                        color: Color(0x555555).withOpacity(1), 
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.oswald(
                        color: Color(0x555555).withOpacity(1), 
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Update profile information in the database
                    _updateProfile(
                      nameController.text,
                      emailController.text,
                      phoneController.text,
                      companyInfoController.text,
                    );

                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Save',
                    style: GoogleFonts.oswald(
                        color: Color(0x555555).withOpacity(1), 
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

   void _handleLogout() {
    
    _showLogoutDialog();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.white,
        ),
          title: GestureDetector(
            onTap: () {
              
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
          width: MediaQuery.of(context).size.width * 0.5, // Set the desired width (50% of screen width in this example)
          child: Container(
            color: const Color(0xFFFF3B3F), // Set the color here
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
                  ListTile(
                    title: Text(
                      'Edit Profile',
                      style: GoogleFonts.oswald(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    onTap: () {
                      //_showEditProfileDialog();
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
                      Navigator.pushNamed(context, '/eventhistory');
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Upcoming Events',
                      style: GoogleFonts.oswald(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/myevents');
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
                      Navigator.pushNamed(context, '/comdonordonationhistory');
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Payment Center',
                      style: GoogleFonts.oswald(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/donorpayment');
                    },
                  ),
                  ExpansionTile(
                    title: Text(
                      'Grant Center',
                      style: GoogleFonts.oswald(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
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
                          Navigator.pushNamed(context, '/grantcreation');
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
                         Navigator.pushNamed(context, '/grantapp');
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
                     Navigator.pushNamed(context, '/notifications');
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
                      //_showLogoutDialog();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
                              'EVENTS',
                              style: GoogleFonts.oswald(
                                color: const Color(0x555555).withOpacity(1),
                                fontSize: 32,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.topRight,
                            padding: EdgeInsets.only(left: 20, right : 20, bottom: 30, top: 40),
                            child: TextFormField(
                              style: GoogleFonts.kreon(
                                color: const Color(0x555555).withOpacity(1),
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
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
                        Container(
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
                        ),
                      ],
                    ),
                  Container(
                        color: const Color(0xD9D9D9).withOpacity(1),
                        padding: EdgeInsets.all(20),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //const SizedBox(width: 50),
                        Flexible(
                          child: GridView.builder (
                            itemCount: events.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 225, crossAxisSpacing: 20, mainAxisSpacing: 20, mainAxisExtent: 400),
                            itemBuilder: (context, index) {
                              return MakeBox(eventName: events[index].eventName, orgName: events[index].orgName, dateTime: events[index].dateTime, location: events[index].location, contactName: events[index].contactName, contactNum: events[index].contactNum, contactEmail: events[index].contactEmail, description: events[index].description);
                            },
                          ),
                        ),
                        //const SizedBox(width: 50),
                      ],
                    ),
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


class MakeBox extends StatelessWidget {
  late String eventName;
  late String orgName;
  late DateTime dateTime;
  late String location;
  late String contactName;
  late String contactNum;
  late String contactEmail;
  late String description;
  
  MakeBox({required this.eventName, required this.orgName, required this.dateTime, required this.location, required this.contactName, required this.contactNum, required this.contactEmail, required this.description});
  final df = DateFormat('MM-dd-yyyy hh:mm a');
  int myval = 1558432747;

  @override
  Widget build(BuildContext context) {
    return Column(
    children: [
      SizedBox(
        width: 250,
      height: 55,
        child: DecoratedBox(
        decoration: BoxDecoration(color:Color(0xCAEBF2).withOpacity(1),),
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eventName,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.kreon(
                      color: const Color(0x555555).withOpacity(1),
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    orgName,
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
    SizedBox(width: 250, height: 315,
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date & Time: ',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      // get amount
                      Text(
                        '\t\t' + df.format(dateTime),
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Location: ',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                        ),
                        // get eligibility
                        Text(
                        '\t\t' +  location,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Contact: ',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                        ),
                        // get eligibility
                        Text(
                        '\t\t' + contactName + ' ' + contactNum + '\n\t\t' + contactEmail,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                        const SizedBox(height: 10),
                        Text(
                        'Event Description: ',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kreon(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                        ),
                        // get eligibility
                        SizedBox(
                          width: 175,
                          child: Text(
                            '\t\t' + description,
                            maxLines: 3,
                            style: GoogleFonts.kreon(
                              color: const Color(0x555555).withOpacity(1),
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ],
                      ),
                    ],
                  ),
                  Row (
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // go to register for event
                          Navigator.of(context).pushNamed('/eventsignup');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xCAEBF2).withOpacity(1),
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
    );
  }
}