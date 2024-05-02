import 'package:flutter/material.dart';
import 'package:givehub/webcomponents/np_topbar.dart';
import 'package:givehub/webcomponents/usertopbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'grantapp.dart';
import '../../authentication/auth.dart';

class GrantSub extends StatefulWidget {
  @override
  _GrantSubState createState() => _GrantSubState();
}

class _GrantSubState extends State<GrantSub> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController organizationNameController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController contactNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController responseController = TextEditingController();
  
   @override
  Widget build(BuildContext context) {
    final Grant chosen = ModalRoute.of(context)!.settings.arguments as Grant;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
      ),
        home: Scaffold(
          key: _scaffoldKey,
          appBar: UserTopBar(),
          endDrawer: NpTopBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 75, right: 75, top: 50, bottom: 75),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chosen.getGrantName() + ' Overview',
                  style: GoogleFonts.oswald(
                    color: const Color(0x555555).withOpacity(1),
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height:10),
                Container(
                  alignment: Alignment.topCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text( 
                        'Deadline: ' + chosen.getDeadline(),
                        style: GoogleFonts.kreon(
                          color: const Color(0xFF3B3F).withOpacity(1),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text( 
                            'Donor: ',
                            style: GoogleFonts.kreon(
                              color: const Color(0x555555).withOpacity(1),
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                            Text( 
                            chosen.getDonorName(),
                            style: GoogleFonts.kreon(
                              color: const Color(0x555555).withOpacity(1),
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text( 
                            'Phone: ',
                            style: GoogleFonts.kreon(
                              color: const Color(0x555555).withOpacity(1),
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text( 
                            chosen.getPhone(),
                            style: GoogleFonts.kreon(
                              color: const Color(0x555555).withOpacity(1),
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text( 
                            'Email: ',
                            style: GoogleFonts.kreon(
                              color: const Color(0x555555).withOpacity(1),
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text( 
                            chosen.getEmail(),
                            style: GoogleFonts.kreon(
                              color: const Color(0x555555).withOpacity(1),
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text( 
                            'Amount: \$',
                            style: GoogleFonts.kreon(
                              color: const Color(0x555555).withOpacity(1),
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text( 
                            chosen.getAmount(),
                            style: GoogleFonts.kreon(
                              color: const Color(0x555555).withOpacity(1),
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text( 
                            'Eligibility: ',
                            style: GoogleFonts.kreon(
                              color: const Color(0x555555).withOpacity(1),
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text( 
                            chosen.getEligibility(),
                            style: GoogleFonts.kreon(
                              color: const Color(0x555555).withOpacity(1),
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text( 
                            'Payment Details: ',
                            style: GoogleFonts.kreon(
                              color: const Color(0x555555).withOpacity(1),
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text( 
                            chosen.getPayment(),
                            style: GoogleFonts.kreon(
                              color: const Color(0x555555).withOpacity(1),
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text( 
                            'Further Requirements: ',
                            style: GoogleFonts.kreon(
                              color: const Color(0x555555).withOpacity(1),
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Flexible (
                            child: Text( 
                              chosen.getFurther(),
                              style: GoogleFonts.kreon(
                                color: const Color(0x555555).withOpacity(1),
                                fontSize: 20,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ], 
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Apply to ' + chosen.getGrantName(),
                        style: GoogleFonts.oswald(
                          color: const Color(0x555555).withOpacity(1),
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height:10),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xCAEBF2).withOpacity(1),
                        ),
                        constraints: const BoxConstraints.expand(
                          height: 575.0,
                          width: 1000.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:[
                            Text(
                              'Organization Name and Website',
                              style: GoogleFonts.kreon(
                                color: const Color(0x555555).withOpacity(1),
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    constraints: BoxConstraints.expand(
                                      height: 55.0,
                                      width: 300.0
                                    ),
                                    child: Column(
                                      children:[
                                        const SizedBox(height: 3),
                                        TextFormField(
                                          controller: organizationNameController,
                                          style: GoogleFonts.kreon(
                                            color: const Color(0x555555).withOpacity(1),
                                            fontSize: 17,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: const Color(0xD9D9D9).withOpacity(1),
                                            contentPadding: EdgeInsets.only(left: 12, bottom: 20),
                                            border: const OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Color(0xAAD1DA).withOpacity(1), width: 2),
                                            ),
                                          ),
                                        ),     
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      constraints: const BoxConstraints.expand(
                                        height: 55.0,
                                        width: 300.0
                                      ),
                                      child: Column(
                                        children:[  
                                          const SizedBox(height: 3),
                                          TextFormField(
                                            controller: websiteController,
                                            style: GoogleFonts.kreon(
                                              color: const Color(0x555555).withOpacity(1),
                                              fontSize: 17,
                                              fontWeight: FontWeight.w300,
                                            ),
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: const Color(0xD9D9D9).withOpacity(1),
                                              hintText: 'URL',
                                              hintStyle: GoogleFonts.kreon(
                                                color: const Color(0xA9A9A9).withOpacity(1),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w300,
                                              ),
                                              contentPadding: EdgeInsets.only(left: 12, bottom: 20),
                                              border: const OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: const Color(0xAAD1DA).withOpacity(1), width: 2),
                                              ),
                                            ),
                                          ),                     
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 25),
                              Text(
                                'Contact Info',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.kreon(
                                  color: const Color(0x555555).withOpacity(1),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Row (
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      constraints: const BoxConstraints.expand(
                                        height: 50.0,
                                        width: 300.0
                                      ),
                                      child: TextFormField(
                                        controller: contactNameController,
                                        textAlignVertical: TextAlignVertical.center,
                                        style: GoogleFonts.kreon(
                                          color: const Color(0x555555).withOpacity(1),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w300,
                                        ),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: const Color(0XD9D9D9).withOpacity(1),
                                          hintText: 'Name',
                                          hintStyle: GoogleFonts.kreon(
                                            color: const Color(0xA9A9A9).withOpacity(1),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          contentPadding: EdgeInsets.only(left: 12, bottom: 20),
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Color(0xAAD1DA).withOpacity(1), width: 2),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      constraints: const BoxConstraints.expand(
                                        height: 50.0,
                                        width: 300.0
                                      ),
                                      child: TextFormField(
                                        controller: emailController,
                                        textAlignVertical: TextAlignVertical.center,
                                        style: GoogleFonts.kreon(
                                          color: const Color(0x555555).withOpacity(1),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w300,
                                        ),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: const Color(0xD9D9D9).withOpacity(1),
                                          hintText: 'Email',
                                          hintStyle: GoogleFonts.kreon(
                                            color: const Color(0xA9A9A9).withOpacity(1),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          contentPadding: EdgeInsets.only(left: 12, bottom: 20),
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: const Color(0xAAD1DA).withOpacity(1), width: 2),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                        constraints: const BoxConstraints.expand(
                                          height: 50.0,
                                          width: 300.0
                                        ),
                                        child: TextFormField(
                                          controller: phoneController,
                                          textAlignVertical: TextAlignVertical.center,
                                          style: GoogleFonts.kreon(
                                            color: const Color(0x555555).withOpacity(1),
                                            fontSize: 17,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: const Color(0xD9D9D9).withOpacity(1),
                                            hintText: 'Phone Number',
                                            hintStyle: GoogleFonts.kreon(
                                              color: const Color(0xA9A9A9).withOpacity(1),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w300,
                                            ),
                                            contentPadding: const EdgeInsets.only(left: 12, bottom: 20),
                                            border: const OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Color(0xAAD1DA).withOpacity(1), width: 2),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 25),
                                Text(
                                  'How Would This Grant Benefit Your Organization? What Is Your Intended Use?',
                                  style: GoogleFonts.kreon(
                                    color: const Color(0x555555).withOpacity(1),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    constraints: const BoxConstraints.expand(
                                      height: 100,
                                      width: 950,
                                    ),
                                    child: TextFormField(
                                      controller: responseController,
                                      maxLines: 12,
                                      style: GoogleFonts.kreon(
                                        color: const Color(0x555555).withOpacity(1),
                                        fontSize: 17,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: const Color(0xD9D9D9).withOpacity(1),
                                        contentPadding: EdgeInsets.only(left: 12, bottom: 20),
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xAAD1DA).withOpacity(1), width: 2),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        userApplyGrant(
                                          context, 
                                          chosen.grantKey,
                                          organizationNameController.text,
                                          websiteController.text, 
                                          contactNameController.text, 
                                          emailController.text, 
                                          phoneController.text, 
                                          responseController.text, 
                                      );
                                      Navigator.pushNamed(context, '/np_applicationstatus');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFFF3B3F).withOpacity(1),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: SizedBox(height: 35, width: 150, 
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Text(
                                            'Submit',  
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
                                        Navigator.pushNamed(context, '/grantapp');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xAAD1DA).withOpacity(1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: SizedBox(height: 35, width: 150, 
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 5),
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}