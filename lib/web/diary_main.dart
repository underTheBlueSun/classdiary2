// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get_storage/get_storage.dart';
// // import 'diary_view.dart';
// import '../controller/attendance_controller.dart';
// import '../controller/subject_controller.dart';
// // import 'subject_controller.dart';
//
// class DiaryMain extends StatelessWidget {
//
//   // int rowCnt = 1;
//   // int number = 1;
//   // int total = 0;
//
//   void stampListDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//           content: Container(
//             width: 600,
//             height: 600,
//             child: GridView.builder(
//                 scrollDirection: Axis.vertical,
//                 primary: false,
//                 shrinkWrap: true,
//                 padding: EdgeInsets.all(10),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 4, //1 개의 행에 보여줄 item 개수
//                   childAspectRatio: 1 / 1, //item 의 가로, 세로 의 비율
//                   crossAxisSpacing: 2,
//                   mainAxisSpacing: 2,
//                 ),
//                 itemCount: 13,
//                 itemBuilder: (_, index) {
//                   // var items_cnt = Hive.box('subjectDiary').values.where((e) => e.mmdd == SubjectController.to.subjects[index].mmdd).length;
//                   return InkWell(
//                     onTap: () {
//                       SubjectController.to.selectedStamp.value = 'stamp' + (index+1).toString() + '.png';
//                       Navigator.pop(context);
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Image.asset('assets/images/stamp${index+1}.png',),
//                     ),
//                   );
//
//                 }
//             ),
//           ),
//           // actions: <Widget>[
//           //   InkWell(
//           //     onTap: () {
//           //       Navigator.pop(context);
//           //     },
//           //     child: Text('취소'),
//           //   ),
//           //   InkWell(
//           //     onTap: () {
//           //       if (SubjectController.to.subjectClassName.length > 1) {
//           //         SubjectController.to.saveSubjectClass();
//           //         Navigator.pop(context);
//           //       }
//           //     },
//           //     child: Text('저장'),
//           //   ),
//           // ],
//         );
//       },
//     );
//
//   }
//
//   void titleUpdDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
//           content: Container(
//             width: 500,
//             height: 100,
//             child: TextField(
//               controller: TextEditingController(text: SubjectController.to.title.value),
//               onChanged: (value) {
//                 SubjectController.to.title.value = value.trim();
//               },
//               // style: TextStyle(fontFamily: 'Jua', color: Color(0xff7B5A59), fontSize: 16.0, height: 1.5),
//               // minLines: 10,
//               maxLines: null,
//               decoration: InputDecoration(
//                 hintText: '제목을 입력하세요',
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: Colors.grey, width: 10)),
//
//               ),
//             ),
//           ),
//           actions: <Widget>[
//             InkWell(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text('취소', style: TextStyle(fontFamily: 'Jua', fontSize: 22),),
//               ),
//             ),
//             InkWell(
//               onTap: () {
//                 if (SubjectController.to.title.value.length > 1) {
//                   SubjectController.to.saveTitle();
//                   Navigator.pop(context);
//                 }
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text('저장', style: TextStyle(fontFamily: 'Jua', fontSize: 22)),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//
//   }
//
//   void listDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
//           content: Container(
//             width: 500,
//             height: 750,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 InkWell(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Icon(Icons.cancel, size: 30, color: Colors.grey)),
//                 SizedBox(height: 10,),
//                 Container(
//                   width: 500,
//                   height: 700,
//                   child: StreamBuilder<QuerySnapshot>(
//                       stream: FirebaseFirestore.instance.collection('subject').where('class_code', isEqualTo: SubjectController.to.classCode.value).snapshots(),
//                       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                         if (!snapshot.hasData) {
//                           return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent)));
//                         }
//                         var docs = snapshot.data!.docs.toList();
//                         return ListView.builder(
//                             itemCount: 365,
//                             itemBuilder: (_, index)  {
//                               return Container(
//                                 // decoration: BoxDecoration(
//                                 //   border: Border(bottom: BorderSide(width: 0.2,),),
//                                 // ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 0),
//                                   child: InkWell(
//                                     onTap: () {
//                                       SubjectController.to.mmdd.value = SubjectController.to.subjects[index].mmdd;
//                                       SubjectController.to.getTitle();
//                                       Navigator.pop(context);
//                                     },
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         /// 날짜
//                                         Text('${SubjectController.to.subjects[index].mmdd.substring(0,2)}월 ${SubjectController.to.subjects[index].mmdd.substring(2,4)}일' ,
//                                           style: TextStyle(fontFamily: 'Jua', fontSize: 13, color: Color(0xff83B4B5), ),),
//                                         SizedBox(height: 5,),
//                                         /// 주제
//                                         Container(
//                                           width: 350,
//                                           child: Text(docs.where((doc) => doc['mmdd'] == SubjectController.to.subjects[index].mmdd).length == 0 ?
//                                           SubjectController.to.subjects[index].title :
//                                           docs.where((doc) => doc['mmdd'] == SubjectController.to.subjects[index].mmdd).first['title'],
//                                             style: TextStyle(fontFamily: 'Jua', fontSize: 15, color: Color(0xff7B5A59), ),),
//                                         ),
//                                         Divider(),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               );
//
//                             }
//                         );
//                       }
//                   ),
//
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return SingleChildScrollView(
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         color: Color(0xFFEEE9DF),
//         child: Column(
//           children: [
//             // 날짜
//             Obx(() => Container(
//               width: 1800,
//               // width: MediaQuery.of(context).size.width - 40,
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 22, right: 22),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 10,),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('${SubjectController.to.mmdd.value.substring(0,2)}월 ${SubjectController.to.mmdd.value.substring(2,4)}일' , style: TextStyle(fontFamily: 'Jua', fontSize: 22, color: Color(0xff83B4B5),),),
//                         // 지금까지 개설한 방들
//                         Row(children: [
//                           for(int i = 0; i < SubjectController.to.classes.value.length ; i++)
//                             Text('${SubjectController.to.classes.value[i]['class_name']}(${SubjectController.to.classes.value[i]['class_code']})     ' ,
//                               style: TextStyle(fontFamily: 'Jua', fontSize: 18, color: Color(0xff83B4B5)),),
//                         ],),
//
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         // 주제 타이틀
//                         Container(
//                           width: 1000,
//                           child: Text(SubjectController.to.title.value, style: TextStyle(fontFamily: 'Jua', fontSize: 30, color: Color(0xff7B5A59),),),
//                         ),
//
//                         // 스탬프 전체선택
//                         Row(
//                           children: [
//                             InkWell(
//                               onTap: () async{
//                                 var yyyy = SubjectController.to.schoolYear.value.substring(0,4);
//                                 var mm = SubjectController.to.mmdd.value.substring(0,2);
//                                 var dd = SubjectController.to.mmdd.value.substring(2,4);
//                                 var yyyymmdd = DateTime.parse('${yyyy}-${mm}-${dd}');
//                                 var before_yyyymmdd = yyyymmdd.subtract(Duration(days: 1)).toString();
//                                 SubjectController.to.mmdd.value = before_yyyymmdd.substring(5,7) + before_yyyymmdd.substring(8,10);
//                                 await SubjectController.to.getTitle();
//                               },
//                               child: Icon(Icons.arrow_circle_left,size: 45, color: Color(0xff83B4B5),),
//                             ),
//                             SizedBox(width: 10,),
//                             InkWell(
//                               onTap: () async{
//                                 var yyyy = SubjectController.to.schoolYear.value.substring(0,4);
//                                 var mm = SubjectController.to.mmdd.value.substring(0,2);
//                                 var dd = SubjectController.to.mmdd.value.substring(2,4);
//                                 var yyyymmdd = DateTime.parse('${yyyy}-${mm}-${dd}');
//                                 var after_yyyymmdd = yyyymmdd.add(Duration(days: 1)).toString();
//                                 SubjectController.to.mmdd.value = after_yyyymmdd.substring(5,7) + after_yyyymmdd.substring(8,10);
//                                 await SubjectController.to.getTitle();
//                               },
//                               child: Icon(Icons.arrow_circle_right, size: 45, color: Color(0xff83B4B5),),
//                             ),
//                             SizedBox(width: 30,),
//                             SizedBox(
//                               height: 33,
//                               child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(backgroundColor: Color(0xff83B4B5),),
//                                 onPressed: () async {
//                                   titleUpdDialog(context);
//                                 },
//                                 child: Row(
//                                   children: [
//                                     Icon(Icons.edit, size: 18,color: Colors.white),
//                                     SizedBox(width: 3,),
//                                     Text('제목 수정',style: TextStyle(fontFamily: 'Jua', fontSize: 17, color: Colors.white),),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 30,),
//                             SizedBox(
//                               height: 33,
//                               child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(backgroundColor: Color(0xff83B4B5),),
//                                 onPressed: () async {
//                                   listDialog(context);
//                                 },
//                                 child: Row(
//                                   children: [
//                                     Icon(Icons.dehaze, size: 18,color: Colors.white),
//                                     SizedBox(width: 3,),
//                                     Text('목록',style: TextStyle(fontFamily: 'Jua', fontSize: 17, color: Colors.white),),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 30,),
//                             SizedBox(
//                               height: 33,
//                               child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(backgroundColor: Color(0xff83B4B5),),
//                                 onPressed: () async {
//                                   // SubjectController.to.stamps.value = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29];
//                                   if (SubjectController.to.stamps.value.length == 0) {
//                                     SubjectController.to.stamps.value = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29];
//                                   }else {
//                                     SubjectController.to.stamps.value = [];
//                                   }
//                                 },
//                                 child: Row(
//                                   children: [
//                                     Image.asset('assets/images/stamp.png', width: 25, color: Colors.white,),
//                                     SizedBox(width: 3,),
//                                     SubjectController.to.stamps.value.length == 0 ?
//                                     Text('전체 찍기',style: TextStyle(fontFamily: 'Jua', fontSize: 17, color: Colors.white),) :
//                                     Text('전체 해제',style: TextStyle(fontFamily: 'Jua', fontSize: 17, color: Colors.white),),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             // SizedBox(width: 20,),
//                             // SizedBox(
//                             //   height: 33,
//                             //   child: ElevatedButton(
//                             //     onPressed: () async {
//                             //       SubjectController.to.stamps.value = [];
//                             //     },
//                             //     child: Row(
//                             //       children: [
//                             //         Image.asset('assets/images/stamp.png', width: 25, color: Colors.white,),
//                             //         SizedBox(width: 3,),
//                             //         Text('전체 해제',style: TextStyle(fontFamily: 'Jua', fontSize: 17),),
//                             //       ],
//                             //     ),
//                             //   ),
//                             // ),
//                             SizedBox(width: 30,),
//                             SizedBox(
//                               height: 33,
//                               child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(backgroundColor: Color(0xff83B4B5),),
//                                 onPressed: () async {
//                                   stampListDialog(context);
//                                 },
//                                 child: Row(
//                                   children: [
//                                     Image.asset('assets/images/stamp.png', width: 25, color: Colors.white,),
//                                     SizedBox(width: 3,),
//                                     Text('선택',style: TextStyle(fontFamily: 'Jua', fontSize: 17, color: Colors.white),),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 5,),
//                             Image.asset('assets/images/${SubjectController.to.selectedStamp.value}', width: 32,),
//                           ],
//                         ),
//
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             ),
//
//             // SizedBox(height: 10,),
//
//             // 일기
//             Container(
//               // width: 1800,
//               width: MediaQuery.of(context).size.width*0.9,
//               height: MediaQuery.of(context).size.height,
//               child: StreamBuilder<QuerySnapshot> (
//                 stream: FirebaseFirestore.instance.collection('attendance').where('email', isEqualTo: GetStorage().read('email'))
//                 .where('yyyy', isEqualTo: SubjectController.to.schoolYear.value.substring(0,4) ).orderBy('number', descending: false).snapshots(),
//                   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1) {
//                   // db가 변경되면 다시 처음부터 row를 그려야 한다.
//                     int rowCnt = 1;
//                     int number = 1;
//                     int total = 0;
//                     if (!snapshot1.hasData) {
//                       return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent)));
//                     }
//                     total = snapshot1.data!.docs.length;
//                     return Column(
//                       children: [
//                         // row 생성
//                         for (rowCnt ; rowCnt <= (total/6).ceil(); rowCnt++)
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               //
//                               for (number ; number <= rowCnt*6; number++)
//                                 number > total ? SizedBox() :
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Container(
//                                     width: 250,
//                                     decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(10.0),
//                                       child: Column(
//                                         children: [
//                                           Text(number.toString()+'번 ' ,  style: TextStyle(fontFamily: 'Jua', fontSize: 12, color: Colors.grey),),
//                                           // Text(snapshot1.data!.docs[number-1]['number'].toString()+'번 ' + snapshot1.data!.docs[number-1]['name'],  style: TextStyle(fontFamily: 'Jua', fontSize: 12, color: Colors.grey),),
//                                           StreamBuilder<QuerySnapshot> (
//                                               stream: FirebaseFirestore.instance.collection('diary').where('class_code', isEqualTo: SubjectController.to.classCode.value)
//                                                   .where('mmdd', isEqualTo: SubjectController.to.mmdd.value).where('number', isEqualTo: snapshot1.data!.docs[number-1]['number']).snapshots(),
//                                               builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
//                                                 if (snapshot2.data!.docs.length == 0) {
//                                                   return SizedBox();
//                                                 }else{
//                                                   var doc = snapshot2.data!.docs[0];
//                                                   // return Text(snapshot2.data!.docs.length.toString(),  style: TextStyle(fontFamily: 'Jua', fontSize: 15, color: Colors.black),);
//                                                   return Text(doc['content'],  style: TextStyle(fontFamily: 'Jua', fontSize: 15, color: Colors.black),);
//                                                 }
//
//                                               }
//                                           ),
//                                           Divider(),
//                                           ListView.builder(
//                                               shrinkWrap: true,
//                                               itemCount: SubjectController.to.comments.value.length,
//                                               itemBuilder: (_, index) {
//                                                 return InkWell(
//                                                   onTap: () {
//                                                   },
//                                                   child: Column(
//                                                     children: [
//                                                       Row(
//                                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                         children: [
//                                                           Text(SubjectController.to.comments.value[index].split('::')[0], style: TextStyle(fontFamily: 'Jua', color: Colors.black, fontSize: 13, ),),
//                                                           Text(SubjectController.to.comments.value[index].split('::')[2], style: TextStyle(fontFamily: 'Jua', color: Colors.black, fontSize: 13, ),),
//                                                         ],
//                                                       ),
//                                                       Text(SubjectController.to.comments.value[index].split('::')[1], style: TextStyle(fontFamily: 'Jua', color: Colors.black, fontSize: 13, ),),
//                                                     ],
//                                                   ),
//                                                 );
//
//                                               }
//                                           ),
//                                           SizedBox(
//                                             height: 30,
//                                             child: TextField(
//                                               textAlignVertical: TextAlignVertical.center,
//                                               onSubmitted: (value) {
//                                                 var comment = '선생님::' + value + '::5.10 13:14';
//                                                 SubjectController.to.comments.value.add(comment);
//                                                 // SubjectController.to.reloadNow.value = DateTime.now().toString();
//                                               },
//                                               style: TextStyle(fontFamily: 'Jua', color: Colors.black, fontSize: 15, ),
//                                               // minLines: 1,
//                                               maxLines: 1,
//                                               decoration: InputDecoration(
//                                                 hintText: '댓글 입력',
//                                                 hintStyle: TextStyle(fontSize: 15, color: Colors.grey.withOpacity(0.5)),
//                                                 // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey, ),),
//                                                 focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
//                                                 enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
//                                                 contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//
//
//
//                             ],
//                           ),
//                       ],
//                     );
//                     // return Column(
//                     //   children: [
//                     //     // row 생성
//                     //     for (rowCnt ; rowCnt <= (total/6).ceil(); rowCnt++)
//                     //       Row(
//                     //         crossAxisAlignment: CrossAxisAlignment.start,
//                     //         children: [
//                     //           //
//                     //           for (number ; number <= rowCnt*6; number++)
//                     //             number > total ? SizedBox() :
//                     // StreamBuilder<QuerySnapshot> (
//                     //   stream: FirebaseFirestore.instance.collection('diary').where('class_code', isEqualTo: SubjectController.to.classCode.value)
//                     //               .where('mmdd', isEqualTo: SubjectController.to.mmdd.value).where('number', isEqualTo: snapshot1.data!.docs[number-1]['number']).snapshots(),
//                     //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
//                     //
//                     //     return Padding(
//                     //       padding: const EdgeInsets.all(8.0),
//                     //       child: Container(
//                     //         width: 250,
//                     //         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
//                     //         child: Padding(
//                     //           padding: const EdgeInsets.all(10.0),
//                     //           child: Column(
//                     //             children: [
//                     //               Text(number.toString()+'번 ' ,  style: TextStyle(fontFamily: 'Jua', fontSize: 12, color: Colors.grey),),
//                     //               // Text(snapshot1.data!.docs[number-1]['number'].toString()+'번 ' + snapshot1.data!.docs[number-1]['name'],  style: TextStyle(fontFamily: 'Jua', fontSize: 12, color: Colors.grey),),
//                     //               Text('ddddddd',  style: TextStyle(fontFamily: 'Jua', fontSize: 15, color: Colors.black),),
//                     //               Divider(),
//                     //               ListView.builder(
//                     //                   shrinkWrap: true,
//                     //                   itemCount: SubjectController.to.comments.value.length,
//                     //                   itemBuilder: (_, index) {
//                     //                     return InkWell(
//                     //                       onTap: () {
//                     //                       },
//                     //                       child: Column(
//                     //                         children: [
//                     //                           Row(
//                     //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     //                             children: [
//                     //                               Text(SubjectController.to.comments.value[index].split('::')[0], style: TextStyle(fontFamily: 'Jua', color: Colors.black, fontSize: 13, ),),
//                     //                               Text(SubjectController.to.comments.value[index].split('::')[2], style: TextStyle(fontFamily: 'Jua', color: Colors.black, fontSize: 13, ),),
//                     //                             ],
//                     //                           ),
//                     //                           Text(SubjectController.to.comments.value[index].split('::')[1], style: TextStyle(fontFamily: 'Jua', color: Colors.black, fontSize: 13, ),),
//                     //                         ],
//                     //                       ),
//                     //                     );
//                     //
//                     //                   }
//                     //               ),
//                     //               SizedBox(
//                     //                 height: 30,
//                     //                 child: TextField(
//                     //                   textAlignVertical: TextAlignVertical.center,
//                     //                   onSubmitted: (value) {
//                     //                     var comment = '선생님::' + value + '::5.10 13:14';
//                     //                     SubjectController.to.comments.value.add(comment);
//                     //                     // SubjectController.to.reloadNow.value = DateTime.now().toString();
//                     //                   },
//                     //                   style: TextStyle(fontFamily: 'Jua', color: Colors.black, fontSize: 15, ),
//                     //                   // minLines: 1,
//                     //                   maxLines: 1,
//                     //                   decoration: InputDecoration(
//                     //                     hintText: '댓글 입력',
//                     //                     hintStyle: TextStyle(fontSize: 15, color: Colors.grey.withOpacity(0.5)),
//                     //                     // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey, ),),
//                     //                     focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
//                     //                     enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
//                     //                     contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//                     //
//                     //                   ),
//                     //                 ),
//                     //               ),
//                     //             ],
//                     //           ),
//                     //         ),
//                     //       ),
//                     //     );
//                     //   }
//                     // ),
//                     //
//                     //         ],
//                     //       ),
//                     //   ],
//                     // );
//                     // return GridView.builder(
//                     //   scrollDirection: Axis.vertical,
//                     //   primary: false,
//                     //   shrinkWrap: true,
//                     //   padding: EdgeInsets.all(10),
//                     //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     //     crossAxisCount: 6, //1 개의 행에 보여줄 item 개수
//                     //     // childAspectRatio: 1.1 / 1, //item 의 가로, 세로 의 비율
//                     //     childAspectRatio: 1.4 / 1, //item 의 가로, 세로 의 비율
//                     //   ),
//                     //   itemCount: snapshot.data!.docs.length,
//                     //   itemBuilder: (context, index) {
//                     //     DocumentSnapshot doc1 = snapshot.data!.docs[index];
//                     //     return GestureDetector(
//                     //       onTap: () {
//                     //         // MainController.to.content.value = items.where((e) => e.yyyy == (GetStorage().read('yyyy')+i).toString()).first.content;
//                     //         // MainController.to.images.value = items.where((e) => e.yyyy == (GetStorage().read('yyyy')+i).toString()).first.images;
//                     //         // Get.to(() => DiaryView());
//                     //       },
//                     //
//                     //       child: Obx(() => StreamBuilder<QuerySnapshot>(
//                     //           stream: FirebaseFirestore.instance.collection('diary').where('class_code', isEqualTo: SubjectController.to.classCode.value)
//                     //               .where('mmdd', isEqualTo: SubjectController.to.mmdd.value).where('number', isEqualTo: doc1['number']).snapshots(),
//                     //             builder: (BuildContext context1, AsyncSnapshot<QuerySnapshot> snapshot2) {
//                     //               if (!snapshot2.hasData) {
//                     //                 return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent)));
//                     //               }
//                     //               return Padding(
//                     //                 padding: const EdgeInsets.all(8.0),
//                     //                 child: Obx(() => Container(
//                     //                     decoration: BoxDecoration(
//                     //                         color: Colors.white,
//                     //                         borderRadius: BorderRadius.circular(10)
//                     //                     ),
//                     //                     // color: Colors.red,
//                     //                     child: Stack(
//                     //                       children: [
//                     //                         Positioned(
//                     //                           top: 10,
//                     //                           left: 15,
//                     //                           right: 15,
//                     //                           child:
//                     //                               // 화면사이즈가 작아지면
//                     //                           MediaQuery.of(context).size.width > 1000 ?
//                     //                           Column(
//                     //                             crossAxisAlignment: CrossAxisAlignment.start,
//                     //                             children: [
//                     //                               Row(
//                     //                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     //                                 children: [
//                     //                                   Container(
//                     //                                     width: 70,
//                     //                                     child: Text(doc1['name'], style: TextStyle(fontFamily: 'Jua', fontSize: 16, color: Color(0xff83B4B5)),),
//                     //                                   ),
//                     //                                   Row(
//                     //                                     children: [
//                     //                                       Container(
//                     //                                         child:
//                     //                                         Icon(Icons.favorite_rounded, color: Color(0xffCE9999),),
//                     //                                       ),
//                     //                                       // Text(doc['heart']),
//                     //                                       SizedBox(width: 10,),
//                     //                                       InkWell(
//                     //                                         onTap: () {
//                     //                                           if (SubjectController.to.stamps.value.contains(index)) {
//                     //                                             // 새로 리로드하기 위해 어쩔수 없이 now 부름
//                     //                                             SubjectController.to.reloadNow.value = DateTime.now().toString();
//                     //                                             SubjectController.to.stamps.value.remove(index);
//                     //                                           }else {
//                     //                                             SubjectController.to.reloadNow.value = DateTime.now().toString();
//                     //                                             SubjectController.to.stamps.value.add(index);
//                     //                                             print(SubjectController.to.stamps.value);
//                     //                                           }
//                     //                                         },
//                     //                                         child: SubjectController.to.stamps.value.contains(index) ?
//                     //                                         Image.asset('assets/images/stamp.png', width: 30, color: Color(0xffCE9999),) :
//                     //                                         Image.asset('assets/images/stamp.png', width: 30, color: Colors.black.withOpacity(0.6),),
//                     //                                       ),
//                     //                                     ],
//                     //                                   ),
//                     //
//                     //                                 ],
//                     //                               ),
//                     //                               SizedBox(height: 5,),
//                     //
//                     //                               // content 일기 내용
//                     //                               Container(
//                     //                                 // width: 300,
//                     //                                 height: 100,
//                     //                                 child: SingleChildScrollView(
//                     //                                   child: Text('동해물과 백두산이 마르고 닳도록하느님이 보우하사 우리나라 만세무궁화 삼천리 화려 강산대한 사람 대한으로 길이 보전하세2. 남산 위에 저 소나무 철갑을 두른 듯바람 서리 불변함은 우리 기상일세무궁화 삼천리 화려 강산대한 사람 대한으로 길이 보전하세',
//                     //                                   // child: Text(snapshot2.data!.docs.length == 0 ? '' : snapshot2.data!.docs[0]['content'],
//                     //                                   //   overflow: TextOverflow.ellipsis, maxLines: 5,
//                     //                                     style: TextStyle(fontFamily: 'Jua', fontSize: 15, color: Color(0xff7B5A59),),),
//                     //                                 ),
//                     //                               ),
//                     //                               Divider(color: Colors.black,),
//                     //                               // 댓글
//                     //                               Text('${SubjectController.to.mmdd.value}/${doc1['number']}/${SubjectController.to.classCode.value}', style: TextStyle(color: Colors.black),),
//                     //                             ],
//                     //                           )
//                     //                               :
//                     //                           // 브라우져 사이즈가 작아지면
//                     //                           Column(
//                     //                             crossAxisAlignment: CrossAxisAlignment.start,
//                     //                             children: [
//                     //                               Container(
//                     //                                 width: 100,
//                     //                                 child: Text(doc1['name'], style: TextStyle(fontFamily: 'Jua', fontSize: 16, color: Color(0xffCE9999)),),
//                     //                               ),
//                     //                             ],
//                     //                           ),
//                     //                         ),
//                     //
//                     //                         SubjectController.to.stamps.value.contains(index) ?
//                     //                         Positioned(
//                     //                           top: 95,
//                     //                           right: 20,
//                     //                           // right: 20,
//                     //                           child: Container(
//                     //                             width: 50,
//                     //                             child: Image.asset('assets/images/${SubjectController.to.selectedStamp.value}', opacity: const AlwaysStoppedAnimation(0.9), ),
//                     //                           ),
//                     //                         )
//                     //                             :
//                     //                         Text(SubjectController.to.reloadNow.value, style: TextStyle(color: Colors.transparent),),
//                     //                         //SizedBox(),
//                     //                       ],
//                     //                     ),
//                     //                   ),
//                     //                 ),
//                     //               );
//                     //             }
//                     //         ),
//                     //       ),
//                     //
//                     //     );
//                     //
//                     //   },
//                     //
//                     // );
//                   }
//               ),
//
//
//             ),
//
//           ],
//         ),
//       ),
//     );
//
//   }
// }
//
//
//
