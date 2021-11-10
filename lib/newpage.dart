import 'package:flutter/material.dart';

class Newpage extends StatefulWidget {
  const Newpage({ Key? key }) : super(key: key);

  @override
  _NewpageState createState() => _NewpageState();
}

class _NewpageState extends State<Newpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text("salom "),),
    );
  }
}