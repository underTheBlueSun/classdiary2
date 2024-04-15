import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/coupon_controller.dart';
import '../controller/diary_controller.dart';
import '../controller/signinup_controller.dart';
import '../web/dashboard.dart';

class CouponTopMenu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// 홈
          TextButton(
            style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.grey.withOpacity(0.5))),
            onPressed: () {
              Get.off(() => Dashboard());
            },
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Icon(Icons.house_siding, size: 35, color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),
                  SizedBox(height: 10,),
                  Text('학급다이어리', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontFamily: 'Jua', fontSize: 13),)
                ],
              ),
            ),
          ),
          SizedBox(width: 50,),
          /// 쿠폰 구매자
          TextButton(
            style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.grey.withOpacity(0.5))),
            onPressed: () {
              CouponController.to.active_screen.value = 'coupon';
            },
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Icon(Icons.sell_outlined, size: 35, color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),
                  SizedBox(height: 10,),
                  Text('쿠폰구매자', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontFamily: 'Jua', fontSize: 13),)
                ],
              ),
            ),
          ),
          SizedBox(width: 50,),
          /// 쿠폰등록
          TextButton(
            style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.grey.withOpacity(0.5))),
            onPressed: () {
              CouponController.to.active_screen.value = 'coupon_add';
            },
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Icon(Icons.airplane_ticket_outlined, size: 35, color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),
                  SizedBox(height: 10,),
                  Text('쿠폰등록', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontFamily: 'Jua', fontSize: 13),)
                ],
              ),
            ),
          ),

        ]);

  }
}


