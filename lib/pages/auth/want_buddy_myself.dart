import 'package:flutter/material.dart';
import 'package:mobile/models/elder_profile.dart';
import 'package:mobile/models/identity_card.dart';
import 'package:mobile/models/personal_data.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/services/elder_service.dart';
import 'package:provider/provider.dart';
import 'package:mobile/models/elder.dart';
import 'package:mobile/models/phone_number.dart';

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

class WantBuddyForMyselfPage extends StatefulWidget {
  const WantBuddyForMyselfPage({super.key});

  @override
  State<WantBuddyForMyselfPage> createState() => _WantBuddyForMyselfPageState();
}

class _WantBuddyForMyselfPageState extends State<WantBuddyForMyselfPage> {
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
    final ElderService elderService = ElderService();

    if (formKey.currentState!.validate()) {
      Elder elder = Elder(
        firebaseUID: authProvider.user!.uid,
        personalData: PersonalData(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          gender: genderController.text,
        ),
        phoneNumber: PhoneNumber(
            countryCode: phoneCountryCodeController.text,
            number: phoneNumberController.text),
        registrationDate: DateTime.now(),
        registrationMethod:
            'email', // TODO: ajustar cuando se agregue registro por Google
        email: authProvider.user!.email!,
        onLovedOneMode: false,
        elderProfile: ElderProfile(),
        identityCard: IdentityCard(),
      );
      await authProvider.sendCode(elder.phoneNumber.countryCode + elder.phoneNumber.number);
      // elderService.createElder(context, elder);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => PinVerificationPage(elder: elder, buddy: null, isBuddy: false,)),
      // );
      
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
                    'Quiero un buddy para mi',
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.left,
                  ),
                ),
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
                    hintText: "Género",
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
                
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(28, 20, 28, 40),
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
