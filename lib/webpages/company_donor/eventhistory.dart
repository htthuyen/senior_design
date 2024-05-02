
import 'package:flutter/material.dart';
import 'package:givehub/webcomponents/donor_company_topbar.dart';
import 'package:givehub/webcomponents/usertopbar.dart';
import 'package:givehub/webpages/np/grantstatus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:givehub/authentication/auth.dart';
import 'companyprofilepage.dart';
import '../np/createevent.dart';
import 'donorcompanydonationhistory.dart';
import 'donorprofile.dart';
import '../np/eventnp.dart';
import '../np/grantapp.dart';
import 'myeventspage.dart';
import '../np/needs.dart';
import '../np/npdonationreview.dart';
import '../np/npprofilepage.dart';

class EventHistory extends StatefulWidget {
  const EventHistory({super.key});


  @override
  State<EventHistory> createState() => _EventHistoryState();
}

class _EventHistoryState extends State<EventHistory> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<EventforUser> events = [];

  @override
  void initState() {
    super.initState();
    
    getUser().then((_) {
      if (uid != null) {
        fetchUserEvents(uid!); 
      } else {
        
        showSnackBar(context, 'User ID not found. Please log in again.');
        Navigator.pushReplacementNamed(context, '/login'); 
      }
    });
  }


  Future<void> fetchUserEvents(String userId) async {
    try {
      List<EventforUser>? userEvents = await getUserEventsFromDatabase(userId);

      if (userEvents != null) {
        setState(() {
          events = userEvents;
        });
        print('Events fetched successfully: $events');
      } else {
        print('No events found for the user.');
      }
    } catch (e) {
      print('Error fetching user events: $e');
      showSnackBar(context, 'Error fetching user events. Please try again later.');
    }
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: UserTopBar(),
      endDrawer: DonorComTopBar(),
      body: ListView(
        children: <Widget>[
          SizedBox(
            width: 389,
            height: 131,
            child: Text(
              'Event History',
              textAlign: TextAlign.center,
              style: GoogleFonts.oswald(
                color: Color.fromRGBO(85, 85, 85, 1),
                fontSize: 45,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            width: 1440,
            height: 779,
            child: DataTable(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(170, 209, 218, 1),
              ),
              dataRowColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                return Color.fromRGBO(170, 209, 218, 1);
              }),
              headingRowColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                return Color.fromRGBO(202, 235, 242, 0.90);
              }),
              showBottomBorder: true,
              columns: [
                DataColumn(
                  label: Text(
                    'Date',
                    style: GoogleFonts.kreon(
                      color: Color.fromRGBO(169, 169, 169, 1),
                      fontSize: 27,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Organization',
                    style: GoogleFonts.kreon(
                      color: Color.fromRGBO(169, 169, 169, 1),
                      fontSize: 27,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Event',
                    style: GoogleFonts.kreon(
                      color: Color.fromRGBO(169, 169, 169, 1),
                      fontSize: 27,
                    ),
                  ),
                ),
              ],
              rows: events.isNotEmpty
                  ? events.map((event) {
                      return DataRow(cells: [
                        DataCell(Text(event.date)),
                        DataCell(Text(event.orgName)),
                        DataCell(Text(event.eventName)),
                      ]);
                    }).toList()
                  : [
                      DataRow(cells: [
                        DataCell(Text('No events found')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                      ]),
                    ], // Show a row with 'No events found' if the list is empty
            ),
          ),
        ],
      ),
    );
  }
}