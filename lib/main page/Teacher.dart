
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zhilki/card/product_card.dart';
import 'package:zhilki/models/productmodel.dart';
import 'package:zhilki/second_pages/search.dart';

class Clubs extends StatefulWidget {
  Clubs({super.key});

  @override
  State<Clubs> createState() => _ClubsState();
}

class _ClubsState extends State<Clubs> {
  List<ProductDetails> list = [];
  late Map<String, dynamic> userMap;
  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;
  TextEditingController searchController = TextEditingController();
   bool phonepay= false  ;
  bool lth  = false  ;
  bool htl  = false  ;
  bool popular  = true  ;
    void d(){
       phonepay = false ;
       lth = false ;
       htl = false ;
       popular = false ;
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_list, color : Colors.white),
        backgroundColor: Color(0xff00652E),
        onPressed: (){
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                height: 300,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  <Widget>[
                      Text("    Filter Products", style : TextStyle(fontWeight: FontWeight.w700)),
                      ListTile(
                        leading : Icon(Icons.arrow_upward_outlined, color : Colors.blue),
                        title : Text("Price - Low to High"),
                        onTap: (){
                          d();
                          setState((){
                            lth = true ;
                          });
                          Navigator.pop(context);
                        },
                        trailing: lth ? Icon(Icons.verified, color : Colors.blue) : Icon(Icons.circle, color : Colors.grey),
                      ),
                      ListTile(
                        leading : Icon(Icons.arrow_downward_outlined, color : Colors.orange),
                        title : Text("Price - High to Low"),
                        onTap: (){
                          d();
                          setState((){
                            htl = true ;
                          });
                          Navigator.pop(context);
                        },
                        trailing: htl ? Icon(Icons.verified, color : Colors.blue) : Icon(Icons.circle, color : Colors.grey),
                      ),
                      ListTile(
                        leading : Icon(Icons.stacked_line_chart, color : Colors.red),
                        title : Text("Popular"),
                        onTap: (){
                          d();
                          setState((){
                            popular = true ;
                          });
                          Navigator.pop(context);
                        },
                        trailing: popular ? Icon(Icons.verified, color : Colors.blue) : Icon(Icons.circle, color : Colors.grey),
                      ),
                      ListTile(
                        leading : Icon(Icons.stairs, color : Colors.green),
                        title : Text("Relevant"),
                        onTap: (){
                          d();
                          setState((){
                            phonepay = true ;
                          });
                          Navigator.pop(context);
                        },
                        trailing: phonepay ? Icon(Icons.verified, color : Colors.blue) : Icon(Icons.circle, color : Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      appBar: AppBar(
        title: Text("All Products", style : TextStyle(color : Colors.white)),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff00652E),
        actions: [
          Container(
            color: Color(0xff00652E),
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search Product',
                    isDense: true,
                    border: OutlineInputBorder() ,
                    fillColor: Colors.white ,
                    filled: true ,
                    prefixIcon: Icon(Icons.search, color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body : StreamBuilder(
        stream: Fire.collection('products').orderBy("mrpPrice", descending: lth).snapshots(),
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
