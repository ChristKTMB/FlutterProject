import 'package:blog_post/Modeles/ApiResponse.dart';
import 'package:blog_post/Modeles/UserModele.dart';
import 'package:blog_post/Pages/RegisterPage.dart';
import 'package:blog_post/Services/UserService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constante.dart';
import 'HomePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool LoadingPage = false;

  void _LoginUser() async {
    ApiResponse response = await login(txtEmail.text, txtPassword.text);
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
        title: Text('Connexion'),
        centerTitle: true,
      ),
      body: Form(
        key: formkey,
        child: ListView(
          padding: EdgeInsets.all(32),
          children: [
            TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: txtEmail,
                validator: (val) =>
                    val!.isEmpty ? 'Adresse mail invalide' : null,
                decoration: kInputDecoration('Email')),
            SizedBox(
              height: 15,
            ),
            TextFormField(
                controller: txtPassword,
                obscureText: true,
                validator: (val) =>
                    val!.length < 6 ? 'Au moins 6 caracteres' : null,
                decoration: kInputDecoration('Mot de passe')),
            SizedBox(
              height: 15,
            ),
            LoadingPage
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : kTextButton('Connexion', () {
                    if (formkey.currentState!.validate()) {
                      setState(() {
                        LoadingPage = true;
                        _LoginUser();
                      });
                    }
                  }),
            SizedBox(
              height: 15,
            ),
            kLoginRegisterHint("Vous n'avez pas de compte ? ", "S'enregistrer",
                () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Register()),
                  (route) => false);
            })
          ],
        ),
      ),
    );
  }
}
