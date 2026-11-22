import 'package:flutter/material.dart';
import '../data/user_data.dart';
import 'photos_manager_page.dart';

class UserPhotosPage extends StatelessWidget {
  const UserPhotosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final saved = UserData.profile["images"];

    return PhotosManagerPage(
      title: "Tus fotos",
      hint: "La primera es tu foto principal.",
      minimum: 1,
      max: 6,
      initial: saved is List ? saved.map((e) => e.toString()).toList() : [],
      onSave: (urls) => UserData.updateProfile(images: urls),
    );
  }
}
