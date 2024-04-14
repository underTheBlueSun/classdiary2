import 'package:classdiary2/coupon/coupon_add.dart';
import 'package:classdiary2/point/point.dart';
import 'package:classdiary2/point/point_top_menu.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/coupon_controller.dart';
import '../controller/point_controller.dart';
import '../controller/signinup_controller.dart';

class PointMain extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// top menu
            Container(
              // color: Colors.grey.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top:15, bottom: 15),
                child: PointTopMenu(),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 화면전환
                Padding(
                  padding: const EdgeInsets.only(left:20, right: 30, top:10, bottom: 20),
                  child: PointController.to.active_screen.value == 'point' ? Point() : SizedBox(),
                ),
              ],
            ),

          ],
        ),
      ),
    ),
    );

  }
}


