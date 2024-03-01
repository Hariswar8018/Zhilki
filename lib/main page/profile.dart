
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:read_more_text/read_more_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zhilki/second_pages/cart.dart';
import 'package:zhilki/second_pages/coupons.dart';
import 'package:zhilki/second_pages/my_saved_address.dart';
import 'package:zhilki/second_pages/notification.dart' as d;
import 'package:zhilki/second_pages/orders.dart';
import 'package:zhilki/update/user_profile_before_update.dart';
import 'package:provider/provider.dart';
import 'package:zhilki/models/usermodel.dart';
import 'package:zhilki/providers/declare.dart';
class Learn extends StatefulWidget {
  Learn({super.key});

  @override
  State<Learn> createState() => _LearnState();
}

class _LearnState extends State<Learn> {
  initState() {
    super.initState();
    vq();
  }

  vq() async {
    UserProvider _userprovider = Provider.of(context, listen: false);
    await _userprovider.refreshuser();
  }
  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        backgroundColor: Color(0xff00652E),
      appBar: AppBar(
        title : Text("Account", style : TextStyle(color : Colors.white, fontWeight: FontWeight.w600, fontSize: 24)),
        backgroundColor: Colors.transparent, elevation: 0, automaticallyImplyLeading: false,
      ),
      body : Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children : [
          ListTile(
            onTap: (){
              Navigator.push(
                  context, PageTransition(
                  child: Before_Update(), type: PageTransitionType.topToBottom, duration: Duration(milliseconds: 100)
              ));
            },
            leading: CircleAvatar(
              backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSBY7ZB3xlh4eEDjYkRZvxualXOi_E1qCsutFaWaEplWg&s"),
            ),
            title : Text(_user!.Name, style : TextStyle(color : Colors.white, fontWeight: FontWeight.w600, fontSize: 23)),
            subtitle : Text( "+91 " + _user!.Phone_Number, style : TextStyle(color : Colors.white, fontWeight: FontWeight.w400)),
            trailing: Icon(Icons.edit_rounded, color : Colors.white),
          ),
          SizedBox(height : 9),
          Container(
            decoration: BoxDecoration(
              color: Colors.white, // Set your desired background color
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            height: MediaQuery.of(context).size.height - 230,
            width : MediaQuery.of(context).size.width ,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children : [
                  SizedBox(height: 20,),
                  Text("    Account Settings", style : TextStyle( fontSize: 20, fontWeight: FontWeight.w800)),
                  InkWell(
                      onTap: (){
                        Navigator.push(
                            context, PageTransition(
                            child: Address1(), type: PageTransitionType.leftToRight, duration: Duration(milliseconds: 300)
                        ));
                      },
                      child: f("My Address", "Your Saved Address" , Icon( CupertinoIcons.house , size : 30),)),
                  InkWell(
                      onTap: (){
                        Navigator.push(
                            context, PageTransition(
                            child: Cart(), type: PageTransitionType.bottomToTop, duration: Duration(milliseconds: 600)
                        ));
                      },
                      child: f("My Cart", "Check your Cart" , Icon( CupertinoIcons.cart , size : 30),)),
                  InkWell(
                      onTap : (){
                        Navigator.push(
                            context, PageTransition(
                            child: Orders(), type: PageTransitionType.leftToRight, duration: Duration(milliseconds: 300)
                        ));
    },
                      child: f("My Orders", "Check your Orders" , Icon( CupertinoIcons.archivebox_fill , size : 30),)),
                  f("Bank Account", "Check your Coins stored" , Icon( CupertinoIcons.creditcard_fill, size : 30),),
                  InkWell(
                      onTap : (){
                        Navigator.push(
                            context, PageTransition(
                            child: Sa(), type: PageTransitionType.leftToRight, duration: Duration(milliseconds: 300)
                        ));
                      },
                      child: f("My Coupons", "Check your Coupons" , Icon( Icons.camera_rear_outlined , size : 30),)),
                  InkWell(
                      onTap : (){
                        Navigator.push(
                            context, PageTransition(
                            child: d.Notification(), type: PageTransitionType.topToBottom, duration: Duration(milliseconds: 100)
                        ));
    },
                      child: f("My Notifications", "Check Notifications" , Icon( CupertinoIcons.bell_fill , size : 30),)),
                  InkWell(
                    onTap : () async {
                      final Uri _url = Uri.parse('https://zhilki.com/document/privacy');
                      if (!await launchUrl(_url)) {
                      throw Exception('Could not launch $_url');
                      }
    },
                      child: f("Account Privacy", "How your Privacy is managed" , Icon( CupertinoIcons.upload_circle_fill , size : 30),)),
                ]
              ),
            ),
          )
        ]
      )
    );
  }
  Widget f( String s, String s2, Widget sj ){
    return ListTile(
      leading: sj,
      title : Text(s, style : TextStyle(color : Colors.black, fontWeight: FontWeight.w600, fontSize: 20)),
      subtitle : Text( s2, style : TextStyle(color : Colors.black, fontWeight: FontWeight.w400, fontSize: 10)),
    );
  }
}
