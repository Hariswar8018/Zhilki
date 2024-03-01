import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_upi_payment/easy_upi_payment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:zhilki/main%20page/navigation.dart';
import 'package:zhilki/models/coupon_model.dart';
import 'package:zhilki/models/order_model.dart';
import 'package:zhilki/models/usermodel.dart';
import 'package:zhilki/providers/declare.dart';
import 'package:zhilki/second_pages/orders.dart';
import '../models/productmodel.dart';
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
class Checkout extends StatefulWidget {

  final String country;
  final String state;
  final String city;
  final String streetAddress;
  final String landmark;
  final String homeNumber;
  final String homeNumber2;
  final String pincode;
  final String street;
  double amountn ;
  int intp ;
  Checkout({super.key, required this.country,
    required this.state,
    required this.city,
    required this.amountn,
    required this.intp,
    required this.streetAddress,
    required this.landmark,
    required this.homeNumber,
    required this.homeNumber2,
    required this.pincode,
    required this.street,});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  List<ProductDetails> list = [];
  List<Coupon> list1 = [];
  late Map<String, dynamic> userMap1;
  late Map<String, dynamic> userMap;
  bool phonepay = true ;
  TextEditingController ud = TextEditingController();

  String strr = FirebaseAuth.instance.currentUser!.uid ;
  double amt = 100.0 ;
  int gh8 = 1 ;
  void initState(){
    amt = widget.amountn ;
    gh8 = widget.intp ;
  }

  void d (){
    if(phonepay){
      phonepay = false ;
    }else{
      phonepay = true ;
    }
    setState(() {

    });
  }

