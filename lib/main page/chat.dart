import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:zhilki/card/product_card.dart';
import 'package:zhilki/second_pages/cart.dart';
import 'package:zhilki/second_pages/search.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:zhilki/models/usermodel.dart';
import 'package:flutter/foundation.dart' as foundation;
import '../models/productmodel.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);
  @override
  State<Chat> createState() => ChatState();
}
class ChatState extends State<Chat> {
  List<ProductDetails> list = [];
  late Map<String, dynamic> userMap;
  final Fire = FirebaseFirestore.instance;
   String gh = FirebaseAuth.instance.currentUser!.uid ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Whislist Products", style : TextStyle(color : Colors.white)),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff00652E),
      ),
      body : StreamBuilder(
        stream: Fire.collection('products').where("Love", arrayContains: gh ).snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list = data
                  ?.map((e) => ProductDetails.fromJson(e.data()))
                  .toList() ??
                  [];
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Set the number of items in each row
                  crossAxisSpacing: 5, // Set the spacing between columns
                  mainAxisSpacing: 10,
                ),
                itemCount: list.length,
                padding: EdgeInsets.all(10),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return ChatUser(
                    user: list[index],
                  );
                },
              );

          }
        },
      ),
    );
  }
}

