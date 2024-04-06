import 'package:flutter/material.dart';

class WorldList extends StatefulWidget {
  const WorldList({super.key});

  @override
  State<WorldList> createState() => _WorldListState();
}

class _WorldListState extends State<WorldList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test2'),
      ),
    );
  }
}