
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:zhilki/card/product_detail_card.dart';
import 'package:zhilki/main%20page/chat.dart';
import 'package:zhilki/models/productmodel.dart';

class ChatUser extends StatelessWidget {
  ProductDetails user;
  String gh = FirebaseAuth.instance.currentUser!.uid ;
  ChatUser({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
            context, PageTransition(
            child: PC(user : user), type: PageTransitionType.leftToRight, duration: Duration(milliseconds: 500)
        ));
      },
      child: Container(
          decoration: BoxDecoration(
            color : Colors.white,
            border: Border.all(
              color: Colors.grey, // Set your desired border color here
              width: 0.1, // Set your desired border width here
            ),
          ),
          child : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children : [
                  Stack(
                    children: [
                      Center(
                        child: Container(
                            child: Image.network(user.photo1, height: MediaQuery.of(context).size.width - 290,)),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children : [
                          Text( " -" + calculateDiscountPercentage( user.mrpPrice,  user.Price) + " OFF" , style : TextStyle(color : Colors.red, fontWeight: FontWeight.w600)),
                          Spacer(),
                          IconButton(onPressed: () async {
                            if ( user.Favourite.contains(gh)){
                              await FirebaseFirestore.instance.collection("products").doc(user.productId).update({
                                "Love" : FieldValue.arrayRemove([gh]),
                              });
                              await FirebaseFirestore.instance.collection("users").doc(gh).collection("Love").doc(user.productId).delete();
                              final snackBar = SnackBar(
                                content: Text("Remove from your Favourite"),
                                duration: Duration(seconds: 3),
                                action: SnackBarAction(
                                  label: 'See',
                                  onPressed: () {
                                    Navigator.push(
                                        context, PageTransition(
                                        child: Chat(), type: PageTransitionType.bottomToTop, duration: Duration(milliseconds: 600)
                                    ));
                                  },
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }else{
                              await FirebaseFirestore.instance.collection("products").doc(user.productId).update({
                                "Love" : FieldValue.arrayUnion([gh]),
                              });
                              ProductDetails bh = user ;
                              await FirebaseFirestore.instance.collection("users").doc(gh).collection("Love").doc(user.productId).set(bh.toJson());
                              final snackBar = SnackBar(
                                content: Text("Added to your Favourite"),
                                duration: Duration(seconds: 3),
                                action: SnackBarAction(
                                  label: 'See',
                                  onPressed: () {
                                    Navigator.push(
                                        context, PageTransition(
                                        child: Chat(), type: PageTransitionType.bottomToTop, duration: Duration(milliseconds: 600)
                                    ));
                                  },
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                          }, icon: user.Favourite.contains(gh) ? Icon(Icons.favorite) : Icon(Icons.favorite_border)),
                        ]
                      )
                    ],
                  ),
                  Divider(
                    thickness: 0.5,
                  ),
                  Text( " " + user.productName, style : TextStyle ( fontWeight: FontWeight.w800, fontSize: 19), maxLines: 1,),
                  Text( " ₹" + user.mrpPrice.toString(), maxLines: 1, style : TextStyle ( fontWeight: FontWeight.w800, fontSize: 20, color : Colors.green)),
                ]
            ),
          )
      ),
    );
  }
  String calculateDiscountPercentage(double mrp, double sellingValue) {
    if (mrp <= 0 || sellingValue < 0) {
      throw ArgumentError("MRP and selling value must be positive numbers. ");
    }

    // Calculate the discount percentage
    double discount = ((mrp - sellingValue) / mrp) * 100;

    // Ensure the discount is not negative (selling price should be less than MRP)
    discount = discount >= 0 ? discount : 0;

    // Convert the discount percentage to a string
    String discountString = discount.toStringAsFixed(0); // Keep two decimal places

    return '$discountString%';
  }
}
