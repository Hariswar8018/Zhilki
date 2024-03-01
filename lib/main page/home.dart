import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:zhilki/card/product_card.dart';
import 'package:zhilki/models/usermodel.dart';
import 'package:zhilki/providers/declare.dart';
import 'package:zhilki/second_pages/cart.dart';
import 'package:zhilki/second_pages/search.dart';
import 'package:zhilki/second_pages/notification.dart' as d;
import '../models/productmodel.dart';

class HomeP extends StatelessWidget {
  HomeP({super.key});

  String getGreeting() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 0 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 18) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }
  List<ProductDetails> list = [];
  late Map<String, dynamic> userMap;
  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;

  TextEditingController searchController = TextEditingController();

  void _handleSearchSubmit(BuildContext context, String searchTerm) {
    Navigator.push(
        context, PageTransition(
        child: Search(str : searchTerm), type: PageTransitionType.leftToRight, duration: Duration(milliseconds: 500)
    ));
  }

  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getGreeting() + " , ",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w300),
            ),
            Text(
              _user!.Name,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w800),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff00652E),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context, PageTransition(
                    child: d.Notification(), type: PageTransitionType.topToBottom, duration: Duration(milliseconds: 100)
                ));
              },
              icon: Icon(Icons.notifications_on, color: Colors.white)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context, PageTransition(
                    child: Cart(), type: PageTransitionType.bottomToTop, duration: Duration(milliseconds: 600)
                ));
              },
              icon: Icon(Icons.shopping_cart_sharp, color: Colors.white),),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Color(0xff00652E),
              width: MediaQuery.of(context).size.width,
              height: 2,
            ),
            Container(
              color: Color(0xff00652E),
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for Products',
                      isDense: true,
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      // Background color of the TextField
                      filled: true,
                      prefixIcon: Icon(Icons.search, color: Colors.black),
                    ),
                    onSubmitted: (value) {
                      _handleSearchSubmit(context, value);
                    },
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xff00652E),
              ),
              width: MediaQuery.of(context).size.width,
              height: 4,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                    "https://ayush.starwish.fun/wp-content/uploads/2024/01/WhatsApp-Video-2024-01-30-at-14.52.01_657c49aa.gif"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text("  Categories", textAlign : TextAlign.left, style : TextStyle(color : Colors.black, fontWeight : FontWeight.w600, fontSize: 24)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height : 80,
                child: ListView.builder(
                  itemCount: imageURLs.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(left : 10),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(
                              context, PageTransition(
                              child: Search(str : imageURL[index]), type: PageTransitionType.leftToRight, duration: Duration(milliseconds: 500)
                          ));
                        },
                        child: Container(
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color : name[index],
                            image: DecorationImage(
                              image: NetworkImage(
                                imageURLs[index],
                              ),
                            ),
                            border: Border.all(
                              color: Color(0xff00652E),
                              width: 1.5, // Adjust the width of the border as needed
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, right : 9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("  You might also like", textAlign : TextAlign.left, style : TextStyle(color : Colors.black, fontWeight : FontWeight.w600, fontSize: 24)),
                TextButton(onPressed: (){}, child: Text("All Products")),
                ],
              ),
            ),
            Container(
              height : 700,
              width : MediaQuery.of(context).size.width,
              child: StreamBuilder(
                stream: Fire.collection('products').snapshots(),
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
            ),
          ],
        ),
      ),
    );
  }


  final List<Color> name = [
    Colors.red,
    Colors.green,
    Colors.blue.shade100,
    Colors.pink,
    Colors.purple
    // Add more image URLs as needed
  ];
  final List<String> imageURLs = [
    'https://m.media-amazon.com/images/I/81PUI2Gv7dL._SL1500_.jpg',
    'https://thebetterbath.in/cdn/shop/products/SPONGE-LOOFAH_PURPLE_FOP_1000x1000pxl_480x480.jpg?v=1665684371',
    'https://static.vecteezy.com/system/resources/previews/014/389/372/original/3d-illustration-of-toothbrush-free-png.png',
    'https://m.media-amazon.com/images/I/81PUI2Gv7dL._SL1500_.jpg',
    'https://thebetterbath.in/cdn/shop/products/SPONGE-LOOFAH_PURPLE_FOP_1000x1000pxl_480x480.jpg?v=1665684371',
  ];
  final List<String> imageURL = [
    'Looaf',
    'Scrub',
    'Tooth Brush',
    'Looaf',
    'Scrub',
  ];
}
