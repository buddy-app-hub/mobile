import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/models/bank_account.dart';
import 'package:mobile/models/buddy.dart';
import 'package:mobile/models/buddy_profile.dart';
import 'package:mobile/models/identity_card.dart';
import 'package:mobile/models/personal_data.dart';
import 'package:mobile/models/phone_number.dart';
import 'package:mobile/models/student_details.dart';
import 'package:mobile/models/worker_details.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/routes.dart';
import 'package:mobile/services/buddy_service.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:provider/provider.dart';

List<DropdownMenuItem<String>>? items = [
  DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
  DropdownMenuItem(value: 'Femenino', child: Text('Femenino')),
  DropdownMenuItem(value: 'No binario', child: Text('No binario')),
  DropdownMenuItem(value: 'Otro', child: Text('Otro')),
  DropdownMenuItem(
      value: 'Prefiero no decir', child: Text('Prefiero no decir')),
];

class BecomeBuddyPage extends StatefulWidget {
  const BecomeBuddyPage(
      {super.key, required this.countryCode, required this.phone});

  final String phone;
  final String countryCode;

  @override
  State<BecomeBuddyPage> createState() => _BecomeBuddyPageState();
}

class _BecomeBuddyPageState extends State<BecomeBuddyPage> {
  late AuthSessionProvider authProvider;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthSessionProvider>(context, listen: false);
  }

  Future<void> _submitForm() async {
    final BuddyService buddyService = BuddyService();

    if (formKey.currentState!.validate()) {
      Buddy buddy = Buddy(
        firebaseUID: authProvider.user!.uid,
        personalData: PersonalData(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          gender: genderController.text,
          birthDate: DateFormat('dd/MM/yyyy').parse(dateController.text),
        ),
        phoneNumber:
            PhoneNumber(countryCode: widget.countryCode, number: widget.phone),
        registrationDate: DateTime.now(),
        registrationMethod: 'email',
        email: authProvider.user!.email!,
        buddyProfile: BuddyProfile(
          studentDetails: StudentDetails(),
          workerDetails: WorkerDetails(),
          photos: List.empty(),
        ),
        identityCard: IdentityCard(),
        bankAccount: BankAccount(),
      );
      await buddyService.createBuddy(context, buddy);
      Navigator.pushNamed(context, Routes.splashScreen);
    } else {
      print("Formulario inválido");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        dateController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
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
                    'Quiero ser buddy',
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
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 18),
                  child: Column(
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
                        validator: (value) => value == null || value.isEmpty
                            ? 'Ingresá tu nombre'
                            : null,
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
                        validator: (value) => value == null || value.isEmpty
                            ? 'Ingresá tu apellido'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        onChanged: (value) =>
                            setState(() => genderController.text = value!),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Ingresá tu género'
                            : null,
                        items: items,
                        decoration: InputDecoration(
                          hintText: "Género",
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 15),
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
                        controller: dateController,
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        decoration: InputDecoration(
                          hintText: "Fecha de nacimiento",
                          suffixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: theme.colorScheme.primary.withOpacity(0.1),
                          filled: true,
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Ingresá tu fecha de nacimiento'
                            : null,
                      ),
                    ],
                  ),
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
            style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
