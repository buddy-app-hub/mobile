import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/routes.dart';
import 'package:mobile/utils/validators.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late AuthSessionProvider authProvider;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthSessionProvider>(context, listen: false);
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _header(context, theme),
            _form(context, theme),
            _forgotPassword(context, theme),
            _signup(context, theme),
          ],
        ),
      ),
    );
  }

  _header(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        Text(
          "Bienvenido",
          style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text("Ingresa tus credenciales para continuar"),
      ],
    );
  }

  _signIn() async {
    if (formKey.currentState!.validate()) {
      print("Formulario válido");
      print("Email: ${emailController.text}, pwd: ${passwordController.text}");

      try {
        final credential = await authProvider.signInWithEmail(
            emailController.text,
            passwordController.text
        );

        if (credential != null) Navigator.pushNamed(context, Routes.home);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    } else {
      print("Formulario inválido");
    }
  }

  _form(BuildContext context, ThemeData theme) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
                hintText: "Correo electrónico",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none),
                fillColor: theme.colorScheme.primary.withOpacity(0.1),
                filled: true,
                prefixIcon: Icon(Icons.person, color: theme.colorScheme.primary)),
            validator: validateEmail,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(
              hintText: "Contraseña",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
              fillColor: theme.colorScheme.primary.withOpacity(0.1),
              filled: true,
              prefixIcon: Icon(Icons.password, color: theme.colorScheme.primary),
            ),
            obscureText: true,
            validator: validatePassword,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _signIn,
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: theme.colorScheme.primary,
            ),
            child: Text(
              "Login",
              style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 20),
            ),
          )
        ],
      ),
    );
  }

  _forgotPassword(BuildContext context, ThemeData theme) {
    return TextButton(
      onPressed: () {},
      child: Text(
        "Olvidaste tu contraseña?",
        style: TextStyle(color: theme.colorScheme.primary),
      ),
    );
  }

  _signup(BuildContext context, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("No tienes una cuenta? "),
        TextButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.signup);
            },
            child: Text(
              "Regístrate",
              style: TextStyle(color: theme.colorScheme.primary),
            ))
      ],
    );
  }
}
