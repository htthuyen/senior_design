
import 'package:flutter/material.dart';
import 'package:givehub/webcomponents/topbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import '../authentication/auth.dart';
import '../webcomponents/input_theme.dart';
import 'login.dart';
import '../webcomponents/validation.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String registerStatus ='';
  bool _isRegistering = false;

  final _radioButtons = [
    'Nonprofit Organization',
    'Company',
    'Individual Donor'
  ];

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String selectedUserType = '';
  
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool obscurePassword = true;

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
        appBar: TopBar(),
        body: 
           Builder(
             builder: (context) {
               return ListView(
                 children:<Widget>[
                   SizedBox(
                     width: 402,
                     height: 55,
                     child: Text(
                       'Create an Account',
                       textAlign: TextAlign.center,
                       style: GoogleFonts.oswald(
                         color: Color(0xFF545454),
                         fontSize: 45,
                         fontWeight: FontWeight.w400, 
                         height:0,
                       )    
                     ),                    
                   ),
                    const SizedBox(height:10),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(25.0),
                           decoration: BoxDecoration(
                             color: const Color(0xCAEBF2).withOpacity(1),
                             borderRadius: BorderRadius.circular(20),
                           ),
                           constraints: const BoxConstraints.expand(
                            height: 650.0,
                             width: 1000.0,
                           ),
                             
                           child: Form(
                            key: _formKey,
                             child: Column(
                               children:[
                                 Expanded(
                                   flex: 5,
                                   child: Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [ 
                                     Expanded(
                                       flex: 2,
                                       child: Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           Text(
                                             'Name',
                                             style: GoogleFonts.kreon(
                                               color: const Color(0x555555).withOpacity(1),
                                               fontSize: 17,
                                               fontWeight: FontWeight.w400,
                                             ),
                                           ),
                                           const SizedBox(height: 3),
                                           TextFormField(
                                            keyboardType: TextInputType.name,
                                            textInputAction: TextInputAction.next,
                                             validator: (value){
                                               if (value!.isWhitespace()){
                                                 return 'This field is requied';    
                                               } 
                                               return null;                                        
                                             },
                                             controller: nameController,
                                             style: GoogleFonts.kreon(
                                               color: const Color(0x555555).withOpacity(1),
                                               fontSize: 16,
                                               fontWeight: FontWeight.w300,
                                             ),
                                             decoration: InputDecoration(
                                               filled: true,
                                               fillColor: const Color(0xD9D9D9).withOpacity(1),
                                               contentPadding: EdgeInsets.all(12),
                                               border: OutlineInputBorder(
                                                 borderRadius: BorderRadius.circular(25),
                                                 borderSide: BorderSide.none,
                                               ),
                                               hintText: 'First and last name for individuals; Organization name for companies and nonprofits.',
                                               hintStyle: GoogleFonts.kreon(
                                                 color: const Color(0x555555).withOpacity(1),
                                                 fontSize: 13,
                                                 fontWeight: FontWeight.w200,),
                                               focusedBorder: OutlineInputBorder(
                                                 borderRadius: BorderRadius.circular(25),
                                                 borderSide: BorderSide(color: Color(0xAAD1DA).withOpacity(1), width: 2),
                                                 ),
                                               ),
                                             ),
                                             const SizedBox(height: 12),
                                             Text(
                                               'Phone Number',
                                               style: GoogleFonts.kreon(
                                                 color: const Color(0x555555).withOpacity(1),
                                                 fontSize: 17,
                                                 fontWeight: FontWeight.w400,
                                               ),
                                             ),
                                             const SizedBox(height: 3),
                                             TextFormField(
                                               controller: phoneController,
                                               keyboardType: TextInputType.phone,
                                               textInputAction: TextInputAction.next,
                                               validator: (p0) {
                                                 if (p0!.isEmpty){
                                                   return "This field is required";
                                                 } else if (!p0.isValidPhoneNumber()){
                                                   return "Invalid phone number";
                                                 }
                                                 return null;
                                               },
                                               style: GoogleFonts.kreon(
                                                 color: const Color(0x555555).withOpacity(1),
                                                 fontSize: 16,
                                                 fontWeight: FontWeight.w300,
                                               ),
                                               decoration: InputDecoration(
                                                 filled: true,
                                                 fillColor: const Color(0xD9D9D9).withOpacity(1),
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
                                             const SizedBox(height: 12),
                                             Text(
                                               'Email',
                                               style: GoogleFonts.kreon(
                                                 color: const Color(0x555555).withOpacity(1),
                                                 fontSize: 17,
                                                 fontWeight: FontWeight.w400,
                                               ),
                                             ),
                                             const SizedBox(height: 3),
                                             TextFormField(
                                               validator: (value) {
                                                 if (value!.isWhitespace()){
                                                   return "This field is required";
                                                 } else if (!value.isValidEmail()){
                                                   return "Invalid email";
                                                 }
                                                 return null;
                                               },
                                               controller: emailController,
                                               textAlignVertical: TextAlignVertical.center,
                                               style: GoogleFonts.kreon(
                                                 color: const Color(0x555555).withOpacity(1),
                                                 fontSize: 16,
                                                 fontWeight: FontWeight.w300,
                                               ),
                                               decoration: InputDecoration(
                                                 filled: true,
                                                 fillColor: const Color(0xD9D9D9).withOpacity(1),
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
                                             const SizedBox(height: 12),
                                             Text(
                                               'Password',
                                               style: GoogleFonts.kreon(
                                                 color: const Color(0x555555).withOpacity(1),
                                                 fontSize: 17,
                                                 fontWeight: FontWeight.w400,
                                               ),
                                             ),
                                           const SizedBox(height: 3),
                                           TextFormField(
                                             validator: (value){
                                               if (value!.isWhitespace()){
                                                 return "This field is required";
                                               } else if(!value.isValidPassword()){
                                                 return "The password must contain more than 8 characters including\n"
                                                   "- at least one uppercase, at least one lowercase, number, and special character";
                                               }
                                               return null;
                                             },
                                             controller: passwordController,
                                             obscureText: obscurePassword,
                                             style: GoogleFonts.kreon(
                                               color: const Color(0x555555).withOpacity(1),
                                               fontSize: 16,
                                               fontWeight: FontWeight.w300,
                                             ),
                                             decoration: InputDecoration(
                                               suffixIcon: IconButton(
                                               onPressed: () => setState(() {
                                                 obscurePassword = !obscurePassword;
                                               }),
                                               icon: Icon( 
                                               obscurePassword ? Icons.visibility_off : Icons.visibility,
                                               color: Color(0xFF3B3F).withOpacity(1),
                                               size: 17,
                                             ),
                                              ),
                                               filled: true,
                                               fillColor: const Color(0xD9D9D9).withOpacity(1),
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
                                           const SizedBox(height: 12),
                                           Text(
                                             'Re-enter Password',
                                             style: GoogleFonts.kreon(
                                               color: const Color(0x555555).withOpacity(1),
                                               fontSize: 17,
                                               fontWeight: FontWeight.w400,
                                             ),
                                           ),
                                           const SizedBox(height: 3),
                                           TextFormField(
                                             validator: (value) {
                                               if (value != passwordController.text){
                                                 return "Passwords do not match.";
                                               } else if (value!.isWhitespace()){
                                                 return "This field is required";
                                               }
                                               return null;
                                             },
                                             controller: confirmPasswordController,
                                                                   
                                             obscureText: obscurePassword,
                                             style: GoogleFonts.kreon(
                                               color: const Color(0x555555).withOpacity(1),
                                               fontSize: 16,
                                               fontWeight: FontWeight.w300,
                                             ),
                                             decoration: InputDecoration(
                                               suffixIcon: IconButton(
                                                 onPressed: () => setState(() {
                                                   obscurePassword = !obscurePassword;
                                                 }),
                                                 icon: Icon( 
                                                   obscurePassword ? Icons.visibility_off : Icons.visibility,
                                                   color: Color(0xFF3B3F).withOpacity(1),
                                                   size: 17,
                                                 ),
                                               ),
                                               filled: true,
                                               fillColor: const Color(0xD9D9D9).withOpacity(1),
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
                                           const SizedBox(height: 40),
                                         ],
                                       ),
                                     ),
                                     Expanded(
                                       flex: 1,
                                       child: Column(
                                         crossAxisAlignment: CrossAxisAlignment.center,
                                         children: [
                                           const Padding(padding: EdgeInsets.only(left:100, right:100),),
                                           const SizedBox(height: 115),
                                           Text(
                                             'I am a...',
                                             style: GoogleFonts.kreon(
                                               color: const Color(0x555555).withOpacity(1),
                                               fontSize: 17,
                                               fontWeight: FontWeight.w400,
                                             ),
                                           ),
                                           GroupButton(
                                             isRadio: true,
                                             buttons: _radioButtons,
                                             onSelected: (selectedText, index, isSelected) {
                                               setState(() {
                                                 selectedUserType = selectedText; 
                                               });
                                             },
                                             options: GroupButtonOptions(
                                               groupingType: GroupingType.column,
                                               alignment: Alignment.center,
                                               unselectedTextStyle: GoogleFonts.kreon(
                                                   color: const Color(0x555555).withOpacity(1),
                                                   fontSize: 15,
                                                   fontWeight: FontWeight.w500,
                                                 ),
                                               selectedTextStyle: GoogleFonts.kreon(
                                                   color: const Color(0x555555).withOpacity(1),
                                                   fontSize: 17,
                                                   fontWeight: FontWeight.w500,
                                                 ),
                                               selectedColor: Color(0xFF3B3F).withOpacity(1),
                                               unselectedColor: Color(0xF18587).withOpacity(1),
                                               borderRadius: BorderRadius.circular(20),
                                               buttonHeight: 35,
                                               buttonWidth: 300,
                                               spacing: 3,
                                             ), 
               
                                           ),
                                           
                                         ],
                                        
                                       ),
                                       
                                     ),        
                                   ],
                                 ),
                                ),
               
                               Row (
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 crossAxisAlignment: CrossAxisAlignment.end,
                                 children: [
                                   Column(
                                     children: [
                                       ElevatedButton(
                                         onPressed: () async {
                                                           
                                           setState(() {
                                             _isRegistering = true;
                                           });
                                           final isValid = _formKey.currentState!.validate();
                                           if(selectedUserType.trim().isEmpty) {
                                             ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                 content: const Text('Please select who you are.' ),
                                                 backgroundColor: Colors.red[300],)) ;
                                           } 
                                           if(isValid && selectedUserType.isNotEmpty){       
                                            await registerWithEmailPassword(context,emailController.text, passwordController.text,
                                              selectedUserType, nameController.text, phoneController.text)
                                            .then((result){
                                              if (result != null){
                                                setState(() {
                                                  registerStatus = 'Registered successfully';
                                                });               
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
                                                         'Your account was created successfully!',
                                                         style: GoogleFonts.oswald(
                                                           fontSize: 30,
                                                           color: Colors.white,
                                                         ),
                                                       ),
                                                     ),
                                                     actions: <Widget>[
                                                       Center(
                                                         // Center the button
                                                         child: TextButton(
                                                           style: ButtonStyle(
                                                             backgroundColor: MaterialStateProperty.all<Color>(
                                                                 Colors.white), // Set background color
                                                           ),
                                                           onPressed: () {
                                                              // Close the dialog
                                                              if ((selectedUserType.trim().toLowerCase() == 'individual donor') || (selectedUserType.trim().toLowerCase() == 'company')  ) {
                                                                  Navigator.pushNamed(context, '/donationsinterest');                                                              
                                                              } else if (selectedUserType.trim().toLowerCase()=='nonprofit organization'){
                                                                Navigator.pushNamed(context, '/needs');

                                                              
                                                              }
                                                           },
                                                           child: Text(
                                                             'Continue',
                                                             style: GoogleFonts.oswald(
                                                               fontSize: 15,
                                                               color: Color(0x555555).withOpacity(
                                                                   1), // Set your desired button color here
                                                             ),
                                                           ),
                                                         ),
                                                       ),
                                                     ],
                                                   ),
                                                 ),
                                               );
                                             },
                                           );                                            
                                           }
                                           }).catchError((error) {
                                             print('Registration Error: $error');
                                             setState(() {
                                               registerStatus = 'Error occurred while registering';
                                             });
                                           }
                                           
                                           ).whenComplete(() {
                                            setState(() {
                                              _isRegistering = false;
                                              emailController.text = '';
                                              passwordController.text='';
                                              
                                            });
                                           });
                                           }
                                         },
                                         
                                         style: ElevatedButton.styleFrom(
                                           backgroundColor: const Color(0xAAD1DA).withOpacity(1),
                                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
                                           ),
                                         ),
                                         child: 
                                          SizedBox(
                                          height: 30,
                                          width: 110,
                                          
                                           
                                           child: Center(
                                             child: Text(
                                                 'Sign Up',                             
                                                 textAlign: TextAlign.center, 
                                                 style: GoogleFonts.kreon(
                                                   color: const Color(0x555555).withOpacity(1),
                                                   fontSize: 16,
                                                   fontWeight: FontWeight.w700,
                                                 ),
                                               ),
                                           ),
                                          ),
                                           
                                         
                                       ),
                                       const SizedBox(height: 12),
                                       // FIND A WAY TO CLICK SIGN IN AND GO TO A DIFFERENT PAGE
                                       Row(
                                         children: [
                                         Text(
                                           'Already have an account?',
                                           style: GoogleFonts.kreon(
                                             color: const Color(0x555555).withOpacity(1),
                                             fontSize: 14,
                                             fontWeight: FontWeight.w300,
                                           ),
                                         ),
                                         TextButton(
                                           //control the flow of buttons when pressed
                                           onPressed: () {
                                              Navigator.push(context, new MaterialPageRoute(
                                                builder: (context) =>
                                                  new Login())
                                              );
                                           },
                                           child: Text(
                                             'Sign in',
                                               style: GoogleFonts.kreon(
                                                 color: const Color(0x555555).withOpacity(1),
                                                 fontSize: 14,
                                                 fontWeight: FontWeight.w400,
                                             ),
                                           ),
                                         ),
                                         ],
                                       ),
                                     ],
                                   ),
                                 ],
                               ),
                             ],
                                                  ),
                           ),
                                              ),
                        ),
                      ),
                    ),
                 ],
               );
             }
           ),
            
           
    )
            );

            }
            }

