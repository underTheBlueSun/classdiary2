
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// ignore_for_file: prefer_const_constructors

class NoticeController extends GetxController {
  static NoticeController get to => Get.find(); // Get.find<MainController>() 대신 MainController.to 사용가능

  String noticeInput = '';
  String id = '';
  DocumentSnapshot? doc;
  RxString whereToGo = 'notice'.obs;
  RxInt noReadCnt = 0.obs;
  String image_url1 = '';
  String image_url2 = '';
  String image_url3 = '';
  String image_url4 = '';
  String image_url5 = '';


  @override
  void onInit() async {
    super.onInit();
  }


  // void saveNotice() async{
  //   // var now = DateTime.now().toString().substring(0,10);
  //   var now = DateTime.now().toString();
  //   await FirebaseFirestore.instance.collection('notice').add({ 'email': GetStorage().read('email'), 'date': now, 'content': noticeInput })
  //       .catchError((error) { print(error); });
  // }

  var cnt = 0;
  void saveNotice() async{
    var now = DateTime.now();
    await FirebaseFirestore.instance.collection('notice')
        .add({ 'email': GetStorage().read('email'), 'date': now, 'content': noticeInput , 'cnt': cnt,
      'image_url1': image_url1, 'image_url2': image_url2, 'image_url3': image_url3, 'image_url4': image_url4, 'image_url5': image_url5,})
        .catchError((error) { print(error); });
  }

  void addCnt() async{
    if (GetStorage().read('email') != 'umssam00@gmail.com') {
      await FirebaseFirestore.instance.collection('notice').doc(doc?.id)
          .update({ 'cnt': FieldValue.increment(1) });
    }

  }

  void updNotice() async{
    await FirebaseFirestore.instance.collection('notice').doc(doc?.id)
        .update({ 'content': noticeInput }).catchError((error) { print(error); });
  }

  void delNotice() async {
    FirebaseFirestore.instance.collection('notice').doc(doc?.id).delete();
  }

  Future getPopup() async {
    var docs = await FirebaseFirestore.instance.collection("notice").orderBy('date', descending: true).limit(1).get().then((QuerySnapshot snapshot) {
      doc = snapshot.docs.toList()[0];
    });
  }

  // void addRead() async{
  //   await FirebaseFirestore.instance.collection('notice').doc(id)
  //       .update({ 'email': FieldValue.arrayUnion([GetStorage().read('email')]), });
  // }

} // MainController