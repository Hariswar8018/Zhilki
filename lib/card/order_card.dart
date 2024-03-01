import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:timelines/timelines.dart';
import 'package:zhilki/models/Track_now.dart';
import 'package:zhilki/models/order_model.dart';
import 'package:http/http.dart' as http;

class Oc extends StatefulWidget {
  OrderModel user;
  String status ;
  Oc({super.key, required this.user, required this.status});

  @override
  State<Oc> createState() => _OcState();
}

class _OcState extends State<Oc> {
  void initState() {
    getOrderDetails(widget.user.awd);
  }

  List<ShipmentTrackActivity> shipmentTrackActivitiesList = [];

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

        // Now you can access the properties of trackingData
        print('Order Details:');
        print('Track Status: ${trackingData.shipmentTrack}');
        print('Shipment Status: ${trackingData.shipmentStatus}');
        print('Track URL: ${trackingData.shipmentTrackActivities}');
        // Access other properties as needed

        // You can also access shipmentTrack and shipmentTrackActivities lists
        for (ShipmentTrack shipmentTrack in trackingData.shipmentTrack) {
          print('Shipment Track - AWB Code: ${shipmentTrack.consigneeName}');
          print('Shipment Track - AWB Code: ${shipmentTrack.podStatus}');
          print('ndcuzk: ${shipmentTrack.courierName}');
          // Access other shipmentTrack properties as needed
        }

        for (ShipmentTrackActivity activity
            in trackingData.shipmentTrackActivities) {
          print(
              'Activity - Date: ${activity.date}, Status: ${activity.status}, Location: ${activity.location}');
          shipmentTrackActivitiesList.add(activity);
          print(activity);
          // Access other shipmentTrackActivities properties as needed
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff00652E),
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(  widget.user.id ,
              style: TextStyle(color: Colors.white)),
        ),
        body: Column(children: [
          ListTile(
              leading: Icon(Icons.calendar_month_sharp,
                  color: Colors.blueAccent, size: 30),
              title: Text(widget.user.status,
                  style: TextStyle(
                      color: Colors.blueAccent, fontWeight: FontWeight.w900)),
              subtitle: Text("Ordered on : " + jo(widget.user.assignDate),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500)), ),
          hj(Icon(Icons.credit_card, color: Color(0xff00652E)), "Payment by",
              "RazorPay"),
          hj(Icon(Icons.offline_share_rounded, color: Color(0xff00652E)),
              "Order Id : ", "ZHILKI_" + widget.user.id + "_6T"),
          hj(Icon(Icons.payments, color: Color(0xff00652E)), "Amount Paid",
              widget.user.amount.toString()),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15),
            child: Divider(),
          ),
          ListTile(
              leading: Icon(Icons.local_shipping,
                  color: Colors.blueAccent, size: 30),
              onTap: (){
                Navigator.push(
                    context, PageTransition(
                    child: KS(shipmentTrackActivitiesList: shipmentTrackActivitiesList, skl : widget.status), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 400)
                ));
              },
              title: Text("Shipping by : ShipRocket",
                  style: TextStyle(
                      color: Colors.blueAccent, fontWeight: FontWeight.w900)),
              subtitle: Text("Status : " + widget.status,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500)),
              trailing: Icon(Icons.arrow_forward_ios_rounded)),
          hj(Icon(Icons.satellite_alt_outlined, color: Colors.blue, size : 25), "AWB ",
              widget.user.awd),
          SizedBox(height : 10),
          hj(Icon(Icons.calendar_month_sharp, color: Colors.blue, size : 25),
              "Estimate Delivery ", "h"),
        ]));
  }

  String jo(String i) {
    String dateString = i;

    // Convert the String to DateTime
    DateTime dateTimeValue = DateTime.parse(dateString);

    String formattedDateTime =
        DateFormat('dd/MM/yyyy HH:mm').format(dateTimeValue);
    // Print the DateTime value
    print('DateTime value: $dateTimeValue');
    return formattedDateTime;
  }

  Widget hj(Widget hgg, String h, String j) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: Row(children: [
        hgg,
        Text(
            "  $h : $j",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500))
      ]),
    );
  }
}

class KS extends StatelessWidget {
  String skl ;
   KS({super.key , required this.shipmentTrackActivitiesList, required this.skl});
   List<ShipmentTrackActivity> shipmentTrackActivitiesList ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Tracking Status : " + skl, style : TextStyle(color : Colors.white)),
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(
            color : Colors.white
          ),
          backgroundColor: Color(0xff00652E),
        ),
      body :  ListView.builder(
    itemCount: shipmentTrackActivitiesList.length,
    padding: EdgeInsets.only(left: 20),
    physics: BouncingScrollPhysics(),
    itemBuilder: (context, index) {
    return TimelineWidget(
    timelineElements: shipmentTrackActivitiesList[index],
    l: shipmentTrackActivitiesList.length,
    ); },
    ));
  }
}


class TimelineWidget extends StatelessWidget {
  int l;

  ShipmentTrackActivity timelineElements;

  TimelineWidget({required this.timelineElements, required this.l});

  String sy(String g) {
    DateTime dateTime = DateTime.parse(g);
    String formattedDate = DateFormat('dd, MMM yy').format(dateTime);
    print(formattedDate); // Output: 28, Jan 22
    return formattedDate;
  }

  String sj(String g) {
    DateTime dateTime = DateTime.parse(g);
    String formattedDate = DateFormat('dd, MMM yy').format(dateTime);
    String formattedTime = DateFormat('hh:mm a').format(dateTime);
    print(formattedDate); // Output: 28, Jan 22
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return FixedTimeline.tileBuilder(
      theme: TimelineTheme.of(context).copyWith(
        nodePosition: 0,
        connectorTheme: TimelineTheme.of(context).connectorTheme.copyWith(
              thickness: 1.0,
            ),
        indicatorTheme: TimelineTheme.of(context).indicatorTheme.copyWith(
              size: 10.0,
              position: 0.5,
            ),
      ),
      builder: TimelineTileBuilder.connectedFromStyle(
        contentsAlign: ContentsAlign.basic,
        contentsBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left : 8.0, top : 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text( h3(timelineElements.date) , style: TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 14)),
                  ],
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 9.0, right: 9, top: 6, bottom: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(timelineElements.location,
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 18, color : Colors.blue)),
                      Text(timelineElements.srStatusLabel),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20)
            ],
          );
        },
        connectorStyleBuilder: (context, index) => ConnectorStyle.solidLine,
        indicatorStyleBuilder: (context, index) => IndicatorStyle.dot,
        itemCount: g(l),
      ),
    );
  }
  String h3(String hj) {
    DateTime dateTime = DateTime.parse(hj);

    // Format the DateTime object
    String formattedDate = DateFormat('dd MMM, yy ').format(dateTime);

    print(formattedDate);
    return formattedDate ;// Output: 25 Jan, 15:33
  }

  int g(int j) {
    int y = j ~/ 4;
    return y;
  }
}
