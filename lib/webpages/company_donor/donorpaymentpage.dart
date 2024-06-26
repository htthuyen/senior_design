

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givehub/webcomponents/donor_company_topbar.dart';
import 'package:givehub/webcomponents/usertopbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:givehub/webcomponents/input_theme.dart';
import 'package:givehub/webcomponents/validation.dart';
import 'package:givehub/authentication/auth.dart';
import 'donorcompanydonationhistory.dart';


class DonorPaymentPage extends StatefulWidget{
  const DonorPaymentPage({super.key});

  
  @override
  _DonorPaymentPage createState() => _DonorPaymentPage();
}
class _DonorPaymentPage extends State<DonorPaymentPage>{

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController email = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController company = TextEditingController();
  final TextEditingController dateCtl = TextEditingController();
  final TextEditingController recipient = TextEditingController();
  final TextEditingController recipientEmail = TextEditingController();
  final TextEditingController amount = TextEditingController();



  //write data to the database
  void writeDonation() async {
    try {
    await getUser();
    final String? currentUserUid = uid;
    String? sender = name.text;
    String? companyName = company.text;
    String? emailSender = email.text;
    String? receiver = recipient.text;
    String? money = amount.text;
    String? date = dateCtl.text;
    String? receiverEmail = recipientEmail.text;

        

    // pending donation for donor/company
    if (uid != null) {
      DatabaseReference ref = FirebaseDatabase.instance.ref('pending_donations').push();
     
      await ref.set({
        'recipient': receiver,
        'recipientEmail': receiverEmail,
        'amount': money,
        'date': date,
        'sender': sender,
        'company': companyName,
        'senderEmail': emailSender,
        'donorcomID': uid,
      });

      final String? recipientNotId = await getUserID(receiver);
      createNotificationS(userId: recipientNotId!, sender: sender, recipient: recipient.text, recipientEmail: recipientEmail.text);
    }
  } catch (error){
    print('$error');
  }


  }
  void createNotification({
  required String userId, // Assuming you have the userId
  // required String type,
  // required String detail,
  required String recipient,
  required String recipientEmail
}) {
  try {
    final notificationsRef = FirebaseDatabase.instance.reference().child('notifications');
    
    final notificationData = {
      'type': 'monetary donation',
      'detail': 'You have sent a monetary donation to $recipient',
      'recipient': recipient,
      'recipientEmail': recipientEmail,
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
  void createNotificationS({
  required String userId, // Assuming you have the userId
  // required String type,
  // required String detail,
  required String recipient,
  required String sender,
  required String recipientEmail
}) {
  try {
    final notificationsRef = FirebaseDatabase.instance.reference().child('notifications');
    
    final notificationData = {
      'type': 'monetary donation received',
      'detail': '$sender has sent you a monetary donation',
      'recipient': recipient,
      'recipientEmail': recipientEmail,
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
        body: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(
                width: 389,
                height: 131,
                child: Text(
                  'Donation Form',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.oswald(
                    color: const Color.fromRGBO(85, 85, 85, 1),
                    fontSize: 45,
                    fontWeight: FontWeight.w400, 
                  )    
                ),                    
              ),
              //full name and company field
              
              Column(
                children: [
                  Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormField(
                  controller: name,
                  validator: (s) {
                    if(s!.isWhitespace()){
                      return "This field is required";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    hintText: "Fullname*",
          
                  ),
                ),
                TextFormField(
                  controller: company,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    hintText: "Company",
          
                     
                  ),
                ),               
              ],
              ),
              
              const SizedBox(height: 30),
              // email and phone field
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormField(
                 validator: (s) {
                    if(s!.isEmpty){
                      return "This field is required";
                    } else if (!s.isValidEmail()) {
                      return "This is not a valid email.";
                    }
                    return null;
                  },
                  controller: email,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    hintText: "Email*",
                  ),
                ),
                         
                // Date
                TextFormField(
                 validator: (s) {
                    if(s!.isEmpty){
                      return "This field is required";
                    } 
                    return null;
                  },
                  controller: dateCtl,
                  // keyboardType: TextInputType.datetime,
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
                  decoration: const InputDecoration(
                    hintText: "Date",
                  ),
                ),               
              ],
            ),
            const SizedBox(height:30),
            Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                               // Recipient field
              TextFormField(
                validator: (s) {
                  if(s!.isEmpty) {
                    return "This field is required";
                  }
                  return null;
                },
                controller:  recipient,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: "Recipient*",
                   
                 ),
              ),
             
              //Amount field
              TextFormField(
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: false,
                ),
                validator:  (s) {
                  if(s!.isEmpty) {
                    return "This field is required";
                  } else if(!s.isValidAmount()){
                    return "This is not a valid amount";
                  }
                  return null;
              
                },
                controller: amount,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                decoration: const InputDecoration(
                  hintText: "Amount*",
                
                ),
              ),
                  ],
            ),
            const SizedBox(height:30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                
                 validator: (s) {
                    if(s!.isEmpty){
                      return "This field is required";
                    } else if (!s.isValidEmail()) {
                      return "This is not a valid email.";
                    }
                    return null;
                  },
                  controller: recipientEmail,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    hintText: "Recipient Email*",
                  ),
                ),
                         
              ],
            )
                ] 
                .map((child) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: child))
                  .toList(),
              ),
            const SizedBox(height: 50),
            Center(
              child:  ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA9D1D9),
                shadowColor: const Color(0x3F000000),
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0)),
                minimumSize: const Size(280, 92), 
              ),
              onPressed: () {
                final isValid = _formKey.currentState!.validate();
                if(isValid){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'Are you sure to submit the payment? This action cannot be undo.',
                        style: GoogleFonts.oswald(
                        fontSize: 30,
                        color: Color(0x555555).withOpacity(1), 
        
                        ),
                      ),
                      actions:<Widget> [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () {
                                writeDonation();
                                Navigator.of(context).pop();
                                createNotification(userId: uid!, recipient: recipient.text, recipientEmail: recipientEmail.text);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context){
                                    return AlertDialog(
                                      title:  Text(
                                        'Thank you for your support. The payment is under review.',
                                        style: GoogleFonts.oswald(
                                        fontSize: 30,
                                        color: Color(0x555555).withOpacity(1), 
          
                                        ),                                      
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) =>
                                              DonationHistoryDonorCompany()));
                                          },
                                          child: const Text(
                                            'Close'
                                          )
                                        ),
                                      ],
                                    );
                                  },

                                );
                              },
                              child: Text(
                                'Yes',
                                style: GoogleFonts.oswald(
                                  fontSize: 20,
                                  color: Colors.green
                                ),
                              )
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
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
                      ],
                    );
                  }
                );
                }
              },
              child: Text('Pay Here!' ,
              style: GoogleFonts.oswald(fontSize:40, color: const Color(0xFF545454))),
            )
            )
                  
                
              
          
              
            ]
           
            
          ),
        )
      ),
    );
  }
}
