// import 'dart:html';
//
// import 'package:classdiary2/web/dashboard.dart';
// import 'package:classdiary2/web/signinup_view.dart';
// import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:qr_flutter/qr_flutter.dart';
//
// import 'controller/attendance_controller.dart';
// import 'controller/class_controller.dart';
// import 'controller/signinup_controller.dart';
// import 'mobile/absent.dart';
// import 'mobile/mobile_signinup_view.dart';
//
// class JobSelect extends StatelessWidget {
//   CustomPopupMenuController popupClassCodeController = CustomPopupMenuController();
//   CustomPopupMenuController popupSaveController = CustomPopupMenuController();
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       resizeToAvoidBottomInset: false,  /// 키보드 render 에러 방지1
//       appBar: AppBar(
//         centerTitle: false,
//         backgroundColor: Colors.black,
//         elevation: 0,
//         title: Text('학급다이어리', style: TextStyle(color: Colors.white),),
//       ),
//       body: Obx(
//             () => Center(
//           child: Container(
//             width: 350,
//             child: Container(
//               height: 600,
//               child: Column(
//                 children: [
//                   QrImageView(
//                     data: 'https://open.kakao.com/o/gyfRjOvf',
//                     // data: 'https://classdiary2.web.app/?paramClassCode=pointtA&destiny=pointB',
//                     version: QrVersions.auto,
//                     size: 200.0,
//                   ),
//
//                   SignInUpController.to.isDarkMode.value == true ?
//                   Image.asset("assets/images/logo_big_dark.png", width: 100,) :
//                   Image.asset("assets/images/logo_big_light.png", width: 100,),
//                   SizedBox(height: 50,),
//                   CustomPopupMenu(
//                     menuOnChange: (bool) {
//                       if (bool == false) {
//                         ClassController.to.isClassCode.value = false;
//                       }
//                     },
//                     controller: popupClassCodeController,
//                     arrowSize: 20,
//                     child: Container(
//                       width: 300, height: 50,
//                       decoration: BoxDecoration(color: Colors.teal.withOpacity(0.5), borderRadius: BorderRadius.circular(8)),
//                       child: Center(
//                         child: Padding(
//                           padding: const EdgeInsets.all(10),
//                           child: Text('학생입니다', style: TextStyle(fontFamily: 'Jua', fontSize: 20, color: Colors.white),),
//                         ),
//                       ),
//                     ),
//                     menuBuilder: () => ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: Obx(() => ClassController.to.isClassCode.value == true ?
//                       Container(
//                         width: 400,
//                         height: 700,
//                         color: Color(0xFF4C4C4C),
//                         child: Column(
//                             children: [
//                               SizedBox(height: 10,),
//                               Row(
//                                 children: [
//                                   Expanded(child: SizedBox()),
//                                   Padding(
//                                     padding: const EdgeInsets.only(right: 25, top: 20),
//                                     child:
//                                     ElevatedButton(
//                                       style: ElevatedButton.styleFrom(backgroundColor: Color(0xff83B4B5),),
//                                       onPressed: () {
//                                         if (ClassController.to.selectedName.value.length > 0) {
//                                           ClassController.to.entrance();
//                                         }
//
//                                       },
//                                       child: Text('입장',style: TextStyle(fontFamily: 'Jua', fontSize: 17, color: Colors.white),),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 10,),
//                               Text('이름을 선택하세요',style: TextStyle(fontFamily: 'Jua', fontSize: 17, color: Colors.white),),
//                               SizedBox(height: 10,),
//                               Container(
//                                 height: 600,
//                                 child: GridView.builder(
//                                   scrollDirection: Axis.vertical,
//                                   primary: false,
//                                   shrinkWrap: true,
//                                   padding: EdgeInsets.all(10),
//                                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                                     crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
//                                     childAspectRatio: 4 / 1, //item 의 가로, 세로 의 비율
//                                   ),
//                                   itemCount: ClassController.to.attendanceList.length,
//                                   itemBuilder: (context, index) {
//                                     return Container(
//                                       decoration: BoxDecoration(
//                                         border: Border(
//                                           bottom: (index + 1 == AttendanceController.to.attendanceCnt.value - 1 && (index + 1).isOdd)
//                                               || index + 1 == AttendanceController.to.attendanceCnt.value
//                                               ? BorderSide(width: 1, color: Colors.transparent,)
//                                               : BorderSide(width: 1, color: Colors.grey.withOpacity(0.5),),
//                                           right: index.isEven ? BorderSide(width: 1, color: Colors.grey.withOpacity(0.5),) : BorderSide(width: 1, color: Colors.transparent,),
//                                         ),
//                                       ),
//                                       child: InkWell(
//                                         onTap: () {
//                                           ClassController.to.selectedName.value = ClassController.to.attendanceList[index];
//                                         },
//                                         child: Obx(() => Container(
//                                           // width: 100,
//                                             child: ClassController.to.selectedName.value == ClassController.to.attendanceList[index] ?
//                                             Row(
//                                               children: [
//                                                 SizedBox(width: 15,),
//                                                 Container(
//                                                   width: 22,
//                                                   child:
//                                                   CircleAvatar(
//                                                     backgroundColor: Colors.orange,
//                                                     child: Center(
//                                                       child: Text((index+1).toString(), style: TextStyle(color: Colors.white, fontSize: 12,),),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 SizedBox(width: 10,),
//                                                 Text(ClassController.to.attendanceList[index], style: TextStyle(fontFamily: 'Jua', fontSize: 20, color: Colors.orange),),
//                                               ],
//                                             ) :
//                                             Row(
//                                               children: [
//                                                 SizedBox(width: 15,),
//                                                 Container(
//                                                   width: 20,
//                                                   child:
//                                                   CircleAvatar(
//                                                     backgroundColor: Colors.teal,
//                                                     child: Center(
//                                                       child: Text((index+1).toString(), style: TextStyle(color: Colors.white, fontSize: 12,),),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 SizedBox(width: 10,),
//                                                 Text(ClassController.to.attendanceList[index], style: TextStyle(fontFamily: 'Jua', fontSize: 17, color: Colors.white),),
//                                               ],
//                                             )
//                                         ),
//                                         ),
//                                       ),
//                                     );
//
//                                   },
//
//                                 ),
//                               )
//                             ]
//                         ),
//                       ) :
//                       Container(
//                         width: 300,
//                         height: 220,
//                         color: Color(0xFF4C4C4C),
//                         child: Column(
//                             children: [
//                               SizedBox(height: 10,),
//                               Row(
//                                 children: [
//                                   Expanded(child: SizedBox()),
//                                   Padding(
//                                     padding: const EdgeInsets.only(right: 25, top: 20),
//                                     child:
//                                     ElevatedButton(
//                                       style: ElevatedButton.styleFrom(backgroundColor: Color(0xff83B4B5),),
//                                       onPressed: () {
//                                         ClassController.to.retClassCode();
//                                       },
//                                       child: Text('저장',style: TextStyle(fontFamily: 'Jua', fontSize: 17, color: Colors.white),),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 20,),
//                               SizedBox(
//                                 width: 250, height: 100,
//                                 child: TextField(
//                                   // controller: titleInputController,
//                                   autofocus: true,
//                                   onChanged: (value) {
//                                     ClassController.to.classInput = value;
//                                   },
//                                   style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 60, ),
//                                   // minLines: 1,
//                                   maxLines: 1,
//                                   decoration: InputDecoration(
//                                     hintText: '반코드를 입력하세요',
//                                     hintStyle: TextStyle(fontSize: 25, color: Colors.grey.withOpacity(0.5)),
//                                     focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
//                                     enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
//
//                                   ),
//                                 ),
//                               ),
//                               Text(ClassController.to.noExitMessage.value , style: TextStyle(fontFamily: 'Jua', color: Colors.orange , fontSize: 17, )),
//                             ]
//                         ),
//                       ),
//                       ),
//                     ),
//                     pressType: PressType.singleClick,
//                     verticalMargin: -10,
//                   ),
//                   SizedBox(height: 40,),
//                   Container(
//                     width: 350,
//                     height: 50,
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         GetStorage().write('job', 'teacher');
//                         // Get.offAll(() => MobileSignInUpView());
//                         if (GetStorage().read('isMobile')) {
//                           Get.offAll(() => StreamBuilder(
//                               stream: FirebaseAuth.instance.authStateChanges(),
//                               builder: (context, snapshot) {
//                                 if(snapshot.hasData) {
//                                   if (GetStorage().read('email') == null) {
//                                     FirebaseAuth.instance.signOut();
//                                     return MobileSignInUpView();
//                                   }else {
//                                     return Absent();
//                                   }
//
//                                 }else {
//                                   return MobileSignInUpView();
//                                 }
//                               }
//                           )
//                           );
//                         }else {
//                           Get.offAll(() => StreamBuilder(
//                               stream: FirebaseAuth.instance.authStateChanges(),
//                               builder: (context, snapshot) {
//                                 if(snapshot.hasData) {
//                                   return Dashboard();
//                                 }
//                                 return SignInUpView();
//                               }
//                           )
//                           );
//                         }
//
//                       }, // onPressed
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.orange.withOpacity(0.7),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                       ),
//                       child: Text('선생님입니다', style: TextStyle(fontFamily: 'Jua', fontSize: 20, color: Colors.white),),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
// }
//
//
//
//
