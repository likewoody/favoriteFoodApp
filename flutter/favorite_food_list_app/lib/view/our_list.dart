import 'package:flutter/material.dart';

class OurList extends StatefulWidget {
  const OurList({super.key});

  @override
  State<OurList> createState() => _OurListState();
}

class _OurListState extends State<OurList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test2'),
      ),
    );
  }
}