  final TextEditingController vb = TextEditingController();
  double coupon =  0.0 ;
  String cou = "NA" ;
  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar : AppBar(
        backgroundColor: Color(0xff00652E),
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: Text("Confirm & Pay", style : TextStyle(color: Colors.white)),
      ),
      body : Column(
        children : [
          SizedBox(height : 10),
          ff(" Total Amount ", total(amt), true, true),
          ff("Total Products ", gh8.toString() , false, false),
          ff("Delivery Charges ", "70", false, true),
          ff("Coupon ( if available ) ", "- " + to(coupon), false, true),
          ff("Amount ( gst + mrp )  ", to(amt) , false, true),
          ff("Total GST ", calculate18PercentAsString(amt), false, true),
          ff("Product Mrp ",calculate18(amt), false, true),
          Divider(),
          SizedBox(height : 5),
          Padding(
            padding: const EdgeInsets.only( left : 18.0, right : 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children : [
                  coupon == 0.0 ? Text("Have Coupon Code ? ", style : TextStyle(fontWeight: FontWeight.w700)) :
                  Text("Coupon Code Applied ", style : TextStyle(fontWeight: FontWeight.w700)),
                  coupon == 0.0  ? InkWell(
                    onTap: (){
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return SizedBox(
                            height: 800,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:  <Widget>[
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Text("   Type / Find Coupons", textAlign : TextAlign.left, style : TextStyle(color : Colors.black, fontWeight : FontWeight.w900, fontSize: 24)),
                                  Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: TextFormField(
                                      controller: vb,
                                      decoration: InputDecoration(
                                        labelText: 'Your Coupon',
                                        isDense: true,
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height : 600,
                                    width : MediaQuery.of(context).size.width,
                                    child : StreamBuilder(
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
                                                    onApply: (minprice, perc, percch, free, much) {
                                                      if(much.toDouble() < amt ){
                                                        if(free){
                                                          amt = amt - 70.0 ;
                                                          coupon = 70.0 ;
                                                          setState(() {
                                                            cou = "Free Deliery";
                                                          });
                                                        }else{
                                                          if(percch){
                                                            amt = amt -  amt / perc ;
                                                            coupon = amt / perc ;
                                                            setState(() {
                                                              cou = "$percch % Discount";
                                                            });
                                                          }else{
                                                            amt = amt - minprice ;
                                                            coupon = minprice ;
                                                            setState(() {
                                                              cou = "$minprice Discount";
                                                            });
                                                          }
                                                        }
                                                        // Update the state with the new values
                                                        setState(() {

                                                        });

                                                        Navigator.pop(context);
                                                      }else{
                                                        final snackBar = SnackBar(
                                                          content: Text("Coupon price must be more than required Price"),
                                                          duration: Duration(seconds: 3),
                                                        );
                                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                      }

                                                    },
                                                  );
                                                },
                                              );
                                            }
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container( color : Colors.grey.shade100, child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Apply"),
                    )),
                  ) : Container( color : Colors.grey.shade100, child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Applied"),
                  )),
                ]
            ),
          ),
          SizedBox(height : 5),
          Divider(),
          Padding(
            padding: const EdgeInsets.only( left : 18.0, right : 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children : [
                  Text("Payment Method", style : TextStyle(fontWeight: FontWeight.w700)),
                  InkWell(
                    onTap: (){
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return SizedBox(
                            height: 200,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:  <Widget>[
                                  Text(" Select Payment Method", style : TextStyle(fontWeight: FontWeight.w700)),
                                  ListTile(
                                    leading : Image.network(height : 40,"https://uxwing.com/wp-content/themes/uxwing/download/brands-and-social-media/phonepe-logo-icon.png"),
                                    title : Text("PhonePay"),
                                    onTap: (){
                                      d();
                                      setState((){

                                      });
                                      Navigator.pop(context);
                                    },
                                    trailing: phonepay ? Icon(Icons.verified, color : Colors.blue) : Icon(Icons.circle, color : Colors.grey),
                                  ),
                                  ListTile(
                                    leading : Image.network(height : 40,"https://m2p-website-static-files.s3.ap-south-1.amazonaws.com/images/upi-btm-img-2.png"),
                                    title : Text("UPI Apps"),
                                    onTap: (){
                                      d();
                                      setState((){

                                      });
                                      Navigator.pop(context);
                                    },
                                    trailing: phonepay ? Icon(Icons.circle, color : Colors.grey) : Icon(Icons.verified, color : Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container( color : Colors.grey.shade100, child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Change"),
                    )),
                  ),
                ]
            ),
          ),
          ListTile(
            leading : phonepay ? Image.network( height : 40, "https://uxwing.com/wp-content/themes/uxwing/download/brands-and-social-media/phonepe-logo-icon.png")
            : Image.network( height : 40, "https://m2p-website-static-files.s3.ap-south-1.amazonaws.com/images/upi-btm-img-2.png"),

              title : phonepay ? Text("PhonePay") : Text("UPI Apps"),
          ),
          SizedBox(height : 5),
          Divider(),
          Padding(
            padding: const EdgeInsets.only( left : 18.0, right : 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children : [
                Text("Shipping Address", style : TextStyle(fontWeight: FontWeight.w700)),
                InkWell(
                  onTap: (){
                    Navigator.pop(context) ;
                  },
                  child: Container( color : Colors.grey.shade100, child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Change"),
                  )),
                ),
              ]
            ),
          ),
          ListTile(
            leading : Icon( CupertinoIcons.location_solid, color : Colors.red),
            title : Text(widget.homeNumber + ", "  + widget.street + ", " + widget.landmark + ", " + widget.city),
            subtitle : Text(widget.pincode + ", " + widget.state + ", " + widget.country)
          ),
          SizedBox(height : 5),
          Divider(),
          Padding(
            padding: const EdgeInsets.only( left : 18.0, right : 16, bottom : 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children : [
                  Text("Products", style : TextStyle(fontWeight: FontWeight.w700)),
                  InkWell(
                    onTap: (){
                      Navigator.pop(context) ;
                      Navigator.pop(context) ;
                    },
                    child: Container( color : Colors.grey.shade100, child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Change"),
                    )),
                  ),
                ]
            ),
          ),
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
                      return Center(child: Text("No Needed"));
                    } else {
                      return ListView.builder(
                        itemCount: list.length,
                        padding: EdgeInsets.only(left: 10),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatUser8(
                            user: list[index],
                            lll : list.length,
                          );
                        },
                      );
                    }
                }
              },
            ),
          ),
        ]
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
                      onPressed: () async  {
                        String datetimemil = "ZHILKI_" + DateTime.now().microsecondsSinceEpoch.toString();
                        try {
                          final res = await EasyUpiPaymentPlatform.instance.startPayment(
                            EasyUpiPaymentModel(
                              payeeVpa: '9707775653@okbizaxis',
                              payeeName: 'Zhilki Pvt. Ltd.',
                              amount: amt + 70,
                              description: datetimemil,
                            ),
                          );
                          /* final res = await EasyUpiPaymentPlatform.instance.startPayment(
                            EasyUpiPaymentModel(
                              payeeVpa: '9707775653@okbizaxis',
                              payeeName: 'Zhilki Pvt. Ltd.',
                              amount: 1,
                              description: datetimemil,
                            ),
                          ); */
                          print(res);
                          print(res);
                          String real = DateTime.now().toString();
                          OrderModel jk = OrderModel(amount: amt, deliveryCharge: 70,
                            paymentMethod: phonepay ? "PhonePay" : "UPI", paymentStatus: "Processing",
                            coupon: cou , status: "Processing", time: real,
                            id: datetimemil, awd: "Na", courierName: "Na",
                            courierStatus: "Na", courierStatusId: "Na",
                            shipmentStatus: "Na", shipmentId: "Na",
                            timestamp: "Na", srOrderId: "Na", assignDate: real,
                            pickupDate: "Na", pod: "Na", pod1: "Na",
                            other1: "Na", other2: "Na", country: widget.country,
                            state: widget.state, city: widget.city, streetAddress: widget.streetAddress,
                            landmark: widget.landmark, homeNumber: widget.homeNumber,
                            homeNumber2: widget.homeNumber2, pincode: widget.pincode,
                            street: widget.street, shipmentTrackActivities: [],
                              email: _user!.Email, dated: real, namec: _user.Name, phone: _user.Phone_Number);
                          List<OModel> oModels = []; // Initialize a list to hold parsed OModel objects
                          for (int i = 0; i < list.length; i++) {
                            ProductDetails productDetails = list[i];
                            OModel oModel = OModel(
                              name: productDetails.productName,
                              price: productDetails.mrpPrice.toString(),
                              sku: productDetails.shelfLife,
                              units: productDetails.q,
                            );
                            oModels.add(oModel); // Add parsed OModel object to the list
                          }
// Now assign oModels list to shipmentTrackActivities
                          jk.shipmentTrackActivities = oModels;
                        String ar = FirebaseAuth.instance.currentUser!.uid ;
                        CollectionReference collectionv = FirebaseFirestore.instance.collection("users").doc( ar ).collection("Order");
                        await collectionv.doc(datetimemil).set(jk.toJson());
                        CollectionReference collectionvb = FirebaseFirestore.instance.collection("Orders");
                        await collectionvb.doc(datetimemil).set(jk.toJson());

                        Navigator.push(
                            context, PageTransition(
                            child: Home(), type: PageTransitionType.leftToRight, duration: Duration(milliseconds: 500)
                        ));
                          final snackBar = SnackBar(
                            content: Text("Yey! Your Order is on your Way "),
                            duration: Duration(seconds: 3),
                            action: SnackBarAction(
                              label: 'Check Orders',
                              onPressed: () {
                                Navigator.push(
                                    context, PageTransition(
                                    child: Orders(), type: PageTransitionType.bottomToTop, duration: Duration(milliseconds: 600)
                                ));
                              },
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } on EasyUpiPaymentException {
                          final snackBar = SnackBar(
                            content: Text("Error ! In Payment"),
                            duration: Duration(seconds: 3),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      icon: Icon(CupertinoIcons.creditcard_fill,
                          color: Colors.white),
                      label: Text("Confirm & Pay",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white))))),
        ),
      ],
    );
  }


  String calculate18PercentAsString(double value) {
    double percent18 = value * 0.18;
    String percent18AsString = percent18.toStringAsFixed(1);
    return percent18AsString ;
  }

  String total(double value) {
    double percent18 = value + 70 ;
    String percent18AsString = percent18.toStringAsFixed(1);
    return percent18AsString ;
  }
  String to(double value) {
    String percent18AsString = value.toStringAsFixed(1);
    return percent18AsString ;
  }

  String calculate18(double value) {
    double percent8 = value * 0.18 ;
    double percent18 = value - percent8 ;
    String percent18AsString = percent18.toStringAsFixed(1) ;
    return percent18AsString ;
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

class ChatUser90 extends StatelessWidget{
  Coupon user ;
  Function(double, double, bool, bool, int) onApply;
  ChatUser90({required this.user, required this.onApply});
  @override
  Widget build(BuildContext context){
    return ListTile(
      tileColor: Colors.white60,
      leading : Icon(Icons.airplane_ticket_sharp, color : Colors.blue, size : 40),
      title : Text(user.name, style : TextStyle(fontWeight : FontWeight.w800)),
      subtitle: Text(user.description),
      trailing : TextButton( onPressed : (){
        onApply(user.minusPrice, user.percent, user.perc, user.free, user.much );
      },
          child : Text("APPLY", style : TextStyle( fontWeight: FontWeight.w600, fontSize: 18))),
    );
  }
}

class ChatUser8 extends StatefulWidget {
  ProductDetails user ;
  int lll ;
  ChatUser8({super.key, required this.user, required this.lll});

  @override
  State<ChatUser8> createState() => _ChatUser8State();
}

class _ChatUser8State extends State<ChatUser8> {

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      leading: Container(
          height : 100,
          child: Image.network(widget.user.photo1)),
      title: Text(widget.user.productName),
      subtitle: Text("₹ " + widget.user.mrpPrice.toString() + "    " + "x " + widget.user.q.toString()),
    );
  }
}