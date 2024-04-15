import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../controller/coupon_controller.dart';
import '../controller/dashboard_controller.dart';
import '../controller/signinup_controller.dart';
import '../controller/temper_controller.dart';
import '../web/dashboard.dart';

class TemperatureTopMenu extends StatelessWidget {

  void pointDialog(context) {
    CouponController.to.icon = ''.obs;
    CouponController.to.title = '';
    CouponController.to.point = 0;

    showCupertinoDialog(
      context: context,
      // barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          // backgroundColor: Color(0xFFDBB671),
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Container(
            width: 120, height: 100,
            child: Material(
              color: Colors.transparent,
              child: Column(
                children: [
                  SizedBox(
                    width: 200,
                    height: 60,
                    child: TextField(
                      controller: TextEditingController(text: TemperController.to.point_by_sticker.toString()),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      cursorColor: Colors.black,
                      autofocus: true,
                      textAlignVertical: TextAlignVertical.center,
                      onChanged: (value) {
                        TemperController.to.point_by_sticker = int.parse(value);
                      },
                      onSubmitted: (value) {
                        TemperController.to.updatePoint();
                        Navigator.pop(context);
                      },
                      style: TextStyle(fontFamily: 'Jua', color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontSize: 20, ),
                      minLines: 1,
                      decoration: InputDecoration(
                        hintText: '스티커당 별포인트 입력',
                        hintStyle: TextStyle(fontSize: 19, color: Colors.grey.withOpacity(0.5)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey ),),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey, ),),
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(isDefaultAction: true, child: Text('닫기'), onPressed: () {
              Navigator.pop(context);
            }),
            CupertinoDialogAction(isDefaultAction: true, child: Text('저장'), onPressed: () {
              TemperController.to.updatePoint();
              Navigator.pop(context);
            })

          ],
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
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
      SizedBox(width: 30,),
      /// 학급온도계
      TextButton(
        style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.grey.withOpacity(0.5))),
        onPressed: () {
          TemperController.to.active_screen.value = 'temperature';
        },
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Icon(Icons.device_thermostat, size: 35, color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),
              SizedBox(height: 10,),
              Text('학급온도계', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontFamily: 'Jua', fontSize: 13),)
            ],
          ),
        ),
      ),
      SizedBox(width: 30,),
      /// 추가
      TextButton(
        style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.grey.withOpacity(0.5))),
        onPressed: () {
          TemperController.to.addPoint();
        },
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Icon(Icons.add, size: 35, color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),
              SizedBox(height: 10,),
              Text('스티커추가', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontFamily: 'Jua', fontSize: 13),)
            ],
          ),
        ),
      ),

      SizedBox(width: 30,),
      /// 삭제
      TextButton(
        style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.grey.withOpacity(0.5))),
        onPressed: () {
          TemperController.to.removePoint();
        },
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Icon(Icons.remove, size: 35, color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),
              SizedBox(height: 10,),
              Text('스티커삭제', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontFamily: 'Jua', fontSize: 13),)
            ],
          ),
        ),
      ),
      SizedBox(width: 30,),

      /// 보상편집
      TextButton(
        style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.grey.withOpacity(0.5))),
        onPressed: () {
          TemperController.to.active_screen.value = 'temperature_edit';
        },
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Icon(Icons.edit, size: 35, color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),
              SizedBox(height: 10,),
              Text('보상편집', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontFamily: 'Jua', fontSize: 13),)
            ],
          ),
        ),
      ),
      SizedBox(width: 30,),
      /// 스티커당 포인트점수
      TextButton(
        style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.grey.withOpacity(0.5))),
        onPressed: () {
          pointDialog(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              // Icon(Icons.star, size: 35, color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('temper_pointbysticker').where('class_code', isEqualTo: GetStorage().read('class_code')).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: Container(
                        height: 40,
                        child: LoadingIndicator(
                            indicatorType: Indicator.ballPulse,
                            colors: DashboardController.to.kDefaultRainbowColors,
                            strokeWidth: 2,
                            backgroundColor: Colors.transparent,
                            pathBackgroundColor: Colors.transparent
                        ),
                      ),);
                    }
                    TemperController.to.point_by_sticker = 0;
                    if (snapshot.data!.docs.length > 0) {
                      TemperController.to.point_by_sticker = snapshot.data!.docs.first['pointbysticker'];
                    }
                    return Text(TemperController.to.point_by_sticker.toString(), style: TextStyle(color: Colors.orange, fontFamily: 'Jua', fontSize: 25));
                  }
              ),
              SizedBox(height: 10,),
              Text('스티커당 별포인트', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontFamily: 'Jua', fontSize: 13),)
            ],
          ),
        ),
      ),


    ]);

  }
}


