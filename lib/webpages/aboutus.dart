import 'package:flutter/material.dart';
import 'package:givehub/webcomponents/topbar.dart';
import 'package:givehub/webpages/signup.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  _AboutUsPage createState() => _AboutUsPage();
}

class _AboutUsPage extends State<AboutUsPage> {
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
            Container(
              height: 10,  
              color: Colors.white,
            ),
            Container(
              color: Colors.white,
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 40,
                  child: Text(
                    'One Website For Everything',
                    style: GoogleFonts.oswald(
                      color: const Color.fromRGBO(85, 85, 85, 1),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ),
            ),
            Container(
              color: Colors.white,
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 60,
                  child: Text(
                    '...',
                    style: GoogleFonts.inter(
                      color: const Color.fromRGBO(255, 59, 63, 0.95),
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ),
            ),
            Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: SizedBox(
                height: 150,
                child: Text(
                  'ABOUT US',
                  style: GoogleFonts.oswald(
                    color: const Color.fromRGBO(169, 169, 169, 1),
                    fontSize: 100,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: Text(
                ' Our goal is to make it easier for non-profit organizations to raise funding  ',
                style: GoogleFonts.kreon(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  backgroundColor: const Color.fromRGBO(202, 235, 242, 0.65),
                  color: const Color.fromRGBO(85, 85, 85, 1),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: Text(
                ' for their operational costs  ',
                style: GoogleFonts.kreon(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  backgroundColor: const Color.fromRGBO(202, 235, 242, 0.65),
                  color: const Color.fromRGBO(85, 85, 85, 1),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: Text(
                ' We make sure non-profits, companies, and potential donors can connect  ',
                style: GoogleFonts.kreon(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  backgroundColor: const Color.fromRGBO(202, 235, 242, 0.65),
                  color: const Color.fromRGBO(85, 85, 85, 1),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: Text(
                ' with eachother in a convenient and effortless way.  ',
                style: GoogleFonts.kreon(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  backgroundColor: const Color.fromRGBO(202, 235, 242, 0.65),
                  color: const Color.fromRGBO(85, 85, 85, 1),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              alignment: Alignment.center,
              padding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.remove_red_eye_outlined,
                    color: Color.fromRGBO(85, 85, 85, 1),
                    size: 15,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const SignUp()));
                    },
                    child: Text(
                      '  Get Started Today >>',
                      style: GoogleFonts.oswald(
                        color: const Color.fromRGBO(85, 85, 85, 1),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: const Icon(
                                Icons.person_add_alt,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                            Text(
                              'Connect based on interests',
                              style: GoogleFonts.oswald(
                                color: const Color.fromRGBO(85, 85, 85, 1),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          child: const Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        Text(
                          'Create events and invite others',
                          style: GoogleFonts.oswald(
                            color: const Color.fromRGBO(85, 85, 85, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: const Icon(
                                Icons.find_in_page_outlined,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                            Text(
                              'Keep track of donations',
                              style: GoogleFonts.oswald(
                                color: const Color.fromRGBO(85, 85, 85, 1),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}