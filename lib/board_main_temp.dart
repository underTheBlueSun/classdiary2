// import '../controller/attendance_controller.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:loading_indicator/loading_indicator.dart';
// import 'board_indi.dart';
//
// import '../controller/board_controller.dart';
// import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
//
// class BoardMain extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     List popupEditControllers = [];
//     CustomPopupMenuController popupAddController = CustomPopupMenuController();
//     // CustomPopupMenuController popupEditController = CustomPopupMenuController();
//     TextEditingController titleInputController = TextEditingController();
//     TextEditingController contentInputController = TextEditingController();
//     var bgColors1 = [0xff2B2B2B, 0xffE9E7EA, 0xff668F85, 0xff84A76A, 0xffD3DC7E];
//     var bgColors2 = [0xffF6EB89, 0xffDCA35D, 0xffC36250, 0xff6994DE, 0xff8739A5];
//     return Scaffold(body:
//     Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Obx(() => Row(
//           children: [
//             Text('반코드: ' + GetStorage().read('class_code')),
//             SizedBox(width: 20,),
//             Text('총원: ' + AttendanceController.to.attendanceCnt.value.toString()),
//             SizedBox(width: 20,),
//             Text('이메일: ' + GetStorage().read('email')),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: IconButton(
//                 icon: Icon(Icons.home),
//                 iconSize: 30,
//                 onPressed: () {
//                   Get.back();
//                   // Get.to(() => MyApp());
//                 },
//               ),
//             ),
//             Expanded(child: SizedBox()),
//             Padding(
//               padding: const EdgeInsets.only(left:15, right:5, top:15, bottom: 15),
//               child:
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(backgroundColor: BoardController.to.mainAlignment.value == 'date' ? Color(0xff83B4B5) : Colors.grey.withOpacity(0.5),),
//                 onPressed: () {
//                   BoardController.to.mainAlignment.value = 'date';
//                 },
//                 child: Text('날짜별정렬',style: TextStyle(fontFamily: 'Jua', fontSize: 17, color: Colors.white),),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left:5, right:5, top:15, bottom: 15),
//               child:
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(backgroundColor: BoardController.to.mainAlignment.value == 'color' ? Color(0xff83B4B5) : Colors.grey.withOpacity(0.5),),
//                 onPressed: () {
//                   BoardController.to.mainAlignment.value = 'color';
//                 },
//                 child: Text('색상별정렬',style: TextStyle(fontFamily: 'Jua', fontSize: 17, color: Colors.white),),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left:5, right:5, top:15, bottom: 15),
//               child:
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(backgroundColor: BoardController.to.mainAlignment.value == 'title' ? Color(0xff83B4B5) : Colors.grey.withOpacity(0.5),),
//                 onPressed: () {
//                   BoardController.to.mainAlignment.value = 'title';
//                 },
//                 child: Text('제목별정렬',style: TextStyle(fontFamily: 'Jua', fontSize: 17, color: Colors.white),),
//               ),
//             ),
//             SizedBox(width: 30,),
//             Padding(
//               padding: const EdgeInsets.all(15),
//               child:
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.withOpacity(0.7),),
//                 onPressed: () {
//                 },
//                 child: Text('년도별목록',style: TextStyle(fontFamily: 'Jua', fontSize: 17, color: Colors.white),),
//               ),
//             ),
//             SizedBox(width: 30,),
//           ],
//         ),
//         ),
//         Center(
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// add 아이콘
//               CustomPopupMenu(
//                 menuOnChange: (bool) {
//                   if (bool == false && BoardController.to.popCloseType == 'nosave') {
//                     BoardController.to.imageModel.value.imageInt8 = null;
//                   }
//                 },
//                 controller: popupAddController,
//                 arrowSize: 20,
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 28, right: 28, top: 50),
//                   child: Icon(Icons.add_circle_outline, color: Colors.orangeAccent, size: 70,),
//                 ),
//                 menuBuilder: () => ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: Container(
//                     width: 400,
//                     height: 720,
//                     color: Color(0xFF4C4C4C),
//                     child: IntrinsicWidth(
//                       child: Column(
//                           children: [
//                             SizedBox(height: 10,),
//                             Row(
//                               children: [
//                                 Expanded(child: SizedBox()),
//                                 Padding(
//                                   padding: const EdgeInsets.all(15),
//                                   child:
//                                   ElevatedButton(
//                                     style: ElevatedButton.styleFrom(backgroundColor: Color(0xff83B4B5),),
//                                     onPressed: () {
//                                       if (BoardController.to.mainTitleInput.length > 0) {
//                                         BoardController.to.popCloseType = 'save';
//                                         BoardController.to.saveBoardMain();
//                                       }
//                                       popupAddController.hideMenu();
//                                     },
//                                     child: Text('저장',style: TextStyle(fontFamily: 'Jua', fontSize: 17, color: Colors.white),),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               width: 370, height: 40,
//                               child: TextField(
//                                 // controller: titleInputController,
//                                 autofocus: true,
//                                 textAlignVertical: TextAlignVertical.center,
//                                 onChanged: (value) {
//                                   BoardController.to.mainTitleInput = value;
//                                 },
//                                 style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 19, ),
//                                 // minLines: 1,
//                                 maxLines: 1,
//                                 decoration: InputDecoration(
//                                   hintText: '제목을 입력하세요',
//                                   hintStyle: TextStyle(fontSize: 19, color: Colors.grey.withOpacity(0.5)),
//                                   // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey, ),),
//                                   focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
//                                   enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
//                                   contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 10,),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 // 보드형태
//                                 Obx(() => Container(
//                                   width: 370,height: 80,
//                                   decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.only(left:8, right: 8, top:8),
//                                         child: Text('보드 형태',style: TextStyle(color: Colors.white),),
//                                       ),
//                                       Row(
//                                         children: [
//                                           InkWell(
//                                             onTap: () {
//                                               BoardController.to.board_type.value = '개인';
//                                             },
//                                             child: Padding(
//                                               padding: const EdgeInsets.all(8),
//                                               child: Row(
//                                                 children: [ BoardController.to.board_type.value == '개인' ?
//                                                 Icon(Icons.check_circle, color: Colors.orangeAccent,) :
//                                                 Icon(Icons.circle_outlined, color: Colors.white,),
//                                                   SizedBox(width: 5,),
//                                                   Text('개인형',style: TextStyle(color: Colors.white, fontSize: 19),),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//
//                                           InkWell(
//                                             onTap: () {
//                                               BoardController.to.board_type.value = '모둠';
//                                             },
//                                             child: Padding(
//                                               padding: const EdgeInsets.all(8.0),
//                                               child: Row(
//                                                 children: [ BoardController.to.board_type.value == '모둠' ?
//                                                 Icon(Icons.check_circle, color: Colors.orangeAccent,) :
//                                                 Icon(Icons.circle_outlined, color: Colors.white,),
//                                                   SizedBox(width: 5,),
//                                                   Text('모둠형',style: TextStyle(color: Colors.white, fontSize: 19),),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 ),
//                                 SizedBox(height: 10,),
//                                 /// 배경색깔
//                                 Obx(() => Container(
//                                   width: 370,height: 140,
//                                   decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Text('배경색깔',style: TextStyle(color: Colors.white),),
//                                       ),
//                                       Row(
//                                         children: [
//                                           for (var color in bgColors1)
//                                             InkWell(
//                                               onTap: () {
//                                                 BoardController.to.board_bgcolor.value = color;
//                                               },
//                                               child: Padding(
//                                                 padding: const EdgeInsets.only(left: 20, ),
//                                                 child: BoardController.to.board_bgcolor.value == color ?
//                                                 Icon(Icons.check_circle, color: Color(color), size: 40,) :
//                                                 Icon(Icons.circle, color: Color(color), size: 40,),
//                                               ),
//                                             ),
//
//                                         ],
//                                       ),
//                                       Row(
//                                         children: [
//                                           for (var color in bgColors2)
//                                             InkWell(
//                                               onTap: () {
//                                                 BoardController.to.board_bgcolor.value = color;
//                                               },
//                                               child: Padding(
//                                                 padding: const EdgeInsets.only(left: 20, top: 7, bottom: 7),
//                                                 child: BoardController.to.board_bgcolor.value == color ?
//                                                 Icon(Icons.check_circle, color: Color(color), size: 40,) :
//                                                 Icon(Icons.circle, color: Color(color), size: 40,),
//                                               ),
//                                             ),
//
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 20,),
//                             SizedBox(
//                               width: 370, height: 150,
//                               child: TextField(
//                                 onChanged: (value) {
//                                   BoardController.to.mainContentInput = value;
//                                 },
//                                 style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 17, ),
//                                 minLines: 10,
//                                 maxLines: null,
//                                 decoration: InputDecoration(
//                                   hintText: '부가적인 설명이 필요한가요?\n이곳에 부가설명을 추가하거나 이미지를 첨부할 수 있습니다.',
//                                   hintStyle: TextStyle(fontSize: 15, color: Colors.grey.withOpacity(0.5)),
//                                   // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey, ),),
//                                   focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
//                                   enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
//
//                                 ),
//                               ),
//                             ),
//                             Obx(()=> Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Container(
//                                   width: 200, height: 200,
//                                   child: BoardController.to.imageModel.value.imageInt8 == null
//                                       ? SizedBox()
//                                       :
//                                   Padding(
//                                     padding: const EdgeInsets.only(top: 10),
//                                     child: Image.memory(BoardController.to.imageModel.value.imageInt8!,),
//                                   ),
//                                 ),
//                                 SizedBox(width: 50,),
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 10, right: 15),
//                                   child: IconButton(
//                                     icon: Icon(Icons.insert_photo_outlined, size: 30, color: Colors.white,),
//                                     onPressed: () {
//                                       BoardController.to.selectImage();
//                                     },
//                                   ),
//                                 ),
//                                 Text(BoardController.to.dummy.value.toString(), style: TextStyle(fontSize: 0),),
//                               ],
//                             ),
//                             ),
//                           ]
//                       ),
//                     ),
//                   ),
//                 ),
//                 pressType: PressType.singleClick,
//                 verticalMargin: -10,
//               ),
//               Obx(() => StreamBuilder<QuerySnapshot>(
//                   stream: BoardController.to.mainAlignment.value == 'date' ?
//                   FirebaseFirestore.instance.collection('board_main').where('class_code', isEqualTo: GetStorage().read('class_code')).orderBy('main_id', descending: true).snapshots() :
//                   BoardController.to.mainAlignment.value == 'color' ?
//                   FirebaseFirestore.instance.collection('board_main').where('class_code', isEqualTo: GetStorage().read('class_code')).orderBy('bg_color', descending: false).snapshots() :
//                   FirebaseFirestore.instance.collection('board_main').where('class_code', isEqualTo: GetStorage().read('class_code')).orderBy('title', descending: false).snapshots(),
//                   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                     if (!snapshot.hasData) {
//                       return Center(child: Container(
//                         height: 40,
//                         child: LoadingIndicator(
//                             indicatorType: Indicator.ballPulse,
//                             colors: BoardController.to.kDefaultRainbowColors,
//                             strokeWidth: 2,
//                             backgroundColor: Colors.transparent,
//                             pathBackgroundColor: Colors.transparent
//                         ),
//                       ),);
//                     }
//                     return
//                       Flexible(
//                         child: GridView.builder(
//                           primary: false,
//                           shrinkWrap: true,
//                           padding: EdgeInsets.all(15),
//                           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 7, //1 개의 행에 보여줄 item 개수
//                             childAspectRatio: 2 / 1.16, //item 의 가로, 세로 의 비율
//                           ),
//                           itemCount: snapshot.data!.docs.length,
//                           itemBuilder: (context, index) {
//                             DocumentSnapshot doc = snapshot.data!.docs[index];
//                             popupEditControllers.add(CustomPopupMenuController());
//                             return Padding(
//                               padding: const EdgeInsets.all(8),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                     color: Color(doc['bg_color']),
//                                     borderRadius: BorderRadius.circular(10)
//                                 ),
//                                 child: Column(children: [
//                                   InkWell(
//                                     highlightColor: Colors.transparent,
//                                     hoverColor: Colors.transparent,
//                                     splashColor: Colors.transparent,
//                                     onTap: () {
//                                       Get.to(() => BoardIndi(), arguments: {'title' : doc['title'], 'mainId' : doc['main_id'], 'bgColor': doc['bg_color']});
//                                     },
//                                     child: Padding(
//                                       padding: const EdgeInsets.only(left: 12, right: 12,top:12, bottom: 3),
//                                       child: Container(
//                                         width: 250, height: 70,
//                                         child: Text(doc['title'],   style: TextStyle(fontFamily: 'Jua', fontSize: 19, color: Colors.white),),
//                                       ),
//                                     ),
//                                   ),
//                                   Divider(color: Colors.black.withOpacity(0.1),),
//                                   Padding(
//                                     padding: const EdgeInsets.only(left: 12, right: 12, bottom: 4),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(doc['main_id'].toDate().toString().substring(2,16), style: TextStyle(color: Colors.white),),
//                                         /// edit 아이콘
//                                         CustomPopupMenu(
//                                           menuOnChange: (bool) {
//                                             BoardController.to.imageModel.value.imageInt8 == null;
//                                             if (bool == true) {
//                                               BoardController.to.mainTitleInput = doc['title'];
//                                               BoardController.to.mainContentInput = doc['content'];
//                                               BoardController.to.board_bgcolor.value = doc['bg_color'];
//                                               // BoardController.to.imageModel.value.imageInt8 = doc['bg_color'];
//                                               // 텍스트필드 커서 뒤로 보내기
//                                               titleInputController.text = BoardController.to.mainTitleInput;
//                                               titleInputController.selection = TextSelection.fromPosition(TextPosition(offset: titleInputController.text.length));
//                                               contentInputController.text = BoardController.to.mainContentInput;
//                                               contentInputController.selection = TextSelection.fromPosition(TextPosition(offset: contentInputController.text.length));
//                                             }
//
//                                           },
//                                           controller: popupEditControllers[index],
//                                           arrowSize: 20,
//                                           child: Icon(Icons.edit_outlined, color: Colors.white,),
//                                           menuBuilder: () => ClipRRect(
//                                             borderRadius: BorderRadius.circular(10),
//                                             child: Container(
//                                               width: 400,
//                                               height: 720,
//                                               color: Color(0xFF4C4C4C),
//                                               child: IntrinsicWidth(
//                                                 child: Column(
//                                                     children: [
//                                                       SizedBox(height: 10,),
//                                                       Row(
//                                                         children: [
//                                                           Expanded(child: SizedBox()),
//                                                           Padding(
//                                                             padding: const EdgeInsets.all(15),
//                                                             child:
//                                                             ElevatedButton(
//                                                               style: ElevatedButton.styleFrom(backgroundColor: Color(0xff83B4B5),),
//                                                               onPressed: () {
//                                                                 // if (BoardController.to.mainTitleInput.length > 0) {
//                                                                 //   BoardController.to.popCloseType = 'save';
//                                                                 //   BoardController.to.saveBoardMain();
//                                                                 // }
//                                                                 popupEditControllers[index].hideMenu();
//                                                               },
//                                                               child: Text('수정',style: TextStyle(fontFamily: 'Jua', fontSize: 17, color: Colors.white),),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                       SizedBox(
//                                                         width: 370, height: 40,
//                                                         child: TextField(
//                                                           controller: titleInputController,
//                                                           autofocus: true,
//                                                           textAlignVertical: TextAlignVertical.center,
//                                                           onChanged: (value) {
//                                                             BoardController.to.mainTitleInput = value;
//                                                           },
//                                                           style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 19, ),
//                                                           // minLines: 1,
//                                                           maxLines: 1,
//                                                           decoration: InputDecoration(
//                                                             hintText: '제목을 입력하세요',
//                                                             hintStyle: TextStyle(fontSize: 19, color: Colors.grey.withOpacity(0.5)),
//                                                             // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey, ),),
//                                                             focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
//                                                             enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
//                                                             contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       SizedBox(height: 10,),
//                                                       Column(
//                                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                                         children: [
//                                                           SizedBox(height: 10,),
//                                                           /// 배경색깔
//                                                           Obx(() => Container(
//                                                             width: 370,height: 140,
//                                                             decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
//                                                             child: Column(
//                                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                                               children: [
//                                                                 Padding(
//                                                                   padding: const EdgeInsets.all(8.0),
//                                                                   child: Text('배경색깔',style: TextStyle(color: Colors.white),),
//                                                                 ),
//                                                                 Row(
//                                                                   children: [
//                                                                     for (var color in bgColors1)
//                                                                       InkWell(
//                                                                         onTap: () {
//                                                                           BoardController.to.board_bgcolor.value = color;
//                                                                         },
//                                                                         child: Padding(
//                                                                           padding: const EdgeInsets.only(left: 20, ),
//                                                                           child: BoardController.to.board_bgcolor.value == color ?
//                                                                           Icon(Icons.check_circle, color: Color(color), size: 40,) :
//                                                                           Icon(Icons.circle, color: Color(color), size: 40,),
//                                                                         ),
//                                                                       ),
//
//                                                                   ],
//                                                                 ),
//                                                                 Row(
//                                                                   children: [
//                                                                     for (var color in bgColors2)
//                                                                       InkWell(
//                                                                         onTap: () {
//                                                                           BoardController.to.board_bgcolor.value = color;
//                                                                         },
//                                                                         child: Padding(
//                                                                           padding: const EdgeInsets.only(left: 20, top: 7, bottom: 7),
//                                                                           child: BoardController.to.board_bgcolor.value == color ?
//                                                                           Icon(Icons.check_circle, color: Color(color), size: 40,) :
//                                                                           Icon(Icons.circle, color: Color(color), size: 40,),
//                                                                         ),
//                                                                       ),
//
//                                                                   ],
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                       SizedBox(height: 20,),
//                                                       SizedBox(
//                                                         width: 370, height: 150,
//                                                         child: TextField(
//                                                           controller: contentInputController,
//                                                           onChanged: (value) {
//                                                             BoardController.to.mainContentInput = value;
//                                                           },
//                                                           style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 17, ),
//                                                           // minLines: 1,
//                                                           maxLines: 10,
//                                                           decoration: InputDecoration(
//                                                             hintText: '부가적인 설명이 필요한가요?\n이곳에 부가설명을 추가하거나 이미지를 첨부할 수 있습니다.',
//                                                             hintStyle: TextStyle(fontSize: 15, color: Colors.grey.withOpacity(0.5)),
//                                                             // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey, ),),
//                                                             focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
//                                                             enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
//
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       Obx(()=> Row(
//                                                         mainAxisAlignment: MainAxisAlignment.end,
//                                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                                         children: [
//                                                           Container(
//                                                             width: 200, height: 200,
//                                                             child: doc['imageUrl'].length == 0 && BoardController.to.imageModel.value.imageInt8 == null
//                                                                 ? SizedBox()
//                                                                 :
//                                                             Padding(
//                                                               padding: const EdgeInsets.only(top: 10),
//                                                               child: BoardController.to.imageModel.value.imageInt8 == null
//                                                                   ? Stack(children: [
//                                                                 Image.network(doc['imageUrl'],),
//                                                                 Positioned(
//                                                                   child: IconButton(
//                                                                     icon: Icon(Icons.delete, color: Colors.white,),
//                                                                     onPressed: () {
//                                                                       BoardController.to.delImage(doc, 'main');
//                                                                     },
//                                                                   ),
//                                                                 ),
//                                                               ],)
//                                                                   : Image.memory(BoardController.to.imageModel.value.imageInt8!,),
//                                                             ),
//                                                           ),
//                                                           SizedBox(width: 50,),
//                                                           Padding(
//                                                             padding: const EdgeInsets.only(top: 10, right: 15),
//                                                             child: IconButton(
//                                                               icon: Icon(Icons.insert_photo_outlined, size: 30, color: Colors.white,),
//                                                               onPressed: () {
//                                                                 BoardController.to.selectImage();
//                                                               },
//                                                             ),
//                                                           ),
//                                                           Text(BoardController.to.dummy.value.toString(), style: TextStyle(fontSize: 0),),
//                                                         ],
//                                                       ),
//                                                       ),
//                                                     ]
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           pressType: PressType.singleClick,
//                                           verticalMargin: -10,
//                                         ),
//
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                                 ),
//                               ),
//                             );
//
//                           },
//
//                         ),
//                       );
//                   }
//               ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//     );
//
//   }
// }
//
//
