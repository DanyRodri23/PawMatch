import 'package:flutter/material.dart';
import 'terms_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  bool aceptarTerminos = false;

  Widget inputField(String label, IconData icon, {bool password = false}) {
    return TextField(
      obscureText: password,
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

                      inputField("Nombre", Icons.person),

                      const SizedBox(height: 15),

                      inputField("Apellidos", Icons.person_outline),

                      const SizedBox(height: 15),

                      inputField("Correo electrónico", Icons.email),

                      const SizedBox(height: 15),

                      inputField("Contraseña", Icons.lock, password: true),

                      const SizedBox(height: 15),

                      inputField("Confirmar contraseña", Icons.lock_outline, password: true),

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

                          onPressed: () {

                            if (!aceptarTerminos) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Debes aceptar los términos y condiciones",
                                  ),
                                ),
                              );
                              return;
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Cuenta creada correctamente",
                                ),
                              ),
                            );

                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),

                          child: const Text(
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