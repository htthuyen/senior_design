import 'package:flutter/material.dart';
import 'package:givehub/webcomponents/topbar.dart';
import 'package:google_fonts/google_fonts.dart';

class FeaturedNonProfitPage extends StatefulWidget {
  @override
  _FeaturedNonProfitPageState createState() => _FeaturedNonProfitPageState();
}

class _FeaturedNonProfitPageState extends State<FeaturedNonProfitPage> {
  final List<Map<String, dynamic>> _nonProfits = [
    {"id": 1, "name": "Ford Organization", "description": "Provides shelters for the homeless"},
    {"id": 2, "name": "Clothes for Kids", "description": "Donates clothes to kids in need"},
    {"id": 3, "name": "Green Group", "description": "Plants trees and cleans up trash"},
    {"id": 4, "name": "Methodist", "description": "Helps people recieve treatments and healthcare"},
    {"id": 5, "name": "XYZ Inc", "description": "Teaches kids life skills"},
    {"id": 6, "name": "Coding 4 Kids", "description": "Teaches kids coding and problem solving"},
    {"id": 7, "name": "Save the Earth", "description": "Fights against climate change"},
    {"id": 8, "name": "Artificial Intelligence Group", "description": "Provides resources on artifical intelligence"},
  ];

  // This widget is the root of your application.
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
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'Featured Non Profits',
                style: GoogleFonts.oswald(
                  color: const Color.fromRGBO(85, 85, 85, 1),
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 370,
                  crossAxisSpacing: 30,
                  mainAxisSpacing: 20,
                ),
                itemCount: _nonProfits.length,
                itemBuilder: (context, index) => SizedBox(
                  child: Card(
                    key: ValueKey(_nonProfits[index]["id"]),
                    color: const Color.fromRGBO(202, 235, 242, 1),
                    elevation: 4,
                    margin: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10, top: 20, bottom: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                              height: 60,
                              width: 60,
                              child: CircleAvatar(
                                backgroundColor:
                                    const Color.fromRGBO(217, 217, 217, 1),
                                child: Text(
                                  'P',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.oswald(
                                    color: const Color.fromRGBO(85, 85, 85, 1),
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )),
                          Text(
                            _nonProfits[index]['name'],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.oswald(
                              color: const Color.fromRGBO(85, 85, 85, 1),
                              fontSize: (_nonProfits[index]['name'].toString().length < 16) ? 24 
                                      : (_nonProfits[index]['name'].toString().length < 32) ? 22
                                      : 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _nonProfits[index]['description'],
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.fade,
                            style: GoogleFonts.oswald(
                              color: const Color.fromRGBO(85, 85, 85, .75),
                              fontSize: (_nonProfits[index]['description'].toString().length < 46) ? 15 
                                      : (_nonProfits[index]['description'].toString().length < 70) ? 13
                                      : 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]
        ),
      ),
      ),
    );
  }  
}