import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:givehub/webcomponents/topbar.dart';
import 'package:givehub/webpages/signup.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body: Center(
        child: Container(
          width: 500,
          height: 450,
          decoration: BoxDecoration(
            color: const Color(0xCAEBF2).withOpacity(1),
            borderRadius: BorderRadius.circular(25.0),
          ),
          padding: EdgeInsets.all(50),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Forgot Password',
                    style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                SizedBox(height: 60),
                Text(
                  "Email",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xA9A9A9).withOpacity(.7),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  // onSaved: (value) {
                  //   email.t = value;
                  // },
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // _formKey.currentState!.save();
                        // Continue button functionality
                        try{
                        await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text).then(
                          (result){
                           showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Center(
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  width: 600,
                                  height: 500,
                                  child: AlertDialog(
                                    backgroundColor: Color(0xFFFF3B3F).withOpacity(1),
                                    content: Padding(
                                      padding: const EdgeInsets.only(bottom: 20), // Add bottom padding to the content
                                      child: Text(
                                        'A password reset link has been sent to ${email.text}.',
                                        style: GoogleFonts.oswald(
                                          fontSize: 30,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );      
                          });
                      });
                      } on FirebaseAuthException catch (e){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:  Text(
                              'Failed with error code ${e.code}'
                            ))
                        );
                      }
                      
                      }

                  
                    },
                    child: Text('Continue', style: GoogleFonts.inter(color: Colors.black, fontSize: 20)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xAAD1DA).withOpacity(1),
                      elevation: 1,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => SignUp()));
                  },
                  child: const Text(
                    "Don't have an account? Sign up",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}