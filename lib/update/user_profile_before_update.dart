import 'dart:typed_data';

import 'package:zhilki/first/onboarding.dart';
import 'package:zhilki/providers/storage.dart';
import 'package:zhilki/update/any_String.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:zhilki/models/usermodel.dart';
import 'package:zhilki/providers/declare.dart';

class Before_Update extends StatefulWidget {
  const Before_Update({super.key});

  @override
  State<Before_Update> createState() => _Before_UpdateState();
}

class _Before_UpdateState extends State<Before_Update> {
  initState() {
    super.initState();
    vq();
  }

  vq() async {
    UserProvider _userprovider = Provider.of(context, listen: true);
    await _userprovider.refreshuser();
  }


  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    String s = FirebaseAuth.instance.currentUser!.uid ;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title : Text("Account", style : TextStyle(color : Colors.white, fontWeight: FontWeight.w600, fontSize: 24)),
        backgroundColor: Color(0xff00652E), automaticallyImplyLeading: true,
         iconTheme: IconThemeData(
            color: Colors.white
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Center(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSBY7ZB3xlh4eEDjYkRZvxualXOi_E1qCsutFaWaEplWg&s",
                  ),
                  minRadius: 50,
                  maxRadius: 60,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Text("Update Profile Picture"),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Divider(),
              ),
              Padding(
                padding: const EdgeInsets.only( left : 16.0, right : 16, bottom : 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children : [
                      Text("Profile Information", style : TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
                      Spacer(),
                    ]
                ),
              ),
              InkWell(
                  onTap: (){
                    Navigator.push(
                        context, PageTransition(
                        child: Update(Name: 'Name', Firebasevalue: 'Name',), type: PageTransitionType.topToBottom, duration: Duration(milliseconds: 100)
                    ));
                  },
                  child: a("Name", _user!.Name, 51, true)),
              InkWell(
                  onTap: (){
                    Navigator.push(
                        context, PageTransition(
                        child: Update(Name: 'Username', Firebasevalue: 'Chess_Level',), type: PageTransitionType.topToBottom, duration: Duration(milliseconds: 100)
                    ));
                  },
                  child: a("UserName", _user!.Username, 15, true)),
              Padding(
                padding: const EdgeInsets.only( left : 10, right : 10, bottom : 10),
                child: Divider(),
              ),
              Padding(
                padding: const EdgeInsets.only( left : 16.0, right : 16, bottom : 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children : [
                      Text("Personal Information", style : TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
                      Spacer(),
                    ]
                ),
              ),
              a("USER Id", _user!.uid, 29, false),
              InkWell(
                  onTap: (){
                    Navigator.push(
                        context, PageTransition(
                        child: Update(Name: 'Email', Firebasevalue: 'Email',), type: PageTransitionType.topToBottom, duration: Duration(milliseconds: 100)
                    ));
                  },
                  child: a("Email", _user!.Email, 45, true)),
              a("Phone", "+91 " + _user!.Phone_Number, 37, false),
              InkWell(
                  onTap: (){
                    Navigator.push(
                        context, PageTransition(
                        child: Update(Name: 'DOB', Firebasevalue: 'Bio',), type: PageTransitionType.topToBottom, duration: Duration(milliseconds: 100)
                    ));
                  },
                  child: a("DOB", _user!.Bio, 29, true)),
              IconButton(onPressed: (){
                FirebaseAuth auth = FirebaseAuth.instance;
                auth.signOut().then((res) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => TestScreen()),
                  );
                });
              }, icon: Icon(Icons.login_outlined, size : 40)),
              SizedBox(height: 50,),
            ],
          ),
        ),
      ),
    );
  }
  Widget a(String s, String s2 , double s3, bool ist){
    return Padding(
      padding: const EdgeInsets.only (left : 18.0, right : 18, bottom : 20),
      child: Row(
        children: [
          Text("$s", style : TextStyle(fontSize: 19)),
          SizedBox(width : s3),
          Text(s2, style : TextStyle(fontSize: 19)),
          ist ? Spacer() : SizedBox(),
          ist ? Icon(Icons.arrow_forward_ios_sharp, color: Colors.black, size: 20,) : SizedBox(),
        ],
      ),
    );
  }
}
