import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:current_location/model/location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:zhilki/models/address_model.dart';
import 'package:current_location/current_location.dart';
import 'package:geocoding/geocoding.dart' as geocoding ;

class Address1 extends StatelessWidget {
   Address1({super.key});
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
        title: Text("My Address", style : TextStyle(color: Colors.white)),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: (){
          Navigator.push(
              context, PageTransition(
              child: Add(id : strr), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 300)
          ));
        },
        child : Icon(Icons.add, color : Colors.orange, size : 34)
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

class ChatUser10 extends StatelessWidget{

  Address user1 ;
  ChatUser10({required this.user1});
  @override
  Widget build(BuildContext context){
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              leading: Icon(CupertinoIcons.location_fill, color : Colors.red),
              title : Text(user1.homeNumber + ", " + user1.homeNumber2 + ", " + user1.city,
                  style : TextStyle ( fontWeight: FontWeight.w800, fontSize: 20)),
              subtitle: Text(user1.state + ", " + user1.country),
            ),
            rd("Nearby Landmark", user1.landmark),
            rd("City", user1.city),
            rd("State", user1.state + ", " + user1.country),
            SizedBox(height: 8,)
          ],
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


class Add extends StatefulWidget {
  String id;

  Add({super.key, required this.id});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final TextEditingController description = TextEditingController();
  final TextEditingController country = TextEditingController();
  final TextEditingController state = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController pin = TextEditingController();
  final TextEditingController landmark = TextEditingController();
  final TextEditingController street = TextEditingController();
  String s = " ";

  int selectedStars = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Add Address", style : TextStyle(color : Colors.white)),
        backgroundColor: Color(0xff00652E),
        iconTheme: IconThemeData(
            color: Colors.white
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: SocialLoginButton(
                backgroundColor: Color(0xff50008e),
                height: 40,
                text: 'Fetch Current Location',
                borderRadius: 20,
                fontSize: 21,
                buttonType: SocialLoginButtonType.generalLogin,
                onPressed: () async {
                  final snackBar = SnackBar(
                    content: Text("Fetching Location....... Please Wait !"),
                    duration: Duration(seconds: 3),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  String country1 = " ", state1 = "h", ip = "h", sip = "h." ;
                  double lat = 9.6, lon = 7.2 ;
                  final Location? userLocation = await UserLocation.getValue();
                  country1 = userLocation!.country ?? "INDIA";
                  state1 = userLocation.regionName ?? "ODISHA";
                  ip = userLocation.currentIP ?? "G";
                  sip = userLocation.isp ?? "GG";
                  lat = userLocation.latitude ?? 8.5;
                  lon = userLocation.longitude ?? 8.5;
                  print(state);
                  String address = " ";
                  List<geocoding.Placemark> placemarks = await geocoding.placemarkFromCoordinates(lat!, lon!);

                  if (placemarks != null && placemarks.isNotEmpty) {
                    geocoding.Placemark placemark = placemarks.first;

                    // Access the address components
                    address = "${placemark.street}, ${placemark.locality}, ${placemark.subLocality}, ${placemark.administrativeArea}, ${placemark.isoCountryCode}";
                    print("User's address: $address");
                    setState(() {
                      description.text = placemark.street! ;
                      street.text = placemark.subLocality! ;
                      landmark.text = placemark.subAdministrativeArea! ;
                      pin.text = placemark.postalCode! ;
                      city.text = placemark.subAdministrativeArea! ;
                      state.text = placemark.administrativeArea! ;
                      country.text = placemark.isoCountryCode! ;
                    });
                  }
                  final snackBar1 = SnackBar(
                    content: Text("Fetched Location Done "),
                    duration: Duration(seconds: 3),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar1);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: TextFormField(
                controller: description, maxLines: 1,
                decoration: InputDecoration(
                  labelText: 'House Number',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please type your Password';
                  }
                  return null;
                },
                onChanged: (value) {
                  /*setState(() {
                    s = value;
                  });*/
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: TextFormField(
                controller: street, maxLines: 1,
                decoration: InputDecoration(
                  labelText: 'Street',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please type your Password';
                  }
                  return null;
                },
                onChanged: (value) {
                  /*setState(() {
                    s = value;
                  });*/
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: TextFormField(
                controller: landmark, maxLines: 1,
                decoration: InputDecoration(
                  labelText: 'Nearby Landmark',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please type your Password';
                  }
                  return null;
                },
                onChanged: (value) {
                  /*setState(() {
                    s = value;
                  });*/
                },
              ),
            ),
            Container(
              width : MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Container(
                    width : MediaQuery.of(context).size.width/2 - 60 ,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: pin, maxLength: 6, keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Pin Code',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width : MediaQuery.of(context).size.width/2 + 60,

                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: city, maxLength : 30,
                        decoration: InputDecoration(
                          labelText: 'City',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width : MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Container(
                    width : MediaQuery.of(context).size.width/2 ,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: state,
                        decoration: InputDecoration(
                          labelText: 'State',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width : MediaQuery.of(context).size.width/2,

                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: country,
                        decoration: InputDecoration(
                          labelText: 'Country',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
                      ],
        ),
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: SocialLoginButton(
            backgroundColor: Color(0xff00652E),
            height: 40,
            text: 'Add New Location Now',
            borderRadius: 20,
            fontSize: 21,
            buttonType: SocialLoginButtonType.generalLogin,
            onPressed: () async {
              if( description.text.isEmpty || street.text.isEmpty || landmark.text.isEmpty ||
              pin.text.isEmpty || city.text.isEmpty || state.text.isEmpty || country.text.isEmpty
              ){
                final snackBar1 = SnackBar(
                  content: Text("Please fill all Values "),
                  duration: Duration(seconds: 3),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar1);
              }else{
                try {
                  CollectionReference collection = FirebaseFirestore.instance.collection("users").doc( widget.id ).collection("Address");
                  String customDocumentId = DateTime.now().toString();
                  Address as = Address(country: country.text, state: state.text, city: city.text,
                      streetAddress: customDocumentId, landmark: landmark.text,
                      homeNumber: description.text, homeNumber2: street.text,
                      pincode: pin.text , street: street.text);
                  await collection.doc(customDocumentId).set(as.toJson());
                  Navigator.pop(context);
                } catch (e) {
                  print('${e}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${e}'),
                    ),
                  );
                }
                ;
              }

            },
          ),
        ),
      ],
    );
  }
}
