
import 'package:favorite_food_list_app/mylocation.dart';
import 'package:favorite_food_list_app/view/%08mylist/mylist_insert.dart';
import 'package:favorite_food_list_app/view/%08mylist/widget/mylist_widget.dart';
import 'package:favorite_food_list_app/vm/vm_mylist_getx.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/*
    Date: 2024-04-07
    Author : Woody Jo
    Description : Favorite Food Mylist View Main Page with SQLite 
*/

class MyList extends StatelessWidget {
  MyList({super.key});

  final controller = Get.put(VMMylistGetX());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VMMylistGetX>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () => Get.to(const Mylocation()), 
                icon: const Icon(Icons.map_outlined)
              ),
              IconButton(
                onPressed: () => Get.to(MyListInsert())!.then((value) => controller.rebuildData()), 
                icon: const Icon(Icons.add_outlined)
              ),
            ],
          ),
          body: MyListWidget(controller: controller),
        );
      },
    );
  }
}