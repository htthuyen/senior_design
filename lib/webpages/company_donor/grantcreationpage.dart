import 'dart:js_interop';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:givehub/webcomponents/donor_company_topbar.dart';
import 'package:givehub/webcomponents/usertopbar.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../authentication/auth.dart';
import '../../webcomponents/input_theme.dart';
import '../../webcomponents/validation.dart';
import '../company_donor/mygrants.dart';


class GrantCreationPage extends StatefulWidget {
  const GrantCreationPage({super.key});

  @override
  _GrantCreationPageState createState() => _GrantCreationPageState();
}

class _GrantCreationPageState extends State<GrantCreationPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController grantName = TextEditingController();
  final TextEditingController grantAmount = TextEditingController();
  final TextEditingController grantDeadline = TextEditingController();
  final TextEditingController paymentDetails = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController eligibity = TextEditingController();
  final TextEditingController eligibities = TextEditingController();

  // write data to user database
  void grantApplication()  async {
    try{
      await getUser();
      if (uid != null){
        DatabaseReference ref = FirebaseDatabase.instance.ref('grants').push();
        await ref.set({
          'donorID': uid,
          'grantName': grantName.text.toJS,
          'grantAmount': grantAmount.text.toJS,
          'grantDeadline': grantDeadline.text.toJS,
          'paymentDetails': paymentDetails.text.toJS,
          'donorName': name.text.toJS,
          'donorEmail': email.text.toJS,        
          'donorPhone': phone.text.toJS,
          'eligibility': eligibity.text.toJS,
          'furtherRequirements': eligibities.text.toJS
        });
      }
    } catch (error){
      print('$error');
    }
  }
