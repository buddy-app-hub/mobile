import 'package:flutter/material.dart';
import 'package:mobile/models/elder.dart';
import 'package:mobile/models/elder_profile.dart';
import 'package:mobile/models/identity_card.dart';
import 'package:mobile/models/loved_one.dart';
import 'package:mobile/models/personal_data.dart';
import 'package:mobile/models/phone_number.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/routes.dart';
import 'package:mobile/services/elder_service.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:provider/provider.dart';

List<DropdownMenuItem<String>>? items = [
  DropdownMenuItem(
    value: 'Masculino',
    child: Text('Masculino'),
  ),
  DropdownMenuItem(
    value: 'Femenino',
    child: Text('Femenino'),
  ),
  DropdownMenuItem(
    value: 'No binario',
    child: Text('No binario'),
  ),
  DropdownMenuItem(
    value: 'Otro',
    child: Text('Otro'),
  ),
  DropdownMenuItem(
    value: 'Prefiero no decir',
    child: Text('Prefiero no decir'),
  ),
];

class WantBuddyForLovedOnePage extends StatefulWidget {
  const WantBuddyForLovedOnePage({super.key, required this.countryCode, required this.phone});

  final String phone;
  final String countryCode;

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
  // TextEditingController phoneNumberController = TextEditingController();
  // TextEditingController phoneCountryCodeController = TextEditingController();
  TextEditingController relationshipToElderController = TextEditingController();

  // Elder data
  TextEditingController elderFirstNameController = TextEditingController();
  TextEditingController elderLastNameController = TextEditingController();
  TextEditingController elderGenderController = TextEditingController();

  Future<void> _submitForm() async {
    final ElderService elderService = ElderService();

    if (formKey.currentState!.validate()) {
      Elder elder = Elder(
        firebaseUID: authProvider.user!.uid,
        personalData: PersonalData(
          firstName: elderFirstNameController.text,
          lastName: elderLastNameController.text,
          gender: elderGenderController.text,
        ),
        phoneNumber: PhoneNumber(
            countryCode: widget.countryCode,
            number: widget.phone),
        registrationDate: DateTime.now(),
        registrationMethod:
            'email', // TODO: ajustar cuando se agregue registro por Google
        email: authProvider.user!.email!,
        onLovedOneMode: true,
        lovedOne: LovedOne(
            firstName: firstNameController.text,
            lastName: lastNameController.text,
            phoneNumber: PhoneNumber(
                countryCode: widget.countryCode,
                number: widget.phone),
            email: authProvider.user!.email!,
            relationshipToElder: relationshipToElderController.text),
        elderProfile: ElderProfile(
          photos: List.empty(),
        ),
        identityCard: IdentityCard(),
      );
      elderService.createElder(context, elder);
      Navigator.pushNamed(context, Routes.splashScreen);
    } else {
      print("Formulario inválido");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 40),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(8, 0, 28, 20),
                  child: Text(
                    'Quiero un buddy para un ser querido',
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 18),
                  child: Text(
                    'Complete todos los datos antes de continuar.',
                    style: ThemeTextStyle.titleInfoSmallOutline(context),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(8, 10, 8, 8),
                  child: Text(
                    'Datos tuyos',
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 18),
                  child: Column(
                    children: [
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
                      DropdownButtonFormField<String>(
                        onChanged: (value) {
                          setState(() {
                            genderController.text = value!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresá tu género';
                          }
                          return null;
                        },
                        items: items,
                        decoration: InputDecoration(
                          hintText: "Mi género",
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: theme.colorScheme.primary.withOpacity(0.1),
                          filled: true,
                        ),
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
                    ],
                  ),
                ),
                // const SizedBox(height: 16),
                // TextFormField(
                //   controller: phoneCountryCodeController,
                //   decoration: InputDecoration(
                //     hintText: "Prefijo Teléfono",
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(18),
                //       borderSide: BorderSide.none,
                //     ),
                //     fillColor: theme.colorScheme.primary.withOpacity(0.1),
                //     filled: true,
                //   ),
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Ingresá el prefijo del país de tu teléfono';
                //     }
                //     return null;
                //   },
                // ),
                // const SizedBox(height: 16),
                // TextFormField(
                //   controller: phoneNumberController,
                //   decoration: InputDecoration(
                //     hintText: "Nro Teléfono",
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(18),
                //       borderSide: BorderSide.none,
                //     ),
                //     fillColor: theme.colorScheme.primary.withOpacity(0.1),
                //     filled: true,
                //   ),
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Ingresá tu número de teléfono';
                //     }
                //     return null;
                //   },
                // ),
                
                const SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.fromLTRB(8, 10, 8, 8),
                  child: Text(
                    'Datos de tu ser querido',
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 18),
                  child: Column(
                    children: [
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
                      DropdownButtonFormField<String>(
                        onChanged: (value) {
                          setState(() {
                            elderGenderController.text = value!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresá el género de tu ser querido';
                          }
                          return null;
                        },
                        items: items,
                        decoration: InputDecoration(
                          hintText: "Género de tu ser querido",
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: theme.colorScheme.primary.withOpacity(0.1),
                          filled: true,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(28, 0, 28, 40),
        child: ElevatedButton(
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
      ),
    );
  }
}
