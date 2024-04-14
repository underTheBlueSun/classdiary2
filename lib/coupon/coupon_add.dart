import 'package:carousel_slider/carousel_slider.dart';
import 'package:classdiary2/controller/dashboard_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../common/sliverGridDelegateWithFixedCrossAxisCountAndFixedHeight.dart';
import '../controller/board_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import '../controller/coupon_controller.dart';
import '../controller/diary_controller.dart';
import '../controller/signinup_controller.dart';

class CouponAdd extends StatelessWidget {

  void addDialog(context) {
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
            width: 200,
            height: 550,
            child: Material(
              color: Colors.transparent,
              child: Column(
                  children: [
                    TextField(
                      autofocus: true,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        CouponController.to.title = value;
                      },
                      style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontFamily: 'Jua' , fontSize: 20, ),
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: '제목을 입력하세요',
                        hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5), ),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey ),),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey ),),
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

                      ),
                    ),
                    SizedBox(height: 20,),
                    TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        CouponController.to.point = int.parse(value);
                      },
                      style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontFamily: 'Jua' , fontSize: 20, ),
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: '점수를 입력하세요',
                        hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5), ),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey ),),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey ),),
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

                      ),
                    ),
                    SingleChildScrollView(
                      child: GridView.builder(
                        primary: false,
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(20),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1/1, //item 의 가로, 세로 의 비율
                        ),
                        itemCount: CouponController.to.coupon_icons.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              CouponController.to.icon.value = CouponController.to.coupon_icons[index];
                            },
                            child: Obx(() => Container(
                              color: CouponController.to.icon.value == CouponController.to.coupon_icons[index] ? Colors.white : Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Image.asset('assets/images/coupon/${CouponController.to.coupon_icons[index]}.png', height: 70,),
                              ),
                            ),
                            ),
                          );

                        },

                      ),
                    ),

                  ]
              ),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(isDefaultAction: true, child: Text('닫기'), onPressed: () {
              Navigator.pop(context);
            }),
            CupertinoDialogAction(isDefaultAction: true, child: Text('저장'), onPressed: () {
              if (CouponController.to.title.length > 0 && CouponController.to.point > 0 && CouponController.to.icon.value.length > 0) {
                CouponController.to.addCoupon();
                Navigator.pop(context);
              }else{
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(duration: Duration(milliseconds: 1000),
                    content: Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('제목, 점수, 아이콘을 입력해 주세요', style: TextStyle(color: Colors.orangeAccent, fontFamily: 'Jua', fontSize: 18),),],),),
                );
              }
            })

          ],
        );
      },
    );

  }

  void updDialog(context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Container(
            height: 550,
            child: Material(
              color: Colors.transparent,
              child: SingleChildScrollView(
                child: Column(
                    children: [
                      TextField(
                        controller: TextEditingController(text: CouponController.to.title),
                        autofocus: true,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          CouponController.to.title = value;
                        },
                        style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontFamily: 'Jua' , fontSize: 20, ),
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: '제목을 입력하세요',
                          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5), ),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey ),),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey ),),
                          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

                        ),
                      ),
                      SizedBox(height: 20,),
                      TextField(
                        controller: TextEditingController(text: CouponController.to.point.toString()),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          CouponController.to.point = int.parse(value);
                        },
                        style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontFamily: 'Jua' , fontSize: 20, ),
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: '점수를 입력하세요',
                          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5), ),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey ),),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey ),),
                          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

                        ),
                      ),
                      GridView.builder(
                        primary: false,
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(30),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1/1, //item 의 가로, 세로 의 비율
                        ),
                        itemCount: CouponController.to.coupon_icons.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              CouponController.to.icon.value = CouponController.to.coupon_icons[index];
                            },
                            child: Obx(() => Container(
                              color: CouponController.to.icon.value == CouponController.to.coupon_icons[index] ? Colors.white : Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Image.asset('assets/images/coupon/${CouponController.to.coupon_icons[index]}.png', height: 70,),
                              ),
                            ),
                            ),
                          );

                        },

                      ),
                      /// 삭제버튼
                      Container(
                        width: 80, height: 30,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, ),
                          onPressed: () async{
                            CouponController.to.delCoupon();
                            Navigator.pop(context);
                          },
                          child: Text('삭제', style: TextStyle(color: Colors.white),),
                        ),
                      ),

                    ]
                ),
              ),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(isDefaultAction: true, child: Text('닫기'), onPressed: () {
              Navigator.pop(context);
            }),
            CupertinoDialogAction(isDefaultAction: true, child: Text('저장'), onPressed: () {
              if (CouponController.to.title.length > 0 && CouponController.to.point > 0 && CouponController.to.icon.value.length > 0) {
                CouponController.to.updCoupon();
                Navigator.pop(context);
              }else{
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(duration: Duration(milliseconds: 1000),
                    content: Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('제목, 점수, 아이콘을 입력해 주세요', style: TextStyle(color: Colors.orangeAccent, fontFamily: 'Jua', fontSize: 18),),],),),
                );
              }
            })

          ],
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          InkWell(
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              addDialog(context);
            },
            child: Icon(Icons.add_circle_outline, size: MediaQuery.sizeOf(context).width > 600 ? 100 : 50, color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black,),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('coupon').where('class_code', isEqualTo: GetStorage().read('class_code')).snapshots(),
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

                if (snapshot.data!.docs.length > 0) {
                  var sort_docs = snapshot.data!.docs;
                  sort_docs.sort((a, b) => b['date'].compareTo(a['date']));

                  return GridView.builder(
                    primary: false,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      /// 그램 1707 * 910/ 왼컴 2048*1030/ 오컴 1920*957, 아이맥 2048, 한성 1920
                      /// 아이패드 가로/세로 = 1180/820, 아이패드프로 가로/세로 = 1366/1024
                      crossAxisCount: MediaQuery.of(context).size.width >= 1920 ? 6 : MediaQuery.of(context).size.width >= 1700 ? 5 : 3,
                      childAspectRatio: 2.5/1, //item 의 가로, 세로 의 비율
                    ),
                    itemCount: sort_docs.length,
                    itemBuilder: (context, index) {
                      var doc = sort_docs[index];
                      // var doc = snapshot.data!.docs[index];
                      return InkWell(
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          CouponController.to.id = doc.id;
                          CouponController.to.title = doc['title'];
                          CouponController.to.icon.value = doc['icon'];
                          CouponController.to.point = doc['point'];
                          updDialog(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 100,
                            decoration: BoxDecoration(color: Color(0xFF76B8C3), borderRadius: BorderRadius.all(Radius.circular(15)),),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      /// 왼쪽 반원
                                      Container(
                                        width: 10, height: 25,
                                        decoration: BoxDecoration(color: SignInUpController.to.isDarkMode.value == true ?  Color(0xFF303030) : Colors.white,
                                          borderRadius: BorderRadius.only(topRight: Radius.circular(100), bottomRight: Radius.circular(100),),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Image.asset('assets/images/coupon/${doc['icon']}.png', width: 35, height: 35,),
                                            SizedBox(width: 15,),
                                            SizedBox(
                                              width: 100,
                                              child: Text(doc['title'], maxLines:2, overflow: TextOverflow.ellipsis,
                                                style: TextStyle(color: Colors.black.withOpacity(0.5), fontFamily: 'Jua', fontSize: 17),),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 100,
                                  // width: MediaQuery.of(context).size.width * 0.3,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      /// 세로 점선
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: CustomPaint(
                                            size: Size(3, double.infinity),
                                            painter: DashedLineVerticalPainter()
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.star, color: Color(0xFFE490A0),),
                                          Text(doc['point'].toString(), style: TextStyle(color: Colors.black.withOpacity(0.3), fontWeight: FontWeight.bold, fontSize: 35, fontFamily: 'Jua'),),
                                        ],
                                      ),
                                      /// 오른쪽 반원
                                      Container(
                                        width: 10, height: 25,
                                        decoration: BoxDecoration(color: SignInUpController.to.isDarkMode.value == true ?  Color(0xFF303030) : Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(100), bottomLeft: Radius.circular(100),),),
                                      ),
                                    ],
                                  ),
                                ),

                              ],),
                          ),
                        ),
                      );

                    },

                  );
                }else{
                  return SizedBox();
                }

              }
          ),
        ],
      ),
    );

  }
}

class DashedLineVerticalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5, dashSpace = 5, startY = 0;
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      // ..color = Color(0xFF76B8C3)
      ..strokeWidth = size.width;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}


