class ArtistModel {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? category;
  String? experience;
  String? price;
  String? description;
  double? avgRating;
  int? totalReviews;
  int? totalPosts;
  List<dynamic>? recentReviews;
  Map<String, dynamic>? profile;
  String? createdAt;

  ArtistModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.category,
    this.experience,
    this.price,
    this.description,
    this.avgRating,
    this.totalReviews,
    this.totalPosts,
    this.recentReviews,
    this.profile,
    this.createdAt,
  });

  factory ArtistModel.fromJson(Map<String, dynamic> json) {
    return ArtistModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      experience: json['experience']?.toString() ?? '',
      price: json['price']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      avgRating: double.tryParse(json['avg_rating'].toString()) ?? 0.0,
      totalReviews: int.tryParse(json['total_reviews'].toString()) ?? 0,
      totalPosts: int.tryParse(json['total_posts'].toString()) ?? 0,
      recentReviews: json['recent_reviews'] as List<dynamic>? ?? [],
      profile: json['profile'] as Map<String, dynamic>? ?? {},
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}