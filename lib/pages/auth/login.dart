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

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _header(context),
            _form(context),
            _forgotPassword(context),
            _signup(context),
          ],
        ),
      ),
    );
  }

  _header(context) {
    return const Column(
      children: [
        Text(
          "Bienvenido",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
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

  _form(context) {
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
                fillColor: Colors.purple.withOpacity(0.1),
                filled: true,
                prefixIcon: const Icon(Icons.person)),
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
              fillColor: Colors.purple.withOpacity(0.1),
              filled: true,
              prefixIcon: const Icon(Icons.password),
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
              backgroundColor: Colors.purple,
            ),
            child: const Text(
              "Login",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ],
      ),
    );
  }

  _forgotPassword(context) {
    return TextButton(
      onPressed: () {},
      child: const Text(
        "Olvidaste tu contraseña?",
        style: TextStyle(color: Colors.purple),
      ),
    );
  }

  _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("No tienes una cuenta? "),
        TextButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.signup);
            },
            child: const Text(
              "Regístrate",
              style: TextStyle(color: Colors.purple),
            ))
      ],
    );
  }
}
