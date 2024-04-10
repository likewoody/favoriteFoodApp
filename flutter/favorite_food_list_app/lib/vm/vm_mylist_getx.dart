import 'package:favorite_food_list_app/vm/db_handler.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class VMMylistGetX extends GetxController{

  // Property
  // MyList Home
  DataBaseHandler handler = DataBaseHandler();

  // MyList GPS
  String name = '';
  double lat = 0;
  double lng = 0;
  XFile? imageFile;
  final ImagePicker picker = ImagePicker();
  

  // ---- Functions ----
  // MyList Home
  rebuildData() {
    handler.queryFoodList();
    update();
  }

  // // MyList Insert
  // // image choose
  // getImageFromGallery(imageSource) async{
  //   final XFile? pickedFile = await picker.pickImage(source: imageSource);
  //   if (pickedFile == null) {
  //     imageFile = null;
  //   } {
  //     imageFile = XFile(pickedFile!.path);
  //   }
  //   update();
  // }
}