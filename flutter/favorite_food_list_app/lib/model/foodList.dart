import 'package:flutter/foundation.dart';

class FoodList{
  int? id; // sequence
  late String name; // 가게 이름
  late String phone; // 전화번호
  late String lat; // 위도 ㅡ
  late String lng; // 경도 ㅣ
  Uint8List? sqlImg; // SQLite img
  late String rate; // 평가
  late String inputDate; // 입력 일
  String? img;

  FoodList({
    this.id,
    required this.name,
    required this.phone,
    required this.lat,
    required this.lng,
    this.sqlImg,
    required this.rate,
    required this.inputDate,
    this.img,
  });

  FoodList.fromMap(Map<String, dynamic> res)
    : id = res['id'],
      name = res['name'],
      phone = res['phone'],
      lat = res['lat'],
      lng = res['lng'],
      sqlImg = res['sqlImg'],
      rate = res['rate'],
      inputDate = res['inputDate'],
      img = res['img'];
}