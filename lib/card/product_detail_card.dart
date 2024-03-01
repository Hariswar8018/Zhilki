
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:zhilki/card/all_reviews.dart';
import 'package:zhilki/main%20page/chat.dart';
import 'package:zhilki/models/productmodel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:zhilki/models/review_model.dart';
import 'package:intl/intl.dart';
import 'package:zhilki/second_pages/cart.dart';

class PC extends StatefulWidget {
  ProductDetails user ;
   PC({super.key, required this.user});

  @override
  State<PC> createState() => _PCState();
}

class _PCState extends State<PC> {

  late final List<Widget> items ;
  List<Review> list = [];
  late Map<String, dynamic> userMap;
  TextEditingController ud = TextEditingController();
  String gh = FirebaseAuth.instance.currentUser!.uid ;
  final Fire = FirebaseFirestore.instance;

  void initState(){
    items = [
      Image.network(widget.user.photo1),
      Image.network(widget.user.photo1),
      Image.network(widget.user.photo1),
    ];
    setState(() {

    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
          backgroundColor: Color(0xff00652E),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        actions : [
          IconButton(onPressed: () async {
            if ( widget.user.Favourite.contains(gh)){
              await FirebaseFirestore.instance.collection("products").doc(widget.user.productId).update({
                "Love" : FieldValue.arrayRemove([gh]),
              });
              await FirebaseFirestore.instance.collection("users").doc(gh).collection("Love").doc(widget.user.productId).delete();
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
            }
            else{
              await FirebaseFirestore.instance.collection("products").doc(widget.user.productId).update({
                "Love" : FieldValue.arrayUnion([gh]),
              });
              ProductDetails bh = widget.user ;
              await FirebaseFirestore.instance.collection("users").doc(gh).collection("Love").doc(widget.user.productId).set(bh.toJson());
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
          }, icon: widget.user.Favourite.contains(gh) ? Icon(Icons.favorite) : Icon(Icons.favorite_border)),
          SizedBox(width : 9),
        ]
      ),
      body : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
                items: items,
                options: CarouselOptions(
                  height: 300,
                  aspectRatio: 16/9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: true,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 600),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  scrollDirection: Axis.horizontal,
                )
            ),
            Text( " " + widget.user.productName, style : TextStyle ( fontWeight: FontWeight.w800, fontSize: 32),),
            Row(
              children: [
                Text( "  ₹" + widget.user.mrpPrice.toString(), maxLines: 1, style : TextStyle ( fontWeight: FontWeight.w800,
                    fontSize: 31, color : Colors.green)),
              SizedBox(width : 25),
                Text(
                  "₹" + widget.user.Price.toString(),
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color : Colors.red, decoration: TextDecoration.lineThrough),
                ),
                SizedBox(width : 10),
                Text( calculateDiscountPercentage( widget.user.mrpPrice,  widget.user.Price) + "OFFER", maxLines: 1, style : TextStyle ( fontWeight: FontWeight.w800,
                    fontSize: 20, color : Colors.orange)),
              ],
            ),
            SizedBox( height : 15),
            Text( "  Product Description", style : TextStyle ( fontWeight: FontWeight.w600, fontSize: 20),),
            Padding(
              padding: const EdgeInsets.only( left : 10.0, right : 10, ),
              child: Text( widget.user.productDescription),
            ),
            SizedBox(height: 10,),
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
                          onPressed: () async {
                            ProductDetails sj = widget.user ;
                            String strr = FirebaseAuth.instance.currentUser!.uid ;
                            await FirebaseFirestore.instance.collection("users").doc(strr).collection("Cart").doc(widget.user.productId).set(sj.toJson());
                            final snackBar = SnackBar(
                              content: Text(widget.user.productName + " is added to your Cart"),
                              duration: Duration(seconds: 3),
                              action: SnackBarAction(
                                label: 'Go to Cart',
                                onPressed: () {
                                  Navigator.push(
                                      context, PageTransition(
                                      child: Cart(), type: PageTransitionType.bottomToTop, duration: Duration(milliseconds: 600)
                                  ));
                                },
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            },
                          icon: Icon(CupertinoIcons.shopping_cart,
                              color: Colors.white),
                          label: Text("Add to Cart",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white))))),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey, // Border color
                          width: 2.0, // Border width
                        ),
                        color: Colors.white,
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
                          width: MediaQuery.of(context).size.width/2 - 20,
                          child: TextButton.icon(
                              onPressed: () async {
                                if ( widget.user.Favourite.contains(gh)){
                                  await FirebaseFirestore.instance.collection("products").doc(widget.user.productId).update({
                                    "Love" : FieldValue.arrayRemove([gh]),
                                  });
                                  await FirebaseFirestore.instance.collection("users").doc(gh).collection("Love").doc(widget.user.productId).delete();
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
                                }
                                else{
                                  await FirebaseFirestore.instance.collection("products").doc(widget.user.productId).update({
                                    "Love" : FieldValue.arrayUnion([gh]),
                                  });
                                  ProductDetails bh = widget.user ;
                                  await FirebaseFirestore.instance.collection("users").doc(gh).collection("Love").doc(widget.user.productId).set(bh.toJson());
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
                              },
                              icon:  widget.user.Favourite.contains(gh) ? Icon(Icons.favorite, color : Colors.red) : Icon(Icons.favorite_border),
                              label: Text("Favourite",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black))))),
                ),
                Center(
                  child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey, // Border color
                          width: 2.0, // Border width
                        ),
                        color: Colors.white,
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
                          width: MediaQuery.of(context).size.width/2 - 20,
                          child: TextButton.icon(
                              onPressed: () {
                                Navigator.push(
                                    context, PageTransition(
                                    child: All(str : widget.user.productId), type: PageTransitionType.leftToRight, duration: Duration(milliseconds: 500)
                                ));
                              },
                              icon: Icon(CupertinoIcons.star_lefthalf_fill,
                                  color: Colors.yellow),
                              label: Text("Reviews",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black))))),
                ),
              ],
            ),
            SizedBox( height : 15),
            f("Country of Origin", widget.user.countryOfOrigin),
            f("Manufacture Details", widget.user.manufacturerDetails),
            f("Marketed by", widget.user.marketedBy),
            f("Category", widget.user.productCategory),
            f("Product ID", widget.user.productId),
            f("Product Weight", widget.user.productWeight.toString()),
            SizedBox(height : 18),
            Padding(
              padding: const EdgeInsets.only( left : 14.0, right : 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children : [
                  Text( "Reviews of Product", style : TextStyle ( fontWeight: FontWeight.w600, fontSize: 20),),
                  TextButton(onPressed: (){
                    Navigator.push(
                        context, PageTransition(
                        child: All(str : widget.user.productId), type: PageTransitionType.leftToRight, duration: Duration(milliseconds: 500)
                    ));
                  }, child: Text("Show all Review"))
                ]
              ),
            ),
            Container(
              width : MediaQuery.of(context).size.width ,
              height : 200,
              child: StreamBuilder(
                stream: Fire.collection('products').doc(widget.user.productId).collection("Reviews").snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Center(child: CircularProgressIndicator());
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      list = data
                          ?.map((e) => Review.fromJson(e.data()))
                          .toList() ??
                          [];
                      if(list.isEmpty){
                        return Center(
                          child : Text("No Needed")
                        );
                      }else{
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: list.length,
                          padding: EdgeInsets.only( left : 10),
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ChatUser1(
                              user: list[index],
                            );
                          },
                        );
                      }
                  }
                },
              ),
            ),
            SizedBox(height : 25),
          ],
        ),
      ),
      persistentFooterButtons: [
      Center(
        child: Dismissible(
          key: Key('your_unique_key'),
          direction: DismissDirection.startToEnd,
          onDismissed: (direction) async {

            if (direction == DismissDirection.startToEnd) {
              ProductDetails sj = widget.user ;
              String strr = FirebaseAuth.instance.currentUser!.uid ;
              await FirebaseFirestore.instance.collection("users").doc(strr).collection("Cart").doc(widget.user.productId).set(sj.toJson());
              Navigator.push(
                  context, PageTransition(
                  child: Cart(), type: PageTransitionType.bottomToTop, duration: Duration(milliseconds: 600)
              ));
             print("fone");
            }
          },
          background: Container(
            color: Colors.red, // Color when swiping
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 20.0),
            child: Text("Checkout Product", style : TextStyle(color : Colors.white, fontWeight: FontWeight.w800))
          ),
          child : Container(
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
                      onPressed: () async {
                        ProductDetails sj = widget.user ;
                        String strr = FirebaseAuth.instance.currentUser!.uid ;
                        await FirebaseFirestore.instance.collection("users").doc(strr).collection("Cart").doc(widget.user.productId).set(sj.toJson());
                        final snackBar = SnackBar(
                          content: Text(widget.user.productName + " is added to your Cart"),
                          duration: Duration(seconds: 3),
                          action: SnackBarAction(
                            label: 'Go to Cart',
                            onPressed: () {
                              Navigator.push(
                                  context, PageTransition(
                                  child: Cart(), type: PageTransitionType.bottomToTop, duration: Duration(milliseconds: 600)
                              ));
                            },
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      icon: Icon(CupertinoIcons.shopping_cart,
                          color: Colors.white),
                      label: Text("Add to Cart",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white))))),
        ),
      ),
    ],
    );
  }
  Widget f( String str, String str1){
    return Row(
      children: [
        Text( "   $str : ", style : TextStyle ( fontWeight: FontWeight.w500, fontSize: 18),),
        Container(child: Text( str1 , style : TextStyle ( fontWeight: FontWeight.w400, fontSize: 17),)),
      ],
    );
  }
  String calculateDiscountPercentage(double sellingValue, double mrp) {
    if (mrp <= 0 || sellingValue < 0) {
      throw ArgumentError("MRP and selling value must be positive numbers.");
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

class ChatUser1 extends StatelessWidget{
  Review user ;
  ChatUser1({required this.user});

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only( right : 8.0),
      child: Container(
        width : 300,
        decoration: BoxDecoration(
          color: Colors.white, // Container color
          borderRadius: BorderRadius.circular(7), // Radius for rounded corners
          border: Border.all(
            color: Colors.black, // Border color
            width: 0.5, // Border width
          ),
        ),
        height : 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user.picLink),
              ),
              title: Text(user.name, style : TextStyle( fontWeight: FontWeight.w700)),
              subtitle: Text( ht(user.date)),
              trailing: TextButton.icon(onPressed: (){},
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                    minimumSize: MaterialStateProperty.all(Size(0, 0)),
                  ), icon: Icon(Icons.star, color : Colors.orange), label: Text(user.post.toString()))
            ),
            Padding(
              padding: const EdgeInsets.only( left : 25, right : 10),
              child: Text(user.description),
            )
          ],
        ),
      ),
    );
  }

  String ht(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedDate = DateFormat('dd MMM, yyyy').format(dateTime);
    return formattedDate;
  }
}
