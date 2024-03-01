import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:zhilki/models/address_model.dart';
import 'package:zhilki/second_pages/checkout.dart';
import 'package:zhilki/models/usermodel.dart';
import 'package:zhilki/providers/declare.dart';
import 'package:provider/provider.dart';

class CheckA extends StatelessWidget {
 CheckA({super.key, });

  List<Address> list = [];
  String strr = FirebaseAuth.instance.currentUser!.uid ;
  late Map<String, dynamic> userMap;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        backgroundColor: Color(0xff00652E),
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: Text("Which Address to Deliver", style : TextStyle(color: Colors.white)),
      ),
      body : StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").doc(strr ).collection("Address").snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list = data?.map((e) => Address.fromJson(e.data())).toList() ?? [];
              if (list.isEmpty) {
                return Center(child: Text("No Needed"));
              } else {
                return ListView.builder(
                  itemCount: list.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ChatUser10(
                      user1: list[index],
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

class ChatUser10 extends StatefulWidget{
  Address user1 ;

  ChatUser10({required this.user1,});

  @override
  State<ChatUser10> createState() => _ChatUser10State();
}

class _ChatUser10State extends State<ChatUser10> {
  bool b = false ;
  initState(){
    super.initState();
    vq();
  }

  vq() async{
    UserProvider _userprovider = Provider.of(context, listen: false);
    await _userprovider.refreshuser();
  }

  @override
  Widget build(BuildContext context){
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return InkWell(
      onTap: (){
        if(b){
          b = false ;
        }else{
          b = true ;
        }
        setState(() {

        });
      },
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                leading: Icon(CupertinoIcons.location_fill, color : Colors.red),
                title : Text(widget.user1.homeNumber + ", " + widget.user1.homeNumber2 + ", " + widget.user1.city,
                    style : TextStyle ( fontWeight: FontWeight.w800, fontSize: 20)),
                subtitle: Text(widget.user1.state + ", " + widget.user1.country),
                trailing: b ? Icon(Icons.verified, color : Colors.blue) : Icon(Icons.circle, color : Colors.grey),
              ),
              rd("Nearby Landmark", widget.user1.landmark),
              rd("City", widget.user1.city),
              rd("State", widget.user1.state + ", " + widget.user1.country),
              SizedBox(height: 8,),
              b ?  Container(
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

                            Navigator.push(
                                context, PageTransition(
                                child: Checkout(country: widget.user1.country, state:  widget.user1.state,
                                  amountn: _user!.Amount, intp : _user.intP ,
                                  city:  widget.user1.city, streetAddress:  widget.user1.streetAddress, landmark:  widget.user1.landmark,
                                  homeNumber:  widget.user1.homeNumber, homeNumber2:  widget.user1.homeNumber2,
                                  pincode:  widget.user1.pincode, street:  widget.user1.street,), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 300)
                            ));
                          },
                          icon: Icon(CupertinoIcons.location_solid,
                              color: Colors.white),
                          label: Text("Use this Address",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white))))) : SizedBox(),
              SizedBox(height: 8,),

            ],
          ),
        ),
      ),
    );
  }

  Widget rd(String hh6, String h7){
    return Padding(
      padding: const EdgeInsets.only( left : 10.0, right : 10),
      child: Row(
        children: [
          Text("$hh6 : ", style : TextStyle ( fontWeight: FontWeight.w500, fontSize: 18)),
          Text(h7)
        ],
      ),
    );
  }
}
