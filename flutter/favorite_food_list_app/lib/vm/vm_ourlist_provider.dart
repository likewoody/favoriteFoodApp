import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class VMOurListProvider extends ChangeNotifier{

  // Property
  List data = [];

  // @override
  // void initState() {
  //   super.initState();
  //   data = [];
  //   getJSONData();
  // }

  getJSONData() async {
    var url = Uri.parse('http://localhost:8080/Flutter/JSP/favoritefoodlistSearch.jsp');
    var response = await http.get(url);
    // print(response.body);

    var dataConvertedJSON = json.decode(response.body);
    var result = dataConvertedJSON['result'];
    data.addAll(result);
    notifyListeners();
  }

  deleteData(id) async{
    var url = Uri.parse('http://localhost:8080/Flutter/JSP/favoritefoodlistDelete.jsp?id=$id');
    var response = await http.get(url);

    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];
    if (result == 'OK') {
      data = [];
      getJSONData();
      _showDialog();
    }
  }

  // ---- Dialog ----
  _showDialog() {
    Get.defaultDialog(
      title: '알림',
      middleText: '삭제가 완료 되었습니다.',
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            Get.back();
          }, 
          child: const Text('종료')
        ),
      ],
    );
  }
}