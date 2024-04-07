import 'dart:convert';
import 'package:favorite_food_list_app/view/ourlist/ourlist_insert.dart';
import 'package:favorite_food_list_app/view/ourlist/ourlist_update.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

/*
    Date: 2024-04-07
    Author : Woody Jo
    Description : Favorite Food Ourlist View Main Page with MySQL
*/

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

  getJSONData() async {
    var url = Uri.parse('http://localhost:8080/Flutter/JSP/favoritefoodlistSearch.jsp');
    var response = await http.get(url);
    // print(response.body);

    var dataConvertedJSON = json.decode(response.body);
    var result = dataConvertedJSON['result'];
    data.addAll(result);
    setState(() {});
  }

  deleteData(id) async{
    var url = Uri.parse('http://localhost:8080/Flutter/JSP/favoritefoodlistDelete.jsp?id=$id');
    var response = await http.get(url);

    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];
    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Get.to(const OurListInsert())!.then((value) {
              // 화면에 addAll 해줄 것이기 때문에 초기화 후 add
              data = [];
              getJSONData();
            }), 
            icon: const Icon(Icons.add_outlined)
          ),
        ],
      ),
      body: Center(
        child: data.isNotEmpty
        ? ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Get.to(
                  const OurListUpdate(),
                  arguments: [
                    data[index]['name'],
                    data[index]['phone'],
                    data[index]['lat'],
                    data[index]['lng'],
                    data[index]['rate'],
                    data[index]['id'],
                  ],
                )!.then((value) {
                  data = [];
                  getJSONData();
                });
              },
              child: Slidable(
                endActionPane: ActionPane(
                  motion: const BehindMotion(), 
                  children: [
                    SlidableAction(
                      icon: Icons.delete_forever,
                      label: '삭제',
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Theme.of(context).colorScheme.onError,
                      onPressed: (context) => deleteData(data[index]['id']),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0,5,0,5),
                  child: GestureDetector(
                    onTap: () => Get.to(
                      const OurListUpdate(),
                      arguments: [
                        data[index]['name'],
                        data[index]['phone'],
                        data[index]['lat'],
                        data[index]['lng'],
                        data[index]['imgPath'],
                        data[index]['rate'],
                        data[index]['id'],
                      ],
                    ),
                    child: Container(
                      height: 150,
                      child: Card(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        child: Row(
                          children: [
                            Image.network(
                              data[index]['imgPath'],
                              width: 100,
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              '이름 :\n',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text('  ${data[index]['name']}\n'),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                                '  전화번호 :',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text('  ${data[index]['phone']}')
                                          ],
                                        )
                                      ],
                                    ),
                                    
                                    
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        )
        : const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}