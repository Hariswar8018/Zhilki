import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:provider/provider.dart';
import 'package:zhilki/models/usermodel.dart';

import 'package:zhilki/providers/declare.dart';
import '../models/review_model.dart';

class All extends StatelessWidget {
  String str ;
  All({super.key, required this.str});
  List<Review> list = [];
  late Map<String, dynamic> userMap;
  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        title: Text("Reviews", style : TextStyle(color : Colors.white)),
        backgroundColor: Color(0xff00652E),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.push(
                context, PageTransition(
                child: Add(id : str), type: PageTransitionType.leftToRight, duration: Duration(milliseconds: 500)
            ));
          }, child: Text("Write a Review", style : TextStyle ( color:Colors.white)))
        ],
      ),
      body : StreamBuilder(
        stream: Fire.collection('products').doc(str).collection("Reviews").snapshots(),
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
                  itemCount: list.length,
                  padding: EdgeInsets.only( left : 10),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ChatUser4(
                      user: list[index],
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


class ChatUser4 extends StatelessWidget {
  Review user;

  ChatUser4({required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom : 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white, // Container color
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.picLink),
                ),
                title: Text(
                    user.name, style: TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text(ht(user.date)),
                trailing: TextButton.icon(onPressed: () {},
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      minimumSize: MaterialStateProperty.all(Size(0, 0)),
                    ),
                    icon: Icon(Icons.star, color: Colors.orange),
                    label: Text(user.post.toString()))
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 10),
              child: Text(user.description),
            ),
            SizedBox(
              height: 20,
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

class Add extends StatefulWidget {
  String id;

  Add({super.key, required this.id});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final TextEditingController description = TextEditingController();

  String s = " ";

  int selectedStars = 0;

  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Post a Review", style : TextStyle(color : Colors.white)),
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
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: TextFormField(
                controller: description, maxLines: 4, minLines: 3,
                decoration: InputDecoration(
                  labelText: 'Write a Review',
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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (index) {
              return IconButton(
                onPressed: () {
                  setState(() {
                    selectedStars = index + 1;
                  });
                },
                icon: Icon(
                  index < selectedStars ? Icons.star : Icons.star_border,
                  color: Colors.orange, size: 44,
                ),
              );
            }),
          ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: SocialLoginButton(
                backgroundColor: Color(0xff50008e),
                height: 40,
                text: 'Add Session Now',
                borderRadius: 20,
                fontSize: 21,
                buttonType: SocialLoginButtonType.generalLogin,
                onPressed: () async {
                  try {
                    CollectionReference collection = FirebaseFirestore.instance.collection('products').doc(widget.id).collection("Reviews");
                    String customDocumentId = DateTime.now().toString(); // Replace with your own custom ID
                    Review as = Review(picLink: _user!.Pic_link, name: _user.Name, date: customDocumentId,
                        post: selectedStars, description: description.text);
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
