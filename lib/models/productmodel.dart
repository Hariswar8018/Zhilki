class ProductDetails {
  ProductDetails({
    required this.productName,
    required this.productDescription,
    required this.productStock,
    required this.productWeight,
    required this.mrpPrice,
    required this.gst,
    required this.productCategory,
    required this.productId,
    required this.manufacturerDetails,
    required this.shelfLife,
    required this.marketedBy,
    required this.countryOfOrigin,
    required this.photo1,
    required this.photo2,
    required this.photo3,
    required this.photo4,
    required this.Price,
    required this.Favourite,
    required this.q,
  });

  late final String productName;
  late final int q;
  late final String productDescription;
  late final int productStock;
  late final int productWeight;
  late final double mrpPrice;
  late final double Price;
  late final double gst;
  late final String productCategory;
  late final String productId;
  late final String manufacturerDetails;
  late final String shelfLife;
  late final String marketedBy;
  late final String countryOfOrigin;
  late final String photo1;
  late final String photo2;
  late final String photo3;
  late final String photo4;
  late final List Favourite ;

  ProductDetails.fromJson(Map<String, dynamic> json) {
    q = json["q"] ?? 1 ;
    productName = json['productName'] ?? 'Product';
    productDescription = json['productDescription'] ?? 'Your resume should highlight successful product launches and improvements, as well as data-driven go-to-market strategies and market research experience. Emphasize your ability to drive growth, improve customer satisfaction, and lead cross-functional teams to achieve product goals.';
    productStock = json['productStock'] ?? 30 ;
    productWeight = json['productWeight'] ?? 50 ;
    mrpPrice = json['mrpPrice'] ?? 60.0;
    gst = json['gst'] ?? 0.0;
    productCategory = json['productCategory'] ?? 'Loofah';
    productId = json['id'] ?? '123@15890';
    manufacturerDetails = json['manufacturerDetails'] ?? 'Ohio Pvt. Ltd.' ;
    shelfLife = json['shelfLife'] ?? 'N/A' ;
    marketedBy = json['marketedBy'] ?? 'Zhilki Pvt. Ltd.' ;
    countryOfOrigin = json['countryOfOrigin'] ?? 'INDIA' ;
    photo1 = json['photo1'] ?? 'url1' ;
    photo2 = json['photo2'] ?? 'url2' ;
    photo3 = json['photo3'] ?? 'url3' ;
    photo4 = json['photo4'] ?? 'url4' ;
    Price = json['Price'] ?? 100.0 ;
    Favourite = json['Love'] ?? [];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['q'] = q ;
    data['productName'] = productName;
    data['Price'] = Price ;
    data['productDescription'] = productDescription;
    data['productStock'] = productStock;
    data['productWeight'] = productWeight;
    data['mrpPrice'] = mrpPrice;
    data['gst'] = gst;
    data['productCategory'] = productCategory;
    data['id'] = productId;
    data['manufacturerDetails'] = manufacturerDetails;
    data['shelfLife'] = shelfLife;
    data['marketedBy'] = marketedBy;
    data['countryOfOrigin'] = countryOfOrigin;
    data['photo1'] = photo1;
    data['photo2'] = photo2;
    data['photo3'] = photo3;
    data['photo4'] = photo4;
    return data;
  }
}
