import 'package:favorite_food_list_app/view/mylist_insert.dart';
import 'package:favorite_food_list_app/view/mylist_update.dart';
import 'package:favorite_food_list_app/viewmodel/db_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'dart:typed_data';

class MyList extends StatefulWidget {
  const MyList({super.key});

  @override
  State<MyList> createState() => _MyListState();
}

class _MyListState extends State<MyList> {

  // Property
  late DataBaseHandler handler;



  @override
  void initState() {
    super.initState();
    handler = DataBaseHandler();
  }


  // ---- Functions ----
  rebuildData() {
    handler.queryFoodList();
    setState(() {});
  }


  // ---- Dialog ----
  _showDeleteDialog() {
    Get.defaultDialog(
      title: '알림',
      middleText: '삭제가 완료 되었습니다',
      actions: [
        TextButton(
          onPressed: () { 
            rebuildData();
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
            onPressed: () => Get.to(const MyListInsert())!.then((value) => rebuildData()), 
            icon: const Icon(Icons.add_outlined)
          ),
        ],
      ),
      body: FutureBuilder(
        future: handler.queryFoodList(), 
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const BehindMotion(), 
                    children: [
                      SlidableAction(
                        icon: Icons.delete_forever,
                        label: '삭제',
                        backgroundColor: Theme.of(context).colorScheme.error,
                        foregroundColor: Theme.of(context).colorScheme.onError,
                        onPressed: (context) async {
                          await handler.deleteFoodList(snapshot.data![index].id);
                          _showDeleteDialog();
                        },
                      )
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(
                        const MyListUpdate(),
                        arguments: [
                          snapshot.data![index].name,
                          snapshot.data![index].phone,
                          snapshot.data![index].lat,
                          snapshot.data![index].lng,
                          snapshot.data![index].sqlImg,
                          snapshot.data![index].rate,
                          snapshot.data![index].id,
                        ],
                      )!.then((value) => rebuildData());
                    },
                    child: Card(
                      child: Column(
                        children: [
                          Row(
                            children: [
                                Image.memory(
                                  snapshot.data![index].sqlImg,
                                  width: 100,
                                ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        '이름 :\n',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Text(
                                        '  ${snapshot.data![index].name}\n',
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        '전화번호 :',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Text(
                                        "  ${snapshot.data![index].phone}",
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}