class OrderModel {
  OrderModel({
    required this.amount,
    required this.deliveryCharge,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.coupon,
    required this.status,
    required this.time,
    required this.id,
    required this.awd,
    required this.courierName,
    required this.courierStatus,
    required this.courierStatusId,
    required this.shipmentStatus,
    required this.shipmentId,
    required this.timestamp,
    required this.srOrderId,
    required this.assignDate,
    required this.pickupDate,
    required this.pod,
    required this.pod1,
    required this.other1,
    required this.other2,
    required this.country,
    required this.state,
    required this.city,
    required this.streetAddress,
    required this.landmark,
    required this.homeNumber,
    required this.homeNumber2,
    required this.pincode,
    required this.street,
    required this.shipmentTrackActivities,
    required this.email,
    required this.dated,
  required this.namec,
  required this.phone
  });

  late final double amount;
  late final String dated ;
  late final String namec;
  late final String email;
  late final String phone ;
  late final double deliveryCharge;
  late final String paymentMethod;
  late final String paymentStatus;
  late final String coupon;
  late final String status;
  late final String time;
  late final String id;
  late final String awd;
  late final String courierName;
  late final String courierStatus;
  late final String courierStatusId;
  late final String shipmentStatus;
  late final String shipmentId;
  late final String timestamp;
  late final String srOrderId;
  late final String assignDate;
  late final String pickupDate;
  late final String pod;
  late final String pod1;
  late final String other1;
  late final String other2;
  late final String country;
  late final String state;
  late final String city;
  late final String streetAddress;
  late final String landmark;
  late final String homeNumber;
  late final String homeNumber2;
  late final String pincode;
  late final String street;
  late List<OModel> shipmentTrackActivities;

  OrderModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? trackActivitiesData = json['shipmentTrackActivities'];
    shipmentTrackActivities = trackActivitiesData != null
        ? List<OModel>.from(trackActivitiesData.map((e) => OModel.fromJson(e)))
        : [];
    dated = json['dated'] ?? "12";
    namec = json['namec'] ?? "12";
    email = json['email'] ?? "12";
    phone = json['phone'] ?? "12";
    amount = json['amount'] ?? 0.0;
    deliveryCharge = json['delivery_charge'] ?? 0.0;
    paymentMethod = json['payment_method'] ?? '';
    paymentStatus = json['payment_status'] ?? '';
    coupon = json['coupon'] ?? '';
    status = json['status'] ?? '';
    time = json['time'] ?? '';
    id = json['id'] ?? '';
    awd = json['awd'] ?? '';
    courierName = json['courier_name'] ?? '';
    courierStatus = json['c_status'] ?? '';
    courierStatusId = json['c_status_id'] ?? '';
    shipmentStatus = json['shipment_st'] ?? '';
    shipmentId = json['ship_id'] ?? '';
    timestamp = json['timestamp'] ?? '';
    srOrderId = json['sr_order_id'] ?? '';
    assignDate = json['assign_date'] ?? '';
    pickupDate = json['pickup_date'] ?? '';
    pod = json['pod'] ?? '';
    pod1 = json['pod1'] ?? '';
    other1 = json['other1'] ?? '';
    other2 = json['other2'] ?? '';
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
     data['dated'] = dated ;
     data['namec'] = namec ;
     data['email'] = email ;
    data['phone'] = phone ;
    data['amount'] = amount;
    data['delivery_charge'] = deliveryCharge;
    data['payment_method'] = paymentMethod;
    data['payment_status'] = paymentStatus;
    data['coupon'] = coupon;
    data['status'] = status;
    data['time'] = time;
    data['id'] = id;
    data['awd'] = awd;
    data['courier_name'] = courierName;
    data['c_status'] = courierStatus;
    data['c_status_id'] = courierStatusId;
    data['shipment_st'] = shipmentStatus;
    data['ship_id'] = shipmentId;
    data['timestamp'] = timestamp;
    data['sr_order_id'] = srOrderId;
    data['assign_date'] = assignDate;
    data['pickup_date'] = pickupDate;
    data['pod'] = pod;
    data['pod1'] = pod1;
    data['other1'] = other1;
    data['other2'] = other2;
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;
    data['streetAddress'] = streetAddress;
    data['landmark'] = landmark;
    data['homeNumber'] = homeNumber;
    data['homeNumber2'] = homeNumber2;
    data['pincode'] = pincode;
    data['street'] = street;
    // Convert shipmentTrackActivities to JSON
    data['shipmentTrackActivities'] = shipmentTrackActivities.map((oModel) => oModel.toJson()).toList();
    return data;
  }

}


class OModel {
  late String name;
  late String sku;
  late int units ;
  late String price ;

  OModel({required this.name, required this.price, required this.sku, required this.units});

  OModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "h";
    sku = json['sku'] ?? "105";
    units = json['units'] ?? 1 ;
    price = json['price'] ?? "10";
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sku': sku,
      'units': units,
      'price': price,
    };
  }
}
