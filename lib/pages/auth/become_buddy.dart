import 'package:flutter/material.dart';
import 'package:mobile/models/buddy.dart';
import 'package:mobile/models/phone_number.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/routes.dart';
import 'package:mobile/services/api_service_base.dart';
import 'package:provider/provider.dart';

class BecomeBuddyPage extends StatefulWidget {
  const BecomeBuddyPage({super.key});

  @override
  State<BecomeBuddyPage> createState() => _BecomeBuddyPageState();
}

class _BecomeBuddyPageState extends State<BecomeBuddyPage> {
  late AuthSessionProvider authProvider;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthSessionProvider>(context, listen: false);
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController phoneCountryCodeController = TextEditingController();

  Future<void> _submitForm() async {
    if (formKey.currentState!.validate()) {
      Buddy buddy = Buddy(
        firebaseUID: authProvider.user!.uid,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        gender: genderController.text,
        phoneNumber: PhoneNumber(
            countryCode: phoneCountryCodeController.text,
            number: phoneNumberController.text
        ),
        registrationDate: DateTime.now(),
        registrationMethod: 'email', // TODO: ajustar cuando se agregue registro por Google
        email: authProvider.user!.email!,
      );

      try {
        await ApiService.post(
          endpoint: "/buddies",
          body: buddy.toJson(),
        );
        print("Datos enviados con éxito");

        await authProvider
            .fetchUserData(); // Actualizamos los datos del usuario "manualmente", ya que no cambio en si el usuario de firebase

        Navigator.pushNamed(context, Routes.splashScreen);
      } catch (e) {
        print("Error al enviar los datos: $e");
      }
    } else {
      print("Formulario inválido");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiero ser buddy'),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    hintText: "Nombre",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: theme.colorScheme.primary.withOpacity(0.1),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresá tu nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    hintText: "Apellido",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: theme.colorScheme.primary.withOpacity(0.1),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresá tu apellido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: genderController,
                  decoration: InputDecoration(
                    hintText: "Género",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: theme.colorScheme.primary.withOpacity(0.1),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresá tu género';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: phoneCountryCodeController,
                  decoration: InputDecoration(
                    hintText: "Prefijo Teléfono",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: theme.colorScheme.primary.withOpacity(0.1),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresá el prefijo del país de tu teléfono';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(
                    hintText: "Nro Teléfono",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: theme.colorScheme.primary.withOpacity(0.1),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresá tu número de teléfono';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    backgroundColor: theme.colorScheme.primary,
                  ),
                  child: Text(
                    "Listo",
                    style: TextStyle(
                        color: theme.colorScheme.onPrimary, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
