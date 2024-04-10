import 'dart:io';
import 'dart:typed_data';

import 'package:favorite_food_list_app/model/foodList.dart';
import 'package:favorite_food_list_app/vm/vm_mylist_getx.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MyListInsertWidget extends StatelessWidget {
  final controller = Get.put(VMMylistGetX());
  MyListInsertWidget({super.key, controller});
  

  // --- Property ---
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController lngController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  
  // --- Function ---
  // image insert
  insertData() async{
    File imgFile = File(controller.imageFile!.path);
    Uint8List getImage = await imgFile.readAsBytes();
    
    FoodList foodList = FoodList(
      name: nameController.text.toString(), 
      phone: phoneController.text.toString(), 
      lat: latController.text.toString(), 
      lng: lngController.text.toString(), 
      rate: rateController.text.toString(), 
      inputDate: _now().toString(),
      sqlImg: getImage,
    );
    await controller.handler.insertFoodList(foodList);
    _showDialog();
  }

  // Date Format
  String _now() {
    final DateTime now = DateTime.now();
    return ('${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${_weekdayToString(now.weekday)} '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}');
	}

  _weekdayToString(weekday) {
    switch(weekday) {
      case 1 :
        return '월';
      case 2 :
        return '화';
      case 3 :
        return '수';
      case 4 :
        return '목';
      case 5 :
        return '금';
      case 6 :
        return '토';
      case 7 :
        return '일';
      default :
        return null;
    } 
  }
  // ---- Dialog ----
  _showDialog() {
    Get.defaultDialog(
      title: '알림',
      middleText: '입력이 완료 되었습니다.',
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
    
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Center(
        child: Column(
          children: [


            // 이미지 선택 & 이미지
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () => controller.getImageFromGallery(ImageSource.gallery), 
                child: const Text('이미지 가져오기'),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Center(
                
                child: controller.imageFile == null
                ? const Text('Image is not selected')
                : Image.file(File(controller.imageFile!.path)),
              ),
            ),
      
            // 위도 - 경도
            Row(
              children: [
                SizedBox(
                  width: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      controller: latController,
                      decoration: const InputDecoration(
                        labelText: '위도'
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      controller: lngController,
                      decoration: const InputDecoration(
                        labelText: '경도'
                      ),
                    ),
                  ),
                ),
              ],
            ),


            // 이름
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: '이름',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0
                    )
                  )
                ),
              ),
            ),
            // 전화번호
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: '전화번호',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0
                    )
                  )
                ),
              ),
            ),
            // 평가
            SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: rateController,
                  decoration: const InputDecoration(
                    labelText: '후기',
                    enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0
                    )
                  )
                  ),
                  // 크기 확장 선언 후 min, max lines 정해 주어야 함
                  expands: true, 
                  maxLines: null,
                  // max Length 정하기
                  maxLength: 50,
                ),
              ),
            ),

            // insert button
            ElevatedButton(
              onPressed: () => insertData(), 
              child: const Text('입력'),
            ),
          ],
        ),
      ),
    );
  }
}