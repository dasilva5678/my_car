import '../../domain/entities/app_user.dart';

class AppUserModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;

  const AppUserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
  });

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel(
      id: json['id'].toString(),
      name: (json['name'] ?? json['username'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      photoUrl: (json['photoUrl'] ?? json['photo_url'])?.toString(),
    );
  }

  AppUser toEntity() => AppUser(
        id: id,
        name: name,
        email: email,
        photoUrl: photoUrl,
      );
}
