import 'package:flutter/material.dart';

import '../Pages/LoadingPage.dart';

class MonApplication extends StatelessWidget{
  @override
  Widget build(BuildContext context){

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Loading(),
    );
  }
}