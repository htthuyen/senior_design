
import 'package:flutter/material.dart';
import 'package:givehub/webcomponents/topbar.dart';
import 'package:givehub/webcomponents/validation.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../authentication/auth.dart';
import '../webcomponents/input_theme.dart';
import 'company_donor/companyprofilepage.dart';
import 'company_donor/donorprofile.dart';
import 'forgotpassword.dart';
import 'np/npprofilepage.dart';
import 'signup.dart';

class Login extends StatefulWidget{
  @override
  _Login createState() => _Login();

}
class _Login extends State<Login> {
    final _formKey = GlobalKey<FormState>();

  Color buttonColor = Color(0xCAEBF2);
  double buttonFontSize = 20;

  bool obscurePassword = true;

  // text editting controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isEditingEmail = false;
  bool _isEdditingPassword = false;
  bool _isLogin = false;

  String loginStatus='';

  

  //email validation
  String? _validateEmail(String text) {
    if(emailController.text.isNotEmpty){
       if (!text.isValidEmail()){
        return "Invalid email";
      }
    }
    return null;
  }
  //password validation
  String? _validatePassword(String text) {
    if(passwordController.text.isNotEmpty){
      if (text.length < 8){
        return "The password must be longer than 8";
      }
    } 
    return null;
  }


  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //the upgrade of flutter caused a shadow
      theme: ThemeData(
        useMaterial3: false,
        inputDecorationTheme: MyInputTheme().theme(),
      ),
      home: Scaffold(
        //the top portion of the webpage
        appBar: TopBar(),
        body: Builder(
          builder: (context) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    child: Container(
                      width: 550,
                      height: 600,
                      decoration: BoxDecoration(
                        color: Color(0xCAEBF2).withOpacity(1),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              'Sign In',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.oswald(
                                color: Color(0x555555).withOpacity(1),
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 60),
                            // Username field
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Email',
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.oswald(
                                      color: Color(0x555555).withOpacity(1),
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5), // Add space between text and field
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  autofocus: false,
                                  controller: emailController,
                                  onChanged: (value) {
                                    setState(() {
                                      _isEditingEmail = true;
                                    });
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "This field is required";
                                    }
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.person, color: Colors.white),
                                    errorText: _isEditingEmail ? _validateEmail(emailController.text) : null,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Password field
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Password',
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.oswald(
                                      color: Color(0x555555).withOpacity(1),
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5), // Add space between text and field
                                TextFormField(
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: obscurePassword,
                                  controller: passwordController,
                                  textInputAction: TextInputAction.done,
                                  autofocus: false,
                                  onChanged: (value) {
                                    setState(() {
                                      _isEdditingPassword = true;
                                    });
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "This field is required";
                                    }
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.lock, color: Colors.white),
                                    errorText: _isEdditingPassword ? _validatePassword(passwordController.text) : null,
                                    suffixIcon: IconButton(
                                      onPressed: () => setState(() {
                                        obscurePassword = !obscurePassword;
                                      }),
                                      icon: Icon(
                                        obscurePassword ? Icons.visibility_off : Icons.visibility,
                                        color: Color(0xFFFF3B3F),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Sign In Button
                            ElevatedButton(
                              onPressed: () async {
                                final isValid = _formKey.currentState!.validate();
                                setState(() {
                                  _isLogin = true;
                                });
                               await signInWithEmailAndPassword(context, emailController.text, passwordController.text)
                                .then((result) async {
                                  setState(() {
                                    loginStatus = 'Successfully logged in';
                                  });
                                  String? userType = await getUserTypeFromDatabase(uid!) as String?;
                                  if (userType == 'Nonprofit Organization') {
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NPProfilePage()));
                                  } else if (userType == 'Individual Donor') {
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DonorProfilePage()));
                                  } else if (userType == 'Company') {
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CompanyProfilePage()));
                                  }
                                })
                                .catchError((error) {
                                  print('Login Error: $error');
                                  setState(() {
                                    loginStatus = "Error: $error";
                                  });
                                })
                                .whenComplete(() {
                                  setState(() {
                                    _isLogin = false;
                                    emailController.text = '';
                                    passwordController.text = '';
                                    _isEditingEmail = false;
                                    _isEdditingPassword = false;
                                  });
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFA9D1D9),
                                shadowColor: Color(0x3F000000),
                                elevation: 3,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
                                minimumSize: Size(200, 50),
                              ),
                              child: _isLogin
                                  ? SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                                      ),
                                    )
                                  : Text(
                                      'Sign In',
                                      style: GoogleFonts.oswald(
                                        fontSize: 30,
                                        color: Color(0x555555).withOpacity(1),
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 50),
                            // Forgot Password | Sign Up
                            Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: () {
                                   Navigator.push(context, new MaterialPageRoute(
                                                builder: (context) =>
                                                  new ForgotPasswordPage())
                                                );
                                },
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(context, new MaterialPageRoute(
                                                builder: (context) =>
                                                  new SignUp())
                                                );
                                },
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Color(0xFFFF3B3F)
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}