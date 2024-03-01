import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    required this.Username,
    required this.Email,
    required this.Name,
    required this.Pic_link,
    required this.Bio,
    required this.Won,
    required this.uid,
    required this.lastlogin,
    required this.code,
    required this.lastloginn, required this.Date, required this.Phone_Number
  });

  late final String Username;
  late final String Date ;
  late final String Email;
  late final String Name;
  late final String Pic_link ;
  late final String Bio;
  late final int Won;
  late final String uid;
  late final String lastlogin;
  late final String code;
  late final String Phone_Number ;
  late final String lastloginn;
  late final double Amount ;
  late final int intP ;


  UserModel.fromJson(Map<String, dynamic> json) {
    Amount = json['Amount'] ?? 0.0;
    intP = json['intP'] ?? 0 ;
    Username = json['Chess_Level'] ?? 'Begineer';
    Email = json['Email'] ?? 'demo@demo.com';
    Name = json['Name'] ?? 'samai';
    Pic_link = json['Pic_link'] ??
        'https://i.pinimg.com/736x/98/fc/63/98fc635fae7bb3e63219dd270f88e39d.jpg';
    Bio = json['Bio'] ?? 'Demo';
    Won = json['Won'] ?? 0;
    uid = json['uid'] ?? "Hello";
    lastlogin = json['lastlogin'] ?? "73838";
    code = json["Code"] ?? "0124" ;
    Phone_Number = json["Age"] ?? "20";
    lastloginn = json['lastloginn'] ?? "7986345";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Chess_Level'] = Username;
    data['Email'] = Email;
    data['Name'] = Name;
    data['Pic_link'] = Pic_link;
    data['Bio'] =  Bio;
    data['uid'] =  uid;
    data['Won'] = Won ;
    data['Age'] = Phone_Number ;
    data['Code'] = code;
    data['lastlogin'] = lastlogin ;
    data['lastloginn'] = lastloginn ;
    return data;
  }

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel.fromJson(snapshot);
  }
}