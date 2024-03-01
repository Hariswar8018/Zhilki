import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:zhilki/card/product_card.dart';

import '../models/productmodel.dart';

class Search extends StatefulWidget {
  String str ;
   Search({super.key, required this.str});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<ProductDetails> list = [];

  late Map<String, dynamic> userMap;

  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;

  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();

    searchController = TextEditingController(text: widget.str);
  }

  void _handleSearchSubmit(BuildContext context, String searchTerm) {

    Navigator.push(
        context, PageTransition(
        child: Search(str : searchTerm), type: PageTransitionType.leftToRight, duration: Duration(milliseconds: 500)
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:  Color(0xff00652E),
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
                  onSubmitted: (value) {
                    _handleSearchSubmit(context, value);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      body : StreamBuilder(
        stream: Fire.collection('products').where("productName", isLessThanOrEqualTo: searchController.text).snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting :
            case ConnectionState.none :
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
