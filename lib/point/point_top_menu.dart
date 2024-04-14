import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/coupon_controller.dart';
import '../controller/diary_controller.dart';
import '../controller/point_controller.dart';
import '../controller/signinup_controller.dart';
import '../web/dashboard.dart';

class PointTopMenu extends StatelessWidget {

  CustomPopupMenuController all_point_popUpController = CustomPopupMenuController();

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
          SizedBox(width: 30,),
          /// 전체점수주기
          TextButton(
            style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.grey.withOpacity(0.5))),
            onPressed: () {
            },
            child: CustomPopupMenu(
              arrowColor: Colors.white,
              controller: all_point_popUpController,
              arrowSize: 20,
              menuOnChange: (bool) {
                PointController.to.point_input.value = '';
              },
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Icon(Icons.exposure_rounded, size: 35, color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),
                    SizedBox(height: 10,),
                    Text('전체 점수 주기', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black, fontFamily: 'Jua', fontSize: 13),)
                  ],
                ),
              ),
              menuBuilder: () => ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SingleChildScrollView(
                  child: Container(
                    width: 350,
                    height: 450,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              /// 1,2,3,4점
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  for (int i = 1; i < 5; i++)
                                    InkWell(
                                      highlightColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        PointController.to.point_input.value = i.toString();
                                      },
                                      child: Container(
                                        width: 65,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                                          child: Text('${i}점', style: TextStyle(color: Colors.white, fontSize: 18),),
                                        ),
                                      ),
                                    ),

                                ],
                              ),
                              SizedBox(height: 20,),
                              /// 5,10,15,20점
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  for (int i = 5; i < 25; i=i+5)
                                    InkWell(
                                      highlightColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        PointController.to.point_input.value = i.toString();
                                      },
                                      child: Container(
                                        width: 65,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                                          child: Text('${i}점', style: TextStyle(color: Colors.white, fontSize: 18),),
                                        ),
                                      ),
                                    ),

                                ],
                              ),
                              SizedBox(height: 20,),
                              /// 25,30,35,40점
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  for (int i = 25; i < 45; i=i+5)
                                    InkWell(
                                      highlightColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        PointController.to.point_input.value = i.toString();
                                      },
                                      child: Container(
                                        width: 65,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                                          child: Text('${i}점', style: TextStyle(color: Colors.white, fontSize: 18),),
                                        ),
                                      ),
                                    ),

                                ],
                              ),
                            ],
                          ),
                        ),

                        Obx(() =>
                            Text(PointController.to.point_input.value, style: TextStyle(fontFamily: 'Jua', fontSize: 25, color: Colors.orange),)
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 150,
                            height: 60,
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                // controller: textfield_controller,
                                // controller: TextEditingController(text: PointController.to.point_input.value.toString()),
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                cursorColor: Colors.black,
                                autofocus: true,
                                textAlignVertical: TextAlignVertical.center,
                                onChanged: (value) {
                                  PointController.to.point_input.value = value;
                                },
                                style: TextStyle(color: Colors.black , fontSize: 25, ),
                                // style: TextStyle(color: Colors.white , fontSize: 16, ),
                                maxLines: 1,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: '직접 점수 입력',
                                  hintStyle: TextStyle(fontSize: 18, color: Colors.grey.withOpacity(0.5)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey,  ),),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey,  ),),
                                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),

                                ),
                              ),
                            ),
                          ),
                        ),
                        /// 차감, 추가 버튼
                        Row(
                          children: [
                            InkWell(
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                PointController.to.delAllPoint();
                                all_point_popUpController.hideMenu();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 350/2,
                                height: 65,
                                color: Colors.redAccent.withOpacity(0.8),
                                child: Text('차감', style: TextStyle(fontFamily: 'Jua', fontSize: 30, color: Colors.white),),
                              ),
                            ),
                            InkWell(
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                PointController.to.addAllPoint();
                                all_point_popUpController.hideMenu();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 350/2,
                                height: 65,
                                color: Colors.blueAccent.withOpacity(0.8),
                                child: Text('추가', style: TextStyle(fontFamily: 'Jua', fontSize: 30, color: Colors.white),),
                              ),
                            ),
                          ],),

                        // child: Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       InkWell(
                        //         highlightColor: Colors.transparent,
                        //         hoverColor: Colors.transparent,
                        //         splashColor: Colors.transparent,
                        //         onTap: () {
                        //           // PointController.to.point_input.value = i;
                        //         },
                        //         child: Padding(
                        //           padding: const EdgeInsets.all(8.0),
                        //           child: Container(
                        //             width: 60,
                        //             alignment: Alignment.center,
                        //             decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(10)),
                        //             child: Padding(
                        //               padding: const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                        //               child: Text('차감', style: TextStyle(color: Colors.white, fontSize: 18),),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //         InkWell(
                        //           highlightColor: Colors.transparent,
                        //           hoverColor: Colors.transparent,
                        //           splashColor: Colors.transparent,
                        //           onTap: () {
                        //             // PointController.to.point_input.value = i;
                        //           },
                        //           child: Padding(
                        //             padding: const EdgeInsets.all(8.0),
                        //             child: Container(
                        //               width: 60,
                        //               alignment: Alignment.center,
                        //               decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(10)),
                        //               child: Padding(
                        //                 padding: const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                        //                 child: Text('추가', style: TextStyle(color: Colors.white, fontSize: 18),),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //
                        //     ],
                        //   ),
                        // ),
                      ],),
                  ),
                ),
              ),
              pressType: PressType.singleClick,
              verticalMargin: -10,

            ),
          ),

        ]);

  }
}


