import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile/pages/auth/login.dart';
import 'package:mobile/pages/auth/providers/auth_session_provider.dart';
import 'package:mobile/routes.dart';
import 'package:mobile/utils/validators.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late AuthSessionProvider authProvider;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
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

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _header(context, theme),
              _form(context, theme),
              _login(context, theme)
            ],
          ),
        ),
      ),
    );
  }

  _header(BuildContext context, ThemeData theme) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 60.0),
        Text(
          "Regístrate",
          style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          "Crea tu cuenta",
          style: TextStyle(fontSize: 15, color: theme.colorScheme.onSurface),
        )
      ],
    );
  }

  _signUp() async {
    if (formKey.currentState!.validate()) {
      try {
        final credential = await authProvider.registerWithEmail(
            emailController.text,
            passwordController.text
        );
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
  }

  _form(BuildContext context, ThemeData theme) {
    return Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                  hintText: "Correo electrónico",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none),
                  fillColor: theme.colorScheme.primary.withOpacity(0.1),
                  filled: true,
                  prefixIcon: Icon(Icons.email, color: theme.colorScheme.primary)),
              validator: validateEmail,
            ),
            const SizedBox(height: 20),
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
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Ingresá una contraseña';
                }
                if (value.length < 6) {
                  return 'La contraseña debe tener al menos 6 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                hintText: "Confirmar contraseña",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none),
                fillColor: theme.colorScheme.primary.withOpacity(0.1),
                filled: true,
                prefixIcon: Icon(Icons.password, color: theme.colorScheme.primary),
              ),
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Ingresá una contraseña';
                }
                if (value != passwordController.text) {
                  return 'Las contraseñas deben coincidir';
                }
                return null;
              },
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _signUp,
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: theme.colorScheme.primary,
              ),
              child: Text(
                "Sign up",
                style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 20),
              ),
            )
          ],
        ));
  }

  _login(BuildContext context, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text("Ya tienes una cuenta?"),
        TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: Text(
              "Ingresá",
              style: TextStyle(color: theme.colorScheme.primary),
            ))
      ],
    );
  }
}
