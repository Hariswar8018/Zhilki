import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_upi_payment/easy_upi_payment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:zhilki/main%20page/Teacher.dart';
import 'package:zhilki/main%20page/navigation.dart';
import 'package:zhilki/models/coupon_model.dart';
import 'package:zhilki/models/order_model.dart';
import 'package:zhilki/models/usermodel.dart';
import 'package:zhilki/providers/declare.dart';
import 'package:zhilki/second_pages/orders.dart';
import '../models/productmodel.dart';

class Sa extends StatelessWidget {
  Sa({super.key});
  List<Coupon> list1 = [];
  late Map<String, dynamic> userMap;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        backgroundColor: Color(0xff00652E),
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: Text("Coupons", style : TextStyle(color: Colors.white)),
      ),
      body : StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Coupons").snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list1 = data?.map((e) => Coupon.fromJson(e.data())).toList() ?? [];
              if (list1.isEmpty) {
                return Center(child: Text("No Coupons in the Cart"));
              } else {
                return ListView.builder(
                  itemCount: list1.length,
                  padding: EdgeInsets.only(left: 10),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ChatUser90(
                      user: list1[index],
                    );
                  },
                );
              }
          }
        },
      ),
    );
  }
}


class ChatUser90 extends StatelessWidget{
  Coupon user ;

  ChatUser90({required this.user,});
  @override
  Widget build(BuildContext context){
    return ListTile(
      tileColor: Colors.white60,
      leading : Icon(Icons.airplane_ticket_sharp, color : Colors.blue, size : 40),
      title : Text(user.name, style : TextStyle(fontWeight : FontWeight.w800)),
      subtitle: Text(user.description),
      trailing : TextButton( onPressed : (){
        Navigator.push(
            context, PageTransition(
            child: Clubs(), type: PageTransitionType.leftToRight, duration: Duration(milliseconds: 300)
        ));
      },
          child : Text("SHOP", style : TextStyle( fontWeight: FontWeight.w600, fontSize: 18))),
    );
  }
}
