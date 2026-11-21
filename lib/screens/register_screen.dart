import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/user_profile_data.dart';
import '../services/user_services.dart';
import 'terms_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  bool aceptarTerminos = false;
  bool isLoading = false;

  @override
  void dispose() {
    nombreController.dispose();
    apellidosController.dispose();
    correoController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  void _mostrarMensaje(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto)),
    );
  }

  String _mensajeError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Ese correo ya tiene una cuenta.';
      case 'invalid-email':
        return 'El correo no es válido.';
      case 'weak-password':
        return 'La contraseña es muy débil (mínimo 6 caracteres).';
      case 'network-request-failed':
        return 'Sin conexión a internet.';
      default:
        return 'No se pudo crear la cuenta. Intenta de nuevo.';
    }
  }

  Future<void> crearCuenta() async {
    final nombre = nombreController.text.trim();
    final apellidos = apellidosController.text.trim();
    final correo = correoController.text.trim();
    final password = passwordController.text;
    final confirmar = confirmController.text;

    if (nombre.isEmpty ||
        apellidos.isEmpty ||
        correo.isEmpty ||
        password.isEmpty ||
        confirmar.isEmpty) {
      _mostrarMensaje("Completa todos los campos.");
      return;
    }

    if (password.length < 6) {
      _mostrarMensaje("La contraseña debe tener al menos 6 caracteres.");
      return;
    }

    if (password != confirmar) {
      _mostrarMensaje("Las contraseñas no coinciden.");
      return;
    }

    if (!aceptarTerminos) {
      _mostrarMensaje("Debes aceptar los términos y condiciones");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final credencial =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: correo,
        password: password,
      );

      await credencial.user?.updateDisplayName("$nombre $apellidos");

      // Si falla el guardado del perfil (por ejemplo, por reglas de
      // Firestore), la cuenta igual queda creada.
      try {
        await UserService.saveUserProfile(
          data: {
            "nombre": nombre,
            "apellidos": apellidos,
          },
        );
      } catch (e) {
        debugPrint("No se pudo guardar el perfil: $e");
      }

      // Para que el perfil tenga el nombre desde la primera sesión.
      UserProfileData.updateProfile(name: nombre);

      if (!mounted) return;

      // Vuelve a la pantalla raíz; AuthGate muestra el dashboard.
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      _mostrarMensaje(_mensajeError(e));
    }
  }

  Widget inputField(
    String label,
    IconData icon,
    TextEditingController controller, {
    bool password = false,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: password,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),

        filled: true,
        fillColor: Colors.grey.shade100,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.grey.shade100,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              const SizedBox(height: 40),

              const Text(
                "Crear cuenta",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Crea tu cuenta para comenzar en PawMatch",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 35),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),

                child: Container(
                  padding: const EdgeInsets.all(22),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),

                  child: Column(
                    children: [

                      inputField("Nombre", Icons.person, nombreController),

                      const SizedBox(height: 15),

                      inputField(
                        "Apellidos",
                        Icons.person_outline,
                        apellidosController,
                      ),

                      const SizedBox(height: 15),

                      inputField(
                        "Correo electrónico",
                        Icons.email,
                        correoController,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 15),

                      inputField(
                        "Contraseña",
                        Icons.lock,
                        passwordController,
                        password: true,
                      ),

                      const SizedBox(height: 15),

                      inputField(
                        "Confirmar contraseña",
                        Icons.lock_outline,
                        confirmController,
                        password: true,
                      ),

                      const SizedBox(height: 15),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Checkbox(
                            value: aceptarTerminos,
                            activeColor: Colors.black,
                            onChanged: (value) {
                              setState(() {
                                aceptarTerminos = value!;
                              });
                            },
                          ),

                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TermsScreen(),
                                  ),
                                );
                              },

                              child: const Padding(
                                padding: EdgeInsets.only(top: 12),

                                child: Text(
                                  "Acepto los términos y condiciones",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 55,

                        child: ElevatedButton(

                          onPressed: isLoading ? null : crearCuenta,

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),

                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Crear cuenta",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                        ),
                      ),

                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },

                child: const Text(
                  "¿Ya tienes cuenta? Iniciar sesión",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 40),

            ],
          ),
        ),
      ),
    );
  }
}
