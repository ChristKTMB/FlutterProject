import 'dart:io';

import 'package:blog_post/Constante.dart';
import 'package:blog_post/Modeles/ApiResponse.dart';
import 'package:blog_post/Pages/HomePage.dart';
import 'package:blog_post/Pages/LoadingPage.dart';
import 'package:blog_post/Pages/LoginPage.dart';
import 'package:blog_post/Services/PostService.dart';
import 'package:blog_post/Services/UserService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostFormPage extends StatefulWidget {
  const PostFormPage({Key? key}) : super(key: key);

  @override
  State<PostFormPage> createState() => _PostFormPageState();
}

class _PostFormPageState extends State<PostFormPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _txtControllerBody = TextEditingController();
  bool _LoadingPage = false;
  File? _imageFile;
  final _picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _createPost() async {
    String? image = _imageFile == null ? null : getStringImage(_imageFile);
    ApiResponse response = await createPost(_txtControllerBody.text, image);

    if(response.error == null){
      Navigator.of(context).pop();
    }
    else if (response.error == unauthorized){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false)
      });
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
      setState(() {
        _LoadingPage = !_LoadingPage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un nouveau poste'),
      ),
      body: _LoadingPage
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  decoration: BoxDecoration(
                      image: _imageFile == null
                          ? null
                          : DecorationImage(
                              image: FileImage(_imageFile ?? File('')),
                              fit: BoxFit.cover)),
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.black45,
                      ),
                      onPressed: () {
                        getImage();
                      },
                    ),
                  ),
                ),
                Form(
                  key: _formkey,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: TextFormField(
                      controller: _txtControllerBody,
                      keyboardType: TextInputType.multiline,
                      maxLines: 9,
                      validator: (val) => val!.isEmpty
                          ? 'Le corps du message est requis'
                          : null,
                      decoration: InputDecoration(
                          hintText: "Votre message...",
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black38))),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: kTextButton("Publier", () {
                    if (_formkey.currentState!.validate()) {
                      setState(() {
                        _LoadingPage = !_LoadingPage;
                      });
                      _createPost();
                    }
                  }),
                )
              ],
            ),
    );
  }
}
