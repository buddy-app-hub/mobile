import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/pages/auth/login.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/routes.dart';
import 'package:mobile/theme/theme_button_style.dart';
import 'package:mobile/theme/theme_text_style.dart';
import 'package:mobile/utils/validators.dart';
import 'package:mobile/widgets/base_decoration.dart';
import 'package:mobile/widgets/base_elevated_button.dart';
import 'package:mobile/widgets/base_text_form_field.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late AuthSessionProvider authProvider;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthSessionProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.primary.withOpacity(0.5),
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
                  color: theme.colorScheme.background,
                ),
                // child: Image.asset(
                //   'assets/images/login.png',
                //   fit: BoxFit.cover,
                // ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 67, 0, 0),
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
                          color: theme.colorScheme.primary.withOpacity(0.5),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BaseDecoration.boxCurveLeft(context),
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
                                      'Registrarse',
                                      style: ThemeTextStyle
                                          .titleXLargeOnBackground700(context),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(2, 0, 0, 1),
                                    child: _signIn(context),
                                  ),
                                ],
                              ),
                            ),
                            Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10),
                                        _buildEmailField(context, theme),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10),
                                        _buildPasswordField(context, theme),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10),
                                        _buildConfirmPasswordField(
                                            context, theme),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 1),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10),
                                        _buildSignUpButton(context),
                                        SizedBox(height: 5),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 1),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 24),
                                  _buildGoogleButton(context),
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

  _signIn(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Ya tienes una cuenta?",
          style: ThemeTextStyle.titleSmallOnBackground(context),
        ),
        TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: Text(
              "Inicia sesión",
              style: ThemeTextStyle.titleSmallOnPrimary(context),
            ))
      ],
    );
  }

  _signUp() async {
    print('_formKey.currentState: ${formKey.currentState}');
    try {
      if (formKey.currentState!.validate()) {
        try {
          final credential = await authProvider.registerWithEmail(
              emailController.text, passwordController.text);
          if (credential != null) {
            print("Usuario registrado con éxito en Firebase");
            Navigator.pushNamed(context, Routes.chooseUser);
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            print('La contraseña proporcionada es muy débil.');
          } else if (e.code == 'email-already-in-use') {
            print('Ya existe una cuenta con ese correo electrónico.');
          }
        } catch (e) {
          print(e);
        }
      } else {
        print("Formulario inválido");
      }
    } catch (e) {
      print('Validation error: $e');
    }
  }

  Widget _buildEmailField(BuildContext context, ThemeData theme) {
    return Container(
        width: double.maxFinite,
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          BaseDecoration.buildPaddingField(context, 'Email'),
          SizedBox(height: 5),
          BaseTextFormField(
            controller: emailController,
            validator: validateEmail,
            fillColor: theme.colorScheme.background.withOpacity(0.7),
          )
        ]));
  }

  Widget _buildPasswordField(BuildContext context, ThemeData theme) {
    return Container(
        width: double.maxFinite,
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          BaseDecoration.buildPaddingField(context, 'Contraseña'),
          SizedBox(height: 5),
          BaseTextFormField(
            controller: passwordController,
            textInputAction: TextInputAction.done,
            obscureText: true,
            validator: validatePassword,
            fillColor: theme.colorScheme.background.withOpacity(0.7),
          )
        ]));
  }

  Widget _buildConfirmPasswordField(BuildContext context, ThemeData theme) {
    return Container(
        width: double.maxFinite,
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          BaseDecoration.buildPaddingField(context, 'Confirmar contraseña'),
          SizedBox(height: 5),
          BaseTextFormField(
            controller: confirmPasswordController,
            textInputAction: TextInputAction.done,
            obscureText: true,
            validator: (value) =>
                validateConfirmPassword(value, passwordController.text),
            fillColor: theme.colorScheme.background.withOpacity(0.7),
          )
        ]));
  }

  Widget _buildSignUpButton(BuildContext context) {
    return BaseElevatedButton(
      text: "Regístrate",
      buttonTextStyle: ThemeTextStyle.titleLargeOnPrimary(context),
      margin: EdgeInsets.symmetric(horizontal: 36),
      buttonStyle: ThemeButtonStyle.primaryButtonStyle(context),
      onPressed: _signUp,
    );
  }

  Widget _buildGoogleButton(BuildContext context) {
    return BaseElevatedButton(
      text: "Continuar con Google",
      margin: EdgeInsets.symmetric(horizontal: 36),
      leftIcon: Container(
        margin: EdgeInsets.only(right: 14),
        child: SvgPicture.asset(
            width: 32,
            height: 32,
            'assets/icons/google.svg',
            semanticsLabel: 'shape'),
      ),
      buttonStyle: ThemeButtonStyle.googleButtonStyle(context),
      buttonTextStyle: ThemeTextStyle.titleLargeGoogle(context),
    );
  }
}
