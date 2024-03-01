
import 'package:provider/provider.dart';
import 'package:zhilki/main%20page/Teacher.dart';
import 'package:zhilki/main%20page/chat.dart';
import 'package:zhilki/main%20page/home.dart';
import 'package:zhilki/main%20page/profile.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:zhilki/providers/declare.dart';

class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{


  initState() {
    super.initState();
    vq();
  }

  vq() async {
    UserProvider _userprovider = Provider.of(context, listen: false);
    await _userprovider.refreshuser();
  }

  int currentTab=0;
  final Set screens ={
    HomeP(),
    Chat(),
    Clubs(),
    Learn(),
  };
  final PageStorageBucket bucket = PageStorageBucket();

  Widget currentScreen = HomeP();

  @override
  Widget build(BuildContext context){
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
                    onPressed: () async {
                      DateTime now = DateTime.now();
                      String s = FirebaseAuth.instance.currentUser!.uid;
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(s)
                          .update({
                        "lastloginn" : now.toString() ,
                      });
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
          backgroundColor: Colors.white,
          body: PageStorage(
            child: currentScreen,
            bucket: bucket,
          ),
          bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 4, color: Colors.white, surfaceTintColor: Colors.white,
            shadowColor:  Colors.white,
            child: Container(
              height: 20, color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                      minWidth: 25, onPressed: (){
                    setState(() {
                      currentScreen = HomeP();
                      currentTab = 0;
                    });
                  },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.home,
                            color: currentTab == 0? Colors.black : Colors.grey, size: 23,
                          ),
                          Text("Home", style: TextStyle(color: currentTab == 0?  Colors.black :Colors.grey, fontSize: 12))
                        ],
                      )
                  ),
                  MaterialButton(
                      minWidth: 25, onPressed: (){
                    setState(() {
                      currentScreen = Clubs();
                      currentTab = 1;
                    });
                  },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.production_quantity_limits_sharp,
                            color: currentTab == 1? Colors.black:Colors.grey,size: 23,
                          ),
                          Text("Products", style: TextStyle(color: currentTab == 1? Colors.black :Colors.grey,fontSize: 12))

                            ],
                      )
                  ),
                  MaterialButton(
                    minWidth: 25, onPressed: (){
                    setState(() {
                      currentScreen = Chat();
                      currentTab = 2;
                    });
                  },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_rounded,
                          color: currentTab == 2? Colors.black:Colors.grey, size: 23,
                        ),
                        Text("Whislist", style: TextStyle(color: currentTab == 2? Colors.black:Colors.grey, fontSize: 12))

                      ],
                    ),
                  ),
                  MaterialButton(
                      minWidth: 25, onPressed: (){
                    setState(() {
                      currentScreen = Learn();
                      currentTab = 3;
                    });
                  },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.profile_circled,
                            color: currentTab == 3? Colors.black:Colors.grey, size: 23,
                          ),
                          Text("Profile", style: TextStyle(color: currentTab == 3? Colors.black:Colors.grey, fontSize: 12))
                        ],
                      )
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}