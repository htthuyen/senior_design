import 'package:flutter/material.dart';
import 'package:givehub/webpages/contactuspage.dart';
import 'package:givehub/webpages/featurednonprofits.dart';
import 'package:givehub/webpages/signup.dart';
import 'package:google_fonts/google_fonts.dart';

import '../webcomponents/topbar.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Color buttonColor = Color(0xCAEBF2);
  double buttonFontSize = 20;

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
        appBar: TopBar(),
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                color: const Color(0xFFFF3B3F), 
                //can align text either left, right, or center
                alignment: Alignment.bottomLeft, 
                padding: EdgeInsets.only(left: 50, bottom: 50),
                child: Text(
                  'Hello, \nWelcome to GiveHub.',
                  style: GoogleFonts.oswald(
                    color: Colors.white,
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
           Expanded(
              flex: 1,
              child: Container(
                //the background color and can set opacity
                color: Color(0xCAEBF2).withOpacity(.50), 
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: ElevatedButton(
                          onPressed: () {
                             Navigator.push(context, new MaterialPageRoute(
                builder: (context) =>
                  ContactUsPage())
                );
                          },
                          style: ElevatedButton.styleFrom(
                            //button color
                            backgroundColor: Color(0xAAD1DA).withOpacity(1),
                            //button size
                            minimumSize: Size(150, 150), 
                            //makes the edges rounder
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: SizedBox(
                            height: 150,
                            width: 200,
                            child: Center(
                              child: Text(
                                'Contact Us',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.oswald(
                                  color: Colors.white,
                                  fontSize: buttonFontSize,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, new MaterialPageRoute(
                builder: (context) =>
                  FeaturedNonProfitPage()));
                            
                          },
                          //color: Color(0x00caebf2),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xAAD1DA).withOpacity(1),
                            minimumSize: Size(150, 150), // Button size
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          //used a box to get the square box shape for the buttons
                          child: SizedBox(
                            height: 150,
                            width: 200,
                            child: Center(
                              child: Text(
                                'Our Featured Non Profits',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.oswald(
                                  color: Colors.white,
                                  fontSize: buttonFontSize,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: ElevatedButton(
                          onPressed: () {
                             Navigator.push(context, new MaterialPageRoute(
                builder: (context) =>
                  SignUp()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xAAD1DA).withOpacity(1),
                            minimumSize: Size(150, 150), // Button size
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: SizedBox(
                            height: 150,
                            width: 200,
                            child: Center(
                              child: Text(
                                'Apply Now',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.oswald(
                                  color: Colors.white,
                                  fontSize: buttonFontSize,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}