import 'package:blog_post/Pages/HomePage.dart';
import 'package:blog_post/Pages/LoginPage.dart';
import 'package:blog_post/Services/UserService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constante.dart';
import '../Modeles/ApiResponse.dart';
import '../Modeles/UserModele.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool LoadingPage = false;
  TextEditingController
      nameController = TextEditingController(),
      emailController = TextEditingController(),
      passwordController = TextEditingController(),
      passwordConfirmController = TextEditingController();

  void _RegisterUser() async {
    ApiResponse response = await register(nameController.text, emailController.text, passwordController.text);
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as UserModele);
    } else {
      setState(() {
        LoadingPage = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  // Save and redirect to home
  void _saveAndRedirectToHome(UserModele user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("S'inscrire"),
        centerTitle: true,
      ),
      body: Form(
        key: formkey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
          children: [
            TextFormField(
                controller: nameController,
                validator: (val) =>
                val!.isEmpty ? 'Nom invalide' : null,
                decoration: kInputDecoration('Nom')),
            SizedBox(
              height: 20,
            ),
            TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (val) =>
                val!.length < 6 ? 'Adresse mail invalide' : null,
                decoration: kInputDecoration('Email')),
            SizedBox(
              height: 20,
            ),
            TextFormField(
                controller: passwordController,
                obscureText: true,
                validator: (val) =>
                val!.length < 6 ? 'Au moins 6 caracteres' : null,
                decoration: kInputDecoration('Mot de passe')),
            SizedBox(
              height: 20,
            ),
            TextFormField(
                controller: passwordConfirmController,
                obscureText: true,
                validator: (val) =>
                val != passwordController.text
                    ? 'Le mot de passe ne correspond pas'
                    : null,
                decoration: kInputDecoration('Confirmer votre mot de passe')),
            SizedBox(
              height: 20,
            ),
            LoadingPage ?
            Center(
              child: CircularProgressIndicator(),
            )
                : kTextButton("S'inscrire", () {
              if (formkey.currentState!.validate()) {
                setState(() {
                  LoadingPage = true;
                  _RegisterUser();
                });
              }
            }),
            SizedBox(
              height: 15,
            ),
            kLoginRegisterHint("Vous avez déjà un compte?", 'login', () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false);
            })
          ],
        ),
      ),
    );
  }

}
