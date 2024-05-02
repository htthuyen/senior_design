

import 'dart:js_interop';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import '../../authentication/auth.dart';
import '../../webcomponents/input_theme.dart';
import '../../webcomponents/validation.dart';

class NonMonDon extends StatefulWidget {
  @override
  _NonMonDonState createState() => _NonMonDonState();
}

class _NonMonDonState extends State<NonMonDon> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formkey = GlobalKey<FormState>();

  final TextEditingController dateCtl = TextEditingController();
  final TextEditingController company = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController message = TextEditingController();
  final TextEditingController recipient = TextEditingController();


  String donationType = '';

  final _groupButtons = [
    'Clothes',
    'Food',
    'Volunteer',
    'Furniture',
    'Other'
  ];

  bool other = false;
// write non-monetary donation to donor/company database
  void nonMonDonations() async{
    getUser();
   
    try{
      if (uid != null){

        // donor/company 
        DatabaseReference ref = FirebaseDatabase.instance.ref('pending_donations').push();
        await ref.set({
          'donationType': donationType.toJS,
          'date': dateCtl.text,
          'recipientEmail': recipient.text,
          'messageToRecipient': message.text,
          'senderEmail': email.text,          
          'company': company.text,
          'sender': name.text, //sender's name
          'phone': phone.text, //sender's phone
          'donorcomID': uid,

      });


      }
    } catch (error){
      print('$error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        inputDecorationTheme: MyInputTheme().theme()
      ),
        home: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
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
        body: SingleChildScrollView(
          child: Center(
            child: Builder(
              builder: (context) {
                return Form(
                  key: _formkey,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 125, right: 110, top: 50, bottom: 100),
                    child : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container (
                          constraints: BoxConstraints.expand(height: 60, width: 850),
                          child: DecoratedBox(
                            decoration: BoxDecoration(color:Color(0xAAD1DA).withOpacity(1),),
                            child: Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: Text(
                                  'Nonmonetary Donation',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.oswald(
                                    color: const Color(0x555555).withOpacity(1),
                                    fontSize: 26,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xD9D9D9).withOpacity(1),
                              ),
                              constraints: BoxConstraints.expand(
                                height: 600.0,
                                width: 850.0
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Donation Type',
                                    style: GoogleFonts.kreon(
                                      color: const Color(0x555555).withOpacity(1),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                  children: [
                                    GroupButton(
                                      isRadio: true,
                                      buttons: _groupButtons,
                                      onSelected: (val, index, isSelected) =>
                                        setState(() {
                                          setState(() {
                                            donationType = val;
                                            print(donationType);
                                          });
                                          if (_groupButtons[index] == 'Other') {
                                            other = isSelected;
                                          }
                                          else {
                                            other = false;
                                          }
                                        }
                                      ),
                                      options: GroupButtonOptions(
                                        groupingType: GroupingType.row,
                                        alignment: Alignment.center,
                                        unselectedTextStyle: GoogleFonts.kreon(
                                            color: const Color(0x555555).withOpacity(1),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        selectedTextStyle: GoogleFonts.kreon(
                                            color: const Color(0x555555).withOpacity(1),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        selectedColor: Color(0xAAD1DA).withOpacity(1),
                                        unselectedColor: Color(0xCAEBF2).withOpacity(1),
                                        borderRadius: BorderRadius.circular(20),
                                        buttonHeight: 30,
                                        buttonWidth: 100,
                                        spacing: 3,
                                      ), 
                                    ),
                                    if (other) 
                                      SizedBox(
                                        width: 250,
                                        child: TextFormField(
                                          validator: (s){
                                            return 'This field is required';
                                          },
                                          style: GoogleFonts.kreon(
                                            color: const Color(0x555555).withOpacity(1),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: 'Type here...',
                                            hintStyle: GoogleFonts.kreon(
                                            color: const Color(0xA9A9A9).withOpacity(1),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w300,
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding: EdgeInsets.all(12),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(25),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(25),
                                              borderSide: BorderSide(color: Color(0xAAD1DA).withOpacity(1), width: 1),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                const SizedBox(height: 20),
                                Row (
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Date',
                                          style: GoogleFonts.kreon(
                                            color: const Color(0x555555).withOpacity(1),
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        SizedBox(
                                          width: 250,
                                          child: TextFormField(
                                            controller: dateCtl,
                                            validator: (s){
                                              if (s!.isWhitespace()){
                                                return 'This field is required';
                                              }
                                              return null;
                                            },
                                            onTap: () async{
                                              DateTime date = DateTime(1900);
                                              FocusScope.of(context).requestFocus(new FocusNode());
                                              date = (await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime(2100),
                                              ))!;
                                              dateCtl.text = date.toIso8601String().replaceRange(10,23, '');
                                            },
                                            style: GoogleFonts.kreon(
                                              color: const Color(0x555555).withOpacity(1),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w300,
                                            ),
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding: EdgeInsets.all(12),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(25),
                                                borderSide: BorderSide.none,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(25),
                                                borderSide: BorderSide(color: Color(0xAAD1DA).withOpacity(1), width: 2),
                                                ),
                                              ),
                                            ),
                                        ),
                                        // const SizedBox(height: 10),
                                      ],
                                    ),
                                  const SizedBox(width: 15),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Company (Optional)',
                                        style: GoogleFonts.kreon(
                                          color: const Color(0x555555).withOpacity(1),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      SizedBox(
                                        width: 250,
                                        child:
                                        TextFormField(
                                          controller: company,
                                          style: GoogleFonts.kreon(
                                          color: const Color(0x555555).withOpacity(1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300,
                                          ),
                                          decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: 'Company Name',
                                          hintStyle: GoogleFonts.kreon(
                                          color: const Color(0xA9A9A9).withOpacity(1),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300,
                                          ),
                                          contentPadding: EdgeInsets.all(12),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(25),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(25),
                                            borderSide: BorderSide(color: Color(0xAAD1DA).withOpacity(1), width: 2),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 15),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Recipient',
                                          style: GoogleFonts.kreon(
                                            color: const Color(0x555555).withOpacity(1),
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        SizedBox(
                                          width: 250,
                                          child: TextFormField(
                                            controller: recipient,
                                            validator: (s){
                                              if (s!.isWhitespace()){
                                                return 'This field is required';
                                              } if (!s.isValidEmail()){
                                                return 'Invalid email';
                                              }
                                              return null;
                                            },
                                          
                                            style: GoogleFonts.kreon(
                                              color: const Color(0x555555).withOpacity(1),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w300,
                                            ),
                                            decoration: InputDecoration(
                                              filled: true,
                                              hintText: 'Email',
                                              hintStyle: GoogleFonts.kreon(
                                                color: const Color(0xA9A9A9).withOpacity(1),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w300,
                                                ),                 
                                              fillColor: Colors.white,
                                              contentPadding: EdgeInsets.all(12),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(25),
                                                borderSide: BorderSide.none,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(25),
                                                borderSide: BorderSide(color: Color(0xAAD1DA).withOpacity(1), width: 2),
                                                ),
                                              ),
                                            ),
                                        ),
                                        // const SizedBox(height: 10),
                                      ],
                                    ),                             
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Text(
                                      'Contact Info',
                                      style: GoogleFonts.kreon(
                                        color: const Color(0x555555).withOpacity(1),
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row (
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 250,
                                      child: TextFormField(
                                        controller: name,
                                        validator: (s){
                                          if (s!.isWhitespace()){
                                            return 'This field is required';
                                          }
                                          return null;
                                        },
                                        textAlignVertical: TextAlignVertical.center,
                                        style: GoogleFonts.kreon(
                                          color: const Color(0x555555).withOpacity(1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300,
                                        ),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: 'Name',
                                          hintStyle: GoogleFonts.kreon(
                                          color: const Color(0xA9A9A9).withOpacity(1),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300,
                                          ),
                                          contentPadding: EdgeInsets.all(12),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(25),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(25),
                                            borderSide: BorderSide(color: Color(0xAAD1DA).withOpacity(1), width: 2),
                                            ),
                                          ),
                                        ),
                                    ),
                                  const SizedBox(width: 15),
                                  SizedBox(
                                    width: 250,
                                    child: TextFormField(
                                      controller: email,
                                      validator: (s){
                                        if (s!.isWhitespace()){
                                          return 'This field is required';
                                        } else if(!s.isValidEmail()){
                                          return 'Invalid email';
                                        } 
                                        return null;
                                      },
                                      textAlignVertical: TextAlignVertical.center,
                                      style: GoogleFonts.kreon(
                                        color: const Color(0x555555).withOpacity(1),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: 'Email',
                                        hintStyle: GoogleFonts.kreon(
                                        color: const Color(0xA9A9A9).withOpacity(1),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                        ),
                                        contentPadding: EdgeInsets.all(12),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(25),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(25),
                                          borderSide: BorderSide(color: Color(0xAAD1DA).withOpacity(1), width: 2),
                                          ),
                                        ),
                                      ),
                                  ),
                                  const SizedBox(width: 15),
                                  SizedBox(
                                    width: 250,
                                    child: TextFormField(
                                      controller: phone,
                                      validator: (s){
                                        if (s!.isWhitespace()){
                                          return 'This field is required';
                                        } else if(!s.isValidPhoneNumber()){
                                          return 'Invalid phone number';
                                        }
                                        return null;
                                      },
                                      // maxLength: 10,
                                      textAlignVertical: TextAlignVertical.center,
                                      style: GoogleFonts.kreon(
                                        color: const Color(0x555555).withOpacity(1),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: 'Phone Number',
                                        hintStyle: GoogleFonts.kreon(
                                        color: const Color(0xA9A9A9).withOpacity(1),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                        ),
                                        contentPadding: EdgeInsets.all(12),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(25),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(25),
                                          borderSide: BorderSide(color: Color(0xAAD1DA).withOpacity(1), width: 2),
                                          ),
                                        ),
                                      ),
                                  )
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Text(
                                      'Message',
                                      style: GoogleFonts.kreon(
                                        color: const Color(0x555555).withOpacity(1),
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 780,
                                      child: TextFormField(
                                        controller: message,
                                        validator: (s){
                                          if (s!.isWhitespace()){
                                            return 'This field is required';
                                          }
                                        },
                                        maxLines: 5,
                                        style: GoogleFonts.kreon(
                                          color: const Color(0x555555).withOpacity(1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300,
                                        ),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: 'Type Here...',
                                              hintStyle: GoogleFonts.kreon(
                                              color: const Color(0xA9A9A9).withOpacity(1),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300,
                                              ),
                                          contentPadding: const EdgeInsets.all(12),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(25),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(25),
                                            borderSide: BorderSide(color: const Color(0xAAD1DA).withOpacity(1), width: 2),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            const SizedBox(height: 48),
                            Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ElevatedButton(
                              onPressed: () {
                                final isValid = _formkey.currentState!.validate();
                                if (donationType.trim().isEmpty){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: 
                                        Text(
                                          'Please select donation type.',
                                          style: GoogleFonts.oswald(
                                            fontSize: 20,
                                          ),
                                        ),
                                        backgroundColor: Colors.red[300],
                                      )
                                  );
                                }
                                if (isValid && donationType.trim().isNotEmpty){
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          'Are you sure to submit the form?',
                                          style: GoogleFonts.oswald(
                                            fontSize: 25,
                                            color: Color(0x555555).withOpacity(1),
                                          ),
                                        ),
                                        actions: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              TextButton(
                                                onPressed: (){
                                                  nonMonDonations();
                                                  Navigator.of(context).pop();
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context){
                                                      return AlertDialog(
                                                        title: Text(
                                                          'Thank you for your support. Your request is under review.',
                                                          style: GoogleFonts.oswald(
                                                            fontSize: 25,
                                                            color: Color(0x555555).withOpacity(1),
                                                          )
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () {
                                                            Navigator.of(context).pop();
                                                            },
                                                            child: Text(
                                                              'Close',
                                                              style: GoogleFonts.oswald(
                                                               fontSize: 20,
                                                               color: Colors.red[400]
                                                              ),
                                                              
                                                            ),
                                                          )
                                                        ],
                                                        
                                                      );
                                                    }
                                                  );
                                                }, 
                                                child: Text(
                                                  'Yes',
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 20,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                                
                                              ),
                                              TextButton(
                                                onPressed: (){
                                                  Navigator.of(context).pop();
                                                }, 
                                                child: Text(
                                                  'Cancel',
                                                  style: GoogleFonts.oswald(
                                                    fontSize: 20,
                                                    color: Colors.red[400],
                                                  ),
                                                ),
                                                )
                                            ],
                                          )
                                        ],
                                      );
                                    });
                                } 

                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xCAEBF2).withOpacity(1),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: SizedBox(height: 35, width: 120, 
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    'Send',  
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
                            const SizedBox(width:10), 
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/comdonordonationhistory');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xAAD1DA).withOpacity(1),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: SizedBox(height: 35, width: 120, 
                              child: Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  'Cancel',  
                                textAlign: TextAlign.center, 
                                style: GoogleFonts.kreon(
                                  color: const Color(0x555555).withOpacity(1),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w300,
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
                        
                          const SizedBox(height: 50),
                         
                    ],
                  ),
                  ),
                );
              }
            ),
          ),
        ),
              ),
    );
  }
}