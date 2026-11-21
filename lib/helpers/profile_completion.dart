import 'package:flutter/material.dart';
import '../data/pet_profile_data.dart';
import '../data/user_data.dart';
import '../data/user_profile_data.dart';

enum ProfileTarget { pet, owner, certificates }

class ProfileTask {
  final String title;
  final String subtitle;
  final IconData icon;
  final int weight;
  final bool done;
  final ProfileTarget target;

  const ProfileTask({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.weight,
    required this.done,
    required this.target,
  });
}

/// Calcula qué tan completo está el perfil (mascota + dueño).
class ProfileCompletion {
  static List<ProfileTask> tasks() {
    final pet = PetProfileData.pet;
    final owner = UserProfileData.user;
    final ownerBase = UserData.profile;

    final petImages = pet["images"] is List ? (pet["images"] as List) : [];
    final traits = pet["traits"] is List ? (pet["traits"] as List) : [];
    final ownerImages =
        ownerBase["images"] is List ? (ownerBase["images"] as List) : [];

    final isPure = pet["isPureBreed"] == true;

    return [
      ProfileTask(
        title: "Fotos de tu mascota",
        subtitle: "Sube al menos 4 fotos",
        icon: Icons.photo_camera_rounded,
        weight: 20,
        done: petImages.length >= 4,
        target: ProfileTarget.pet,
      ),
      ProfileTask(
        title: "Personalidad",
        subtitle: "Elige 3 o más características",
        icon: Icons.emoji_emotions_rounded,
        weight: 10,
        done: traits.length >= 3,
        target: ProfileTarget.pet,
      ),
      ProfileTask(
        title: "Descripción",
        subtitle: "Cuenta algo sobre tu mascota",
        icon: Icons.edit_note_rounded,
        weight: 5,
        done: (pet["description"] ?? "").toString().trim().isNotEmpty,
        target: ProfileTarget.pet,
      ),
      ProfileTask(
        title: "Qué busca",
        subtitle: "Dinos qué busca tu mascota",
        icon: Icons.favorite_rounded,
        weight: 5,
        done: (pet["lookingFor"] ?? "").toString().isNotEmpty,
        target: ProfileTarget.pet,
      ),
      ProfileTask(
        title: "Carnet de vacunas",
        subtitle: "Gana la insignia de vacuna",
        icon: Icons.vaccines_rounded,
        weight: 15,
        done: (pet["vaccineCard"] ?? "").toString().isNotEmpty,
        target: ProfileTarget.certificates,
      ),
      if (isPure)
        ProfileTask(
          title: "Certificado de pedigrí",
          subtitle: "Gana la huellita azul",
          icon: Icons.workspace_premium_rounded,
          weight: 15,
          done: (pet["pedigreeCertificate"] ?? "").toString().isNotEmpty,
          target: ProfileTarget.certificates,
        ),
      ProfileTask(
        title: "Tu foto",
        subtitle: "Agrega tu foto de dueño",
        icon: Icons.person_rounded,
        weight: 10,
        done: ownerImages.isNotEmpty,
        target: ProfileTarget.owner,
      ),
      ProfileTask(
        title: "Sobre ti",
        subtitle: "Escribe una breve biografía",
        icon: Icons.notes_rounded,
        weight: 5,
        done: (owner["bio"] ?? "").toString().trim().isNotEmpty,
        target: ProfileTarget.owner,
      ),
      // Lo básico (nombre, edad, sexo, raza) ya se pidió en el registro.
      const ProfileTask(
        title: "Datos básicos",
        subtitle: "Nombre, edad, sexo y raza",
        icon: Icons.pets,
        weight: 15,
        done: true,
        target: ProfileTarget.pet,
      ),
    ];
  }

  static int percent() {
    final all = tasks();
    final total = all.fold<int>(0, (a, t) => a + t.weight);
    final done = all.where((t) => t.done).fold<int>(0, (a, t) => a + t.weight);

    if (total == 0) return 0;
    return ((done / total) * 100).round();
  }

  static List<ProfileTask> pending() =>
      tasks().where((t) => !t.done).toList();
}
