import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:zhilki/card/order_card.dart';
import 'package:zhilki/models/Track_now.dart';
import 'package:zhilki/models/order_model.dart';

class Orders extends StatelessWidget {
   Orders({super.key});
   List<OrderModel> list = [];
   late Map<String, dynamic> userMap;
   String ar = FirebaseAuth.instance.currentUser!.uid ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
          backgroundColor: Color(0xff00652E),
          iconTheme: IconThemeData(
              color: Colors.white
          ),
        title: Text("Your Orders", style : TextStyle(color : Colors.white)),
      ),
      body : StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").doc( ar ).collection("Order").snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list = data?.map((e) => OrderModel.fromJson(e.data())).toList() ?? [];
              if (list.isEmpty) {
                return Center(child: Text("No Needed"));
              } else {
                return ListView.builder(
                  itemCount: list.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ChatUser19(
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

class ChatUser19 extends StatefulWidget{
  OrderModel user1 ;
  ChatUser19({required this.user1});

  @override
  State<ChatUser19> createState() => _ChatUser19State();
}

class _ChatUser19State extends State<ChatUser19> {

  String status = "In Transit" ;
  String assignDate = "12 Oct, 2023" ;

  void initState(){
    status = widget.user1.status ;
    getOrderDetails(widget.user1.awd) ;
  }


  String ar = FirebaseAuth.instance.currentUser!.uid ;

  void getOrderDetails(String orderId) async {
    String apiUrl = 'https://apiv2.shiprocket.in/v1/external/courier/track/awb/$orderId';
    String apiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2FwaXYyLnNoaXByb2NrZXQuaW4vdjEvZXh0ZXJuYWwvYXV0aC9sb2dpbiIsImlhdCI6MTcwNjMyNzY1MSwiZXhwIjoxNzA3MTkxNjUxLCJuYmYiOjE3MDYzMjc2NTEsImp0aSI6InBMYmxvS1BqQkVhNHNwQngiLCJzdWIiOjQzNzY0NDAsInBydiI6IjA1YmI2NjBmNjdjYWM3NDVmN2IzZGExZWVmMTk3MTk1YTIxMWU2ZDkifQ.5f4QD2IVyRaVMlYy7E_KJwnpGg0tbV4mUyNMKHZaQ8s";
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        // Parse and handle the successful response
        Map<String, dynamic> jsonData = json.decode(response.body);
        print(jsonData);

        TrackingData trackingData = TrackingData.fromJson(jsonData);
        for (ShipmentTrack shipmentTrack in trackingData.shipmentTrack) {
          print('Shipment Track - AWB Code: ${shipmentTrack.consigneeName}');
          if(shipmentTrack.currentStatus != widget.user1.status){
            await FirebaseFirestore.instance.collection("users").doc( ar ).collection("Order").doc(widget.user1.id).update({
              "status" : shipmentTrack.currentStatus ,
            });
            setState((){
              status = shipmentTrack.currentStatus ;
            });
          }
          print('Shipment Track - AWB Code: ${shipmentTrack.podStatus}');
          print('Shipment Track - AWB Code: ${shipmentTrack.shipmentId}');
          // Access other shipmentTrack properties as needed
        }
      } else {
        // Handle errors
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
    }
  }

  void df() async {
    OrderModel hj = widget.user1 ;
    await FirebaseFirestore.instance.collection("Orders").doc(widget.user1.id).set(hj.toJson());
    print("Success");
  }

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only( left : 4.0, right : 4, bottom : 4),
      child: Card(
        color : Colors.white,
        child: Column(
          children : [
            ListTile(
              onTap: (){
                Navigator.push(
                    context, PageTransition(
                    child: Oc(user: widget.user1, status: status,), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 400)
                ));
              }, onLongPress: (){
                print("aifgg");
                df();
            },
              leading: Icon(Icons.calendar_month_sharp, color : Colors.blueAccent, size : 30),
              title : Text(widget.user1.status, style : TextStyle( color : Colors.blueAccent, fontWeight: FontWeight.w900)),
              subtitle: Text("Ordered on : " + jo(widget.user1.assignDate), style : TextStyle( color : Colors.black, fontWeight: FontWeight.w500)),
              trailing : Icon(Icons.arrow_forward_ios_rounded)
            ),
            Padding(
              padding: const EdgeInsets.only( left : 15.0, right : 15),
              child: Divider(),
            ),
            hj (  Icon(Icons.credit_card, color : Color(0xff00652E)), "Payment by", "UPI" ),
            hj (  Icon(Icons.offline_share_rounded, color : Color(0xff00652E)), "Order Id : ", "ZHILKI_" + widget.user1.id + "_6T" ),
            hj (  Icon(Icons.payments, color : Color(0xff00652E)), "Amount Paid", widget.user1.amount.toString() ),
            SizedBox(height : 10),
          ]
        )
      ),
    );
  }

  String jo(String i ) {
    String dateString = i;

    // Convert the String to DateTime
    DateTime dateTimeValue = DateTime.parse(dateString);

    String formattedDateTime = DateFormat('dd/MM/yyyy HH:mm').format(dateTimeValue);
    // Print the DateTime value
    print('DateTime value: $dateTimeValue');
    return formattedDateTime ;
  }

  Widget hj(Widget hgg , String h, String j){
    return Padding(
      padding: const EdgeInsets.only( left : 15.0, right : 15),
      child: Row(
          children : [
           hgg,
            Text("  $h : $j", style : TextStyle(fontSize: 17, fontWeight: FontWeight.w500))
          ]
      ),
    );
  }
}
