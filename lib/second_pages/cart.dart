import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:zhilki/models/productmodel.dart';
import 'package:zhilki/models/usermodel.dart';
import 'package:zhilki/second_pages/address.dart';
import 'package:provider/provider.dart';
import 'package:zhilki/models/usermodel.dart';
import 'package:zhilki/providers/declare.dart';
import 'package:zhilki/update/user_profile_before_update.dart';

class Cart extends StatefulWidget {

  
  Cart({super.key, });

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<ProductDetails> list = [];
  late Map<String, dynamic> userMap;
  TextEditingController ud = TextEditingController();

  String strr = FirebaseAuth.instance.currentUser!.uid ;
  List<UserModel> list1 = [];
  late Map<String, dynamic> userMap1;
  final Fire = FirebaseFirestore.instance;

  void initState(){
    as();
    vq();
  }


  vq() async {
    UserProvider _userprovider = Provider.of(context, listen: true);
    await _userprovider.refreshuser();
  }
  void as() async {
    await FirebaseFirestore.instance.collection("users").doc(strr).update({
      "intP" : 0,
      "Amount" : 0.0,
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    final CollectionReference _dataCollection = FirebaseFirestore.instance.collection("users").doc(strr).collection("Cart");
    return Scaffold(
      appBar : AppBar(
          backgroundColor: Color(0xff00652E),
          iconTheme: IconThemeData(
              color: Colors.white
          ),
          title: Text("Your Cart", style : TextStyle(color: Colors.white)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start ,
        children: [
          SizedBox(height : 10),
          Container(
            height: 150,
            width : MediaQuery.of(context).size.width,
            child : StreamBuilder(
              stream: FirebaseFirestore.instance.collection("users").where("uid", isEqualTo : strr ).snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    list1 = data?.map((e) => UserModel.fromJson(e.data())).toList() ?? [];
                    if (list1.isEmpty) {
                      return Center(child: Text("No Needed"));
                    } else {
                      return ListView.builder(
                        itemCount: list1.length,
                        padding: EdgeInsets.only(left: 10),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatUser10(
                            user1: list1[index],
                          );
                        },
                      );
                    }
                }
              },
            ),
          ),
          SizedBox(height : 10),
          Flexible(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("users").doc(strr).collection("Cart").snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    list = data?.map((e) => ProductDetails.fromJson(e.data())).toList() ?? [];
                    if (list.isEmpty) {
                      return Center(child: Text("No Products in the Cart"));
                    } else {
                      return ListView.builder(
                        itemCount: list.length,
                        padding: EdgeInsets.only(left: 10),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatUser8(
                            user: list[index],
                            lll : list.length,
                            onApply: (minprice, perc)  async {
                             if(perc) {
                               await FirebaseFirestore.instance.collection("users").doc(strr).update({
                                 "Amount" : FieldValue.increment(minprice),
                               });
                             }else{
                               await FirebaseFirestore.instance.collection("users").doc(strr).update({
                                 "Amount" : FieldValue.increment(-minprice),
                               });
                             }
                            },

                          );
                        },
                      );
                    }
                }
              },
            ),
          ),
          SizedBox(height : 10),
        ],
      ),
      persistentFooterButtons: [
        Center(
          child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black, // Border color
                  width: 1.0, // Border width
                ),
                color: Color(0xff00652E),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  // specify the radius for the top-left corner
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  // specify the radius for the top-right corner
                ),
              ),
              child: Container(
                  width: MediaQuery.of(context).size.width - 20,
                  child: TextButton.icon(
                      onPressed: () {
                        if(_user!.Name == " " || _user.Name == "" || _user.Name == "Add Name" || _user.Email == " " || _user.Email == "" || _user.Email == "Add Email"){
                          Navigator.push(
                              context, PageTransition(
                              child: Before_Update(), type: PageTransitionType.topToBottom, duration: Duration(milliseconds: 100)
                          ));
                          final snackBar = SnackBar(
                            content: Text("You must have email & Name before Order. It can't be empty"),
                            duration: Duration(seconds: 3),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }else{
                          Navigator.push(
                              context, PageTransition(
                              child: CheckA(), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 500)
                          ));
                        }

                      },
                      icon: Icon(CupertinoIcons.creditcard_fill,
                          color: Colors.white),
                      label: Text("Continue to CheckOut",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white))))),
        ),
      ],
    );
  }


}

