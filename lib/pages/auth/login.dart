import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mobile/pages/auth/choose_user.dart';
import 'package:mobile/pages/auth/phone_verification.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/pages/auth/signup.dart';
import 'package:mobile/routes.dart';
import 'package:mobile/theme/theme_button_style.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/utils/validators.dart';
import 'package:mobile/widgets/base_decoration.dart';
import 'package:mobile/widgets/base_elevated_button.dart';
import 'package:mobile/widgets/base_text_form_field.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late AuthSessionProvider authProvider;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController ();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthSessionProvider>(context, listen: false);
    final theme = Theme.of(context);

    return 
    SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        extendBody: true,
        extendBodyBehindAppBar: true, 
        resizeToAvoidBottomInset: false, 
        body: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.5),
                ),
                // child: Image.asset(
                //   'assets/images/login.png',
                //   fit: BoxFit.cover,
                // ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 70, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(28, 10, 28, 30),
                      child: SizedBox(
                        width: 175,
                        height: 75,
                        child: SvgPicture.asset(
                          'assets/icons/logo.svg',
                          color: theme.colorScheme.background,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BaseDecoration.boxCurveRight(context),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(7, 0, 7, 5),
                                    child: Text(
                                      'Ingresar',
                                      style: ThemeTextStyle.titleXLargeOnBackground700(context),
                                    ),
                                  ),
                                  Text(
                                    'Iniciá sesión para continuar',
                                    style: ThemeTextStyle.titleSmallOnSecondary(context),
                                  ),
                                ],
                              ),
                            ),
                            Form(
                              key: formKey,
                              child: Column(children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      _buildEmailField(context, theme),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      _buildPasswordField(context, theme),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 1),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      _buildLoginButton(context),
                                      SizedBox(height: 34),
                                    ],
                                  ),
                                ),
                              ],),
                              ),
                            Container(
                              margin: EdgeInsets.fromLTRB(1, 0, 0, 0),
                              child: _forgotPassword(context)
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(2, 0, 0, 1),
                              child: _signup(context),
                            ),
                            Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 1),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10),
                                    _buildGoogleLoginButton(context),
                                    SizedBox(height: 46)
                                  ],
                                ),
                          ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "No tienes una cuenta? ",
          style: ThemeTextStyle.titleSmallOnBackground(context),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignupPage()),
            );
          },
          child: Text(
            "Regístrate",
            style: ThemeTextStyle.titleSmallPrimary(context),
          ),
        )
      ],
    );
  }

  _forgotPassword(context) {
    return TextButton(
      onPressed: () {},
      child: Text(
        "Olvidaste tu contraseña?", 
        style: ThemeTextStyle.titleSmallOnBackground(context),
      ),
    );
  }

  _signIn() async {
    try {
      if (formKey.currentState!.validate()) {
      print("Formulario válido");
      print("Email: ${emailController.text}, pwd: ${passwordController.text}");

      try {
        final credential = await authProvider.signInWithEmail(
            emailController.text,
            passwordController.text
        );

        if (credential != null && credential.emailVerified) {
          if (credential.phoneNumber != null) {
            print("Sesión iniciada con correo verificado.");

            if (authProvider.userData != null &&
              authProvider.userData!.userWithPendingSignUp) {
              print("Registro de usuario pendiente, falta la elección de tipo de usuario.");
              String? countryCode = await extractCountryCode(credential.phoneNumber!);
              print(countryCode);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChooseUserPage(countryCode: (countryCode == null) ? countryCode! : '', phone: credential.phoneNumber!,)),
              );
            } else {
              Navigator.pushNamed(context, Routes.splashScreen);
            }

          } else {
            print("Sesión iniciada con correo verificado, falta verificar el teléfono.");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PhonePage()),
            );
          }
          
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Por favor verifica tu correo antes de iniciar sesión.')),
          );
          FirebaseAuth.instance.signOut();
        }

        // if (credential != null) Navigator.pushNamed(context, Routes.splashScreen);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No se encontro un usuario con ese mail.')),
          );
        } else if (e.code == 'wrong-password' || e.code == 'invalid-email') {
          print('Wrong password provided for that user.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Por favor verifica tu correo y/o contraseña.')),
          );
        }
      }
    } else {
      print("Formulario inválido");
    }
    } catch (e) {
      print('Validation error: $e');
    }
  }
  
  Widget _buildEmailField(BuildContext context, ThemeData theme) {
    return Container (
      width: double.maxFinite, 
      margin: EdgeInsets.symmetric(horizontal: 30), 
      child: Column (
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [
        BaseDecoration.buildPaddingField(context, 'Email'),
        SizedBox(height: 5),
        BaseTextFormField(
          controller: emailController,
          validator: validateEmail,
          fillColor: theme.colorScheme.primary.withOpacity(0.05),
        )
      ]
      )
    );
  }

  Widget _buildPasswordField(BuildContext context, ThemeData theme) {
    return Container (
      width: double.maxFinite, 
      margin: EdgeInsets.symmetric(horizontal: 30), 
      child: Column (
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          BaseDecoration.buildPaddingField(context, 'Contraseña'),
          SizedBox(height: 5),
          BaseTextFormField(
            controller: passwordController, 
            textInputAction: TextInputAction. done,
            obscureText: true,
            validator: validatePassword,
            fillColor: theme.colorScheme.primary.withOpacity(0.05),
          )
        ]
      )
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return BaseElevatedButton (
      text: "Ingresar",
      buttonTextStyle: ThemeTextStyle.titleLargeOnPrimary(context),
      margin: EdgeInsets. symmetric(horizontal: 36),
      buttonStyle: ThemeButtonStyle.primaryButtonStyle(context),
      onPressed: _signIn,
    );
  }
    
  Widget _buildGoogleLoginButton (BuildContext context) {
    return BaseElevatedButton(
      text: "Continuar con Google",
      margin: EdgeInsets. symmetric(horizontal: 36),
      leftIcon: Container(
        margin: EdgeInsets.only(right: 14),
        child: SvgPicture.asset(
          width: 32,
          height: 32,
          'assets/icons/google.svg',
          semanticsLabel: 'shape'
        ),
      ),
      buttonStyle: ThemeButtonStyle.googleButtonStyle(context), 
      buttonTextStyle: ThemeTextStyle.titleLargeGoogle(context),
    );
    
  }

  Future<String?> extractCountryCode(String phoneNumber) async {
    try {
      PhoneNumber number = await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber);
      String? countryCode = number.isoCode;
      return countryCode;
    } catch (e) {
      print('Error al extraer el ISO del número de telefono: $e');
      return null;
    }
  }
}
