import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'verify_code_screen.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({super.key});

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {

  String selectedCountryCode = "+506";
  final TextEditingController phoneController = TextEditingController();

  bool isLoading = false;

  Future<void> sendCode() async {

    String phone = "$selectedCountryCode${phoneController.text.trim()}";

    setState(() {
      isLoading = true;
    });

    await FirebaseAuth.instance.verifyPhoneNumber(

      phoneNumber: phone,

      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },

      verificationFailed: (FirebaseAuthException e) {

        setState(() {
          isLoading = false;
        });

        debugPrint("Error: ${e.message}");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Error de verificación")),
        );

      },

      codeSent: (String verificationId, int? resendToken) {

        setState(() {
          isLoading = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyCodeScreen(
              verificationId: verificationId,
            ),
          ),
        );

      },

      codeAutoRetrievalTimeout: (String verificationId) {},

    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.grey.shade100,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// BOTON RETROCEDER
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 10),

              const Text(
                "Tu número de teléfono",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Te enviaremos un código SMS para verificar tu identidad.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 40),

              /// TARJETA DEL INPUT
              Container(
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),

                child: Row(
                  children: [

                    /// CODIGO PAIS
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: DropdownButton<String>(
                        value: selectedCountryCode,
                        underline: const SizedBox(),

                        items: const [

                          DropdownMenuItem(
                            value: "+506",
                            child: Text("CR +506"),
                          ),

                          DropdownMenuItem(
                            value: "+1",
                            child: Text("US +1"),
                          ),

                          DropdownMenuItem(
                            value: "+55",
                            child: Text("BR +55"),
                          ),

                        ],

                        onChanged: (value) {
                          setState(() {
                            selectedCountryCode = value!;
                          });
                        },

                      ),
                    ),

                    const SizedBox(width: 12),

                    /// NUMERO
                    Expanded(
                      child: TextField(

                        controller: phoneController,
                        keyboardType: TextInputType.phone,

                        decoration: const InputDecoration(
                          hintText: "Número de teléfono",
                          border: InputBorder.none,
                        ),

                      ),
                    ),

                  ],
                ),
              ),

              const Spacer(),

              /// BOTON
              SizedBox(
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

                  onPressed: isLoading ? null : sendCode,

                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Enviar código",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                ),
              ),

              const SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }
}