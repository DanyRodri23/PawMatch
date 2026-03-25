import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Términos y Condiciones"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: Column(
        children: [

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),

                child: const SingleChildScrollView(
                  child: Text(
'''
TÉRMINOS Y CONDICIONES – PAWMATCH

Bienvenido a PawMatch. Al utilizar esta aplicación aceptas los siguientes términos y condiciones.

1. PROPÓSITO DE LA PLATAFORMA
PawMatch es una plataforma diseñada para conectar propietarios de mascotas que buscan posibles parejas para sus animales de forma responsable.

2. REGISTRO DE USUARIOS
Para utilizar la aplicación es necesario crear una cuenta proporcionando información veraz y actualizada.

3. INFORMACIÓN DE LAS MASCOTAS
Los usuarios pueden registrar información sobre sus mascotas como nombre, raza, edad, características y fotografías.

4. DECLARACIÓN DE RAZA Y PEDIGREE
Si el usuario indica que su mascota es de raza pura o pedigree, podrá solicitarse un certificado que respalde dicha información.

5. BIENESTAR ANIMAL
PawMatch promueve el respeto y bienestar de los animales.

6. USO APROPIADO DE LA PLATAFORMA
La aplicación está destinada exclusivamente para el registro de mascotas reales.

7. REPRESENTACIONES HUMANAS O "THERIANS"
PawMatch está diseñada exclusivamente para mascotas reales. No se permite el uso de la plataforma para representar identidades humanas, personajes ficticios, avatares o personas que se identifiquen como animales.

8. RESPONSABILIDAD
PawMatch funciona únicamente como una plataforma de conexión entre propietarios de mascotas.

9. PRIVACIDAD
La información proporcionada por los usuarios será utilizada únicamente para el funcionamiento de la plataforma.

10. MODIFICACIONES
PawMatch se reserva el derecho de modificar estos términos en cualquier momento.

11. ACEPTACIÓN
Al utilizar la aplicación el usuario declara haber leído y aceptado estos términos y condiciones.
''',

                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
            child: SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),

                onPressed: () {
                  Navigator.pop(context);
                },

                child: const Text(
                  "Aceptar y continuar",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ),
            ),
          ),

        ],
      ),
    );
  }
}