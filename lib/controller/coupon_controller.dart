import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class CouponController extends GetxController {
  static CouponController get to => Get.find();

  List coupon_icons = ['coupon_1role','coupon_bitamine','coupon_boardgame','coupon_candy','coupon_comic','coupon_cookie','coupon_dice','coupon_freetime','coupon_friend',
    'coupon_homework','coupon_location', 'coupon_meal','coupon_movie','coupon_music','coupon_note','coupon_phone','coupon_random','coupon_sports'];

  String id = '';
  RxString icon = ''.obs;
  String title = '';
  int point = 0;
  RxString active_screen = 'coupon'.obs;

  @override
  void onInit() async {

  }

  void addCoupon() async{
    await FirebaseFirestore.instance.collection('coupon').add({'class_code': GetStorage().read('class_code'), 'date': DateTime.now().toString(),
      'icon': icon.value, 'title': title, 'point': point});

  }

  void delCoupon() async{
    await FirebaseFirestore.instance.collection('coupon').doc(id).delete();
  }

  void updCoupon() async{
    await FirebaseFirestore.instance.collection('coupon').doc(id).update({'icon': icon.value,'title': title, 'point': point});
  }

  void buyCoupon() async{
    await FirebaseFirestore.instance.collection('coupon_buy').add({'class_code': GetStorage().read('class_code'), 'date': DateTime.now().toString(),
      'number': GetStorage().read('number'),'name': GetStorage().read('name'),'icon': icon.value, 'title': title, 'point': point, });

    /// 포인트 점수 차감
    delPoint();

  }

  void delPoint() async{
    await FirebaseFirestore.instance.collection('point').where('class_code', isEqualTo: GetStorage().read('class_code'))
        .where('number', isEqualTo: GetStorage().read('number')).get().then((QuerySnapshot snapshot) {
      if (snapshot.docs.length > 0) {
        if (snapshot.docs.first['point'] > 0) {
          FirebaseFirestore.instance.collection('point').doc(snapshot.docs.first.id).update({'point': FieldValue.increment(-point)});
        }
      }
    });
  }



}






