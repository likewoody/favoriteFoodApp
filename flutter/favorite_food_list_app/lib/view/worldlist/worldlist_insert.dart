import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

/*
    Date: 2024-04-07
    Author : Woody Jo
    Description : Favorite Food Worldlist View Insert Page with Firebase
*/

class WorldListInsert extends StatefulWidget {
  const WorldListInsert({super.key});

  @override
  State<WorldListInsert> createState() => _WorldListInsertState();
}

class _WorldListInsertState extends State<WorldListInsert> {
  // Property
  late String inputDate;

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController latController;
  late TextEditingController lngController;
  late TextEditingController rateController;

  XFile? imageFile;
  final ImagePicker picker = ImagePicker();
  // XFile type을 변경 해주기 위함
  File? imgFile;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    latController = TextEditingController();
    lngController = TextEditingController();
    rateController = TextEditingController();

    inputDate = '';
  }


  // ---- Functions ----

  // 이미지 선택
  getImageFromGallery(imageSource) async{
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile == null) {
      imageFile = null;
    } {
      imageFile = XFile(pickedFile!.path);
      imgFile = File(imageFile!.path);
      setState(() {});
    }
  }

  insertData() async{
    String image = await preparingImage();
    FirebaseFirestore.instance
      .collection('list')
      .add({
        'name':nameController.text,
        'phone':phoneController.text,
        'lat':latController.text,
        'lng':lngController.text,
        'img':image,
        'rate':rateController.text,
        'inputDate':_now(),
      });
    _showDialog();
  }

  Future<String> preparingImage() async{
    final firebaseStorage = FirebaseStorage.instance
      .ref()
      .child('images') // storage folder name
      .child("${nameController.text}.png"); // image 이름 생성
      
      // upload
      await firebaseStorage.putFile(imgFile!);

      // file path
      String downloadURL = await firebaseStorage.getDownloadURL();
      return downloadURL;

  }

  // ---- date format ----
  String _now() {
    final DateTime now = DateTime.now();
    inputDate =
      ('${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${_weekdayToString(now.weekday)} '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}');
    return inputDate;
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('추가하기'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              children: [


                // 이미지 선택 & 이미지
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () => getImageFromGallery(ImageSource.gallery), 
                    child: const Text('이미지 가져오기'),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: Center(
                    child: imageFile == null
                    ? const Text('Image is not selected')
                    : Image.file(File(imageFile!.path)),
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
        ),
      ),
    );
  }
}