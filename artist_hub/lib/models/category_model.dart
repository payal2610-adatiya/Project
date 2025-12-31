import '../core/constants/app_assets.dart';

class CategoryModel {
  final String id;
  final String name;
  final String? description;
  final String icon;
  final int artistCount;
  final bool isActive;
  final DateTime createdAt;

  CategoryModel({
    required this.id,
    required this.name,
    this.description,
    required this.icon,
    required this.artistCount,
    required this.isActive,
    required this.createdAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      icon: json['icon'] ?? '',
      artistCount: json['artistCount'] ?? 0,
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'artistCount': artistCount,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String get iconAsset {
    // Map backend icon names to local assets
    switch (icon) {
      case 'singer':
        return AppAssets.iconSinger;
      case 'dancer':
        return AppAssets.iconDancer;
      case 'dj':
        return AppAssets.iconDj;
      case 'musician':
        return AppAssets.iconMusician;
      case 'magician':
        return AppAssets.iconMagician;
      case 'comedian':
        return AppAssets.iconComedian;
      case 'painter':
        return AppAssets.iconPainter;
      case 'photographer':
        return AppAssets.iconPhotographer;
      default:
        return AppAssets.iconArtist;
    }
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    int? artistCount,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      artistCount: artistCount ?? this.artistCount,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}