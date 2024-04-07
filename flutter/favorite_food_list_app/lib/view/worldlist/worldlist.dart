import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favorite_food_list_app/model/foodList.dart';
import 'package:favorite_food_list_app/view/worldlist/worldlist_gps.dart';
import 'package:favorite_food_list_app/view/worldlist/worldlist_insert.dart';
import 'package:favorite_food_list_app/view/worldlist/worldlist_update.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';


/*
    Date: 2024-04-07
    Author : Woody Jo
    Description : Favorite Food Worldlist View Main Page with Firebase
*/

class WorldList extends StatefulWidget {
  const WorldList({super.key});

  @override
  State<WorldList> createState() => _WorldListState();
}

// 그림 그리는 함수
Widget _buildItemWidget(context, doc) {
  final foodList = FoodList(
    name: doc['name'], 
    phone: doc['phone'], 
    lat: doc['lat'], 
    lng: doc['lng'], 
    rate: doc['rate'], 
    inputDate: doc['inputDate'],
    img: doc['img']
  );
  // data 삭제
  return Slidable(
    endActionPane: ActionPane(
      motion: const BehindMotion(), 
      children: [
        SlidableAction(
          icon: Icons.delete_forever,
          label: '삭제',
          backgroundColor: Theme.of(context).colorScheme.error,
          foregroundColor: Theme.of(context).colorScheme.onError,
          onPressed: (context) async{
            FirebaseFirestore.instance
            .collection('list')
            .doc(doc.id)
            .delete();
            // image 삭제
            await deleteImage(foodList.name);
          },
        ),
      ],
    ),
    child: GestureDetector(
      onTap: () => Get.to(
        const WorldLIstUpdate(),
        arguments: [
          doc.id,
          doc['name'],
          doc['phone'],
          doc['lat'],
          doc['lng'],
          doc['img'],
          doc['rate'],
        ],
      ),
      onLongPress: () => Get.to(
        const WorldListGPS(),
        arguments: [
          doc['name'],
          doc['lat'],
          doc['lng'],
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0,5,0,5),
        child: Card(
          child: ListTile(
            title: Row(
              children: [
                Image.network(
                  foodList.img ?? "",
                  width: 100,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          '\n     이름 :\n',
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(" ${foodList.name}")
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          '  전화번호 :\n',
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(" ${foodList.phone}\n")
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
}

// ---- Delete ----
deleteImage(name) async{
  final firebaseStorage = FirebaseStorage.instance
    .ref()
    .child('images')
    .child('$name.png');
  await firebaseStorage.delete();
}

class _WorldListState extends State<WorldList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Get.to(const WorldListInsert()), 
            icon: const Icon(Icons.add_outlined)
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
                .collection('list')
                .snapshots(),
                // .orderBy()
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            final documents = snapshot.data!.docs;
            return ListView(
              children: documents.map((e) => _buildItemWidget(context, e)).toList(),
            );
          }
          else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}