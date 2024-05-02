import 'package:flutter/material.dart';
import 'package:givehub/webpages/aboutus.dart';
import 'package:givehub/webpages/login.dart';
import 'package:givehub/webpages/signup.dart';
import 'package:givehub/webpages/welcomepage.dart';
import 'package:google_fonts/google_fonts.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor = Color(0xFFFF3B3F);

  @override
  Widget build(BuildContext context) {
    //this section
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
        color: Colors.white, // Change the color here
      ),
      actions: [
        //padding can be used to help add space or move items
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: TextButton(
            //control the flow of buttons when pressed
            onPressed: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new AboutUsPage()));
            },
            child: Text(
              'About Us',
              //change change the font, size, color, and bold/thinness
              style: GoogleFonts.oswald(
                color: Colors.white,
                fontSize: 16,
                //fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: TextButton(
            onPressed: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new SignUp()));
            },
            child: Text(
              'Sign Up',
              style: GoogleFonts.oswald(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: TextButton(
            onPressed: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new Login()));
            },
            child: Text(
              'Login',
              style: GoogleFonts.oswald(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
      title: Align(
        alignment: Alignment.topLeft,
        child: TextButton(
          onPressed: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new WelcomePage()));
          },
          child: Text(
            'GiveHub',
            style: GoogleFonts.oswald(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}