import 'package:favorite_food_list_app/view/ourlist/ourlist_gps.dart';
import 'package:favorite_food_list_app/view/ourlist/ourlist_update.dart';
import 'package:favorite_food_list_app/vm/vm_ourlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class OurListWidget extends StatelessWidget {
  // 수정 필요 왜 init이 안되는지 모르겠음
  final provider = VMOurListProvider();
  OurListWidget({super.key, provider});
  // const OurListWidget({super.key});

  // 수정 필요 왜 init이 안되는지 모르겠음
  @override
  Widget build(BuildContext context) {
    // 수정 필요 왜 init이 안되는지 모르겠음
    provider.getJSONData();
    // 수정 필요 왜 init이 안되는지 모르겠음
    return Center(
      child: provider.data.isNotEmpty
      ? ListView.builder(
        itemCount: provider.data.length,
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
                  onPressed: (context) => provider.deleteData(provider.data[index]['id']),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0,5,0,5),
              child: Container(
                height: 150,
                child: GestureDetector(
                  onTap: () => Get.to(
                    const OurListUpdate(),
                    arguments: [
                      provider.data[index]['name'],
                      provider.data[index]['phone'],
                      provider.data[index]['lat'],
                      provider.data[index]['lng'],
                      provider.data[index]['img'],
                      provider.data[index]['rate'],
                      provider.data[index]['imgPath'],
                      provider.data[index]['id'],
                    ],
                  ),
                  onLongPress: () => Get.to(
                    const OurlistGPS(),
                    arguments: [
                      provider.data[index]['name'],
                      provider.data[index]['lat'],
                      provider.data[index]['lng'],
                    ]
                  ),
                  child: Card(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.network(
                              provider.data[index]['imgPath'],
                              width: 100,
                              height: 100,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                const Text(
                                  '\n이름 :\n',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('\n ${provider.data[index]['name']}\n'),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                    '\n전화번호 :',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('\n ${provider.data[index]['phone']}')
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
          );
        },
      )
      : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}