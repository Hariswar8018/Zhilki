class Address {
  Address({
    required this.country,
    required this.state,
    required this.city,
    required this.streetAddress,
    required this.landmark,
    required this.homeNumber,
    required this.homeNumber2,
    required this.pincode,
    required this.street,
  });

  late final String country;
  late final String state;
  late final String city;
  late final String streetAddress;
  late final String landmark;
  late final String homeNumber;
  late final String homeNumber2;
  late final String pincode;
  late final String street;

  Address.fromJson(Map<String, dynamic> json) {
    country = json['country'] ?? 'INDIA';
    state = json['state'] ?? 'ODISHA';
    city = json['city'] ?? 'ROURKELA';
    streetAddress = json['streetAddress'] ?? 'A-10';
    landmark = json['landmark'] ?? 'Govt. High School';
    homeNumber = json['homeNumber'] ?? 'A-10';
    homeNumber2 = json['homeNumber2'] ?? 'RS Colony';
    pincode = json['pincode'] ?? '769042';
    street = json['street'] ?? 'Road Bazaar';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;
    data['streetAddress'] = streetAddress;
    data['landmark'] = landmark;
    data['homeNumber'] = homeNumber;
    data['homeNumber2'] = homeNumber2;
    data['pincode'] = pincode;
    data['street'] = street;
    return data;
  }
}
