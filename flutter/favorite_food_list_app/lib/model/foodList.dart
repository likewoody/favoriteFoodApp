import 'package:flutter/foundation.dart';

class FoodList{
  int? id; // sequence
  Uint8List? sqlImg; // SQLite img
  late String name; // 가게 이름
  late String phone; // 전화번호
  late String lat; // 위도 ㅡ
  late String lng; // 경도 ㅣ
  String? img; // 이미지
  late String rate; // 평가
  late String inputDate; // 입력 일

  FoodList({
    this.id,
    this.sqlImg,
    this.img,
    required this.name,
    required this.phone,
    required this.lat,
    required this.lng,
    required this.rate,
    required this.inputDate,
  });

  FoodList.fromMap(Map<String, dynamic> res)
    : id = res['id'],
      sqlImg = res['sqlImg'],
      name = res['name'],
      phone = res['phone'],
      lat = res['lat'],
      lng = res['lng'],
      img = res['img'],
      rate = res['rate'],
      inputDate = res['inputDate'];
}