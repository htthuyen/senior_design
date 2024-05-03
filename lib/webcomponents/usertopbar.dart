import 'package:flutter/material.dart';
import 'package:givehub/webpages/search.dart';
import 'package:givehub/webpages/welcomepage.dart';
import 'package:google_fonts/google_fonts.dart';

class UserTopBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor = Color(0xFFFF3B3F);

  @override
  Widget build(BuildContext context) {
    //this section
    return AppBar(
      leading: null,
        title: GestureDetector(
          onTap: () {
            Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => WelcomePage()));
          },
          child: Text(
            'GiveHub',
            style: GoogleFonts.oswald(
              fontSize: 30,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: false,
        backgroundColor: const Color(0xFFFF3B3F),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => SearchPage()));
            },
            icon: Icon(Icons.search, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
            icon: Icon(Icons.menu, color: Colors.white),
          ),
        ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
