// import 'package:classdiary2/controller/class_controller.dart';
// import 'package:classdiary2/main.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:loading_indicator/loading_indicator.dart';
//
// import 'package:classdiary2/controller/attendance_controller.dart';
// import 'package:classdiary2/controller/board_controller.dart';
// import 'package:flutter/foundation.dart';
//
// import '../controller/quiz_controller.dart';
//
// class QuizNameEntrance extends StatelessWidget {
//   final String paramClassCode;
//   final String paramIsRealName;
//   final String paramQuizId;
//   QuizNameEntrance(this.paramClassCode, this.paramIsRealName, this.paramQuizId);
//
//   void checkMyNameDialog(context,id, attendance, paramClassCode) {
//     showDialog(
//       context: context,
//       barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Color(0xFF4C4C4C),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//           content: Container(
//             width: 120, height: 100,
//             child: Column(
//               children: [
//                 Text('나의 이름이', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 17),),
//                 Text(attendance['name'], style: TextStyle(color: Colors.teal, fontFamily: 'Jua', fontSize: 25),),
//                 Text('맞습니까?', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 17),),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(5),
//                 child: Text('아닙니다', style: TextStyle(color: Colors.white, fontSize: 17, fontFamily: 'Jua'),),
//               ),
//             ),
//             SizedBox(width: 30,),
//             TextButton(
//               style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
//               onPressed: () {
//                 ClassController.to.addVisit(id, attendance, paramClassCode);
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(5),
//                 child: Text('맞습니다', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 17),),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (paramIsRealName == 'yes') { /// 실명
//       return MediaQuery.of(context).size.width < 600 ?
//       Scaffold(
//         resizeToAvoidBottomInset: false,  /// 키보드 render 에러 방지
//         appBar: AppBar(
//           centerTitle: false,
//           backgroundColor: Colors.teal,
//           elevation: 0,
//           title: Center(child: Text('자신의 이름을 선택하세요', style: TextStyle(color: Colors.white, ),)),
//         ),
//         backgroundColor: Colors.white,
//         body: StreamBuilder<QuerySnapshot>(
//             stream: FirebaseFirestore.instance.collection('class_info').where('class_code', isEqualTo: paramClassCode).snapshots(),
//             builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//               if (!snapshot.hasData) {
//                 return Center(child: Container(
//                   height: 40,
//                   child: LoadingIndicator(
//                       indicatorType: Indicator.ballPulse,
//                       colors: BoardController.to.kDefaultRainbowColors,
//                       strokeWidth: 2,
//                       backgroundColor: Colors.transparent,
//                       pathBackgroundColor: Colors.transparent
//                   ),
//                 ),);
//               }
//
//               if (snapshot.data!.docs.isEmpty) {
//                 return Center(
//                   child: Container(
//                     width: 500, height: 250,
//                     decoration: BoxDecoration(
//                       color: Color(0xFF4C4C4C),
//                       borderRadius: BorderRadius.circular(15.0),
//                       border: Border.all(width: 3, color: Colors.grey.withOpacity(0.5),),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(height: 10,),
//                           Container(
//                               width: 500,
//                               child: Center(child: Text('출석부가 존재하지 않습니다', style: TextStyle(fontFamily: 'Jua', fontSize: 30, color: Colors.orangeAccent),))),
//                           SizedBox(height: 25,),
//                           Text('(추측1) 링크주소가 잘못되었다', style: TextStyle(fontFamily: 'Jua', fontSize: 25, color: Colors.white),),
//                           SizedBox(height: 15,),
//                           Text('(추측2) 선생님이 출석부를 아직 만들지 않으셨다', style: TextStyle(fontFamily: 'Jua', fontSize: 25, color: Colors.white),),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               }else{
//                 // List attendanceList = snapshot.data!.docs.first['attendance'];
//                 // attendanceList.sort((a, b) => a['number'].compareTo(b['number']));
//                 List attendanceList = AttendanceController.to.attendanceList;
//                 List visitList = snapshot.data!.docs.first['visit'];
//                 return
//                   SingleChildScrollView(
//                     child: GridView.builder(
//                       primary: false,
//                       shrinkWrap: true,
//                       // padding: const EdgeInsets.all(10),
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         childAspectRatio: 2/0.7, //item 의 가로, 세로 의 비율
//                       ),
//                       itemCount: attendanceList.length,
//                       itemBuilder: (context, index) {
//                         /// visitList.contains(attendanceList[index]), visitList.contains({'number': 2, 'name': '강현우'}) 이거 안됨
//                         return visitList.any((e) => mapEquals(e, attendanceList[index])) ?
//                         Padding(
//                           padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
//                           child: Container(
//                             width: 150, height: 50,
//                             child: Card(
//                               color: Colors.grey.withOpacity(0.3),
//                               // color: Colors.grey.withOpacity(0.6),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Container(
//                                     width: 22,
//                                     child:
//                                     CircleAvatar(
//                                       backgroundColor: Colors.grey,
//                                       child: Center(
//                                         child: Text(attendanceList[index]['number'].toString(), style: TextStyle(color: Colors.black.withOpacity(0.1), fontSize: 15, fontFamily: 'Jua',),),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(width: 10,),
//                                   Text(attendanceList[index]['name'], style: TextStyle(color: Colors.grey, fontFamily: 'Jua', fontSize: 25,),),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ) :
//                         InkWell(
//                           highlightColor: Colors.transparent,
//                           hoverColor: Colors.transparent,
//                           splashColor: Colors.transparent,
//                           onTap: () {
//                             checkMyNameDialog(context,snapshot.data!.docs.first.id, attendanceList[index], paramClassCode);
//                             // ClassController.to.addVisit(snapshot.data!.docs.first.id, attendanceList[index], paramClassCode);
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
//                             child: Container(
//                               width: 150, height: 50,
//                               child: Card(
//                                 color: Colors.orangeAccent,
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Container(
//                                       width: 22,
//                                       child:
//                                       CircleAvatar(
//                                         backgroundColor: Colors.white,
//                                         child: Center(
//                                           child: Text(attendanceList[index]['number'].toString(), style: TextStyle(color: Colors.grey, fontSize: 15, fontFamily: 'Jua',),),
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(width: 10,),
//                                     Text(attendanceList[index]['name'], style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 25,),),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//
//                       },
//
//                     ),
//                   );
//               }
//
//             }
//         ),
//
//       ) :
//       Scaffold(
//         resizeToAvoidBottomInset: false,  /// 키보드 render 에러 방지
//         appBar: AppBar(
//           centerTitle: false,
//           backgroundColor: Colors.black,
//           elevation: 0,
//           title: Center(child: Text('자신의 이름을 선택하세요', style: TextStyle(color: Colors.white),)),
//         ),
//         backgroundColor: Colors.white,
//         body: StreamBuilder<QuerySnapshot>(
//             stream: FirebaseFirestore.instance.collection('class_info').where('class_code', isEqualTo: paramClassCode).snapshots(),
//             builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//               if (!snapshot.hasData) {
//                 return Center(child: Container(
//                   height: 40,
//                   child: LoadingIndicator(
//                       indicatorType: Indicator.ballPulse,
//                       colors: BoardController.to.kDefaultRainbowColors,
//                       strokeWidth: 2,
//                       backgroundColor: Colors.transparent,
//                       pathBackgroundColor: Colors.transparent
//                   ),
//                 ),);
//               }
//
//               if (snapshot.data!.docs.isEmpty) {
//                 return Center(
//                   child: Container(
//                     width: 500, height: 250,
//                     decoration: BoxDecoration(
//                       color: Color(0xFF4C4C4C),
//                       borderRadius: BorderRadius.circular(15.0),
//                       border: Border.all(width: 3, color: Colors.grey.withOpacity(0.5),),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(height: 10,),
//                           Container(
//                               width: 500,
//                               child: Center(child: Text('출석부가 존재하지 않습니다', style: TextStyle(fontFamily: 'Jua', fontSize: 30, color: Colors.orangeAccent),))),
//                           SizedBox(height: 25,),
//                           Text('(추측1) 링크주소가 잘못되었다', style: TextStyle(fontFamily: 'Jua', fontSize: 25, color: Colors.white),),
//                           SizedBox(height: 15,),
//                           Text('(추측2) 선생님이 출석부를 아직 만들지 않으셨다', style: TextStyle(fontFamily: 'Jua', fontSize: 25, color: Colors.white),),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               }else{
//                 // List attendanceList = snapshot.data!.docs.first['attendance'];
//                 // attendanceList.sort((a, b) => a['number'].compareTo(b['number']));
//                 List attendanceList = AttendanceController.to.attendanceList;
//                 List visitList = snapshot.data!.docs.first['visit'];
//                 return
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Center(
//                       child: Container(
//                         width: 700, height: 800,
//                         // width: 400, height: 650,
//                         // decoration: BoxDecoration(
//                         //   borderRadius: BorderRadius.circular(5.0),
//                         //   border: Border.all(width: 3, color: Colors.grey.withOpacity(0.5),),
//                         // ),
//                         child: GridView.builder(
//                           primary: false,
//                           shrinkWrap: true,
//                           // padding: const EdgeInsets.all(10),
//                           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 4,
//                             childAspectRatio: 2/0.8, //item 의 가로, 세로 의 비율
//                           ),
//                           itemCount: attendanceList.length,
//                           itemBuilder: (context, index) {
//                             /// visitList.contains(attendanceList[index]), visitList.contains({'number': 2, 'name': '강현우'}) 이거 안됨
//                             return visitList.any((e) => mapEquals(e, attendanceList[index])) ?
//
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Container(
//                                 width: 150, height: 50,
//                                 child: Card(
//                                   color: Colors.grey.withOpacity(0.3),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Container(
//                                         width: 22,
//                                         child:
//                                         CircleAvatar(
//                                           backgroundColor: Colors.grey,
//                                           child: Center(
//                                             child: Text(attendanceList[index]['number'].toString(), style: TextStyle(color: Colors.black.withOpacity(0.1), fontSize: 15, fontFamily: 'Jua',),),
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(width: 10,),
//                                       Text(attendanceList[index]['name'], style: TextStyle(color: Colors.grey, fontFamily: 'Jua', fontSize: 25,),),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ) :
//                             InkWell(
//                               highlightColor: Colors.transparent,
//                               hoverColor: Colors.transparent,
//                               splashColor: Colors.transparent,
//                               onTap: () {
//                                 checkMyNameDialog(context,snapshot.data!.docs.first.id, attendanceList[index], paramClassCode);
//                                 // ClassController.to.addVisit(snapshot.data!.docs.first.id, attendanceList[index], paramClassCode);
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Container(
//                                   width: 150, height: 50,
//                                   child: Card(
//                                     color: Colors.orangeAccent,
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         Container(
//                                           width: 22,
//                                           child:
//                                           CircleAvatar(
//                                             backgroundColor: Colors.white,
//                                             child: Center(
//                                               child: Text(attendanceList[index]['number'].toString(), style: TextStyle(color: Colors.grey, fontSize: 15, fontFamily: 'Jua',),),
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(width: 10,),
//                                         Text(attendanceList[index]['name'], style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 25,),),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//
//                           },
//
//                         ),
//                       ),
//                     ),
//                   );
//               }
//
//             }
//         ),
//
//       );
//     }else { /// 익명
//       return
//         Scaffold(
//         resizeToAvoidBottomInset: false,  /// 키보드 render 에러 방지
//         appBar: AppBar(
//           centerTitle: false,
//           backgroundColor: Colors.black,
//           elevation: 0,
//           title: Center(child: Text('닉네임 입력', style: TextStyle(color: Colors.white),)),
//         ),
//         backgroundColor: Colors.white,
//         body:
//         Center(
//         child: Container(
//         width: 330,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               width: 330,
//               child: TextField(
//                 maxLength: 20,
//                 textAlignVertical: TextAlignVertical.center,
//                 onChanged: (value) {
//                   QuizController.to.nickname_input = value;
//                 },
//                 style: TextStyle(color: Colors.black , fontSize: 25, fontFamily: 'Jua' ),
//                 // style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 19, ),
//                 maxLines: 1,
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: Colors.white,
//                   hintText: '이름을 입력하세요(3글자이상)',
//                   hintStyle: TextStyle(fontSize: 20, color: Colors.grey.withOpacity(0.5)),
//                   focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.orange, width: 2 ),),
//                   enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.orange, width: 2 ),),
//                   contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//
//                 ),
//               ),
//             ),
//             SizedBox(height: 50,),
//             Container(
//               width: 330,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(backgroundColor: Color(0xff3E6888), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),),
//                 onPressed: () async{
//                   if (QuizController.to.nickname_input.trim().length > 2) {
//                     QuizController.to.saveAnonymous(paramClassCode, paramQuizId);
//                   }
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 10, bottom: 10, left: 11, right: 8),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.arrow_circle_right, color: Colors.white, size: 25,),
//                       SizedBox(width: 10,),
//                       Text('입장',style: TextStyle(fontFamily: 'Jua', fontSize: 30,  color: Colors.white),),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//
//       );
//     }
//
//   }
//
// }
//
//
//
//
