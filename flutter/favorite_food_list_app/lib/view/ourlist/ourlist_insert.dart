import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

/*
    Date: 2024-04-09
    Author : Woody Jo
    Description : Favorite Food Ourlist View insert Page with MySQL
                  and insert image by MultipartRequest
*/


class OurListInsert extends StatefulWidget {
  const OurListInsert({super.key});

  @override
  State<OurListInsert> createState() => _OurListInsertState();
}

class _OurListInsertState extends State<OurListInsert> {
  
  // Property
  late String inputDate;

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController latController;
  late TextEditingController lngController;
  late TextEditingController rateController;
  late Random rand;
  late String imgName;

  XFile? imageFile;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    latController = TextEditingController();
    lngController = TextEditingController();
    rateController = TextEditingController();
    rand = Random();
  }

  // 이미지 선택
  getImageFromGallery(imageSource) async{
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile == null) {
      imageFile = null;
    } {
      imageFile = XFile(pickedFile!.path);
      setState(() {});
    }
  }

  // image save on server
  imageInsert() async {
    dio.Dio dioImg = dio.Dio();
    // imgFile name
    File imgFile = File(imageFile!.path);

    // image 이름 만들기
    imgName = nameController.text + rand.nextInt(10000).toString() + ".jpg";

    // image update 준비, fromMap({db컬럼명:     fromFile(이미지 파일, 이미지 파일명)}) 
    final data = dio.FormData.fromMap({
      'img': await dio.MultipartFile.fromFile(imgFile.path, filename: imgName),
    });

    // post = server에 [post]하는 것
    dio.Response response = await dioImg.post('http://localhost:8080/Flutter/JSP/image.jsp', data: data);

    // Json Decode
    final responseData = jsonDecode(response.data);
    // {}의 result만 가져오기
    final result = responseData['result'];

    print(result);    
    
    if (result == "OK") {
      print("image upload succeed...");
    }else {
      print("image upload failed...");
    }
  }

  Future<void> insertData() async{
    // image Path 만들기
    String imgPath = "http://localhost:8080/images/$imgName";

    var url = Uri.parse('http://localhost:8080/Flutter/JSP/favoritefoodlistInsert.jsp?name=${nameController.text}&phone=${phoneController.text}&lat=${latController.text}&lng=${lngController.text}&imgName=$imgName&rate=${rateController.text}&inputDate=${_now()}&imgPath=$imgPath');
    var response = await http.get(url);

    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];

    if (result == 'OK') {
      _showDialog();
      print("insert data succeed...");
    }else {
      print("insert data failed...");
    }
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
                  onPressed: () async{
                    await imageInsert();
                    await insertData();
                  }, 
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