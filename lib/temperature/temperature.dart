import 'package:bubble/bubble.dart';
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
import '../controller/signinup_controller.dart';
import '../controller/temper_controller.dart';


class Temperature extends StatelessWidget {

  void awardDialog(context, award_number, award_title) {
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
            width: 120, height: 150,
            child: Material(
              color: Colors.transparent,
              child: Column(
                children: [
                  SizedBox(
                    width: 200,
                    height: 100,
                    child: TextField(
                      // maxLength: 7,
                      controller: TextEditingController(text: award_title),
                      textAlignVertical: TextAlignVertical.center,
                      // textAlign: TextAlign.center,
                      onChanged: (value) {
                        TemperController.to.award_title = value;
                      },
                      style: TextStyle(fontFamily: 'Jua', color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontSize: 20, ),
                      // minLines: 1,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: '내용을 입력하세요',
                        hintStyle: TextStyle(fontSize: 19, color: Colors.grey.withOpacity(0.5)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent, ),),
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
              TemperController.to.award_title = '';
              Navigator.pop(context);
            }),

          ],
        );
      },
    );

  }


  @override
  Widget build(BuildContext context) {

    return Obx(() => Column(
        children: [
          Text(TemperController.to.dummy_date.value, style: TextStyle(fontSize: 0),),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('temper_point').where('class_code', isEqualTo: GetStorage().read('class_code')).snapshots(),
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
                // snapshot2.data!.docs = snapshot.data!.docs.toList();
                return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('temper_award').where('class_code', isEqualTo: GetStorage().read('class_code')).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
                      if (!snapshot2.hasData) {
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
                      List award_list = [];

                      for (int i = 0; i < 16; i++) {
                        award_list.add('');
                      }

                      snapshot2.data!.docs.forEach((doc) {
                        award_list[doc['award_number']] = doc['award_title'];
                      });

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// 왼쪽 보상
                          Container(
                            alignment: Alignment.center,
                            // color: Colors.blue,
                            width: 200,
                            height: MediaQuery.of(context).size.height*0.65,
                            child: GridView.builder(
                              reverse: true,
                              // physics: NeverScrollableScrollPhysics(),
                              primary: false,
                              shrinkWrap: true,
                              // padding: EdgeInsets.all(15),
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                                crossAxisCount: 1,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 3,
                                height: 35,  /// 높이 지정
                              ),
                              itemCount: 16,
                              itemBuilder: (context, index) {
                                return
                                  index % 2 == 0 && award_list[index].length > 0 ?
                                  InkWell(
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      awardDialog(context, index, award_list[index]);
                                    },
                                    child: Bubble(
                                      // margin: BubbleEdges.only(bottom: 24),
                                      nip: BubbleNip.rightCenter,
                                      color: Colors.teal,
                                      child: Text(award_list[index], overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontFamily: 'Jua',),),
                                    ),
                                  ) : SizedBox();
                              },
                            ),
                          ),
                          /// 온도계와 구슬들
                          Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Image.asset('assets/images/temper.png', height: MediaQuery.of(context).size.height*0.85,),
                              Container(
                                alignment: Alignment.center,
                                width: 150,
                                height: MediaQuery.of(context).size.height*0.65,
                                child: GridView.builder(
                                  primary: false,
                                  shrinkWrap: true,
                                  gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                                    crossAxisCount: 5,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 3,
                                    height: 35,  /// 높이 지정
                                  ),
                                  itemCount: 80,
                                  itemBuilder: (context, index) {
                                    if (snapshot.data!.docs.length > 0) {
                                      var accumulate_point_by_index = (81-(index+1))*TemperController.to.point_by_sticker;
                                      var point = snapshot.data!.docs.first['point'];
                                      if (accumulate_point_by_index <= point) {
                                        return Container(decoration: BoxDecoration(color: Colors.redAccent, border: Border.all(color: Colors.redAccent), shape: BoxShape.circle,),);
                                      }else {
                                        if ((accumulate_point_by_index - point) < TemperController.to.point_by_sticker ) {
                                          int aaa = accumulate_point_by_index - point as int;
                                          int bbb = TemperController.to.point_by_sticker - aaa as int;
                                          return Container(decoration: BoxDecoration(color: Colors.redAccent.withOpacity(bbb / TemperController.to.point_by_sticker), border: Border.all(color: Colors.redAccent), shape: BoxShape.circle,),);
                                        }else {
                                          return Container(decoration: BoxDecoration(border: Border.all(color: Colors.redAccent), shape: BoxShape.circle,),);
                                        }


                                      }
                                    }else {
                                      return Container(decoration: BoxDecoration(border: Border.all(color: Colors.redAccent), shape: BoxShape.circle,),);
                                      // return CircleAvatar(radius: 200, backgroundColor: Colors.redAccent.withOpacity(0.1),);
                                    }
                                  },
                                ),
                              ),
                            ],),
                          /// 오른쪽 보상
                          Container(
                            alignment: Alignment.center,
                            // color: Colors.blue,
                            width: 200,
                            height: MediaQuery.of(context).size.height*0.65,
                            child: GridView.builder(
                              reverse: true,
                              // physics: NeverScrollableScrollPhysics(),
                              primary: false,
                              shrinkWrap: true,
                              // padding: EdgeInsets.all(15),
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                                crossAxisCount: 1,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 3,
                                height: 35,  /// 높이 지정
                              ),
                              itemCount: 16,
                              itemBuilder: (context, index) {
                                return
                                  index % 2 == 1 && award_list[index].length > 0 ?
                                  InkWell(
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      awardDialog(context, index, award_list[index]);
                                    },

                                    child: Bubble(
                                      // margin: BubbleEdges.only(bottom: 24),
                                      nip: BubbleNip.leftCenter,
                                      color: Colors.teal,
                                      child: Text(award_list[index], overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontFamily: 'Jua',),),
                                    ),
                                  ) : SizedBox();
                              },
                            ),
                          ),
                        ],

                      );
                    }
                );
              }
          ),
        ],
      ),
    );

  }
}


