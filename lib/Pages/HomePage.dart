import 'package:blog_post/Pages/LoginPage.dart';
import 'package:blog_post/Pages/PostFormPage.dart';
import 'package:blog_post/Pages/PostPage.dart';
import 'package:blog_post/Pages/ProfilePage.dart';
import 'package:blog_post/Services/UserService.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog App'),
        actions: [
          IconButton(
            onPressed: () {
              logout().then((value) => {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false)
                  });
            },
            icon: Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: currentIndex == 0 ? PostPage() : ProfilePage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PostFormPage()));
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 3,
        elevation: 10,
        clipBehavior: Clip.antiAlias,
        shape: CircularNotchedRectangle(),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: '')
          ],
            currentIndex: currentIndex,
          onTap: (val){
            setState(() {
              currentIndex = val;
            });
          },
        ),
      ),
    );
  }
}
