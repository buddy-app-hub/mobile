import 'package:flutter/material.dart';
import 'package:mobile/models/address.dart';
import 'package:mobile/models/personal_data.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/services/buddy_service.dart';
import 'package:mobile/services/elder_service.dart';
import 'package:provider/provider.dart';

class EditAddressPage extends StatefulWidget {
  @override
  _EditAddressPageState createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  final BuddyService buddyService = BuddyService();
  final ElderService elderService = ElderService();

  late AuthSessionProvider authProvider;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController streetNameController;
  late TextEditingController streetNumberController;
  late TextEditingController apartmentNumberController;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController postalCodeController;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthSessionProvider>(context, listen: false);

    Address? existingAddress = authProvider.isBuddy
          ? authProvider.userData!.buddy!.personalData.address
          : authProvider.userData!.elder!.personalData.address;

    Address address = existingAddress ?? Address(streetName: "", apartmentNumber: "", city: "", state: "", postalCode: "", country: "Argentina");

    streetNameController = TextEditingController(
      text: address.streetName,
    );
    streetNumberController = TextEditingController(
      text: address.streetNumber != null ? address.streetNumber.toString() : ""
    );
    apartmentNumberController = TextEditingController(
        text: address.apartmentNumber,
    );
    cityController = TextEditingController(
        text: address.city,
    );
    stateController = TextEditingController(
        text: address.state,
    );
    postalCodeController = TextEditingController(
        text: address.postalCode,
    );
  }

  void _submitForm() {
    if (formKey.currentState!.validate()) {
      Address newAddress = Address(
        streetName: streetNameController.text, 
        streetNumber: int.parse(streetNumberController.text), 
        apartmentNumber: apartmentNumberController.text, 
        city: cityController.text, 
        state: stateController.text, 
        postalCode: postalCodeController.text, 
        country: "Argentina"
      );

      if (authProvider.isBuddy) {
        PersonalData personalData = authProvider.userData!.buddy!.personalData;
        personalData.address = newAddress;
        buddyService.updateBuddyPersonalData(context, personalData);
      } else {
        PersonalData personalData = authProvider.userData!.elder!.personalData;
        personalData.address = newAddress;
        elderService.updateElderPersonalData(context, personalData);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Domicilio'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            onPressed: _submitForm,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(25, 10, 25, 40),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextFormField(streetNameController, "Nombre de la calle", theme),
                const SizedBox(height: 16),
                _buildTextFormField(streetNumberController, "Número de la calle", theme, isNumber: true),
                const SizedBox(height: 16),
                _buildTextFormField(apartmentNumberController, "Número del apartamento", theme),
                const SizedBox(height: 16),
                _buildTextFormField(cityController, "Ciudad", theme),
                const SizedBox(height: 16),
                _buildTextFormField(stateController, "Estado/Provincia", theme),
                const SizedBox(height: 16),
                _buildTextFormField(postalCodeController, "Código Postal", theme, isNumber: true),
                const SizedBox(height: 16),
                _buildCountryField(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String hintText, ThemeData theme, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        fillColor: theme.colorScheme.primary.withOpacity(0.1),
        filled: true,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Este campo es obligatorio';
        }
        return null;
      },
    );
  }

  Widget _buildCountryField(ThemeData theme) {
  return TextFormField(
    initialValue: "Argentina",
    enabled: false,
    decoration: InputDecoration(
      hintText: "País",
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      fillColor: theme.colorScheme.primary.withOpacity(0.1),
      filled: true,
    ),
  );
}

}
