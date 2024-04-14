
import 'package:classdiary2/mobile/consult.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// ignore_for_file: prefer_const_constructors

class ConsultController extends GetxController {
  static ConsultController get to => Get.find(); // Get.find<MainController>() 대신 MainController.to 사용가능

  String consultInput = '';
  String id = '';
  RxString whereToGo = 'Consult'.obs;

  @override
  void onInit() async {
    super.onInit();
  }

  void saveConsult() async{
    var now = DateTime.now().toString();
    // var now = DateTime.now().toString().substring(0,10);
    await FirebaseFirestore.instance.collection('consult')
        .add({ 'email': GetStorage().read('email'), 'date': now, 'content': consultInput })
        .catchError((error) { print(error); });
    consultInput = '';
  }

  void updConsult() async{
    await FirebaseFirestore.instance.collection('consult').doc(id)
        .update({ 'content': consultInput }).catchError((error) { print(error); });
    consultInput = '';
  }

  void delConsult() async {
    FirebaseFirestore.instance.collection('consult').doc(id).delete();
    consultInput = '';
  }

} // MainController