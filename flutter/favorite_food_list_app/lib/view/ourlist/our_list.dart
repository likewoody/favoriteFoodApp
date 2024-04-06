import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OurList extends StatefulWidget {
  const OurList({super.key});

  @override
  State<OurList> createState() => _OurListState();
}

class _OurListState extends State<OurList> {

  // Property
  late List data;

  @override
  void initState() {
    super.initState();
    data = [];
    getJSONData();
  }

  getJSONData() {
    var url = Uri.parse('http://localhost:8080/Flutter/JSP/favoritefoodlist.jsp');
    var response = http.get(url);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      // body: ,
    );
  }
}