import 'package:favorite_food_list_app/view/mylist_insert.dart';
import 'package:favorite_food_list_app/viewmodel/db_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Get.to(const MyListInsert()), 
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
                return Card(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              const Text(
                                '이름 :',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                '${snapshot.data![index].name}\n',
                              ),
                              const Text(
                                '전화번호 :',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                snapshot.data![index].phone,
                              ),
                            ],
                          ),
                          
                        ],
                      )
                    ],
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