class Coupon {
  late final bool free ;
  late final int much ;
  late final int up ;
  late final bool perc ;
  late final double percent ;
  late final double minusPrice ;
  late final String name ;
  late final String description ;

  Coupon({
    required this.free ,
    required this.up ,
    required this.much ,
    required this.perc ,
    required this.percent,
    required this.minusPrice,
    required this.name,
    required this.description,
  });

  Coupon.fromJson(Map<String, dynamic> json) {
    free = json['free'] ?? false;
    much = json['much'] ?? 1000;
    up = json['up'] ?? 10000 ;
    perc = json['perc'] ?? false;
    percent = json['percent'] ?? 3.0;
    minusPrice = json['minusPrice'] ?? 5.0;
    name = json['name'] ?? 'Coupon Name';
    description = json['description'] ?? 'No coupon description available';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['free'] = free ;
    data['up'] = up ;
    data['much'] = much ;
    data['perc'] = perc ;
    data['percent'] = percent ;
    data['minusPrice'] = minusPrice ;
    data['name'] = name ;
    data['description'] = description ;
    return data;
  }
}