void createNotification({
  required String userId, // Assuming you have the userId
  // required String type,
  // required String detail,
  required String orgName,
}) {
  try {
    final notificationsRef = FirebaseDatabase.instance.reference().child('notifications');
    
    final notificationData = {
      'type': 'grant creation',
      'detail': 'You have created a grant: $orgName',
      'orgName': orgName,
      'userId': userId,
    };

    notificationsRef.push().set(notificationData).then((_) {
      print('Notification created successfully.');
    }).catchError((error) {
      print('Error creating notification: $error');
    });
  } catch (e) {
    print('Error creating notification: $e');
  }
}
   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        inputDecorationTheme: MyInputTheme().theme(),
      ),
        home: Scaffold(
          key: _scaffoldKey,
          appBar: UserTopBar(),
          endDrawer: DonorComTopBar(),
      body: Builder(
        builder: (context) {
          return Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                SizedBox(
                  width: 389,
                  height: 100,
                child:Text(
                  ' Create Your Grant Application',
                  textAlign: TextAlign.center,
                    style: GoogleFonts.oswald(
                    color: const Color(0x555555).withOpacity(1),
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ),
                const SizedBox(height: 10),               
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextFormField(
                      controller: grantName,
                      validator: (s){
                        if(s!.isWhitespace()){
                          return 'This field is required';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        labelText: 'Grant Name',
                        fillColor: Color.fromRGBO(202, 235, 242, 0.9)
                        
                      ),
                    
                    ),
                    TextFormField(
                      controller: grantAmount,
                      validator: (s){
                        if(s!.isWhitespace()){
                          return 'This field is required';
                        }
                        return null;
                      },
                      keyboardType: const TextInputType.numberWithOptions(
                        signed: false,
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Grant Amount',
                        fillColor: Color.fromRGBO(202, 235, 242, 0.9)
                       
                      ),
                    
                    ),   
                  ],
                ),                   
                    const SizedBox(height:40),
                    Row(             
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextFormField(
                          controller: grantDeadline,
                          validator: (s){
                            if(s!.isWhitespace()){
                              return 'This field is required';
                            }
                            return null;
                          },
                          onTap: () async {
                            DateTime date = DateTime(1900);
                            FocusScope.of(context).requestFocus(new FocusNode());
                            date = ( await showDatePicker(
                              builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: Color(0xFF4549).withOpacity(1), // header background color
                                    onPrimary: Color(0x555555).withOpacity(1), // header text color
                                    onSurface: Color(0x555555).withOpacity(1), // body text color
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Color(0x555555).withOpacity(1), // button text color
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100)
                            ))!;
                            grantDeadline.text = date.toIso8601String().replaceRange(10, 23, '');
                          },
                          decoration: const InputDecoration(
                            labelText: 'Grant Deadline',
                            fillColor: Color.fromRGBO(202, 235, 242, 0.9)
                
                          ),
                        ),
                        TextFormField(
                          controller: paymentDetails,
                          validator: (s){
                            if(s!.isWhitespace()){
                              return 'This field is required';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: 'Payment Details',
                            fillColor: Color.fromRGBO(202, 235, 242, 0.9)
                
                          ),
                        
                        ),                                 
                    
                      ]         
                  
                    ),  
                    const SizedBox(height: 40),                       
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left:130),
                            child: Text(
                              'Your Company/Donor Details',
                              style: GoogleFonts.oswald(
                                color: const Color(0x555555).withOpacity(1),
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height:20),
                      Row (
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                        SizedBox(
                          width:300,
                          child: TextFormField(
                            controller: name,
                            validator: (s){
                              if(s!.isWhitespace()){
                                return 'This field is required';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              fillColor: Color.fromRGBO(202, 235, 242, 0.9)
                
                            ),
                          
                          ),
                        ), 
                        SizedBox(
                          width: 280,
                          child: TextFormField(
                            controller: email,
                            validator: (s){
                              if(s!.isWhitespace()){
                                return 'This field is required';
                              } else if (!s.isValidEmail()){
                                return 'This is not a valid email';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              fillColor: Color.fromRGBO(202, 235, 242, 0.9)
                
                            ),
                          
                          ),
                        ), 
                    
                        SizedBox(
                          width: 250,
                          child: TextFormField(
                            controller: phone,
                            validator: (s){
                              if(s!.isWhitespace()){
                                return 'This field is required';
                              } else if (!s.isValidPhoneNumber()){
                                return 'This is not a valid phone number';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Phone',
                              fillColor: Color.fromRGBO(202, 235, 242, 0.9)
                
                            ),
                          
                          ),
                        ), 
                          ],
                        ),
                        const SizedBox(height: 40),
                          
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                    TextFormField(
                      controller: eligibity,
                      validator: (s){
                        if(s!.isWhitespace()){
                          return 'This field is required';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Eligibility',
                        fillColor: Color.fromRGBO(202, 235, 242, 0.9)
                
                      ),
                    
                    ),
                    TextFormField(
                      controller: eligibities,
                      validator: (s){
                        if(s!.isWhitespace()){
                          return 'This field is required';
                        }
                        return null;
                      },
                          
                      decoration: const InputDecoration(
                        labelText: 'Further Eligibility Requirements ',
                        hintText: 'URL',
                        fillColor: Color.fromRGBO(202, 235, 242, 0.9)
                
                      ),
                    
                    ), 
                          ]
                          .map((child) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: child))
                            .toList(),
                        ),
                
                                  
                                  
                        const SizedBox(height: 40),
                        
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 50,
                              width: 150,
                              child: ElevatedButton(
                                onPressed: () {
                                  final isValid = _formKey.currentState!.validate();
                                  if (isValid){
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            'Are you sure to submit the application?',
                                            style: GoogleFonts.oswald(
                                              fontSize: 20,
                                              color: Color(0x555555).withOpacity(1), 
                                            ),
                                          ),
                                          actions: <Widget>[
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                TextButton(
                                                  onPressed: (){
                                                    grantApplication();
                                                    createNotification(userId: uid!, orgName: grantName.text);
                                                    Navigator.of(context).pop();
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context){
                                                        return AlertDialog(
                                                          title: Text(
                                                            'Your application is submitted successfully.',
                                                            style: GoogleFonts.oswald(
                                                              fontSize: 25,
                                                              color: Color(0x555555).withOpacity(1),
                                                            ),
                                                          ),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: (){
                                                                Navigator.of(context).pop();
                                                              },
                                                              child: Text(
                                                                'Close',
                                                                style: GoogleFonts.oswald(
                                                                  fontSize: 25,
                                                                  color: Colors.red
                                                                )
                                                              ))
                                                          ]
                                                        );

                                                      }
                                                    );
                                                    Navigator.push(context, new MaterialPageRoute(
                                                      builder: (context) =>
                                                      MyGrants()));
                                                  },
                                                  child: Text(
                                                    'Yes',
                                                    style: GoogleFonts.oswald(
                                                      fontSize: 25,
                                                      color: Colors.green
                                                    )
                                                  )
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.push(context, new MaterialPageRoute(
                                                    builder: (context) =>
                                                    MyGrants()));
                                                  },
                                                  child: Text(
                                                    'Cancel',
                                                    style: GoogleFonts.oswald(
                                                      fontSize: 20,
                                                      color: Colors.red
                                                    )
                                                  ),
                                                ),                                              
                                              ],
                                            )
                                          ]
                                        );
                                      }
                                    );
                                  }
                
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF08587).withOpacity(1),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  'Submit',  
                                  textAlign: TextAlign.center, 
                                  style: GoogleFonts.oswald(
                                    color: const Color(0x555555).withOpacity(1),
                                    fontSize: 17,
                                    
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width:50), 
                            SizedBox(
                              height: 50,
                              width: 150,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context, new MaterialPageRoute(
                                    builder: (context) =>
                                    MyGrants()));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFA9D1D9).withOpacity(1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  'Cancel',  
                                  textAlign: TextAlign.center, 
                                  style: GoogleFonts.oswald(
                                    color: const Color(0xFFFF3B3F).withOpacity(1),
                                    fontSize: 17,
                                    
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
            
          );
        }
      ),
               ),
    );
  }
}