class ChatUser8 extends StatefulWidget {
  ProductDetails user ;
  int lll ;
  Function(double, bool) onApply;
  ChatUser8({super.key, required this.user, required this.lll, required this.onApply});

  @override
  State<ChatUser8> createState() => _ChatUser8State();
}

class _ChatUser8State extends State<ChatUser8> {

  void initState(){
    as();
  }
  String strr = FirebaseAuth.instance.currentUser!.uid ;
  void as() async {

    await FirebaseFirestore.instance.collection("users").doc(strr).update({
      "intP" : widget.lll,
      "Amount" : FieldValue.increment(widget.user.mrpPrice),
    });
    await FirebaseFirestore.instance.collection("users").doc(strr).collection("Cart").doc(widget.user.productId).update({
      "q" : 1.toInt() ,
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.grey.shade100,
      leading: Container(
          height : 100,
          child: Image.network(widget.user.photo1)),
      title: Text(widget.user.productName),
      subtitle: Row(
        children: [
          Text("₹ " + widget.user.mrpPrice.toString()),
          SizedBox(width : 20),
          InkWell(
            onTap : () async {
              await FirebaseFirestore.instance.collection("users").doc(strr).collection("Cart").doc(widget.user.productId).update({
                "q" : FieldValue.increment(-1),
              });
              widget.onApply(widget.user.mrpPrice, false);
    },
            child: Container(
              color : Colors.white, height : 30, width : 30, child : Center(child: Text("-", style : TextStyle(fontSize: 26, fontWeight : FontWeight.w900))),
            ),
          ),
          Container(
            color : Colors.white, height : 30, width : 30, child : Center(child: Text(
              widget.user.q.toString(), style : TextStyle(fontSize: 22, fontWeight : FontWeight.w900))),
          ),
          GestureDetector(
            onTap : () async {
              await FirebaseFirestore.instance.collection("users").doc(strr).collection("Cart").doc(widget.user.productId).update({
                "q" : FieldValue.increment(1),
              });
              widget.onApply(widget.user.mrpPrice, true);
    },
            child: Container(
              color : Colors.white, height : 30, width : 30, child : Center(child: Text("+", style : TextStyle(fontSize: 22, fontWeight : FontWeight.w900))),
            ),
          ),
        ],
      ),
      trailing: IconButton(
        onPressed: () async {
          await FirebaseFirestore.instance.collection("users").doc(strr).collection("Cart").
          doc(widget.user.productId).delete();
          setState(() {

          });
        },
        icon : Icon(Icons.delete, color : Colors.red)
      ),
    );
  }
}

class ChatUser10 extends StatelessWidget {

  UserModel user1 ;
  ChatUser10({super.key, required this.user1});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          ff("Total Amount ", total (user1.Amount ), true, true),
          ff("Total Products ", user1.intP.toString(), false, false),
          ff("Delivery Charges ", "70", false, true),
          ff("Total GST ", calculate18PercentAsString(user1.Amount ), false, true),
          ff("Product Mrp ", calculate18(user1.Amount ), false, true),
        ]
    );
  }
  String total(double value) {
    double percent18 = value + 70 ;
    String percent18AsString = percent18.toStringAsFixed(1);
    return percent18AsString ;
  }

  String calculate18PercentAsString(double value) {
    double percent18 = value * 0.18;
    String percent18AsString = percent18.toStringAsFixed(1);
    return percent18AsString;
  }

  String calculate18(double value) {
    double percent8 = value * 0.18;
    double percent18 = value - percent8 ;
    String percent18AsString = percent18.toStringAsFixed(1);
    return percent18AsString;
  }


  Widget ff(String s, String f, bool b, bool j ){
    String h = j ? "₹" : " ";
    return  Padding(
      padding:  EdgeInsets.only( left : b ? 4.0 : 12.0, right : b ? 4 : 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$s : ", style : TextStyle(fontWeight:  b ? FontWeight.w800 : FontWeight.w600,
              fontSize:  b ? 25 : 18, color : b ? Colors.black : Colors.grey)),
          Text("$h $f   ", style : TextStyle(fontWeight:  b ? FontWeight.w800 : FontWeight.w600,
              fontSize: b ? 25 : 18, color : b ? Colors.black : Colors.grey)),
        ],
      ),
    );
  }
}