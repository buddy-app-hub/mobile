import 'package:flutter/material.dart';
import 'package:mobile/models/elder.dart';
import 'package:mobile/models/loved_one.dart';
import 'package:mobile/models/personal_data.dart';
import 'package:mobile/models/phone_number.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/routes.dart';
import 'package:mobile/services/api_service_base.dart';
import 'package:provider/provider.dart';

class WantBuddyForLovedOnePage extends StatefulWidget {
  const WantBuddyForLovedOnePage({super.key});

  @override
  State<WantBuddyForLovedOnePage> createState() =>
      _WantBuddyForLovedOnePageState();
}

class _WantBuddyForLovedOnePageState extends State<WantBuddyForLovedOnePage> {
  late AuthSessionProvider authProvider;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthSessionProvider>(context, listen: false);
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // Loved one data
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController phoneCountryCodeController = TextEditingController();
  TextEditingController relationshipToElderController = TextEditingController();

  // Elder data
  TextEditingController elderFirstNameController = TextEditingController();
  TextEditingController elderLastNameController = TextEditingController();
  TextEditingController elderGenderController = TextEditingController();

  Future<void> _submitForm() async {
    if (formKey.currentState!.validate()) {
      Elder elder = Elder(
          firebaseUID: authProvider.user!.uid,
          personalData: PersonalData(
          firstName: elderFirstNameController.text,
          lastName: elderLastNameController.text,
          gender: elderGenderController.text,
          ),
          phoneNumber: PhoneNumber(
              countryCode: phoneCountryCodeController.text,
              number: phoneNumberController.text),
          registrationDate: DateTime.now(),
          registrationMethod:
              'email', // TODO: ajustar cuando se agregue registro por Google
          email: authProvider.user!.email!,
          onLovedOneMode: true,
          lovedOne: LovedOne(
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              phoneNumber: PhoneNumber(
                  countryCode: phoneCountryCodeController.text,
                  number: phoneNumberController.text),
              email: authProvider.user!.email!,
              relationshipToElder: relationshipToElderController.text));

      try {
        await ApiService.post(
          endpoint: "/elders",
          body: elder.toJson(),
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
        title: const Text('Quiero un buddy para un ser querido'),
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
                Text('Datos tuyos'),
                TextFormField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    hintText: "Mi nombre",
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
                    hintText: "Mi apellido",
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
                    hintText: "Mi género",
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: relationshipToElderController,
                  decoration: InputDecoration(
                    hintText: "Relación con tu ser querido",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: theme.colorScheme.primary.withOpacity(0.1),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresá la relación con tu ser querido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Text('Datos de tu ser querido'),
                TextFormField(
                  controller: elderFirstNameController,
                  decoration: InputDecoration(
                    hintText: "Nombre de tu ser querido",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: theme.colorScheme.primary.withOpacity(0.1),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresá el nombre de tu ser querido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: elderLastNameController,
                  decoration: InputDecoration(
                    hintText: "Apellido de tu ser querido",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: theme.colorScheme.primary.withOpacity(0.1),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresá el apellido de tu ser querido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: elderGenderController,
                  decoration: InputDecoration(
                    hintText: "Género de tu ser querido",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: theme.colorScheme.primary.withOpacity(0.1),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresá el género de tu ser querido';
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
