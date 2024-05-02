import 'package:flutter/material.dart';
import 'package:givehub/webcomponents/topbar.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
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
              flex: 0,
              child: Container(
                color: const Color(0xFFFF3B3F),
                //can align text either left, right, or center
                alignment: Alignment.center, 
                padding: EdgeInsets.only(top: 50),
                child: Text(
                  'Contact Us!',
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
                          onPressed: () {},
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
                            height: 250,
                            width: 300,


                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                               Text(
                                'Our Address:',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.oswald(
                                  color: const Color(0x555555).withOpacity(1),
                                  fontSize: buttonFontSize,
                                  fontWeight: FontWeight.bold                          
                                ),
                                
                              ),
                              Text(
                                '800 W Campbell Rd, Richardson, TX 75080',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.oswald(
                                  color: const Color(0x555555).withOpacity(1),
                                  fontSize: buttonFontSize,
                                ),
                              ),

                              ],
                            ),


                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            child: ElevatedButton(
                          onPressed: () {},
                          //color: Color(0x00caebf2),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xAAD1DA).withOpacity(1),
                            minimumSize: Size(150, 50), // Button size
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          //used a box to get the square box shape for the buttons
                          child: SizedBox(
                            height: 100,
                            width: 300,


                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                               Text(
                                'Email Us:',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.oswald(
                                  color: const Color(0x555555).withOpacity(1),
                                  fontSize: buttonFontSize,
                                  fontWeight: FontWeight.bold                          
                                ),
                                
                              ),
                              Text(
                                'GiveHub@gmail.com',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.oswald(
                                  color: const Color(0x555555).withOpacity(1),
                                  fontSize: buttonFontSize,
                                ),
                              ),

                              ],
                            ),



                          ),
                        ),
                        ),        
                      Container(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xAAD1DA).withOpacity(1),
                            minimumSize: Size(150, 50), // Button size
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: SizedBox(
                            height: 100,
                            width: 300,

                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                               Text(
                                'Phone Us:',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.oswald(
                                  color: const Color(0x555555).withOpacity(1),
                                  fontSize: buttonFontSize,
                                  fontWeight: FontWeight.bold                          
                                ),
                                
                              ),
                              Text(
                                '888-321-5678',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.oswald(
                                  color: const Color(0x555555).withOpacity(1),
                                  fontSize: buttonFontSize,
                                ),
                              ),

                              ],
                            ),


                          ),
                        ),
                      ),
                      Container(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xAAD1DA).withOpacity(1),
                            minimumSize: Size(150, 50), // Button size
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: SizedBox(
                            height: 100,
                            width: 300,


                           child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                               Text(
                                'LinkedIn:',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.oswald(
                                  color: const Color(0x555555).withOpacity(1),
                                  fontSize: buttonFontSize,
                                  fontWeight: FontWeight.bold                          
                                ),
                                
                              ),
                              Text(
                                'https://www.linkedin.com/GiveHub',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.oswald(
                                  color: const Color(0x555555).withOpacity(1),
                                  fontSize: buttonFontSize,
                                ),
                              ),

                              ],
                            ),



                          ),
                        ),
                      )
                        ],                        
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