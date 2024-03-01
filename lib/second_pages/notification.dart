import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Notification extends StatelessWidget {
  const Notification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        backgroundColor: Color(0xff00652E),
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: Text("Notifications", style : TextStyle(color: Colors.white)),
      ),
    body : Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children : [
        Icon(Icons.notifications_off, color : Colors.red, size : 45),
        SizedBox(height : 15),
        Center(child: Text("Currently ! There's No Notification"))
      ]
    )
    /*  body : Column(
          children : [
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
      ),*/
    );
  }
}


