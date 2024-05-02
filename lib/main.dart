import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'webpages/aboutus.dart';
import 'webpages/company_donor/companyprofilepage.dart';
import 'webpages/company_donor/donationofinterestspage.dart';
import 'webpages/company_donor/donorcompanydonationhistory.dart';
import 'webpages/company_donor/donorpaymentpage.dart';
import 'webpages/company_donor/donorprofile.dart';
import 'webpages/company_donor/eventhistory.dart';
import 'webpages/company_donor/eventsignuppage.dart';
import 'webpages/company_donor/grantcreationpage.dart';
import 'webpages/company_donor/myeventspage.dart';
import 'webpages/company_donor/mygrants.dart';
import 'webpages/company_donor/nonmondon.dart';
import 'webpages/company_donor/npselectionpage.dart';
import 'webpages/company_donor/publicdonationhistory.dart';
import 'webpages/connectionspage.dart';
import 'webpages/contactuspage.dart';
import 'webpages/forgotpassword.dart';
import 'webpages/login.dart';
import 'webpages/notificationspage.dart';
import 'webpages/np/createevent.dart';
import 'webpages/np/eventnp.dart';
import 'webpages/np/events.dart';
import 'webpages/np/featurednonprofits.dart';
import 'webpages/np/grantapp.dart';
import 'webpages/np/grantstatus.dart';
import 'webpages/np/grantsub.dart';
import 'webpages/np/needs.dart';
import 'webpages/np/npdonationhistory.dart';
import 'webpages/np/npdonationreview.dart';
import 'webpages/np/npprofilepage.dart';
import 'webpages/search.dart';
import 'webpages/signup.dart';
import 'webpages/subscription.dart';
import 'webpages/welcomepage.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBpl5DBw59BgCkYqVPi8APx6Aijgnzj4d4",
      authDomain: "senior-project-e07a6.firebaseapp.com",
      databaseURL: "https://senior-project-e07a6-default-rtdb.firebaseio.com",
      projectId: "senior-project-e07a6",
      storageBucket: "senior-project-e07a6.appspot.com",
      messagingSenderId: "788472484500",
      appId: "1:788472484500:web:4446d1c8e9fd1611ff9a81",
      measurementId: "G-24K76CQQZ9"
    ),
  );

  //Firebase Messaging Permission Request to Users  
  FirebaseMessaging messaging = FirebaseMessaging.instance;
 NotificationSettings settings = await messaging.requestPermission(
  alert: true,
  announcement: false,
  badge: true,
  carPlay: false,
  criticalAlert: false,
  provisional: false,
  sound: true
  );
  print('User granted permission: ${settings.authorizationStatus}');
  
  // use the returned token to send messages to users from your custom server
    FirebaseMessaging.instance.getToken(vapidKey: "BOUuofpCpzENoclgxR0WenwsP47F6hK7-abX-hdzugQbDnBf3R-SG3J1QIKCnS6OA08nFYRA-qC9JNO4TmwnMw4").then(print);

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  runApp(MyApp(observer));
}


class MyApp extends StatelessWidget {
  final FirebaseAnalyticsObserver observer;

  MyApp(this.observer);
final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [observer],
      debugShowCheckedModeBanner: false,
      initialRoute: '/welcome', // Set the initial route
      routes: {
        '/welcome': (context) => WelcomePage(),
        '/companyprofile': (context) => CompanyProfilePage(),
        '/notifications': (context) => NotificationsPage(),
        '/forgotpassword': (context) => ForgotPasswordPage(),
        '/npselect': (context) => NPSelectionPage(),
        '/signup': (context) => const SignUp(),
        '/events': (context) => Events(),
        '/contactus':(context) => ContactUsPage(),
        '/aboutus':(context) => const AboutUsPage(),
        '/connections':(context) => const ConnectionsPage(),
        '/createevent':(context) => CreateEvent(),
        '/donationsinterest':(context) => const DonationOfInterestsPage(),
        '/donordonationhistory':(context) => const DonationHistoryDonorCompany(),
        '/donorpayment':(context) => const DonorPaymentPage(),
        '/donorprofile':(context) => DonorProfilePage(),
        '/events_np':(context) => EventsNP(),
        '/myevents':(context) => MyEventsPage(),
        '/eventsignup':(context) => EventSignUpPage(),
        '/eventhistory':(context) => const EventHistory(),
        '/featurednp':(context) => FeaturedNonProfitPage(),
        '/grantapp':(context) => GrantApp(),
        '/grantcreation':(context) => const GrantCreationPage(),
        '/grantsub':(context) => GrantSub(),
        '/mygrants':(context) => MyGrants(),
        '/needs':(context) => const NeedsPage(),
        '/nonmondonation':(context) => NonMonDon(),
        '/np_donationreview':(context) => const NPDonationReview(),
        '/npprofile':(context) => NPProfilePage(),
        '/np_history':(context) => NPHistory(),
        '/login':(context) => Login(),
        '/mygrantsnp':(context) => MyGrants(),
        '/subscription':(context) => SubscriptionPage(),
        '/search':(context) => SearchPage(),
        '/grantstatus':(context) => GrantStatusPage(),
      },
      home: FutureBuilder(
        future: _initialization,builder: (context, snapshot){
          if(snapshot.hasError){
            print("error");
          }
          if(snapshot.connectionState == ConnectionState.done){
            return WelcomePage();
          }
          return CircularProgressIndicator();
        }
      )
    );
  }
}