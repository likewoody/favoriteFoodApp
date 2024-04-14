import 'package:favorite_food_list_app/mylocation.dart';
import 'package:favorite_food_list_app/view/ourlist/ourlist_insert.dart';
import 'package:favorite_food_list_app/view/ourlist/widget/ourlist_widget.dart';
import 'package:favorite_food_list_app/vm/vm_ourlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';


/*
    Date: 2024-04-07
    Author : Woody Jo
    Description : Favorite Food Ourlist View Main Page with MySQL
*/

class OurList extends StatelessWidget {
  const OurList({super.key});
  

  @override
  Widget build(BuildContext context) {
    // 수정 필요 왜 init이 안되는지 모르겠음
    final provider = Provider.of<VMOurListProvider>(context);
    provider.getJSONData(); 
    // 수정 필요 왜 init이 안되는지 모르겠음
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Get.to(const Mylocation()), 
            icon: const Icon(Icons.map_outlined)
          ),
          IconButton(
            onPressed: () => Get.to(const OurListInsert())!.then((value) {
              // 화면에 addAll 해줄 것이기 때문에 초기화 후 add
              provider.data = [];
              provider.getJSONData();
            }), 
            icon: const Icon(Icons.add_outlined)
          ),
        ],
      ),
      body: OurListWidget(provider: provider),
      // body: const OurListWidget(),
    );
  }
}