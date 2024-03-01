import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';
import 'package:zhilki/first/signup.dart';
import 'package:zhilki/main%20page/navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

import '../models/usermodel.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String s = "Demo";
  String d = "Demo";

  @override
  void dispose() {
    _emailController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool on = false;
  String var1 = " ";
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show the alert dialog and wait for a result
        bool exit = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Exit App'),
              content: Text('Are you sure you want to exit?'),
              actions: [
                ElevatedButton(
                  child: Text('No'),
                  onPressed: () {
                    // Return false to prevent the app from exiting
                    Navigator.of(context).pop(false);
                  },
                ),
                ElevatedButton(
                  child: Text('Yes'),
                  onPressed: () {
                    // Return true to allow the app to exit
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        );

        // Return the result to handle the back button press
        return exit ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.red,
        ),
        backgroundColor: Colors.red,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Image.asset(
                  "assets/login-form-img.png"),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 500,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0), // Adjust the radius as needed
                    topRight:
                        Radius.circular(20.0), // Adjust the radius as needed
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Text("   Login Now", textAlign : TextAlign.left, style : TextStyle(color : Colors.black, fontWeight : FontWeight.w900, fontSize: 24)),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width : 100  ,
                          child: Padding(
                            padding: const EdgeInsets.only( left : 10.0),
                            child: IntlPhoneField(
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                isDense: true, enabled : false ,
                                border: OutlineInputBorder(),
                              ),
                              initialCountryCode: 'IN',
                              onChanged: (phone) {
                                print(phone.completeNumber);
                              }, readOnly: true, disableLengthCheck: true,
                            ),
                          ),
                        ),
                        Container(
                          width : MediaQuery.of(context).size.width - 100  ,
                          child: Padding(
                            padding: const EdgeInsets.only( left :10, right : 18.0),
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              decoration: InputDecoration(
                                labelText: 'Your Phone Number',
                                isDense: true,
                                border: OutlineInputBorder(),
                                enabled: !on,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    on
                        ? Padding(
                            padding: const EdgeInsets.only(left: 18, right: 18),
                            child: OTPTextFieldV2(
                              length: 6,
                              width: MediaQuery.of(context).size.width,
                              textFieldAlignment: MainAxisAlignment.spaceAround,
                              fieldWidth: 50,
                              fieldStyle: FieldStyle.box,
                              outlineBorderRadius: 25,
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w800),
                              onChanged: (pin) {
                                print("Changed: " + pin);
                              },
                              onCompleted: (pin) async {
                                print("Completed: " + pin);
                                  String smsCode = pin;
                                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                                          verificationId: var1,
                                          smsCode: smsCode);
                                  try {
                                    await _auth.signInWithCredential(credential);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Success!'),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                    String uid = FirebaseAuth.instance.currentUser!.uid ;
                                    nowsend(uid);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Verification Failed'),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                    print('Error signing in: $e');
                                  }
                              },
                            ),
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 20,
                    ),
                    on
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20.0, top: 11),
                            child: Row(
                              children: [
                                CircularProgressIndicator(
                                  strokeWidth: 3.0,
                                ),
                                SizedBox(width: 15),
                                Text("We are auto verifying your OTP",
                                    style: TextStyle(fontSize: 15))
                              ],
                            ),
                          )
                        : SizedBox(),
                    if (on) SizedBox() else Padding(
                            padding: const EdgeInsets.only(left: 18.0, right: 18),
                            child: SocialLoginButton(
                                backgroundColor: Color(0xff00652E),
                                height: 40,
                                text: 'SEND OTP',
                                borderRadius: 20,
                                fontSize: 21,
                                buttonType: SocialLoginButtonType.generalLogin,
                                onPressed: () async {
                                  if (_emailController.text.length == 10) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text('Please wait ! We are verfying you are not a robot'),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                    try {
                                      await _auth.verifyPhoneNumber(
                                        phoneNumber:
                                            "+91" + _emailController.text,
                                        verificationCompleted: (PhoneAuthCredential credential) async {
                                          await _auth
                                              .signInWithCredential(credential);
                                          String uid = FirebaseAuth.instance.currentUser!.uid ;
                                          nowsend(uid);
                                        },

                                        verificationFailed:
                                            (FirebaseAuthException e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content:
                                                  Text('Verification Failed '),
                                              duration: Duration(seconds: 3),
                                            ),
                                          );
                                          print(
                                              'Verification failed: ${e.message}');
                                        },
                                        codeSent: (String verificationId,
                                            int? resendToken) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Code sent to your number'),
                                              duration: Duration(seconds: 3),
                                            ),
                                          );
                                          Navigator.push(
                                              context, PageTransition(
                                              child: Step2(var1: verificationId, phone: _emailController.text,), type: PageTransitionType.leftToRight, duration: Duration(milliseconds: 300)
                                          ));
                                          print(
                                              'Verification ID: $verificationId');
                                        },
                                        codeAutoRetrievalTimeout:
                                            (String verificationId) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text('Code time out '),
                                              duration: Duration(seconds: 3),
                                            ),
                                          );
                                          // Auto-retrieval of the SMS code timed out.
                                          // Handle the situation by manually verifying the code.
                                          print(
                                              'Auto Retrieval Timeout. Verification ID: $verificationId');
                                        },
                                      );
                                    } catch (e) {
                                      print(
                                          'Error sending verification code: $e');
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('${e}'),
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Type 10 digit number'),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                }),
                          ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void verifyPhoneNumber(String phoneNumber) async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {

    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      print('Phone verification failed: ${authException.message}');
    };

    PhoneCodeSent codeSent =
        (String verificationId, [int? forceResendingToken]) async {
      String smsCode = '...'; // Get the SMS code from the user.
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      // Sign in with the credential.
      await _auth.signInWithCredential(credential);
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      // Auto retrieval timeout.
    };

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  void nowsend (String uid ) async {
    String uidToSearch = uid; // Replace with the actual uid you want to search

    UserModel? user2 = await getUserByUid(uidToSearch);

    if (user2 != null) {
      print("User found: His Name }");
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        "Age" : _emailController.text,
      });
      Navigator.push(
          context, PageTransition(
          child: Home(), type: PageTransitionType.leftToRight, duration: Duration(milliseconds: 300)
      ));
    } else {
      UserModel njh = UserModel(Username: "", Email: "", Name: "", Pic_link: "",
          Bio: "", Won: 0, uid: uid, lastlogin: "", code: "",
          lastloginn: "", Date: "", Phone_Number: _emailController.text);
      await FirebaseFirestore.instance.collection('users').doc(uid).set(njh.toJson());
      Navigator.push(
          context, PageTransition(
          child: NewU(), type: PageTransitionType.leftToRight, duration: Duration(milliseconds: 300)
      ));
    }
  }
  Future<UserModel?> getUserByUid(String uid) async {
    try {
      // Reference to the 'users' collection
      CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

      // Query the collection based on uid
      QuerySnapshot querySnapshot = await usersCollection.where('uid', isEqualTo: uid).get();

      // Check if a document with the given uid exists
      if (querySnapshot.docs.isNotEmpty) {
        // Convert the document snapshot to a UserModel
        UserModel user = UserModel.fromSnap(querySnapshot.docs.first);
        return user;
      } else {
        // No document found with the given uid
        return null;
      }
    } catch (e) {
      print("Error fetching user by uid: $e");
      return null;
    }
  }
}

class NewU extends StatelessWidget {
  const NewU({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children : [
          Spacer(),
          Image.network("https://previews.123rf.com/images/qualitdesign/qualitdesign1904/qualitdesign190400019/124007527-five-happy-friends-make-selfie-photo-friendship-vector-flat-illustration-young-people-have-a-fun.jpg"),
          SizedBox( height : 20),
          Text( textAlign : TextAlign.center , "Your Account Created Successfully", style : TextStyle ( fontSize:  29, fontWeight: FontWeight.w800)),
          SizedBox( height : 8),
          Text( textAlign : TextAlign.center ,"Now place order for your Products, pay, and get your products deliver at home, It is that simple !", style : TextStyle ( fontSize:  18, fontWeight: FontWeight.w400)),
          SizedBox( height : 18),
          ElevatedButton(onPressed: (){
            Navigator.push(
                context, PageTransition(
                child: Home(), type: PageTransitionType.leftToRight, duration: Duration(milliseconds: 300)
            ));
          }, child: Text("Continue", style : TextStyle ( fontSize:  25))),
          Spacer(),
        ]
      )
    );
  }
}
