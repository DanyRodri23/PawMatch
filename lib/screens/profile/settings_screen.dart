import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/discover_prefs.dart';
import '../../data/pet_profile_data.dart';
import '../terms_screen.dart';

/// Ajustes de PawMatch.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const Color bg = Color(0xFF0B0B0F);
  static const Color card = Color(0xFF16161C);

  // Se mantienen mientras la app está abierta.
  static bool pushOn = true;
  static bool autoplay = true;
  static bool showActivity = true;

  void soon(String what) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$what: próximamente"),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> logout() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cerrar sesión"),
        content: const Text("¿Seguro que quieres salir de PawMatch?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Cerrar sesión"),
          ),
        ],
      ),
    );

    if (ok == true) {
      if (mounted) Navigator.of(context).popUntil((r) => r.isFirst);
      await FirebaseAuth.instance.signOut();
    }
  }

  void openText(String title, List<List<String>> blocks) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _TextPage(title: title, blocks: blocks)),
    );
  }

  // ------------------------------------------------------------- piezas

  Widget title(String t) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 26, 24, 10),
        child: Text(
          t,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
      );

  Widget hint(String t) => Padding(
        padding: const EdgeInsets.fromLTRB(26, 8, 26, 0),
        child: Text(
          t,
          style: const TextStyle(color: Colors.white54, fontSize: 13, height: 1.35),
        ),
      );

  Widget group(List<Widget> rows) {
    final children = <Widget>[];
    for (int i = 0; i < rows.length; i++) {
      children.add(rows[i]);
      if (i != rows.length - 1) {
        children.add(const Divider(color: Colors.white10, height: 1, indent: 18));
      }
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(children: children),
    );
  }

  Widget row(
    String label, {
    String? value,
    VoidCallback? onTap,
    bool soonTag = false,
    Widget? trailing,
    Color color = Colors.white,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (value != null)
              Flexible(
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white54, fontSize: 15),
                ),
              ),
            if (soonTag)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Pronto",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            if (trailing != null) trailing,
            if (trailing == null && onTap != null && !soonTag)
              const Padding(
                padding: EdgeInsets.only(left: 6),
                child: Icon(Icons.chevron_right_rounded, color: Colors.white38),
              ),
          ],
        ),
      ),
    );
  }

  Widget switchRow(String label, bool value, ValueChanged<bool> onChanged,
      {String? sub}) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
      activeThumbColor: Colors.white,
      activeTrackColor: Colors.pinkAccent,
      title: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      subtitle: sub == null
          ? null
          : Text(sub, style: const TextStyle(color: Colors.white54, fontSize: 12.5)),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget radioRow(String label, String? sub, bool selected, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(color: Colors.white, fontSize: 16)),
                  if (sub != null) ...[
                    const SizedBox(height: 2),
                    Text(sub,
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 12.5)),
                  ],
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_rounded, color: Colors.pinkAccent),
          ],
        ),
      ),
    );
  }

  Widget plan(String name, String sub, Color color) {
    return GestureDetector(
      onTap: () => soon(name),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.workspace_premium_rounded, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sub,
                    style: const TextStyle(color: Colors.white60, fontSize: 13),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Pronto",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget shortcut(IconData icon, Color color, String label) {
    return Expanded(
      child: GestureDetector(
        onTap: () => soon(label),
        child: Container(
          height: 96,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 13.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sliderBlock({
    required String label,
    required String value,
    required Widget slider,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 6),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(label,
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
              ),
              Text(value,
                  style: const TextStyle(color: Colors.white60, fontSize: 15)),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              activeTrackColor: Colors.pinkAccent,
              inactiveTrackColor: Colors.white24,
              thumbColor: Colors.white,
              overlayColor: Colors.pinkAccent.withValues(alpha: 0.15),
            ),
            child: slider,
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------- build

  @override
  Widget build(BuildContext context) {
    final u = FirebaseAuth.instance.currentUser;
    final phone = (u?.phoneNumber ?? "").isEmpty ? "Agregar" : u!.phoneNumber!;
    final email = (u?.email ?? "").isEmpty ? "Agregar" : u!.email!;
    final loc = (PetProfileData.pet["location"] ?? "").toString();
    final genderLabel = DiscoverPrefs.gender == "Macho"
        ? "Machos"
        : DiscoverPrefs.gender == "Hembra"
            ? "Hembras"
            : "Todos";
    final ageMax = DiscoverPrefs.ageMax.round();
    final ageText =
        "${DiscoverPrefs.ageMin.round()}-${ageMax >= 15 ? "15+" : ageMax} años";
    final kmText =
        DiscoverPrefs.km.round() >= 100 ? "Sin límite" : "${DiscoverPrefs.km.round()} km";

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: const BoxDecoration(
                        color: Colors.white10,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white, size: 18),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      "Ajustes",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 46),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: MediaQuery.of(context).padding.bottom + 30,
                ),
                children: [
                  // Planes
                  plan("PawMatch Plus", "Likes ilimitados y más", Colors.redAccent),
                  plan("PawMatch Oro", "Descubre quién te dio like", Colors.amber),
                  plan("PawMatch Platino", "Likes prioritarios y todo lo anterior",
                      const Color(0xFFB0BEC5)),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        shortcut(Icons.star_rounded, Colors.lightBlueAccent,
                            "Más Super Likes"),
                        shortcut(Icons.bolt_rounded, Colors.purpleAccent,
                            "Conseguir Boosts"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        shortcut(Icons.visibility_off_rounded, Colors.white,
                            "Activar incógnito"),
                        shortcut(Icons.flight_takeoff_rounded, Colors.redAccent,
                            "Modo pasaporte"),
                      ],
                    ),
                  ),

                  // Cuenta
                  title("Ajustes de cuenta"),
                  group([
                    row("Número de teléfono", value: phone, onTap: () => soon("Cambiar teléfono")),
                    row("Cuentas conectadas",
                        value: (u?.providerData.any((p) => p.providerId == "google.com") ?? false)
                            ? "Google"
                            : null,
                        onTap: () => soon("Cuentas conectadas")),
                    row("Correo electrónico", value: email, onTap: () => soon("Cambiar correo")),
                  ]),
                  hint("Tu teléfono y correo verificados ayudan a proteger tu cuenta."),

                  // Descubrimiento
                  title("Descubrimiento"),
                  group([
                    row(
                      "Ubicación",
                      value: loc.isEmpty ? "Sin detectar" : loc,
                      onTap: () => soon("Agregar nueva ubicación"),
                    ),
                    sliderBlock(
                      label: "Distancia máxima",
                      value: kmText,
                      slider: Slider(
                        value: DiscoverPrefs.km,
                        min: 1,
                        max: 100,
                        onChanged: (v) => setState(() => DiscoverPrefs.km = v),
                        onChangeEnd: (_) => DiscoverPrefs.changed(),
                      ),
                    ),
                    row(
                      "Interesado en",
                      value: genderLabel,
                      onTap: () async {
                        final v = await showModalBottomSheet<String>(
                          context: context,
                          backgroundColor: const Color(0xFF121217),
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(28)),
                          ),
                          builder: (_) => SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 14),
                                for (final o in const [
                                  ["Todos", "Todos"],
                                  ["Macho", "Machos"],
                                  ["Hembra", "Hembras"],
                                ])
                                  ListTile(
                                    title: Text(o[1],
                                        style: const TextStyle(color: Colors.white)),
                                    trailing: DiscoverPrefs.gender == o[0]
                                        ? const Icon(Icons.check_rounded,
                                            color: Colors.pinkAccent)
                                        : null,
                                    onTap: () => Navigator.pop(context, o[0]),
                                  ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        );
                        if (v != null) {
                          setState(() => DiscoverPrefs.gender = v);
                          DiscoverPrefs.changed();
                        }
                      },
                    ),
                    sliderBlock(
                      label: "Rango de edad",
                      value: ageText,
                      slider: RangeSlider(
                        values: RangeValues(DiscoverPrefs.ageMin, DiscoverPrefs.ageMax),
                        min: 0,
                        max: 15,
                        divisions: 15,
                        onChanged: (v) => setState(() {
                          DiscoverPrefs.ageMin = v.start;
                          DiscoverPrefs.ageMax = v.end;
                        }),
                        onChangeEnd: (_) => DiscoverPrefs.changed(),
                      ),
                    ),
                    switchRow(
                      "Global",
                      false,
                      (_) => soon("Modo global"),
                      sub: "Por ahora PawMatch está disponible solo en Costa Rica.",
                    ),
                  ]),

                  title("Controla a quién ves"),
                  group([
                    radioRow(
                      "Recomendaciones equilibradas",
                      "Ve primero a las mascotas más relevantes para ti.",
                      DiscoverPrefs.order == "Equilibradas",
                      () => setState(() => DiscoverPrefs.order = "Equilibradas"),
                    ),
                    radioRow(
                      "Actividad reciente",
                      "Ve primero a quienes han estado activos hace poco.",
                      DiscoverPrefs.order == "Actividad reciente",
                      () => setState(() => DiscoverPrefs.order = "Actividad reciente"),
                    ),
                  ]),

                  title("Controlar mi visibilidad"),
                  group([
                    radioRow("Estándar", "Estarás visible en la pila de perfiles.",
                        true, () {}),
                    row("Incógnito", soonTag: true, onTap: () => soon("Incógnito")),
                    row("Bloquear contactos", soonTag: true,
                        onTap: () => soon("Bloquear contactos")),
                  ]),

                  title("Notificaciones"),
                  group([
                    switchRow("Notificaciones push", pushOn,
                        (v) => setState(() => pushOn = v)),
                  ]),
                  hint("Elige si quieres recibir avisos de matches y mensajes."),

                  title("Uso de datos"),
                  group([
                    switchRow("Reproducir videos automáticamente", autoplay,
                        (v) => setState(() => autoplay = v)),
                    switchRow("Mostrar estatus de actividad", showActivity,
                        (v) => setState(() => showActivity = v),
                        sub: "Otros verán cuándo estuviste activo."),
                  ]),

                  title("Apariencia"),
                  group([
                    radioRow("Oscuro", null, true, () {}),
                    row("Claro", soonTag: true, onTap: () => soon("Modo claro")),
                    row("Usar la configuración del sistema",
                        soonTag: true, onTap: () => soon("Modo automático")),
                  ]),

                  const SizedBox(height: 22),
                  group([
                    row("Restaurar compras", onTap: () => soon("Restaurar compras")),
                    row("Compartir PawMatch", onTap: () => soon("Compartir")),
                  ]),

                  title("Contáctanos"),
                  group([
                    row("Ayuda y asistencia", onTap: () => soon("Ayuda y asistencia")),
                    row("Reglas de la comunidad", onTap: () => openText(
                          "Reglas de la comunidad",
                          [
                            ["Respeto primero", "Trata con respeto a las personas y a sus mascotas. No se permite acoso, insultos ni discriminación."],
                            ["Perfiles reales", "Usa fotos reales de tu mascota y de ti. No se permiten perfiles falsos ni suplantar a otros."],
                            ["Bienestar animal", "No se permite promover maltrato, peleas ni venta ilegal de animales. La reproducción debe ser responsable."],
                            ["Contenido adecuado", "No publiques contenido violento, sexual o ilegal."],
                            ["Reportes", "Si ves algo que rompe las reglas, repórtalo desde el chat. Revisamos cada reporte."],
                          ],
                        )),
                    row("Consejos de seguridad", onTap: () => openText(
                          "Consejos de seguridad",
                          [
                            ["Primer encuentro", "Queda en un lugar público y concurrido, como un parque. Avísale a alguien de confianza."],
                            ["Tus datos", "No compartas tu dirección exacta, documentos ni datos bancarios por el chat."],
                            ["Pagos", "Desconfía de quien pida dinero por adelantado. PawMatch nunca te pedirá tu contraseña."],
                            ["Salud de tu mascota", "Para reproducción, pide siempre carnet de vacunas y revisa el estado de verificación del perfil."],
                            ["Denunciar", "Puedes bloquear o denunciar a cualquier persona desde el chat con el botón de tres puntos."],
                          ],
                        )),
                    row("Centro de seguridad", onTap: () => soon("Centro de seguridad")),
                  ]),

                  title("Privacidad"),
                  group([
                    row("Política de cookies", onTap: () => soon("Política de cookies")),
                    row("Política de privacidad", onTap: () => soon("Política de privacidad")),
                    row("Preferencias de privacidad", onTap: () => soon("Preferencias de privacidad")),
                  ]),

                  title("Legal"),
                  group([
                    row("Licencias", onTap: () => showLicensePage(
                          context: context,
                          applicationName: "PawMatch",
                          applicationVersion: "1.0.0",
                        )),
                    row("Términos de servicio", onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TermsScreen()),
                        )),
                  ]),

                  const SizedBox(height: 26),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: card,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: logout,
                        child: const Text("Cerrar sesión",
                            style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Center(
                    child: Column(
                      children: [
                        Icon(Icons.pets, color: Colors.pinkAccent),
                        SizedBox(height: 6),
                        Text("Versión 1.0.0",
                            style: TextStyle(color: Colors.white38)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: card,
                          foregroundColor: Colors.redAccent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () => soon("Borrar cuenta"),
                        child: const Text("Borrar cuenta",
                            style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextPage extends StatelessWidget {
  final String title;
  final List<List<String>> blocks;
  const _TextPage({required this.title, required this.blocks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0B0F),
        foregroundColor: Colors.white,
        title: Text(title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          for (final b in blocks)
            Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF16161C),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    b[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    b[1],
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14.5,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
