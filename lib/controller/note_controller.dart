
import 'package:classdiary2/mobile/note.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// ignore_for_file: prefer_const_constructors

class NoteController extends GetxController {
  static NoteController get to => Get.find(); // Get.find<MainController>() 대신 MainController.to 사용가능

  String noteInput = '';
  String id = '';
  RxString whereToGo = 'Note'.obs;

  @override
  void onInit() async {
    super.onInit();
  }

  void saveNote() async{
    // var now = DateTime.now().toString().substring(0,10);
    var now = DateTime.now().toString();
    await FirebaseFirestore.instance.collection('note')
        .add({ 'email': GetStorage().read('email'), 'date': now, 'content': noteInput })
        .catchError((error) { print(error); });
  }

  void updNote() async{
    await FirebaseFirestore.instance.collection('note').doc(id)
        .update({ 'content': noteInput }).catchError((error) { print(error); });
  }

  void delNote() async {
    FirebaseFirestore.instance.collection('note').doc(id).delete();
  }

} // MainController