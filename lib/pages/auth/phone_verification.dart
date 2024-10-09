import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/pages/auth/phone_code_verification.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:provider/provider.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({super.key});

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  String phone = "";
  bool enableCodeSend = false;
  String initialCountry = 'AR';
  PhoneNumber number = PhoneNumber(isoCode: 'AR');
  TextEditingController phoneController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();

  Future<void> sendCode({int? forceResendingToken}) async {
    print(phoneController.text);
    phone = phoneController.text;
    AuthSessionProvider authProvider = Provider.of<AuthSessionProvider>(context, listen: false);

    authProvider.sendCode(
      phone: phone, 
      verificationCompleted: (phoneAuthCredential) async {
        final smsCode = phoneAuthCredential.smsCode;
        print("Verification completed $smsCode");
      },
      verificationFailed: (error) {
        ScaffoldMessenger.of(context)
          ..hideCurrentMaterialBanner()
          ..showSnackBar(SnackBar(content: Text("${error.message}")));
      },
      codeSent: (verificationId, x) {
        if (forceResendingToken == null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyPhoneCodePage(
                countryCode: countryCodeController.text,
                phone: phoneController.text,
                verificationId: verificationId,
                forceResendingToken: x,
              ),
            ),
          );
        }
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  bool validatePhoneNumber(String phoneNumber) {
    final phoneInput = PhoneNumber(phoneNumber: phoneNumber);
    final isValid = phoneInput.phoneNumber?.isNotEmpty ?? false;
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(8, 0, 28, 20),
                child: Text(
                  'Ingrese su número de teléfono',
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Text(
                  'Verificaremos tu número de teléfono',
                  style: ThemeTextStyle.titleInfoSmallOutline(context),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(18, 30, 18, 40),
                child: InternationalPhoneNumberInput(
                  onInputChanged: (value) {
                    phoneController.text = value.phoneNumber!;
                    countryCodeController.text = value.isoCode!;
                    setState(() {
                      enableCodeSend = validatePhoneNumber(phoneController.text);
                    });
                  },
                  errorMessage:  'Número de teléfono inválido',
                  keyboardType: TextInputType.phone,
                  initialValue: number,
                  formatInput: true,
                  autoFocus: true,
                  selectorConfig: const SelectorConfig(
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    useEmoji: true,
                    useBottomSheetSafeArea: true,
                  ),
                  inputDecoration: InputDecoration(
                    hintText: "Número de teléfono",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                    filled: true,
                  ),
                  searchBoxDecoration: InputDecoration(
                    hintText: "Buscar país",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                    filled: true,
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: enableCodeSend ? sendCode : null,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    "Enviar código", 
                    style: TextStyle(
                      fontSize: 16
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}