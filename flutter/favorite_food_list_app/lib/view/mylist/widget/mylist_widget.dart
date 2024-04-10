import 'dart:typed_data';

import 'package:favorite_food_list_app/view/%08mylist/mylist_gps.dart';
import 'package:favorite_food_list_app/view/%08mylist/mylist_update.dart';
import 'package:favorite_food_list_app/vm/vm_mylist_getx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class MyListWidget extends StatelessWidget {
  final controller = Get.put(VMMylistGetX());
  MyListWidget({super.key, controller});

  // ---- Dialog ----
  _showDeleteDialog() {
    Get.defaultDialog(
      title: '알림',
      middleText: '삭제가 완료 되었습니다',
      actions: [
        TextButton(
          onPressed: () { 
            controller.rebuildData();
            Get.back();
          }, 
          child: const Text('종료')
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controller.handler.queryFoodList(), 
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
                        await controller.handler.deleteFoodList(snapshot.data![index].id);
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
                    )!.then((value) => controller.rebuildData());
                  },
                  onLongPress: () => Get.to(
                    MylistGPS(),
                    arguments: [
                      snapshot.data![index].name,
                      snapshot.data![index].lat,
                      snapshot.data![index].lng,
                      snapshot.data![index].id,
                    ],
                  ),
                  child: Container(
                    height: 150,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0,5,0,5),
                      child: Card(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.memory(
                                      snapshot.data![index].sqlImg ?? Uint8List(0),
                                      width: 100,
                                    ),
                                  ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          '이름 :\n',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          '  ${snapshot.data![index].name}\n',
                                          style: const TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          '  전화번호 :',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          "  ${snapshot.data![index].phone}",
                                          style: const TextStyle(
                                            fontSize: 15,
                                          ),
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
    );
  }
}