class Review {
  late final String picLink;
  late final String name;
  late final String date;
  late final String description;
  late final int post ;
  Review({
    required this.picLink,
    required this.name,
    required this.date,
    required this.post,
    required this.description,
  });

  Review.fromJson(Map<String, dynamic> json){
    picLink = json['picLink'] ?? 'https://i1.sndcdn.com/artworks-XlSkUSDiFao4fUac-sWFuPA-t500x500.jpg';
    post = json['post'] ?? 5 ;
    name = json['name'] ?? 'AYUSMAN SAMASI';
    date =  json['date'] ?? "2024-01-24 10:52:00.139434";
    description = json['description'] ?? 'No review description available';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['picLink'] = picLink;
    data['post'] = post ;
    data['name'] = name;
    data['date'] = date ;
    data['description'] = description;
    return data;
  }
}
