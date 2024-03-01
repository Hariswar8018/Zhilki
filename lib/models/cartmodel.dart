class CartModel {
  CartModel({
    required this.coupon,
    required this.cityWise,
    required this.totalAmount,
    required this.orderSuccessful,
    required this.orderStatus,
    required this.uniqueOrderNumber,
    required this.date,
    required this.payment,
    required this.paymentId,
  });

  late final String coupon;
  late final double cityWise;
  late final double totalAmount;
  late final bool orderSuccessful;
  late final String orderStatus;
  late final String uniqueOrderNumber;
  late final String date;
  late final String payment;
  late final String paymentId;

  CartModel.fromJson(Map<String, dynamic> json) {
    coupon = json['coupon'] ?? 'No Coupon';
    cityWise = json['cityWise'] ?? 0.0;
    totalAmount = json['totalAmount'] ?? 0.0;
    orderSuccessful = json['orderSuccessful'] ?? false;
    orderStatus = json['orderStatus'] ?? 'Pending';
    uniqueOrderNumber = json['uniqueOrderNumber'] ?? '123456';
    date = json['date'] ?? '2024-01-22';
    payment = json['payment'] ?? 'Credit Card';
    paymentId = json['paymentId'] ?? 'PAY123';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['coupon'] = coupon;
    data['cityWise'] = cityWise;
    data['totalAmount'] = totalAmount;
    data['orderSuccessful'] = orderSuccessful;
    data['orderStatus'] = orderStatus;
    data['uniqueOrderNumber'] = uniqueOrderNumber;
    data['date'] = date;
    data['payment'] = payment;
    data['paymentId'] = paymentId;
    return data;
  }
}
