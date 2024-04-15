// import 'package:classdiary2/board_add_mobile.dart';
// import 'package:classdiary2/board_main.dart';
// import 'package:classdiary2/board_upd_mobile.dart';
// // import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
//
// import '../controller/attendance_controller.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:loading_indicator/loading_indicator.dart';
// import 'board_modum.dart';
// import 'controller/board_controller.dart';
// import 'package:get/get.dart';
// import 'dart:js' as js;
//
// import 'controller/subject_controller.dart';
//
// class BoardIndi2 extends StatelessWidget {
//   CustomPopupMenuController popupSettingController = CustomPopupMenuController();
//   CustomPopupMenuController addController = CustomPopupMenuController();
//   TextEditingController titleSettingController = TextEditingController();
//   TextEditingController contentSettingController = TextEditingController();
//   List addControllers = [];
//   List updIndiControllers = [];
//   List updCommentControllers = [];
//   List addCommentControllers = [];
//   List updTitleInputControllers = [];
//   List updContentInputControllers = [];
//   List updCommentInputControllers = [];
//   int indiCnt = 0;
//   int commentCnt = 0;
//   int addCommentCnt = 0;
//   int updTitleCnt = 0;
//   int updContentCnt = 0;
//   int updCommentInputCnt = 0;
//   /// index.html에서 테마색깔 지정, 폰 제일 위 색깔 마추기위해
//   List bg_colors = ['#5CBCCD', '#FBECBC', '#F9F9F9', '#FBFBFB', '#D8F9FE', '#FEF8F5', '#A7D1EB', '#6BD8FA', '#C4D5EE', '#C0E4F8'];
//   List appbar_colors = [0xff56BCCF, 0xffFBECBC, 0xffF9F9F9, 0xffFBFBFB, 0xffD8F9FE, 0xffFEF8F5, 0xffA7D1EB, 0xff6BD8FA, 0xffC4D5EE, 0xffC0E4F8];
//
//   void delDialog(context, main_doc_id, main_id) {
//     showDialog(
//       context: context,
//       barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Color(0xFF4C4C4C),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//           content: Container(
//             width: 200,
//             height: 100,
//             child: Text('정말 삭제하시겠습니까?', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 25,),),
//           ),
//           actions: <Widget>[
//             InkWell(
//               highlightColor: Colors.transparent,
//               hoverColor: Colors.transparent,
//               splashColor: Colors.transparent,
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Image.asset('assets/images/font_cancel.png', height: 32),
//                 // child: Text('취소',style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 20,),),
//               ),
//             ),
//             SizedBox(width: 20,),
//             InkWell(
//               highlightColor: Colors.transparent,
//               hoverColor: Colors.transparent,
//               splashColor: Colors.transparent,
//               onTap: () {
//                 BoardController.to.delBoardMain(main_doc_id, main_id, 'indi');
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Image.asset('assets/images/font_delete.png', height: 32),
//                 // child: Text('삭제', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 20,),),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//
//   }
//
//   void updCommentDialog(context, comment, id) {
//     showDialog(
//       context: context,
//       barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Color(0xFF4C4C4C),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//           content: Container(
//             width: 150,
//             height: 150,
//             color: Color(0xFF4C4C4C),
//             child: IntrinsicWidth(
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text('댓글 수정' ,style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 14, )),
//                     Divider(color: Colors.white.withOpacity(0.3),),
//                     Container(
//                       height: 110,
//                       child: TextField(
//                         controller: TextEditingController(text: comment['comment']),
//                         // textAlignVertical: TextAlignVertical.center,
//                         onChanged: (value) {
//                           BoardController.to.indiCommentInput = value;
//                         },
//                         style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 15, ),
//                         maxLines: 10,
//                         decoration: InputDecoration(
//                           focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
//                           enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent, ),),
//                         ),
//                       ),
//                     ),
//
//                   ]
//               ),
//             ),
//           ),
//           actions: <Widget>[
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   InkWell(
//                     highlightColor: Colors.transparent,
//                     hoverColor: Colors.transparent,
//                     splashColor: Colors.transparent,
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Image.asset('assets/images/font_cancel.png', height: 22),
//                     // child: Text('취소',style: TextStyle(color: Colors.white, fontSize: 17,),),
//                   ),
//                   InkWell(
//                     highlightColor: Colors.transparent,
//                     hoverColor: Colors.transparent,
//                     splashColor: Colors.transparent,
//                     onTap: () {
//                       BoardController.to.delComment(id, comment, 'board_indi');
//                       Navigator.pop(context);
//                     },
//                     child: Image.asset('assets/images/font_delete.png', height: 22),
//                     // child: Text('삭제', style: TextStyle(color: Colors.white, fontSize: 17,),),
//                   ),
//                   InkWell(
//                     highlightColor: Colors.transparent,
//                     hoverColor: Colors.transparent,
//                     splashColor: Colors.transparent,
//                     onTap: () {
//                       BoardController.to.updComment(id, comment, 'board_indi');
//                       Navigator.pop(context);
//                     },
//                     child: Image.asset('assets/images/font_upd.png', height: 22),
//                     // child: Text('수정', style: TextStyle(color: Colors.white, fontSize: 17,),),
//                   ),
//                 ],
//               ),
//             ),
//
//           ],
//         );
//       },
//     );
//
//   }
//
//   void imageDialog(context, id, imageUrl, isDelete) {
//     showDialog(
//       context: context,
//       barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Color(0xFF4C4C4C),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//           content: Container(
//             width: 400,
//             height: 400,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(5.0),
//               child: Image.network(imageUrl),
//             ),
//           ),
//           actions: <Widget>[
//             InkWell(
//               highlightColor: Colors.transparent,
//               hoverColor: Colors.transparent,
//               splashColor: Colors.transparent,
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Image.asset('assets/images/font_close.png', height: 32),
//               ),
//             ),
//             SizedBox(width: 20,),
//             Visibility(
//               visible: isDelete,
//               child: InkWell(
//                 highlightColor: Colors.transparent,
//                 hoverColor: Colors.transparent,
//                 splashColor: Colors.transparent,
//                 onTap: () {
//                   BoardController.to.delImage(id, imageUrl, 'board_indi');
//                   Navigator.pop(context);
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Image.asset('assets/images/font_delete.png', height: 32),
//                 ),
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
//     if (BoardController.to.selected_background.length == 10) {
//       js.context.callMethod("setMetaThemeColor", ['#'+ int.parse(BoardController.to.selected_background).toRadixString(16).toUpperCase().substring(2,8)]);
//     }else {
//       js.context.callMethod("setMetaThemeColor", [ bg_colors[int.parse(BoardController.to.selected_background.substring(2,4))-1] ]);
//     }
//
//     // var bgColors1 = [0xff2B2B2B, 0xffE9E7EA, 0xff668F85, 0xff84A76A, 0xffD3DC7E];
//     // var bgColors2 = [0xffF6EB89, 0xffDCA35D, 0xffC36250, 0xff6994DE, 0xff8739A5];
//     var bgColors = [0xffE9E7EA, 0xff2B2B2B, 0xff668F85, 0xff84A76A, 0xffD3DC7E, 0xffF6EB89, 0xffDCA35D, 0xffC36250, 0xff6994DE, 0xff8739A5];
//     var bgImages = ['bg01', 'bg02', 'bg03', 'bg04', 'bg05', 'bg06', 'bg07', 'bg08', 'bg09', 'bg10'];
//
//
//     // CustomPopupMenuController stampController = CustomPopupMenuController();
//     /// 전체 스탬프 찍기 위해  전체 인텍스 가져오기
//     List allIndexs = [];
//
//     return MediaQuery.of(context).size.width < 600 ?
//     Scaffold(
//       // appBar: AppBar(
//       //   // toolbarHeight: 130,
//       //   automaticallyImplyLeading: false,
//       //   centerTitle: false,
//       //   backgroundColor: BoardController.to.selected_background.length == 10 ?
//       //   Color(int.parse(BoardController.to.selected_background)) :
//       //   Color(appbar_colors[int.parse(BoardController.to.selected_background.substring(2,4))-1]),
//       //   elevation: 0,
//       //   title:
//       //   Padding(
//       //     padding: const EdgeInsets.only(left: 10, right: 10, ),
//       //     child: Row(
//       //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       //       children: [
//       //         /// 홈
//       //         InkWell(
//       //           highlightColor: Colors.transparent,
//       //           hoverColor: Colors.transparent,
//       //           splashColor: Colors.transparent,
//       //           onTap: () {
//       //             Get.off(() => BoardMain());
//       //           },
//       //           child: Padding(
//       //             padding: const EdgeInsets.only(left: 4, top:8,bottom: 8),
//       //             child: Image.asset('assets/images/font_home.png', height: 40),
//       //           ),
//       //           // child: Padding(
//       //           //   padding: const EdgeInsets.all(8.0),
//       //           //   child: Container(
//       //           //     decoration: BoxDecoration(color: Colors.orangeAccent, border: Border.all(color: Colors.white, width: 3), shape: BoxShape.circle,),
//       //           //     height: 30.0,
//       //           //     width: 30.0,
//       //           //     child: Icon(Icons.home, size: 20, color: Colors.black.withOpacity(0.4)),
//       //           //   ),
//       //           // ),
//       //         ),
//       //         /// 설명보기
//       //         BoardController.to.selected_content.length > 0 ?
//       //         CustomPopupMenu(
//       //           arrowSize: 20,
//       //           child: Padding(
//       //             padding: const EdgeInsets.only(left: 8, right: 20, top: 8, bottom: 8),
//       //             child: Image.asset('assets/images/font_hint.png', height: 25),
//       //             // child: Container(
//       //             //   decoration: BoxDecoration(color: Colors.orangeAccent, border: Border.all(color: Colors.white, width: 3), shape: BoxShape.circle,),
//       //             //   height: 30,
//       //             //   width: 30,
//       //             //   child: Icon(Icons.menu_book_rounded, size: 20, color: Colors.black.withOpacity(0.4)),
//       //             // ),
//       //           ),
//       //           menuBuilder: () => ClipRRect(
//       //             borderRadius: BorderRadius.circular(10),
//       //             child: Container(
//       //               width: 300,
//       //               height: 400,
//       //               color: Color(0xFF4C4C4C),
//       //               child: IntrinsicWidth(
//       //                 child: SingleChildScrollView(
//       //                   child: Padding(
//       //                     padding: const EdgeInsets.all(8.0),
//       //                     child: Column(
//       //                         children: [
//       //                           SizedBox(height: 30,),
//       //                           Text(BoardController.to.selected_main_title, style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 18, ),),
//       //                           Padding(
//       //                             padding: const EdgeInsets.all(8.0),
//       //                             child: Divider(color: Colors.white.withOpacity(0.3),),
//       //                           ),
//       //                           Text(BoardController.to.selected_content, style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 15, ),),
//       //                         ]
//       //                     ),
//       //                   ),
//       //                 ),
//       //               ),
//       //             ),
//       //           ),
//       //           pressType: PressType.singleClick,
//       //           verticalMargin: -10,
//       //
//       //         ) : SizedBox(),
//       //       ],
//       //     ),
//       //   ),
//       // ),
//       body: Container(
//         /// 길이가 10이면 배경색깔
//         decoration: BoardController.to.selected_background.length == 10 ?
//         BoxDecoration(color: Color(int.parse(BoardController.to.selected_background))) :
//         BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/' + BoardController.to.selected_background + '.png'), fit: BoxFit.cover, ),),
//         child: Stack(children: [
//           SingleChildScrollView(
//             child: Column(
//               children: [
//                 SizedBox(height: 60,),
//                 /// 제목
//                 Padding(
//                   padding: const EdgeInsets.only(top:8,bottom:8, left: 40, right:40),
//                   child: Container(
//                     // width: MediaQuery.of(context).size.width*0.65,
//                     child: Stack(
//                       children: <Widget>[
//                         Text(
//                           BoardController.to.mainTitleInput,
//                           maxLines: 2,
//                           style: TextStyle(
//                             fontFamily: 'Jua',
//                             fontSize: 22,
//                             foreground: Paint()
//                               ..style = PaintingStyle.stroke
//                               ..strokeWidth = 3
//                               ..color = Colors.black.withOpacity(0.3),
//                           ),
//                         ),
//                         Text(
//                           BoardController.to.mainTitleInput,
//                           maxLines: 2,
//                           style: TextStyle(
//                             fontFamily: 'Jua',
//                             fontSize: 22,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 /// 본문 내용
//                 Padding(
//                   padding: const EdgeInsets.only(left:40, right:40, top:20, bottom: 40),
//                   child: ListView.builder(
//                       shrinkWrap: true,
//                       primary: false,
//                       itemCount: AttendanceController.to.attendanceDocs.length,
//                       itemBuilder: (_, index) {
//                         DocumentSnapshot attendanceDoc = AttendanceController.to.attendanceDocs[index];
//                         addControllers.add(CustomPopupMenuController());
//
//                         return StreamBuilder<QuerySnapshot>(
//                             stream: FirebaseFirestore.instance.collection('board_indi').where('class_code', isEqualTo: GetStorage().read('class_code'))
//                                 .where('main_id', isEqualTo: BoardController.to.selected_main_id).where('number', isEqualTo: attendanceDoc['number'])
//                                 .orderBy('date', descending: true).snapshots(),
//                             builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                               if (!snapshot.hasData) {
//                                 return Center(child: Container(
//                                   height: 40,
//                                   child: LoadingIndicator(
//                                       indicatorType: Indicator.ballPulse,
//                                       colors: BoardController.to.kDefaultRainbowColors,
//                                       strokeWidth: 2,
//                                       backgroundColor: Colors.transparent,
//                                       pathBackgroundColor: Colors.transparent
//                                   ),
//                                 ),);
//                               }
//                               return
//                                 Column(
//                                   children: [
//                                     /// 번호, 이름, 추가아이콘
//                                     Container(
//                                       height: 30,
//                                       decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(8)),
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         children: [
//                                           Text('${attendanceDoc['number']}번  ${attendanceDoc['name']}',  style: TextStyle(fontFamily: 'Jua', fontSize: 16, color: Colors.white),),
//                                         ],
//                                       ),
//                                     ),
//                                     ListView.builder(
//                                         shrinkWrap: true,
//                                         primary: false,
//                                         itemCount: snapshot.data!.docs.length,
//                                         itemBuilder: (_, index) {
//                                           DocumentSnapshot indiDoc = snapshot.data!.docs[index];
//                                           /// 스탬프 전체찍기 위해
//                                           if (!allIndexs.contains('${attendanceDoc['number']}-${index}')) {
//                                             allIndexs.add('${attendanceDoc['number']}-${index}');
//                                           }
//
//                                           // 댓글 날짜순 정렬
//                                           List commentList = indiDoc['comment'];
//                                           commentList.sort((a, b) => a['date'].compareTo(b['date']));
//                                           indiCnt ++;
//                                           updTitleCnt ++;
//                                           updContentCnt ++;
//                                           /// 겹치는거 때문에 obx 처리한 후로 addCommentCnt를 제대로 못가져와서 아래와 같이 처리함
//                                           ///  여기서 addCommentCnt ++ 하면 모든 addCommentCnt가 같은 값 가짐.
//                                           ///  addCommentCnt = 0을 해줘야 리로드시마다 1부터 올라감
//                                           // addCommentCnt ++;
//                                           addCommentCnt = 0;
//                                           updIndiControllers.add(CustomPopupMenuController());
//                                           updTitleInputControllers.add(TextEditingController());
//                                           updContentInputControllers.add(TextEditingController());
//                                           addCommentControllers.add(TextEditingController());
//
//                                           return Padding(
//                                             padding: EdgeInsets.only(top: 10, right: 0),
//                                             child: Container(
//                                               // width: 250,
//                                               decoration: BoxDecoration(
//                                                 color: Colors.white,
//                                                 borderRadius: BorderRadius.circular(8),
//                                                 boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.7), spreadRadius: 0, blurRadius: 2.0, offset: Offset(0, 3), ),],
//                                               ),
//                                               child: Padding(
//                                                 padding: const EdgeInsets.all(15.0),
//                                                 child: Column(
//                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                   children: [
//                                                     /// 제목
//                                                     Row(
//                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                       children: [
//                                                         Text(indiDoc['title'],  style: TextStyle(fontFamily: 'Jua', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
//                                                         GetStorage().read('number') == indiDoc['number'] ?
//                                                         /// 수정아이콘
//                                                         InkWell(
//                                                             highlightColor: Colors.transparent,
//                                                             hoverColor: Colors.transparent,
//                                                             splashColor: Colors.transparent,
//                                                             onTap: () {
//                                                               /// 이거안하면 텍스트필드 onchange없으면 널값 됨
//                                                               BoardController.to.indiTitleInput = indiDoc['title'];
//                                                               BoardController.to.indiContent = indiDoc['content'];
//                                                               // Get.off(() => BoardUpdMoblie(), arguments: {'indiDoc' : indiDoc, 'type': 'indi'}, );
//                                                               Get.off(() => BoardUpdMoblie(), arguments: {'indiDoc' : indiDoc, 'type': 'indi', 'title' : BoardController.to.selected_main_title, 'main_id' : BoardController.to.selected_main_id, 'background': BoardController.to.selected_background,
//                                                                 'content': BoardController.to.selected_content, 'id': BoardController.to.selected_id,}, );
//                                                             },
//                                                             child: Icon(Icons.edit_outlined, size: 20, color: Colors.black.withOpacity(0.3),)) :
//                                                         SizedBox(),
//
//                                                       ],
//                                                     ),
//                                                     SizedBox(height: 5,),
//                                                     /// 내용, 이미지로딩중
//                                                     Obx(() => Stack(children: [
//                                                       indiDoc['content'].length > 0 ?
//                                                       Text(indiDoc['content'],  style: TextStyle(fontFamily: 'Jua', fontSize: 15, color: Colors.black,),) : SizedBox(),
//                                                       BoardController.to.isImageLoading.value == true && indiDoc['number'] == GetStorage().read('number') && index == 0 ?
//                                                       Center(child: Container(
//                                                         height: 40,
//                                                         child: LoadingIndicator(
//                                                             indicatorType: Indicator.ballPulse,
//                                                             colors: BoardController.to.kDefaultRainbowColors,
//                                                             strokeWidth: 2,
//                                                             backgroundColor: Colors.transparent,
//                                                             pathBackgroundColor: Colors.transparent
//                                                         ),
//                                                       ),) : SizedBox(),
//                                                     ],),
//                                                     ),
//                                                     /// 내용
//                                                     // Container(
//                                                     //   // width: 250,
//                                                     //   // constraints: BoxConstraints(minHeight: 30),
//                                                     //   child: Text(indiDoc['content'],  style: TextStyle(fontFamily: 'Jua', fontSize: 15, color: Colors.black,),),
//                                                     // ),
//                                                     SizedBox(height: 5,),
//                                                     /// 이미지
//                                                     indiDoc['imageUrl'].length != 0 ?
//                                                     InkWell(
//                                                       onTap: () {
//                                                         if (GetStorage().read('number') == indiDoc['number']) {
//                                                           imageDialog(context, indiDoc.id, indiDoc['imageUrl'], true);
//                                                         }else {
//                                                           imageDialog(context, indiDoc.id, indiDoc['imageUrl'], false);
//                                                         }
//
//                                                       },
//                                                       child: ClipRRect(
//                                                         borderRadius: BorderRadius.circular(5.0),
//                                                         child: Image.network(indiDoc['imageUrl']),
//                                                       ),
//                                                     )
//                                                         : SizedBox(),
//
//                                                     /// 이모티콘
//                                                     indiDoc['stamp'] == '' ? SizedBox() :
//                                                     Row(
//                                                       children: [
//                                                         Expanded(child: SizedBox()),
//                                                         Container(
//                                                           height: 32,
//                                                           child: Image.asset('assets/images/${indiDoc['stamp']}'),
//                                                         ),
//                                                       ],
//                                                     ),
//
//                                                     Divider(color: Colors.black,),
//                                                     /// 좋아요
//                                                     Row(
//                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                       children: [
//                                                         Row(
//                                                           children: [
//                                                             InkWell(
//                                                               highlightColor: Colors.transparent,
//                                                               hoverColor: Colors.transparent,
//                                                               splashColor: Colors.transparent,
//                                                               onTap: () {
//                                                                 if (indiDoc['like'].contains(GetStorage().read('number'))) {
//                                                                   BoardController.to.delLike(indiDoc.id, GetStorage().read('number'), 'board_indi');
//                                                                 }else {
//                                                                   BoardController.to.addLike(indiDoc.id, GetStorage().read('number'), 'board_indi');
//                                                                 }
//                                                               },
//                                                               child: Container(
//                                                                 width: 30,
//                                                                 child: indiDoc['like'].contains(GetStorage().read('number')) == true ?
//                                                                 Icon(Icons.favorite, size: 20, color: Colors.red,) :
//                                                                 Icon(Icons.favorite_border_outlined, size: 20, color: Colors.black,),
//                                                               ),
//                                                             ),
//                                                             Text(indiDoc['like'].length.toString(), style: TextStyle(color: Colors.black),),
//                                                           ],
//                                                         ),
//                                                         GetStorage().read('job') == 'teacher' ?
//                                                         /// 스탬프아이콘
//                                                         InkWell(
//                                                           highlightColor: Colors.transparent,
//                                                           hoverColor: Colors.transparent,
//                                                           splashColor: Colors.transparent,
//                                                           onTap: () {
//                                                             if (indiDoc['stamp'] == '') {
//                                                               BoardController.to.selectedStamp.value = 'stamp1.png';
//                                                               BoardController.to.addStamp(indiDoc.id, 'board_indi');
//                                                             }else if (indiDoc['stamp'] == 'stamp1.png') {
//                                                               BoardController.to.selectedStamp.value = 'stamp2.png';
//                                                               BoardController.to.addStamp(indiDoc.id, 'board_indi');
//                                                             }else if (indiDoc['stamp'] == 'stamp2.png') {
//                                                               BoardController.to.selectedStamp.value = 'stamp3.png';
//                                                               BoardController.to.addStamp(indiDoc.id, 'board_indi');
//                                                             }else if (indiDoc['stamp'] == 'stamp3.png') {
//                                                               BoardController.to.selectedStamp.value = 'stamp4.png';
//                                                               BoardController.to.addStamp(indiDoc.id, 'board_indi');
//                                                             }else if (indiDoc['stamp'] == 'stamp4.png') {
//                                                               BoardController.to.selectedStamp.value = 'stamp5.png';
//                                                               BoardController.to.addStamp(indiDoc.id, 'board_indi');
//                                                             }else if (indiDoc['stamp'] == 'stamp5.png') {
//                                                               BoardController.to.selectedStamp.value = 'stamp6.png';
//                                                               BoardController.to.addStamp(indiDoc.id, 'board_indi');
//                                                             } else {
//                                                               BoardController.to.selectedStamp.value = '';
//                                                               BoardController.to.delStamp(indiDoc.id, 'board_indi');
//                                                             }
//                                                           },
//                                                           child:  Image.asset('assets/images/stamp.png', width: 28, color: Colors.black.withOpacity(0.7),),
//                                                         ) : SizedBox(),
//                                                       ],
//                                                     ),
//                                                     SizedBox(height: 5,),
//                                                     /// 댓글허용 여부
//                                                     StreamBuilder<QuerySnapshot>(
//                                                         stream: FirebaseFirestore.instance.collection('board_main').where('class_code', isEqualTo: GetStorage().read('class_code'))
//                                                             .where('main_id', isEqualTo: BoardController.to.selected_main_id).snapshots(),
//                                                         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                                                           if (!snapshot.hasData) {
//                                                             return SizedBox();
//                                                           }
//                                                           return
//                                                             Visibility(
//                                                               visible: snapshot.data!.docs.first['isAcceptComment'],
//                                                               child: Column(
//                                                                 children: [
//                                                                   /// 댓글리스트
//                                                                   ListView.builder(
//                                                                       shrinkWrap: true,
//                                                                       itemCount: commentList.length,
//                                                                       itemBuilder: (_, index) {
//                                                                         commentCnt ++;
//                                                                         updCommentControllers.add(CustomPopupMenuController());
//                                                                         updCommentInputCnt ++;
//                                                                         updCommentInputControllers.add(TextEditingController());
//                                                                         return Column(
//                                                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                                                           children: [
//                                                                             Row(
//                                                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                                               children: [
//                                                                                 Row(
//                                                                                   children: [
//                                                                                     Text(commentList[index]['name'], style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 11),),
//                                                                                     SizedBox(width: 2,),
//                                                                                     Text('('+commentList[index]['date'].toDate().month.toString()+'.'+commentList[index]['date'].toDate().day.toString()+' '+
//                                                                                         commentList[index]['date'].toDate().hour.toString()+':'+commentList[index]['date'].toDate().minute.toString()+')',
//                                                                                       style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 11),),
//                                                                                   ],
//                                                                                 ),
//                                                                                 GetStorage().read('name') == commentList[index]['name'] ?
//                                                                                 /// 댓글수정아이콘
//                                                                                 InkWell(
//                                                                                   highlightColor: Colors.transparent,
//                                                                                   hoverColor: Colors.transparent,
//                                                                                   splashColor: Colors.transparent,
//                                                                                   onTap: () {
//                                                                                     updCommentDialog(context, commentList[index], indiDoc.id);
//                                                                                   },
//                                                                                   child: Icon(Icons.edit_outlined, size: 17, color: Colors.black.withOpacity(0.3),),
//                                                                                 )
//                                                                                     : SizedBox(),
//                                                                               ],
//                                                                             ),
//                                                                             Text(commentList[index]['comment'], style: TextStyle(fontSize: 12, color: Colors.black,),),
//                                                                             SizedBox(height: 3,),
//                                                                           ],
//                                                                         );
//                                                                       }
//                                                                   ),
//                                                                   /// 이거 안해주면 index 에러남
//                                                                   Text((addCommentCnt++).toString(), style: TextStyle(fontSize: 0),),
//                                                                   /// 댓글입력
//                                                                   Container(
//                                                                     height: 28,
//                                                                     child: TextField(
//                                                                       controller: addCommentControllers[addCommentCnt - 1],
//                                                                       textAlignVertical: TextAlignVertical.center,
//                                                                       onSubmitted: (value) {
//                                                                         BoardController.to.saveComment(indiDoc, value, 'board_indi');
//                                                                         // addCommentControllers[addCommentCnt - 1].clear();
//                                                                         for(var con in addCommentControllers)
//                                                                           con.clear();
//                                                                       },
//
//                                                                       style: TextStyle(fontFamily: 'Jua', color: Colors.black, fontSize: 14, ),
//                                                                       // minLines: 1,
//                                                                       maxLines: 1,
//                                                                       decoration: InputDecoration(
//                                                                         hintText: '댓글 입력',
//                                                                         hintStyle: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.5)),
//                                                                         // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey, ),),
//                                                                         focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
//                                                                         enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
//                                                                         contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             );
//                                                         }
//                                                     ),
//
//                                                   ],
//                                                 ),
//
//
//                                               ),
//                                             ),
//                                           );
//                                         }
//                                     ),
//                                     SizedBox(height: 30,),
//                                   ],
//                                 );
//                             }
//                         );
//                       }
//                   ),
//                   // child: Container(
//                   //   child: AlignedGridView.count(
//                   //     shrinkWrap: true,
//                   //     physics: NeverScrollableScrollPhysics(),
//                   //     crossAxisCount: 1,
//                   //     // crossAxisCount: MediaQuery.of(context).size.width > 2000 ? 7 : 6,
//                   //     mainAxisSpacing: 50,  // 아래쪽과의 차이
//                   //     crossAxisSpacing: 14,
//                   //     itemCount: AttendanceController.to.attendanceDocs.length,
//                   //     itemBuilder: (context, index) {
//                   //       DocumentSnapshot attendanceDoc = AttendanceController.to.attendanceDocs[index];
//                   //       addControllers.add(CustomPopupMenuController());
//                   //       return StreamBuilder<QuerySnapshot>(
//                   //           stream: FirebaseFirestore.instance.collection('board_indi').where('class_code', isEqualTo: GetStorage().read('class_code'))
//                   //               .where('main_id', isEqualTo: BoardController.to.selected_main_id).where('number', isEqualTo: attendanceDoc['number'])
//                   //               .orderBy('date', descending: true).snapshots(),
//                   //           builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                   //             if (!snapshot.hasData) {
//                   //               return Center(child: Container(
//                   //                 height: 40,
//                   //                 child: LoadingIndicator(
//                   //                     indicatorType: Indicator.ballPulse,
//                   //                     colors: BoardController.to.kDefaultRainbowColors,
//                   //                     strokeWidth: 2,
//                   //                     backgroundColor: Colors.transparent,
//                   //                     pathBackgroundColor: Colors.transparent
//                   //                 ),
//                   //               ),);
//                   //             }
//                   //             return
//                   //               Column(
//                   //                 children: [
//                   //                   /// 번호, 이름, 추가아이콘
//                   //                   Container(
//                   //                     height: 30,
//                   //                     decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(8)),
//                   //                     child: Row(
//                   //                       mainAxisAlignment: MainAxisAlignment.center,
//                   //                       children: [
//                   //                         Text('${attendanceDoc['number']}번  ${attendanceDoc['name']}',  style: TextStyle(fontFamily: 'Jua', fontSize: 16, color: Colors.white),),
//                   //                       ],
//                   //                     ),
//                   //                   ),
//                   //                   ListView.builder(
//                   //                       shrinkWrap: true,
//                   //                       itemCount: snapshot.data!.docs.length,
//                   //                       itemBuilder: (_, index) {
//                   //
//                   //                         DocumentSnapshot indiDoc = snapshot.data!.docs[index];
//                   //                         /// 스탬프 전체찍기 위해
//                   //                         if (!allIndexs.contains('${attendanceDoc['number']}-${index}')) {
//                   //                           allIndexs.add('${attendanceDoc['number']}-${index}');
//                   //                         }
//                   //
//                   //                         // 댓글 날짜순 정렬
//                   //                         List commentList = indiDoc['comment'];
//                   //                         commentList.sort((a, b) => a['date'].compareTo(b['date']));
//                   //                         indiCnt ++;
//                   //                         updTitleCnt ++;
//                   //                         updContentCnt ++;
//                   //                         /// 겹치는거 때문에 obx 처리한 후로 addCommentCnt를 제대로 못가져와서 아래와 같이 처리함
//                   //                         ///  여기서 addCommentCnt ++ 하면 모든 addCommentCnt가 같은 값 가짐.
//                   //                         ///  addCommentCnt = 0을 해줘야 리로드시마다 1부터 올라감
//                   //                         // addCommentCnt ++;
//                   //                         addCommentCnt = 0;
//                   //                         updIndiControllers.add(CustomPopupMenuController());
//                   //                         updTitleInputControllers.add(TextEditingController());
//                   //                         updContentInputControllers.add(TextEditingController());
//                   //                         addCommentControllers.add(TextEditingController());
//                   //
//                   //                         return Padding(
//                   //                           padding: EdgeInsets.only(top: 10, right: 0),
//                   //                           child: Container(
//                   //                             // width: 250,
//                   //                             decoration: BoxDecoration(
//                   //                               color: Colors.white,
//                   //                               borderRadius: BorderRadius.circular(8),
//                   //                               boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.7), spreadRadius: 0, blurRadius: 2.0, offset: Offset(0, 3), ),],
//                   //                             ),
//                   //                             child: Padding(
//                   //                               padding: const EdgeInsets.all(15.0),
//                   //                               child: Column(
//                   //                                 crossAxisAlignment: CrossAxisAlignment.start,
//                   //                                 children: [
//                   //                                   /// 제목
//                   //                                   Row(
//                   //                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   //                                     children: [
//                   //                                       Text(indiDoc['title'],  style: TextStyle(fontFamily: 'Jua', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
//                   //                                       GetStorage().read('number') == indiDoc['number'] || GetStorage().read('job') == 'teacher' ?
//                   //                                       /// 수정아이콘
//                   //
//                   //                                       InkWell(
//                   //                                           onTap: () {
//                   //                                             /// 이거안하면 텍스트필드 onchange없으면 널값 됨
//                   //                                             BoardController.to.indiTitleInput = indiDoc['title'];
//                   //                                             BoardController.to.indiContent = indiDoc['content'];
//                   //                                             Get.to(() => BoardUpdMoblie(), arguments: {'indiDoc' : indiDoc, 'type': 'indi'}, );
//                   //                                             // Get.to(() => BoardUpdMoblie(), arguments: {'indiDoc' : indiDoc, 'type': 'indi', 'title' : BoardController.to.selected_main_title, 'main_id' : BoardController.to.selected_main_id, 'background': BoardController.to.selected_background,
//                   //                                             //   'content': BoardController.to.selected_content, 'id': BoardController.to.selected_id,}, );
//                   //                                           },
//                   //                                           child: Icon(Icons.edit_outlined, size: 20, color: Colors.black.withOpacity(0.3),)) :
//                   //                                       SizedBox(),
//                   //
//                   //                                     ],
//                   //                                   ),
//                   //                                   /// 내용
//                   //                                   Container(
//                   //                                     // width: 250,
//                   //                                     // constraints: BoxConstraints(minHeight: 30),
//                   //                                     child: Text(indiDoc['content'],  style: TextStyle(fontFamily: 'Jua', fontSize: 15, color: Colors.black,),),
//                   //                                   ),
//                   //                                   SizedBox(height: 5,),
//                   //                                   /// 이미지
//                   //                                   indiDoc['imageUrl'].length != 0 ?
//                   //                                   ClipRRect(
//                   //                                     borderRadius: BorderRadius.circular(5.0),
//                   //                                     child: Image.network(indiDoc['imageUrl']),
//                   //                                   )
//                   //                                       : SizedBox(),
//                   //
//                   //                                   /// 이모티콘
//                   //                                   indiDoc['stamp'] == '' ? SizedBox() :
//                   //                                   Row(
//                   //                                     children: [
//                   //                                       Expanded(child: SizedBox()),
//                   //                                       Container(
//                   //                                         height: 32,
//                   //                                         child: Image.asset('assets/images/${indiDoc['stamp']}'),
//                   //                                       ),
//                   //                                     ],
//                   //                                   ),
//                   //
//                   //                                   Divider(color: Colors.black,),
//                   //                                   /// 좋아요
//                   //                                   Row(
//                   //                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   //                                     children: [
//                   //                                       Row(
//                   //                                         children: [
//                   //                                           InkWell(
//                   //                                             onTap: () {
//                   //                                               if (indiDoc['like'].contains(GetStorage().read('number'))) {
//                   //                                                 BoardController.to.delLike(indiDoc.id, GetStorage().read('number'), 'board_indi');
//                   //                                               }else {
//                   //                                                 BoardController.to.addLike(indiDoc.id, GetStorage().read('number'), 'board_indi');
//                   //                                               }
//                   //                                             },
//                   //                                             child: Container(
//                   //                                               width: 30,
//                   //                                               child: indiDoc['like'].contains(GetStorage().read('number')) == true ?
//                   //                                               Icon(Icons.favorite, size: 20, color: Colors.red,) :
//                   //                                               Icon(Icons.favorite_border_outlined, size: 20, color: Colors.black,),
//                   //                                             ),
//                   //                                           ),
//                   //                                           Text(indiDoc['like'].length.toString(), style: TextStyle(color: Colors.black),),
//                   //                                         ],
//                   //                                       ),
//                   //                                       GetStorage().read('job') == 'teacher' ?
//                   //                                       /// 스탬프아이콘
//                   //                                       InkWell(
//                   //                                         onTap: () {
//                   //                                           if (indiDoc['stamp'] == '') {
//                   //                                             BoardController.to.selectedStamp.value = 'stamp1.png';
//                   //                                             BoardController.to.addStamp(indiDoc.id, 'board_indi');
//                   //                                           }else if (indiDoc['stamp'] == 'stamp1.png') {
//                   //                                             BoardController.to.selectedStamp.value = 'stamp2.png';
//                   //                                             BoardController.to.addStamp(indiDoc.id, 'board_indi');
//                   //                                           }else if (indiDoc['stamp'] == 'stamp2.png') {
//                   //                                             BoardController.to.selectedStamp.value = 'stamp3.png';
//                   //                                             BoardController.to.addStamp(indiDoc.id, 'board_indi');
//                   //                                           }else if (indiDoc['stamp'] == 'stamp3.png') {
//                   //                                             BoardController.to.selectedStamp.value = 'stamp4.png';
//                   //                                             BoardController.to.addStamp(indiDoc.id, 'board_indi');
//                   //                                           }else if (indiDoc['stamp'] == 'stamp4.png') {
//                   //                                             BoardController.to.selectedStamp.value = 'stamp5.png';
//                   //                                             BoardController.to.addStamp(indiDoc.id, 'board_indi');
//                   //                                           }else if (indiDoc['stamp'] == 'stamp5.png') {
//                   //                                             BoardController.to.selectedStamp.value = 'stamp6.png';
//                   //                                             BoardController.to.addStamp(indiDoc.id, 'board_indi');
//                   //                                           } else {
//                   //                                             BoardController.to.selectedStamp.value = '';
//                   //                                             BoardController.to.delStamp(indiDoc.id, 'board_indi');
//                   //                                           }
//                   //                                         },
//                   //                                         child:  Image.asset('assets/images/stamp.png', width: 28, color: Colors.black.withOpacity(0.7),),
//                   //                                       ) : SizedBox(),
//                   //                                     ],
//                   //                                   ),
//                   //                                   SizedBox(height: 5,),
//                   //                                   /// 댓글허용 여부
//                   //                                   StreamBuilder<QuerySnapshot>(
//                   //                                       stream: FirebaseFirestore.instance.collection('board_main').where('class_code', isEqualTo: GetStorage().read('class_code'))
//                   //                                           .where('main_id', isEqualTo: BoardController.to.selected_main_id).snapshots(),
//                   //                                       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                   //                                         if (!snapshot.hasData) {
//                   //                                           return SizedBox();
//                   //                                         }
//                   //                                         return
//                   //                                           Visibility(
//                   //                                             visible: snapshot.data!.docs.first['isAcceptComment'],
//                   //                                             child: Column(
//                   //                                               children: [
//                   //                                                 /// 댓글리스트
//                   //                                                 ListView.builder(
//                   //                                                     shrinkWrap: true,
//                   //                                                     itemCount: commentList.length,
//                   //                                                     itemBuilder: (_, index) {
//                   //                                                       commentCnt ++;
//                   //                                                       updCommentControllers.add(CustomPopupMenuController());
//                   //                                                       updCommentInputCnt ++;
//                   //                                                       updCommentInputControllers.add(TextEditingController());
//                   //                                                       return Column(
//                   //                                                         crossAxisAlignment: CrossAxisAlignment.start,
//                   //                                                         children: [
//                   //                                                           Row(
//                   //                                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   //                                                             children: [
//                   //                                                               Row(
//                   //                                                                 children: [
//                   //                                                                   Text(commentList[index]['name'], style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 11),),
//                   //                                                                   SizedBox(width: 2,),
//                   //                                                                   Text('('+commentList[index]['date'].toDate().month.toString()+'.'+commentList[index]['date'].toDate().day.toString()+' '+
//                   //                                                                       commentList[index]['date'].toDate().hour.toString()+':'+commentList[index]['date'].toDate().minute.toString()+')',
//                   //                                                                     style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 11),),
//                   //                                                                 ],
//                   //                                                               ),
//                   //                                                               GetStorage().read('name') == commentList[index]['name'] ?
//                   //                                                               /// 댓글수정아이콘
//                   //                                                               InkWell(
//                   //                                                                 onTap: () {
//                   //                                                                   updCommentDialog(context, commentList[index], indiDoc.id);
//                   //                                                                 },
//                   //                                                                 child: Icon(Icons.edit_outlined, size: 17, color: Colors.black.withOpacity(0.3),),
//                   //                                                               )
//                   //                                                                   : SizedBox(),
//                   //                                                             ],
//                   //                                                           ),
//                   //                                                           Text(commentList[index]['comment'], style: TextStyle(fontSize: 12, color: Colors.black,),),
//                   //                                                           SizedBox(height: 3,),
//                   //                                                         ],
//                   //                                                       );
//                   //                                                     }
//                   //                                                 ),
//                   //                                                 /// 이거 안해주면 index 에러남
//                   //                                                 Text((addCommentCnt++).toString(), style: TextStyle(fontSize: 0),),
//                   //                                                 /// 댓글입력
//                   //                                                 Container(
//                   //                                                   height: 28,
//                   //                                                   child: TextField(
//                   //                                                     controller: addCommentControllers[addCommentCnt - 1],
//                   //                                                     textAlignVertical: TextAlignVertical.center,
//                   //                                                     onSubmitted: (value) {
//                   //                                                       BoardController.to.saveComment(indiDoc, value, 'board_indi');
//                   //                                                       // addCommentControllers[addCommentCnt - 1].clear();
//                   //                                                       for(var con in addCommentControllers)
//                   //                                                         con.clear();
//                   //                                                     },
//                   //
//                   //                                                     style: TextStyle(fontFamily: 'Jua', color: Colors.black, fontSize: 14, ),
//                   //                                                     // minLines: 1,
//                   //                                                     maxLines: 1,
//                   //                                                     decoration: InputDecoration(
//                   //                                                       hintText: '댓글 입력',
//                   //                                                       hintStyle: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.5)),
//                   //                                                       // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey, ),),
//                   //                                                       focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
//                   //                                                       enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
//                   //                                                       contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//                   //
//                   //                                                     ),
//                   //                                                   ),
//                   //                                                 ),
//                   //                                               ],
//                   //                                             ),
//                   //                                           );
//                   //                                       }
//                   //                                   ),
//                   //
//                   //                                 ],
//                   //                               ),
//                   //
//                   //
//                   //                             ),
//                   //                           ),
//                   //                         );
//                   //                       }
//                   //                   ),
//                   //
//                   //                 ],
//                   //               );
//                   //           }
//                   //       );
//                   //     },
//                   //   ),
//                   // ),
//                 ),
//                 SizedBox(height: 100,),
//               ],
//             ),
//           ),
//           /// 윗줄
//           Padding(
//             padding: const EdgeInsets.only(left: 10,),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 /// 홈
//                 InkWell(
//                   highlightColor: Colors.transparent,
//                   hoverColor: Colors.transparent,
//                   splashColor: Colors.transparent,
//                   onTap: () {
//                     Get.off(() => BoardMain());
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.only(top:10, bottom: 10, left: 20, right: 20),
//                     child: Image.asset('assets/images/font_home.png', height: 40),
//                   ),
//                   // child: Padding(
//                   //   padding: const EdgeInsets.all(8.0),
//                   //   child: Container(
//                   //     decoration: BoxDecoration(color: Colors.orangeAccent, border: Border.all(color: Colors.white, width: 3), shape: BoxShape.circle,),
//                   //     height: 30.0,
//                   //     width: 30.0,
//                   //     child: Icon(Icons.home, size: 20, color: Colors.black.withOpacity(0.4)),
//                   //   ),
//                   // ),
//                 ),
//                 SizedBox(width: 10,),
//                 /// 힌트
//                 BoardController.to.selected_content.length > 0 ?
//                 CustomPopupMenu(
//                   arrowSize: 20,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 8, right: 20, top: 8, bottom: 8),
//                     child: Image.asset('assets/images/font_hint.png', height: 25),
//                     // child: Container(
//                     //   decoration: BoxDecoration(color: Colors.orangeAccent, border: Border.all(color: Colors.white, width: 3), shape: BoxShape.circle,),
//                     //   height: 30,
//                     //   width: 30,
//                     //   child: Icon(Icons.menu_book_rounded, size: 20, color: Colors.black.withOpacity(0.4)),
//                     // ),
//                   ),
//                   menuBuilder: () => ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: Container(
//                       width: 300,
//                       height: 400,
//                       color: Color(0xFF4C4C4C),
//                       child: IntrinsicWidth(
//                         child: SingleChildScrollView(
//                           child: Padding(
//                             padding: const EdgeInsets.all(15),
//                             child: Column(
//                                 children: [
//                                   SizedBox(height: 30,),
//                                   Text(BoardController.to.selected_main_title, style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 18, ),),
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Divider(color: Colors.white.withOpacity(0.3),),
//                                   ),
//                                   Text(BoardController.to.selected_content, style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 15, ),),
//                                 ]
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   pressType: PressType.singleClick,
//                   verticalMargin: -10,
//
//                 ) : SizedBox(),
//                 Spacer(),
//                 Padding(
//                   padding: const EdgeInsets.only(top:10, bottom: 10, left: 20, right: 20),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Icon(Icons.person, color: Colors.teal,),
//                       SizedBox(width: 5,),
//                       Text(GetStorage().read('name'), style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 16),),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//         ),
//
//
//       ),
//       floatingActionButton: FloatingActionButton(
//         heroTag: "btn1",
//         backgroundColor: Colors.transparent,
//         onPressed: () {
//           /// 이거 안하면 수정 누른후 바로 추가 누르면 제목,내용 가지고 옴
//           BoardController.to.indiTitleInput = '';
//           BoardController.to.indiContent = '';
//
//           /// 폰의 bottom sheet가 argument를 받지못해서, 데스크탑에선 귀찮아서 그냥 argument 받음
//           /// 폰에서 이미지를 추가하면 회색 먹통이 되어서 다시 원복함. ㅠㅠ
//           // BoardController.to.mainId = BoardController.to.selected_main_id;
//
//           // showCupertinoModalBottomSheet(
//           //   enableDrag: true,
//           //   expand: true,
//           //   context: context,
//           //   builder: (context) => Scaffold(
//           //     backgroundColor: Color(0xFF4C4C4C),
//           //     appBar: AppBar(
//           //       automaticallyImplyLeading: false, /// back button 제거
//           //       centerTitle: false,
//           //       backgroundColor: Color(0xFF4C4C4C),
//           //       elevation: 0,
//           //       title:
//           //       Padding(
//           //         padding: const EdgeInsets.all(8.0),
//           //         child: Row(
//           //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //           children: [
//           //             InkWell(
//           //               onTap: () {
//           //                 Navigator.pop(context);
//           //               },
//           //               child: Icon(Icons.cancel, color: Colors.grey, size: 30,),
//           //             ),
//           //             Row(
//           //               children: [
//           //                 SizedBox(
//           //                   height: 30,
//           //                   child: OutlinedButton(
//           //                     style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.white),),
//           //                     onPressed: () {
//           //                       BoardController.to.selectImage();
//           //                     }, // onPressed
//           //                     child: Text('사진', style: TextStyle(color: Colors.white, fontSize: 15),),
//           //                   ),
//           //                 ),
//           //                 SizedBox(width: 15,),
//           //                 SizedBox(
//           //                   height: 30,
//           //                   child: OutlinedButton(
//           //                     style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.white),),
//           //                     onPressed: () {
//           //                       if (BoardController.to.indiTitleInput.length > 0) {
//           //                         // if (Get.arguments['type'] == 'indi') {
//           //                         //   BoardController.to.saveBoardIndi(BoardController.to.selected_main_id, GetStorage().read('number'),);
//           //                         //   Get.off(() => BoardIndi(), arguments: {'title' : BoardController.to.selected_main_title, 'main_id' : BoardController.to.selected_main_id, 'background': BoardController.to.selected_background,
//           //                         //     'content': BoardController.to.selected_content, 'id': BoardController.to.selected_id});
//           //                         // }else {
//           //                         //   BoardController.to.saveBoardModum(BoardController.to.selected_main_id, Get.arguments['modum_number'],);
//           //                         //   Get.off(() => BoardModum(), arguments: {'title' : BoardController.to.selected_main_title, 'main_id' : BoardController.to.selected_main_id, 'background': BoardController.to.selected_background,
//           //                         //     'content': BoardController.to.selected_content, 'id': BoardController.to.selected_id, 'modums': Get.arguments['modums']});
//           //                         // }
//           //                         BoardController.to.saveBoardIndi(BoardController.to.mainId, GetStorage().read('number'),);
//           //                         BoardController.to.imageModel.value.imageInt8 == null;
//           //                       }
//           //
//           //                       Navigator.pop(context);
//           //
//           //                     }, // onPressed
//           //                     child: Text('저장', style: TextStyle(color: Colors.white, fontSize: 15),),
//           //                   ),
//           //                 ),
//           //               ],
//           //             ),
//           //
//           //           ],
//           //         ),
//           //       ),
//           //     ),
//           //     body: SingleChildScrollView(
//           //       child: Obx(() => Column(
//           //         // crossAxisAlignment: CrossAxisAlignment.center,
//           //           children: [
//           //             Padding(
//           //               padding: const EdgeInsets.only(left: 18, right: 18, top: 18),
//           //               child: SizedBox(
//           //                 // width: 350,
//           //                 height: 30,
//           //                 child: TextField(
//           //                   // textAlignVertical: TextAlignVertical.center,
//           //                   onChanged: (value) {
//           //                     BoardController.to.indiTitleInput = value;
//           //                   },
//           //                   style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 17, ),
//           //                   // minLines: 1,
//           //                   maxLines: 1,
//           //                   decoration: InputDecoration(
//           //                     hintText: '제목을 입력하세요',
//           //                     hintStyle: TextStyle(fontSize: 17, color: Colors.grey.withOpacity(0.5)),
//           //                     focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
//           //                     // focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
//           //                     enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent, ),),
//           //                     // enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
//           //                     // contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//           //
//           //                   ),
//           //                 ),
//           //               ),
//           //             ),
//           //             Padding(
//           //               padding: const EdgeInsets.only(left: 18, right: 18),
//           //               child: Divider(color: Colors.grey.withOpacity(0.3),),
//           //             ),
//           //             Padding(
//           //               padding: const EdgeInsets.only(left: 18, right: 18, bottom: 10),
//           //               child: SizedBox(
//           //                 // width: 350,
//           //                 height: 250,
//           //                 child: TextField(
//           //                   onChanged: (value) {
//           //                     BoardController.to.indiContent = value;
//           //                   },
//           //                   style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 17, ),
//           //                   minLines: 10,
//           //                   maxLines: null,
//           //                   decoration: InputDecoration(
//           //                     hintText: '내용을 입력하세요',
//           //                     hintStyle: TextStyle(fontSize: 17, color: Colors.grey.withOpacity(0.5)),
//           //                     focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
//           //                     // focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
//           //                     enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent, ),),
//           //                     // enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
//           //                   ),
//           //                 ),
//           //               ),
//           //             ),
//           //
//           //             Padding(
//           //               padding: const EdgeInsets.only(top: 8, bottom: 8, right: 15, left: 15),
//           //               child: Container(
//           //                 width: MediaQuery.of(context).size.width,
//           //                 child: BoardController.to.imageModel.value.imageInt8 == null ?
//           //                 SizedBox() :
//           //                 ClipRRect(
//           //                     borderRadius: BorderRadius.circular(8.0),
//           //                     child: Image.memory(BoardController.to.imageModel.value.imageInt8!, fit: BoxFit.fill)),
//           //               ),
//           //             ),
//           //             Text(BoardController.to.dummy.value.toString(), style: TextStyle(fontSize: 0),),
//           //
//           //           ]
//           //       ),
//           //       ),
//           //     ),
//           //   ),
//           // );
//
//           /// argument 안넘기고 저장후 get.back하면 폰에서는 회색화면만 뜸
//           Get.off(() => BoardAddMoblie(), arguments: {'title' : BoardController.to.selected_main_title, 'main_id' : BoardController.to.selected_main_id, 'background': BoardController.to.selected_background,
//             'content': BoardController.to.selected_content, 'id': BoardController.to.selected_id, 'type': 'indi'});
//         },
//         child: Container(
//           decoration: BoxDecoration(color: Colors.orangeAccent, border: Border.all(color: Colors.white, width: 3), shape: BoxShape.circle,),
//           height: 70.0,
//           width: 70.0,
//           child: Icon(Icons.add, size: 40, color: Colors.white),
//         ),
//       ),
//     ) :
//     Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           // color: Color(Get.arguments['bg_color']),
//           /// 길이가 10이면 배경색깔
//           decoration: BoardController.to.selected_background.length == 10 ?
//           BoxDecoration(color: Color(int.parse(BoardController.to.selected_background))) :
//           BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/' + BoardController.to.selected_background + '.png'), fit: BoxFit.cover, opacity: 0.8),),
//           child: Column(
//             children: [
//               /// 윗쪽
//               Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: Row(
//                   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       /// 홈
//                       InkWell(
//                         highlightColor: Colors.transparent,
//                         hoverColor: Colors.transparent,
//                         splashColor: Colors.transparent,
//                         onTap: () {
//                           Get.off(() => BoardMain());
//                           // Get.back();
//                         },
//                         child: Column(
//                           children: [
//                             Image.asset('assets/images/quiz_home_icon.png', height: 30,),
//                             SizedBox(height: 5,),
//                             Text('집으로', style: TextStyle(color: Colors.black, fontFamily: 'Jua', fontSize: 13,),)
//                           ],
//                         ),
//                         // child: Image.asset('assets/images/font_home.png', height: 50),
//                       ),
//                       SizedBox(width: 20,),
//                       /// 제목
//                       Container(
//                         width: MediaQuery.of(context).size.width*0.68,
//                         height: 70,
//                         child: Stack(
//                           children: <Widget>[
//                             Text(BoardController.to.mainTitleInput, style: TextStyle(fontFamily: 'Jua', fontSize: 30,
//                               foreground: Paint()..style = PaintingStyle.stroke..strokeWidth = 3..color = Colors.black.withOpacity(0.3),),),
//                             Text(BoardController.to.mainTitleInput, style: TextStyle(fontFamily: 'Jua', fontSize: 30, color: Colors.white,),),
//                           ],
//                         ),
//                       ),
//                       Expanded(child: SizedBox()),
//                       /// 설명보기
//                       BoardController.to.selected_content.length > 0 ?
//                       TextButton(
//                         style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
//                         onPressed: () {
//
//                         },
//                         child: CustomPopupMenu(
//                           arrowSize: 20,
//                           child: Text('설명보기',style: TextStyle(fontFamily: 'Jua', fontSize: 20,  color: Colors.black, ),),
//                           // child: Image.asset('assets/images/font_hint.png', height: 32),
//                           menuBuilder: () => ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             child: Container(
//                               width: 300,
//                               height: 400,
//                               color: Color(0xFF4C4C4C),
//                               child: IntrinsicWidth(
//                                 child: SingleChildScrollView(
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(15),
//                                     child: Column(
//                                         children: [
//                                           SizedBox(height: 30,),
//                                           Text(BoardController.to.selected_main_title, style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 18, ),),
//                                           Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Divider(color: Colors.white.withOpacity(0.3),),
//                                           ),
//                                           Text(BoardController.to.selected_content, style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 15, ),),
//                                         ]
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           pressType: PressType.singleClick,
//                           verticalMargin: -10,
//
//                         ),
//                       ) :
//                       SizedBox(),
//                       SizedBox(width: 10,),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Icon(Icons.person, color: Colors.teal,),
//                           SizedBox(width: 5,),
//                           Text(GetStorage().read('name'), style: TextStyle(color: Colors.black, fontFamily: 'Jua', fontSize: 17),),
//                         ],
//                       ),
//                       GetStorage().read('job') == 'teacher' ?
//                       Row(
//                         children: [
//                           SizedBox(width: 30  ,),
//                           /// 설정
//                           TextButton(
//                             style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
//                             onPressed: () {
//
//                             },
//                             child: CustomPopupMenu(
//                               menuOnChange: (bool) {
//                                 titleSettingController.text = BoardController.to.selected_main_title;
//                                 titleSettingController.selection = TextSelection.fromPosition(TextPosition(offset: titleSettingController.text.length));
//                                 contentSettingController.text = BoardController.to.selected_content;
//                                 contentSettingController.selection = TextSelection.fromPosition(TextPosition(offset: contentSettingController.text.length));
//
//                               },
//                               controller: popupSettingController,
//                               // arrowColor: Color(pop_bgcolor),
//                               arrowSize: 20,
//                               child: Text('설정',style: TextStyle(fontFamily: 'Jua', fontSize: 20,  color: Colors.black, ),),
//                               // child: Image.asset('assets/images/font_setting.png', height: 32),
//                               menuBuilder: () => ClipRRect(
//                                 borderRadius: BorderRadius.circular(10),
//                                 child: Container(
//                                   width: 400,
//                                   height: MediaQuery.of(context).size.height*0.8,
//                                   // height: 550,
//                                   // color: Color(pop_bgcolor),
//                                   color: Color(0xFF4C4C4C),
//                                   child: SingleChildScrollView(
//                                     child: Column(
//                                         children: [
//                                           SizedBox(height: 10,),
//                                           Row(
//                                             children: [
//                                               Expanded(child: SizedBox()),
//                                               Padding(
//                                                 padding: const EdgeInsets.all(15),
//                                                 child: TextButton(
//                                                   style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
//                                                   onPressed: () {
//                                                     if (BoardController.to.mainTitleInput.length > 0) {
//                                                       BoardController.to.updBoardMain(BoardController.to.selected_id);
//                                                       popupSettingController.hideMenu();
//                                                     }
//                                                   },
//                                                   child: Text('수정',style: TextStyle(fontFamily: 'Jua', fontSize: 20,  color: Colors.white, ),),
//                                                 ),
//                                                 // child: InkWell(
//                                                 //     onTap: () {
//                                                 //       if (BoardController.to.mainTitleInput.length > 0) {
//                                                 //         BoardController.to.updBoardMain(BoardController.to.selected_id);
//                                                 //         popupSettingController.hideMenu();
//                                                 //       }
//                                                 //     },
//                                                 //     // child: Image.asset('assets/images/font_upd.png', height: 32),
//                                                 // ),
//                                               ),
//                                             ],
//                                           ),
//                                           SizedBox(
//                                             width: 370, height: 40,
//                                             child: TextField(
//                                               controller: titleSettingController,
//                                               // controller: TextEditingController(text: BoardController.to.selected_main_title),
//                                               // controller: titleInputController,
//                                               autofocus: true,
//                                               textAlignVertical: TextAlignVertical.center,
//                                               onChanged: (value) {
//                                                 BoardController.to.mainTitleInput = value;
//                                               },
//                                               style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 19, ),
//                                               // minLines: 1,
//                                               maxLines: 1,
//                                               decoration: InputDecoration(
//                                                 hintText: '제목을 입력하세요',
//                                                 hintStyle: TextStyle(fontSize: 19, color: Colors.grey.withOpacity(0.5)),
//                                                 // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey, ),),
//                                                 focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
//                                                 enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
//                                                 contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(height: 15,),
//                                           SizedBox(
//                                             width: 370, height: 100,
//                                             child: TextField(
//                                               controller: contentSettingController,
//                                               onChanged: (value) {
//                                                 BoardController.to.mainContentInput = value;
//                                               },
//                                               style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 15, ),
//                                               // minLines: 1,
//                                               maxLines: 5,
//                                               decoration: InputDecoration(
//                                                 hintText: '힌트를 입력하세요',
//                                                 hintStyle: TextStyle(fontSize: 15, color: Colors.grey.withOpacity(0.5)),
//                                                 // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey, ),),
//                                                 focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
//                                                 enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
//
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(height: 15,),
//                                           /// 배경색깔
//                                           Container(
//                                             width: 370,
//                                             child: Text('  배경색깔', style: TextStyle(color: Colors.white),),
//                                           ),
//                                           Container(
//                                             width: 370,height: 100,
//                                             // decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
//                                             child: GridView.builder(
//                                               primary: false,
//                                               shrinkWrap: true,
//                                               padding: EdgeInsets.all(2),
//                                               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                                                 crossAxisCount: 5,
//                                                 childAspectRatio: 2/1.16, //item 의 가로, 세로 의 비율
//                                               ),
//                                               itemCount: 10,
//                                               itemBuilder: (context, index) {
//                                                 return Obx(() => InkWell(
//                                                   highlightColor: Colors.transparent,
//                                                   hoverColor: Colors.transparent,
//                                                   splashColor: Colors.transparent,
//                                                   onTap: () {
//                                                     BoardController.to.background.value = bgColors[index].toString();
//                                                     // BoardController.to.board_bgcolor.value = bgColors[index];
//                                                   },
//                                                   child: Stack(
//                                                       children: [
//                                                         Padding(
//                                                           padding: const EdgeInsets.all(1),
//                                                           child: Container(
//                                                             decoration: index == 0 ?
//                                                             BoxDecoration(color: Color(bgColors[index]), borderRadius: BorderRadius.only(topLeft: Radius.circular(10),),) :
//                                                             index == 4 ?
//                                                             BoxDecoration(color: Color(bgColors[index]), borderRadius: BorderRadius.only(topRight: Radius.circular(10),),) :
//                                                             index == 5 ?
//                                                             BoxDecoration(color: Color(bgColors[index]), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),),) :
//                                                             index == 9 ?
//                                                             BoxDecoration(color: Color(bgColors[index]), borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),),) :
//                                                             BoxDecoration(color: Color(bgColors[index]), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(0),),),
//                                                             // color: Colors.red,
//                                                           ),
//                                                         ),
//                                                         Positioned(
//                                                           child: BoardController.to.background.value == bgColors[index].toString() ?
//                                                           // child: BoardController.to.board_bgcolor.value == bgColors[index] ?
//                                                           Icon(Icons.check_circle) :
//                                                           SizedBox(),
//                                                         ),
//                                                       ]
//                                                   ),
//                                                 ),
//                                                 );
//
//                                               },
//
//                                             ),
//                                           ),
//                                           SizedBox(height: 10,),
//                                           /// 배경이미지
//                                           Container(
//                                             width: 370,
//                                             child: Text('  배경이미지', style: TextStyle(color: Colors.white),),
//                                           ),
//                                           Container(
//                                             width: 370,height: 100,
//                                             // decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
//                                             child: GridView.builder(
//                                               primary: false,
//                                               shrinkWrap: true,
//                                               padding: EdgeInsets.all(2),
//                                               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                                                 crossAxisCount: 5,
//                                                 childAspectRatio: 2/1.16, //item 의 가로, 세로 의 비율
//                                               ),
//                                               itemCount: 10,
//                                               itemBuilder: (context, index) {
//                                                 return Obx(() => InkWell(
//                                                   highlightColor: Colors.transparent,
//                                                   hoverColor: Colors.transparent,
//                                                   splashColor: Colors.transparent,
//                                                   onTap: () {
//                                                     BoardController.to.background.value = bgImages[index];
//                                                     // BoardController.to.boardBgImage.value = bgImages[index];
//                                                   },
//                                                   child: Stack(
//                                                       children: [
//                                                         Padding(
//                                                           padding: const EdgeInsets.all(1),
//                                                           child: Container(
//                                                             decoration: index == 0 ?
//                                                             BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/' + bgImages[index] + '_thumb.png'), fit: BoxFit.cover, opacity: 0.8), borderRadius: BorderRadius.only(topLeft: Radius.circular(10),),) :
//                                                             index == 4 ?
//                                                             BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/' + bgImages[index] + '_thumb.png'), fit: BoxFit.cover, opacity: 0.8), borderRadius: BorderRadius.only(topRight: Radius.circular(10),),) :
//                                                             index == 5 ?
//                                                             BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/' + bgImages[index] + '_thumb.png'), fit: BoxFit.cover, opacity: 0.8), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),),) :
//                                                             index == 9 ?
//                                                             BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/' + bgImages[index] + '_thumb.png'), fit: BoxFit.cover, opacity: 0.8), borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),),) :
//                                                             BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/' + bgImages[index] + '_thumb.png'), fit: BoxFit.cover, opacity: 0.8), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(0),),),
//                                                             // color: Colors.red,
//                                                           ),
//                                                         ),
//                                                         Positioned(
//                                                           child: BoardController.to.background.value == bgImages[index] ?
//                                                           // child: BoardController.to.boardBgImage.value == bgImages[index] ?
//                                                           Icon(Icons.check_circle) :
//                                                           SizedBox(),
//                                                         ),
//                                                       ]
//                                                   ),
//                                                 ),
//                                                 );
//
//                                               },
//
//                                             ),
//                                           ),
//                                           SizedBox(height: 10,),
//                                           /// 댓글 허용 여부
//                                           Container(
//                                             width: 370,
//                                             decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
//                                             child: Padding(
//                                               padding: const EdgeInsets.only(left: 18, right: 18, top: 5, bottom: 5),
//                                               child:
//                                               Row(
//                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                 children: [
//                                                   Text('댓글허용', style: TextStyle(color: Colors.white, fontSize: 16),),
//                                                   Obx(() => InkWell(
//                                                     highlightColor: Colors.transparent,
//                                                     hoverColor: Colors.transparent,
//                                                     splashColor: Colors.transparent,
//                                                     onTap: () {
//                                                       BoardController.to.isRepeatToggle.value = !BoardController.to.isRepeatToggle.value;
//                                                       BoardController.to.updAcceptComment(BoardController.to.selected_id);
//                                                     },
//                                                     child: BoardController.to.isRepeatToggle.value == true
//                                                         ? Icon(Icons.toggle_on, color: Colors.yellow, size: 45,)
//                                                         : Icon(Icons.toggle_off, color: Colors.grey, size: 45,),
//                                                   ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(height: 30,),
//                                           /// 삭제
//                                           Container(
//                                             width: 370,
//                                             decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
//                                             child: Padding(
//                                               padding: const EdgeInsets.only(left: 18, right: 18, top: 5, bottom: 5),
//                                               child:
//                                               Row(
//                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                 children: [
//                                                   Text('삭제 ', style: TextStyle(color: Colors.white, fontSize: 16),),
//                                                   Padding(
//                                                     padding: const EdgeInsets.only(left:15, right:5, top:15, bottom: 15),
//                                                     child:
//                                                     ElevatedButton(
//                                                       style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange,),
//                                                       onPressed: () {
//                                                         popupSettingController.hideMenu();
//                                                         delDialog(context, BoardController.to.selected_id, BoardController.to.selected_main_id);
//
//                                                       },
//                                                       child: Text('삭제',style: TextStyle(fontFamily: 'Jua', fontSize: 17, color: Colors.white),),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(height: 20,),
//                                         ]
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               pressType: PressType.singleClick,
//                               verticalMargin: -10,
//                             ),
//                           ),
//
//                           SizedBox(width: 30,),
//                           /// 스탬프
//                           TextButton(
//                             style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
//                             onPressed: () {
//                               if (BoardController.to.stamps.value.length == 0) {
//                                 BoardController.to.stamps.value = allIndexs;
//                                 BoardController.to.addAllStamp(BoardController.to.selected_main_id, 'indi');
//                               }else {
//                                 BoardController.to.stamps.value = [];
//                                 BoardController.to.delAllStamp(BoardController.to.selected_main_id, 'indi');
//                               }
//                             },
//                             child: Text('전체도장찍기/해제',style: TextStyle(fontFamily: 'Jua', fontSize: 20,  color: Colors.black, ),),
//                           ),
//                           // InkWell(
//                           //   highlightColor: Colors.transparent,
//                           //   hoverColor: Colors.transparent,
//                           //   splashColor: Colors.transparent,
//                           //   onTap: () {
//                           //     if (BoardController.to.stamps.value.length == 0) {
//                           //       BoardController.to.stamps.value = allIndexs;
//                           //       BoardController.to.addAllStamp(BoardController.to.selected_main_id, 'indi');
//                           //     }else {
//                           //       BoardController.to.stamps.value = [];
//                           //       BoardController.to.delAllStamp(BoardController.to.selected_main_id, 'indi');
//                           //     }
//                           //   },
//                           //   child: Image.asset('assets/images/font_stamp_all.png', height: 32),
//                           // ),
//                         ],
//                       ) : SizedBox(),
//                       SizedBox(width: 20,),
//                     ]
//                 ),
//               ),
//               SizedBox(height: 5,),
//               /// 본문 내용
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     // color: Colors.red,
//                     width: MediaQuery.of(context).size.width*0.01,
//                     height: MediaQuery.of(context).size.height,
//                   ),
//                   Column(
//                     mainAxisSize: MainAxisSize.min, // 스크롤은 부드럽게 하기 위해 필요
//                     children: [
//                       Container(
//                         width: MediaQuery.of(context).size.width*0.98,
//                         child: AlignedGridView.count(
//                           shrinkWrap: true,
//                           physics: NeverScrollableScrollPhysics(),
//                           /// 교실 작은 컴퓨터가 1920이라서 5로 하면 너무 사이가 벌어져서 내용이 삐져나옴
//                           crossAxisCount: MediaQuery.of(context).size.width > 1800 ? 7 :
//                           // crossAxisCount: MediaQuery.of(context).size.width > 2000 ? 7 :
//                           MediaQuery.of(context).size.width < 1000 ? 4: 5,
//                           mainAxisSpacing: 50,
//                           crossAxisSpacing: 14,
//                           itemCount: AttendanceController.to.attendanceDocs.length,
//                           itemBuilder: (context, index) {
//                             DocumentSnapshot attendanceDoc = AttendanceController.to.attendanceDocs[index];
//                             addControllers.add(CustomPopupMenuController());
//
//                             return StreamBuilder<QuerySnapshot>(
//                                 stream: FirebaseFirestore.instance.collection('board_indi').where('class_code', isEqualTo: GetStorage().read('class_code'))
//                                     .where('main_id', isEqualTo: BoardController.to.selected_main_id).where('number', isEqualTo: attendanceDoc['number'])
//                                     .orderBy('date', descending: true).snapshots(),
//                                 builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                                   if (!snapshot.hasData) {
//                                     return Center(child: Container(
//                                       height: 40,
//                                       child: LoadingIndicator(
//                                           indicatorType: Indicator.ballPulse,
//                                           colors: BoardController.to.kDefaultRainbowColors,
//                                           strokeWidth: 2,
//                                           backgroundColor: Colors.transparent,
//                                           pathBackgroundColor: Colors.transparent
//                                       ),
//                                     ),);
//                                   }
//                                   /// 겹치는 거 방지
//                                   Future.delayed(const Duration(milliseconds: 200), () {
//                                     BoardController.to.nowdate.value = DateTime.now().toString();
//                                   });
//
//                                   return
//                                     Obx(() => Container(
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           /// 이거 안하면 추가할때 밑의 번호뒤로 겹쳐지는 경우 발생
//                                           Text(BoardController.to.nowdate.value, style: TextStyle(color: Colors.transparent, fontSize: 0),),
//                                           /// 번호, 이름
//                                           GetStorage().read('number') == attendanceDoc['number'] ?
//                                           CustomPopupMenu(
//                                             menuOnChange: (bool) {
//                                               /// 이거 안하면 수정 누른후 바로 추가 누르면 제목,내용 가지고 옴
//                                               BoardController.to.indiTitleInput = '';
//                                               BoardController.to.indiContent = '';
//                                               if (bool == false && BoardController.to.popCloseType == 'nosave') {
//                                                 BoardController.to.imageModel.value.imageInt8 = null;
//                                               }
//                                             },
//                                             controller: addController,
//                                             // controller: addControllers[index],
//                                             arrowSize: 20,
//                                             child: Container(
//                                               width: 300,
//                                               height: 30,
//                                               decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(8)),
//                                               child: Center(child: Text('${attendanceDoc['number']}번  ${attendanceDoc['name']}',  style: TextStyle(fontFamily: 'Jua', fontSize: 16, color: Colors.white),)),
//                                             ),
//                                             menuBuilder: () => ClipRRect(
//                                               borderRadius: BorderRadius.circular(15),
//                                               child: Obx(() => AnimatedContainer(
//                                                 duration: const Duration(milliseconds: 300),
//                                                 width: BoardController.to.imageModel.value.imageInt8 == null ? 380 : 600,
//                                                 height: 270,
//                                                 color: Color(0xFF4C4C4C),
//                                                 child: BoardController.to.imageModel.value.imageInt8 == null ?
//                                                 SingleChildScrollView(
//                                                   child: Column(
//                                                       crossAxisAlignment: CrossAxisAlignment.end,
//                                                       children: [
//                                                         Text(BoardController.to.dummy.value.toString(), style: TextStyle(fontSize: 0),),
//                                                         Row(
//                                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                           children: [
//                                                             Padding(
//                                                               padding: const EdgeInsets.all(15),
//                                                               child: InkWell(
//                                                                 highlightColor: Colors.transparent,
//                                                                 hoverColor: Colors.transparent,
//                                                                 splashColor: Colors.transparent,
//                                                                 onTap: () {
//                                                                   BoardController.to.selectImage();
//                                                                 },
//                                                                 child: Image.asset('assets/images/camera.png', height: 32),
//                                                               ),
//                                                             ),
//                                                             Padding(
//                                                               padding: const EdgeInsets.all(15),
//                                                               child: InkWell(
//                                                                   highlightColor: Colors.transparent,
//                                                                   hoverColor: Colors.transparent,
//                                                                   splashColor: Colors.transparent,
//                                                                   onTap: () {
//                                                                     if (BoardController.to.indiTitleInput.length > 0) {
//                                                                       BoardController.to.popCloseType = 'save';
//                                                                       BoardController.to.saveBoardIndi(BoardController.to.selected_main_id, attendanceDoc['number'],);
//                                                                       // addControllers[index].hideMenu();
//                                                                       addController.hideMenu();
//                                                                     }
//                                                                   },
//                                                                   child: Image.asset('assets/images/font_save.png', height: 32)),
//                                                               // ElevatedButton(
//                                                               //   style: ElevatedButton.styleFrom(backgroundColor: Color(0xff83B4B5),),
//                                                               //   // onPressed: () => null,
//                                                               //   onPressed: () {
//                                                               //     if (BoardController.to.indiTitleInput.length > 0) {
//                                                               //       BoardController.to.popCloseType = 'save';
//                                                               //       BoardController.to.saveBoardIndi(BoardController.to.selected_main_id, attendanceDoc['number'],);
//                                                               //       // addControllers[index].hideMenu();
//                                                               //       addController.hideMenu();
//                                                               //     }
//                                                               //
//                                                               //   },
//                                                               //   child: Text('저장',style: TextStyle(fontFamily: 'Jua', fontSize: 17, color: Colors.white),),
//                                                               // ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         Padding(
//                                                           padding: const EdgeInsets.only(top: 0, right: 15),
//                                                           child: SizedBox(
//                                                             width: 350, height: 30,
//                                                             child: TextField(
//                                                               textAlignVertical: TextAlignVertical.center,
//                                                               onChanged: (value) {
//                                                                 BoardController.to.indiTitleInput = value;
//                                                               },
//                                                               style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 17, ),
//                                                               // minLines: 1,
//                                                               maxLines: 1,
//                                                               decoration: InputDecoration(
//                                                                 hintText: '제목을 입력하세요',
//                                                                 hintStyle: TextStyle(fontSize: 17, color: Colors.grey.withOpacity(0.5)),
//                                                                 // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey, ),),
//                                                                 focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
//                                                                 enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
//                                                                 contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         Padding(
//                                                           padding: const EdgeInsets.only(top: 5, right: 15),
//                                                           child: SizedBox(
//                                                             width: 350, height: 150,
//                                                             child: TextField(
//                                                               onChanged: (value) {
//                                                                 BoardController.to.indiContent = value;
//                                                               },
//                                                               style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 17, ),
//                                                               minLines: 10,
//                                                               maxLines: null,
//                                                               decoration: InputDecoration(
//                                                                 hintText: '내용을 입력하세요',
//                                                                 hintStyle: TextStyle(fontSize: 17, color: Colors.grey.withOpacity(0.5)),
//                                                                 focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
//                                                                 enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//
//                                                         SizedBox(height: 5,),
//                                                         // Row(
//                                                         //   children: [
//                                                         //     Container(
//                                                         //       width: 380,
//                                                         //       // width: 150, height: 150,
//                                                         //       // decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
//                                                         //       child: BoardController.to.imageModel.value.imageInt8 == null
//                                                         //           ? SizedBox()
//                                                         //           :
//                                                         //       Image.memory(BoardController.to.imageModel.value.imageInt8!, fit: BoxFit.fill),
//                                                         //     ),
//                                                         //     Text(BoardController.to.dummy.value.toString(), style: TextStyle(fontSize: 0),),
//                                                         //   ],
//                                                         // ),
//
//                                                       ]
//                                                   ),
//                                                 ) :
//                                                 Row(
//                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                   children: [
//                                                     Column(
//                                                       children: [
//                                                         Container(
//                                                           width: 200, height: 269,
//                                                           child: Image.memory(BoardController.to.imageModel.value.imageInt8!, fit: BoxFit.cover),
//                                                         ),
//                                                         Text(BoardController.to.dummy.value.toString(), style: TextStyle(fontSize: 0),),
//                                                       ],
//                                                     ),
//                                                     SizedBox(width: 10,),
//                                                     Container(
//                                                       width: 380,
//                                                       child: SingleChildScrollView(
//                                                         child: Column(
//                                                             crossAxisAlignment: CrossAxisAlignment.end,
//                                                             children: [
//                                                               Row(
//                                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                                 children: [
//                                                                   Padding(
//                                                                     padding: const EdgeInsets.all(15),
//                                                                     child: InkWell(
//                                                                       highlightColor: Colors.transparent,
//                                                                       hoverColor: Colors.transparent,
//                                                                       splashColor: Colors.transparent,
//                                                                       onTap: () {
//                                                                         BoardController.to.selectImage();
//                                                                       },
//                                                                       child: Image.asset('assets/images/camera.png', height: 32),
//                                                                     ),
//                                                                   ),
//                                                                   // Padding(
//                                                                   //   padding: const EdgeInsets.all(15),
//                                                                   //   child: IconButton(
//                                                                   //     icon: Icon(Icons.insert_photo_outlined, size: 30, color: Colors.white,),
//                                                                   //     onPressed: () {
//                                                                   //       BoardController.to.selectImage();
//                                                                   //     },
//                                                                   //   ),
//                                                                   // ),
//
//                                                                   Padding(
//                                                                     padding: const EdgeInsets.all(15),
//                                                                     child: InkWell(
//                                                                       highlightColor: Colors.transparent,
//                                                                       hoverColor: Colors.transparent,
//                                                                       splashColor: Colors.transparent,
//                                                                       onTap: () {
//                                                                         if (BoardController.to.indiTitleInput.length > 0) {
//                                                                           BoardController.to.popCloseType = 'save';
//                                                                           BoardController.to.saveBoardIndi(BoardController.to.selected_main_id, attendanceDoc['number'],);
//                                                                         }
//                                                                         addController.hideMenu();
//                                                                       },
//                                                                       child: Image.asset('assets/images/font_save.png', height: 32),
//                                                                     ),
//                                                                   ),
//                                                                   // Padding(
//                                                                   //   padding: const EdgeInsets.all(15),
//                                                                   //   child:
//                                                                   //   ElevatedButton(
//                                                                   //     style: ElevatedButton.styleFrom(backgroundColor: Color(0xff83B4B5),),
//                                                                   //     onPressed: () {
//                                                                   //       // BoardController.to.loading.value = true;
//                                                                   //       if (BoardController.to.indiTitleInput.length > 0) {
//                                                                   //         BoardController.to.popCloseType = 'save';
//                                                                   //         BoardController.to.saveBoardIndi(BoardController.to.selected_main_id, attendanceDoc['number'],);
//                                                                   //         // BoardController.to.nowdate.value = DateTime.now().toString();
//                                                                   //       }
//                                                                   //       // addControllers[index].hideMenu();
//                                                                   //       addController.hideMenu();
//                                                                   //     },
//                                                                   //     child: Text('저장',style: TextStyle(fontFamily: 'Jua', fontSize: 17, color: Colors.white),),
//                                                                   //   ),
//                                                                   // ),
//                                                                 ],
//                                                               ),
//                                                               Padding(
//                                                                 padding: const EdgeInsets.only(top: 0, right: 15),
//                                                                 child: SizedBox(
//                                                                   width: 350, height: 30,
//                                                                   child: TextField(
//                                                                     /// 제목 입력후 이미지 선택하면 제목이 사라져서 밑에거 추가함
//                                                                     controller: TextEditingController(text: BoardController.to.indiTitleInput),
//                                                                     textAlignVertical: TextAlignVertical.center,
//                                                                     onChanged: (value) {
//                                                                       BoardController.to.indiTitleInput = value;
//                                                                     },
//                                                                     style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 17, ),
//                                                                     // minLines: 1,
//                                                                     maxLines: 1,
//                                                                     decoration: InputDecoration(
//                                                                       hintText: '제목을 입력하세요',
//                                                                       hintStyle: TextStyle(fontSize: 17, color: Colors.grey.withOpacity(0.5)),
//                                                                       // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey, ),),
//                                                                       focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
//                                                                       enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
//                                                                       contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                               Padding(
//                                                                 padding: const EdgeInsets.only(top: 5, right: 15),
//                                                                 child: SizedBox(
//                                                                   width: 350, height: 150,
//                                                                   child: TextField(
//                                                                     controller: TextEditingController(text: BoardController.to.indiContent),
//                                                                     onChanged: (value) {
//                                                                       BoardController.to.indiContent = value;
//                                                                     },
//                                                                     style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 17, ),
//                                                                     minLines: 10,
//                                                                     maxLines: null,
//                                                                     decoration: InputDecoration(
//                                                                       hintText: '내용을 입력하세요',
//                                                                       hintStyle: TextStyle(fontSize: 17, color: Colors.grey.withOpacity(0.5)),
//                                                                       focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
//                                                                       enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ),
//
//                                                               SizedBox(height: 5,),
//                                                             ]
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//
//                                               ),
//                                               ),
//                                             ),
//                                             pressType: PressType.singleClick,
//                                             verticalMargin: -10,
//
//                                           ) :
//                                           Container(
//                                             width: 300,
//                                             height: 30,
//                                             decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(8)),
//                                             child: Center(child: Text('${attendanceDoc['number']}번  ${attendanceDoc['name']}',  style: TextStyle(fontFamily: 'Jua', fontSize: 16, color: Colors.white),)),
//                                           ),
//
//                                           // Container(
//                                           //   width: 300,
//                                           //   height: 30,
//                                           //   decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(8)),
//                                           //   child: Row(
//                                           //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                           //     children: [
//                                           //       Container(
//                                           //         width: 50,
//                                           //         child: Icon(Icons.add, color: Colors.transparent,),
//                                           //       ),
//                                           //       /// 번호,이름
//                                           //       Text('${attendanceDoc['number']}번  ${attendanceDoc['name']}',  style: TextStyle(fontFamily: 'Jua', fontSize: 16, color: Colors.white),),
//                                           //       GetStorage().read('number') == attendanceDoc['number'] ?
//                                           //       /// 추가버튼
//                                           //       CustomPopupMenu(
//                                           //         menuOnChange: (bool) {
//                                           //           /// 이거 안하면 수정 누른후 바로 추가 누르면 제목,내용 가지고 옴
//                                           //           BoardController.to.indiTitleInput = '';
//                                           //           BoardController.to.indiContent = '';
//                                           //           if (bool == false && BoardController.to.popCloseType == 'nosave') {
//                                           //             BoardController.to.imageModel.value.imageInt8 = null;
//                                           //           }
//                                           //         },
//                                           //         controller: addController,
//                                           //         // controller: addControllers[index],
//                                           //         arrowSize: 20,
//                                           //         child: Container(
//                                           //           width: 50,
//                                           //           child: Icon(Icons.add_circle, color: Colors.orangeAccent,),
//                                           //           // padding: EdgeInsets.all(10),
//                                           //         ),
//                                           //         menuBuilder: () => ClipRRect(
//                                           //           borderRadius: BorderRadius.circular(15),
//                                           //           child: Obx(() => AnimatedContainer(
//                                           //             duration: const Duration(milliseconds: 300),
//                                           //             // child: Obx(() => Container(
//                                           //             width: BoardController.to.imageModel.value.imageInt8 == null ? 380 : 600,
//                                           //             // width: 380,
//                                           //             height: 270,
//                                           //             // height: 350,
//                                           //             color: Color(0xFF4C4C4C),
//                                           //             child: BoardController.to.imageModel.value.imageInt8 == null ?
//                                           //             SingleChildScrollView(
//                                           //               child: Column(
//                                           //                   crossAxisAlignment: CrossAxisAlignment.end,
//                                           //                   children: [
//                                           //                     Text(BoardController.to.dummy.value.toString(), style: TextStyle(fontSize: 0),),
//                                           //                     Row(
//                                           //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                           //                       children: [
//                                           //                         Padding(
//                                           //                           padding: const EdgeInsets.all(15),
//                                           //                           child: IconButton(
//                                           //                             icon: Icon(Icons.insert_photo_outlined, size: 30, color: Colors.white,),
//                                           //                             onPressed: () {
//                                           //                               BoardController.to.selectImage();
//                                           //                             },
//                                           //                           ),
//                                           //                           // child: Icon(Icons.insert_photo_outlined, size: 30, color: Colors.white,),
//                                           //                         ),
//                                           //                         Padding(
//                                           //                           padding: const EdgeInsets.all(15),
//                                           //                           child:
//                                           //                           ElevatedButton(
//                                           //                             style: ElevatedButton.styleFrom(backgroundColor: Color(0xff83B4B5),),
//                                           //                             // onPressed: () => null,
//                                           //                             onPressed: () {
//                                           //                               if (BoardController.to.indiTitleInput.length > 0) {
//                                           //                                 BoardController.to.popCloseType = 'save';
//                                           //                                 BoardController.to.saveBoardIndi(BoardController.to.selected_main_id, attendanceDoc['number'],);
//                                           //                                 // addControllers[index].hideMenu();
//                                           //                                 addController.hideMenu();
//                                           //                               }
//                                           //
//                                           //                             },
//                                           //                             child: Text('저장',style: TextStyle(fontFamily: 'Jua', fontSize: 17, color: Colors.white),),
//                                           //                           ),
//                                           //                         ),
//                                           //                       ],
//                                           //                     ),
//                                           //                     Padding(
//                                           //                       padding: const EdgeInsets.only(top: 0, right: 15),
//                                           //                       child: SizedBox(
//                                           //                         width: 350, height: 30,
//                                           //                         child: TextField(
//                                           //                           textAlignVertical: TextAlignVertical.center,
//                                           //                           onChanged: (value) {
//                                           //                             BoardController.to.indiTitleInput = value;
//                                           //                           },
//                                           //                           style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 17, ),
//                                           //                           // minLines: 1,
//                                           //                           maxLines: 1,
//                                           //                           decoration: InputDecoration(
//                                           //                             hintText: '제목을 입력하세요',
//                                           //                             hintStyle: TextStyle(fontSize: 17, color: Colors.grey.withOpacity(0.5)),
//                                           //                             // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey, ),),
//                                           //                             focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
//                                           //                             enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
//                                           //                             contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//                                           //
//                                           //                           ),
//                                           //                         ),
//                                           //                       ),
//                                           //                     ),
//                                           //                     Padding(
//                                           //                       padding: const EdgeInsets.only(top: 5, right: 15),
//                                           //                       child: SizedBox(
//                                           //                         width: 350, height: 150,
//                                           //                         child: TextField(
//                                           //                           onChanged: (value) {
//                                           //                             BoardController.to.indiContent = value;
//                                           //                           },
//                                           //                           style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 17, ),
//                                           //                           minLines: 10,
//                                           //                           maxLines: null,
//                                           //                           decoration: InputDecoration(
//                                           //                             hintText: '내용을 입력하세요',
//                                           //                             hintStyle: TextStyle(fontSize: 17, color: Colors.grey.withOpacity(0.5)),
//                                           //                             focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
//                                           //                             enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
//                                           //                           ),
//                                           //                         ),
//                                           //                       ),
//                                           //                     ),
//                                           //
//                                           //                     SizedBox(height: 5,),
//                                           //                     // Row(
//                                           //                     //   children: [
//                                           //                     //     Container(
//                                           //                     //       width: 380,
//                                           //                     //       // width: 150, height: 150,
//                                           //                     //       // decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
//                                           //                     //       child: BoardController.to.imageModel.value.imageInt8 == null
//                                           //                     //           ? SizedBox()
//                                           //                     //           :
//                                           //                     //       Image.memory(BoardController.to.imageModel.value.imageInt8!, fit: BoxFit.fill),
//                                           //                     //     ),
//                                           //                     //     Text(BoardController.to.dummy.value.toString(), style: TextStyle(fontSize: 0),),
//                                           //                     //   ],
//                                           //                     // ),
//                                           //
//                                           //                   ]
//                                           //               ),
//                                           //             ) :
//                                           //             Row(
//                                           //               crossAxisAlignment: CrossAxisAlignment.start,
//                                           //               children: [
//                                           //                 Column(
//                                           //                   children: [
//                                           //                     Container(
//                                           //                       width: 200, height: 269,
//                                           //                       child: Image.memory(BoardController.to.imageModel.value.imageInt8!, fit: BoxFit.cover),
//                                           //                     ),
//                                           //                     Text(BoardController.to.dummy.value.toString(), style: TextStyle(fontSize: 0),),
//                                           //                   ],
//                                           //                 ),
//                                           //                 SizedBox(width: 10,),
//                                           //                 Container(
//                                           //                   width: 380,
//                                           //                   child: SingleChildScrollView(
//                                           //                     child: Column(
//                                           //                         crossAxisAlignment: CrossAxisAlignment.end,
//                                           //                         children: [
//                                           //                           Row(
//                                           //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                           //                             children: [
//                                           //                               Padding(
//                                           //                                 padding: const EdgeInsets.all(15),
//                                           //                                 child: IconButton(
//                                           //                                   icon: Icon(Icons.insert_photo_outlined, size: 30, color: Colors.white,),
//                                           //                                   onPressed: () {
//                                           //                                     BoardController.to.selectImage();
//                                           //                                   },
//                                           //                                 ),
//                                           //                                 // child: Icon(Icons.insert_photo_outlined, size: 30, color: Colors.white,),
//                                           //                               ),
//                                           //                               Padding(
//                                           //                                 padding: const EdgeInsets.all(15),
//                                           //                                 child:
//                                           //                                 ElevatedButton(
//                                           //                                   style: ElevatedButton.styleFrom(backgroundColor: Color(0xff83B4B5),),
//                                           //                                   onPressed: () {
//                                           //                                     // BoardController.to.loading.value = true;
//                                           //                                     if (BoardController.to.indiTitleInput.length > 0) {
//                                           //                                       BoardController.to.popCloseType = 'save';
//                                           //                                       BoardController.to.saveBoardIndi(BoardController.to.selected_main_id, attendanceDoc['number'],);
//                                           //                                       // BoardController.to.nowdate.value = DateTime.now().toString();
//                                           //                                     }
//                                           //                                     // addControllers[index].hideMenu();
//                                           //                                     addController.hideMenu();
//                                           //                                   },
//                                           //                                   child: Text('저장',style: TextStyle(fontFamily: 'Jua', fontSize: 17, color: Colors.white),),
//                                           //                                 ),
//                                           //                               ),
//                                           //                             ],
//                                           //                           ),
//                                           //                           Padding(
//                                           //                             padding: const EdgeInsets.only(top: 0, right: 15),
//                                           //                             child: SizedBox(
//                                           //                               width: 350, height: 30,
//                                           //                               child: TextField(
//                                           //                                 /// 제목 입력후 이미지 선택하면 제목이 사라져서 밑에거 추가함
//                                           //                                 controller: TextEditingController(text: BoardController.to.indiTitleInput),
//                                           //                                 textAlignVertical: TextAlignVertical.center,
//                                           //                                 onChanged: (value) {
//                                           //                                   BoardController.to.indiTitleInput = value;
//                                           //                                 },
//                                           //                                 style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 17, ),
//                                           //                                 // minLines: 1,
//                                           //                                 maxLines: 1,
//                                           //                                 decoration: InputDecoration(
//                                           //                                   hintText: '제목을 입력하세요',
//                                           //                                   hintStyle: TextStyle(fontSize: 17, color: Colors.grey.withOpacity(0.5)),
//                                           //                                   // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey, ),),
//                                           //                                   focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
//                                           //                                   enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
//                                           //                                   contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//                                           //
//                                           //                                 ),
//                                           //                               ),
//                                           //                             ),
//                                           //                           ),
//                                           //                           Padding(
//                                           //                             padding: const EdgeInsets.only(top: 5, right: 15),
//                                           //                             child: SizedBox(
//                                           //                               width: 350, height: 150,
//                                           //                               child: TextField(
//                                           //                                 controller: TextEditingController(text: BoardController.to.indiContent),
//                                           //                                 onChanged: (value) {
//                                           //                                   BoardController.to.indiContent = value;
//                                           //                                 },
//                                           //                                 style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 17, ),
//                                           //                                 minLines: 10,
//                                           //                                 maxLines: null,
//                                           //                                 decoration: InputDecoration(
//                                           //                                   hintText: '내용을 입력하세요',
//                                           //                                   hintStyle: TextStyle(fontSize: 17, color: Colors.grey.withOpacity(0.5)),
//                                           //                                   focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
//                                           //                                   enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
//                                           //                                 ),
//                                           //                               ),
//                                           //                             ),
//                                           //                           ),
//                                           //
//                                           //                           SizedBox(height: 5,),
//                                           //                         ]
//                                           //                     ),
//                                           //                   ),
//                                           //                 ),
//                                           //               ],
//                                           //             ),
//                                           //
//                                           //           ),
//                                           //           ),
//                                           //         ),
//                                           //         pressType: PressType.singleClick,
//                                           //         verticalMargin: -10,
//                                           //
//                                           //       ) :
//                                           //       Container(
//                                           //         width: 50,
//                                           //         child: Icon(Icons.add, color: Colors.transparent,),
//                                           //       ),
//                                           //     ],
//                                           //   ),
//                                           // ),
//                                           ListView.builder(
//                                               shrinkWrap: true,
//                                               itemCount: snapshot.data!.docs.length,
//                                               itemBuilder: (_, index) {
//                                                 DocumentSnapshot indiDoc = snapshot.data!.docs[index];
//                                                 /// 스탬프 전체찍기 위해
//                                                 if (!allIndexs.contains('${attendanceDoc['number']}-${index}')) {
//                                                   allIndexs.add('${attendanceDoc['number']}-${index}');
//                                                 }
//
//                                                 // 댓글 날짜순 정렬
//                                                 List commentList = indiDoc['comment'];
//                                                 commentList.sort((a, b) => a['date'].compareTo(b['date']));
//                                                 indiCnt ++;
//                                                 // updTitleCnt ++;
//                                                 // updContentCnt ++;
//                                                 updTitleCnt = 0;
//                                                 updContentCnt = 0;
//                                                 /// 겹치는거 때문에 obx 처리한 후로 addCommentCnt를 제대로 못가져와서 아래와 같이 처리함
//                                                 ///  여기서 addCommentCnt ++ 하면 모든 addCommentCnt가 같은 값 가짐.
//                                                 ///  addCommentCnt = 0을 해줘야 리로드시마다 1부터 올라감
//                                                 // addCommentCnt ++;
//                                                 addCommentCnt = 0;
//                                                 updIndiControllers.add(CustomPopupMenuController());
//                                                 updTitleInputControllers.add(TextEditingController());
//                                                 updContentInputControllers.add(TextEditingController());
//                                                 addCommentControllers.add(TextEditingController());
//
//                                                 return Padding(
//                                                   padding: EdgeInsets.only(top: 10, right: 0),
//                                                   child: Container(
//                                                     width: 250,
//                                                     decoration: BoxDecoration(
//                                                       color: Colors.white,
//                                                       borderRadius: BorderRadius.circular(8),
//                                                       boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.7), spreadRadius: 0, blurRadius: 2.0, offset: Offset(0, 3), ),],
//                                                     ),
//                                                     child: Padding(
//                                                       padding: const EdgeInsets.all(15.0),
//                                                       child:
//                                                       Column(
//                                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                                         children: [
//                                                           /// 제목
//                                                           Row(
//                                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                             children: [
//                                                               Container(
//                                                                 width: 200,
//                                                                 child: Text(indiDoc['title'],  style: TextStyle(fontFamily: 'Jua', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
//                                                               ),
//                                                               GetStorage().read('number') == attendanceDoc['number']  ?
//                                                               // GetStorage().read('number') == indiDoc['number'] ?
//                                                               /// 수정아이콘
//                                                               CustomPopupMenu(
//                                                                 menuOnChange: (bool) {
//                                                                   BoardController.to.imageModel.value.imageInt8 = null;
//                                                                   BoardController.to.indiTitleInput = indiDoc['title'];
//                                                                   BoardController.to.indiContent = indiDoc['content'];
//                                                                   // 텍스트필드 커서 뒤로 보내기
//                                                                   updTitleInputControllers[updTitleCnt - 1].text = BoardController.to.indiTitleInput;
//                                                                   updTitleInputControllers[updTitleCnt - 1].selection = TextSelection.fromPosition(TextPosition(offset: updTitleInputControllers[updTitleCnt - 1].text.length));
//                                                                   updContentInputControllers[updContentCnt - 1].text = BoardController.to.indiContent;
//                                                                   updContentInputControllers[updContentCnt - 1].selection = TextSelection.fromPosition(TextPosition(offset: updContentInputControllers[updContentCnt - 1].text.length));
//                                                                 },
//                                                                 controller: updIndiControllers[indiCnt-1],
//                                                                 arrowSize: 20,
//                                                                 child:
//                                                                 Icon(Icons.edit_outlined, size: 20, color: Colors.black.withOpacity(0.3),),
//
//                                                                 menuBuilder: () => ClipRRect(
//                                                                   borderRadius: BorderRadius.circular(15),
//                                                                   child:
//                                                                   Obx(() => AnimatedContainer(
//                                                                     duration: const Duration(milliseconds: 300),
//                                                                     width: indiDoc['imageUrl'].length == 0 && BoardController.to.imageModel.value.imageInt8 == null ?
//                                                                     380 : 600,
//                                                                     height: 270,
//                                                                     color: Color(0xFF4C4C4C),
//                                                                     child: indiDoc['imageUrl'].length == 0 && BoardController.to.imageModel.value.imageInt8 == null ?
//                                                                     SingleChildScrollView(
//                                                                       child: Column(
//                                                                           crossAxisAlignment: CrossAxisAlignment.end,
//                                                                           children: [
//                                                                             Row(
//                                                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                                               children: [
//                                                                                 InkWell(
//                                                                                   highlightColor: Colors.transparent,
//                                                                                   hoverColor: Colors.transparent,
//                                                                                   splashColor: Colors.transparent,
//                                                                                   onTap: () {
//                                                                                     BoardController.to.selectImage();
//                                                                                   },
//                                                                                   child: Padding(
//                                                                                     padding: const EdgeInsets.all(15),
//                                                                                     child: Image.asset('assets/images/camera.png', height: 32),
//                                                                                   ),
//                                                                                 ),
//                                                                                 // Padding(
//                                                                                 //   padding: const EdgeInsets.all(15),
//                                                                                 //   child: IconButton(
//                                                                                 //     icon: Icon(Icons.insert_photo_outlined, size: 30, color: Colors.white,),
//                                                                                 //     onPressed: () {
//                                                                                 //       BoardController.to.selectImage();
//                                                                                 //     },
//                                                                                 //   ),
//                                                                                 //   // child: Icon(Icons.insert_photo_outlined, size: 30, color: Colors.white,),
//                                                                                 // ),
//                                                                                 Expanded(child: SizedBox()),
//                                                                                 InkWell(
//                                                                                   highlightColor: Colors.transparent,
//                                                                                   hoverColor: Colors.transparent,
//                                                                                   splashColor: Colors.transparent,
//                                                                                   onTap: () {
//                                                                                     BoardController.to.delBoardIndi(indiDoc);
//                                                                                     for(var con in updIndiControllers)
//                                                                                       con.hideMenu();
//                                                                                   },
//                                                                                   child: Padding(
//                                                                                     padding: const EdgeInsets.all(15),
//                                                                                     child: Image.asset('assets/images/font_delete.png', height: 32),
//                                                                                   ),
//                                                                                 ),
//                                                                                 // Padding(
//                                                                                 //   padding: const EdgeInsets.all(15),
//                                                                                 //   child:
//                                                                                 //   ElevatedButton(
//                                                                                 //     style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange,),
//                                                                                 //     onPressed: () {
//                                                                                 //       BoardController.to.delBoardIndi(indiDoc);
//                                                                                 //       for(var con in updIndiControllers)
//                                                                                 //         con.hideMenu();
//                                                                                 //     },
//                                                                                 //     child: Text('삭제',style: TextStyle(fontFamily: 'Jua', fontSize: 17, color: Colors.white),),
//                                                                                 //   ),
//                                                                                 // ),
//                                                                                 InkWell(
//                                                                                   highlightColor: Colors.transparent,
//                                                                                   hoverColor: Colors.transparent,
//                                                                                   splashColor: Colors.transparent,
//                                                                                   onTap: () {
//                                                                                     BoardController.to.updBoardIndi(indiDoc);
//                                                                                     for(var con in updIndiControllers)
//                                                                                       con.hideMenu();
//                                                                                   },
//                                                                                   child: Padding(
//                                                                                     padding: const EdgeInsets.all(15),
//                                                                                     child: Image.asset('assets/images/font_upd.png', height: 32),
//                                                                                   ),
//                                                                                 ),
//                                                                                 // Padding(
//                                                                                 //   padding: const EdgeInsets.all(15),
//                                                                                 //   child:
//                                                                                 //   ElevatedButton(
//                                                                                 //     style: ElevatedButton.styleFrom(backgroundColor: Color(0xff83B4B5),),
//                                                                                 //     onPressed: () async {
//                                                                                 //       // await 안하면 menutonchange가 먼저 실행되어 titleinput값이 제대로 반영 안됨
//                                                                                 //       await BoardController.to.updBoardIndi(indiDoc);
//                                                                                 //       for(var con in updIndiControllers)
//                                                                                 //         con.hideMenu();
//                                                                                 //     },
//                                                                                 //     child: Text('수정',style: TextStyle(fontFamily: 'Jua', fontSize: 17, color: Colors.white),),
//                                                                                 //   ),
//                                                                                 // ),
//                                                                               ],
//                                                                             ),
//                                                                             /// 제목수정
//                                                                             Padding(
//                                                                               padding: const EdgeInsets.only(top: 0, right: 15),
//                                                                               child: SizedBox(
//                                                                                 width: 350, height: 30,
//                                                                                 child: TextField(
//                                                                                   controller: updTitleInputControllers[updTitleCnt - 1],
//                                                                                   textAlignVertical: TextAlignVertical.center,
//                                                                                   onChanged: (value) {
//                                                                                     BoardController.to.indiTitleInput = value;
//                                                                                   },
//                                                                                   style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 17, ),
//                                                                                   // minLines: 1,
//                                                                                   maxLines: 1,
//                                                                                   decoration: InputDecoration(
//                                                                                     focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
//                                                                                     enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
//                                                                                     contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//
//                                                                                   ),
//                                                                                 ),
//                                                                               ),
//                                                                             ),
//                                                                             /// 내용수정
//                                                                             Padding(
//                                                                               padding: const EdgeInsets.only(top: 5, right: 15),
//                                                                               child: SizedBox(
//                                                                                 width: 350, height: 150,
//                                                                                 child: TextField(
//                                                                                   controller: updContentInputControllers[updContentCnt - 1],
//                                                                                   onChanged: (value) {
//                                                                                     BoardController.to.indiContent = value;
//                                                                                   },
//                                                                                   style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 17, ),
//                                                                                   minLines: 10,
//                                                                                   maxLines: null,
//                                                                                   decoration: InputDecoration(
//                                                                                     focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
//                                                                                     enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
//                                                                                   ),
//                                                                                 ),
//                                                                               ),
//                                                                             ),
//
//                                                                             SizedBox(height: 5,),
//                                                                             Row(
//                                                                               children: [
//                                                                                 Container(
//                                                                                   width: 380,
//                                                                                   child: BoardController.to.imageModel.value.imageInt8 == null
//                                                                                       ? SizedBox()
//                                                                                       :
//                                                                                   Image.memory(BoardController.to.imageModel.value.imageInt8!, fit: BoxFit.fill),
//                                                                                 ),
//                                                                                 Text(BoardController.to.dummy.value.toString(), style: TextStyle(fontSize: 0),),
//                                                                               ],
//                                                                             ),
//
//                                                                           ]
//                                                                       ),
//                                                                     ) :
//                                                                     Row(
//                                                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                                                       children: [
//                                                                         Column(
//                                                                           children: [
//                                                                             Container(
//                                                                               width: 200, height: 269,
//                                                                               child: BoardController.to.imageModel.value.imageInt8 == null ?
//                                                                               Image.network(indiDoc['imageUrl'], fit: BoxFit.cover) :
//                                                                               Image.memory(BoardController.to.imageModel.value.imageInt8!, fit: BoxFit.cover),
//                                                                             ),
//                                                                             Text(BoardController.to.dummy.value.toString(), style: TextStyle(fontSize: 0),),
//                                                                           ],
//                                                                         ),
//                                                                         SizedBox(width: 10,),
//                                                                         Container(
//                                                                           width: 380,
//                                                                           child: SingleChildScrollView(
//                                                                             child: Column(
//                                                                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                                                                 children: [
//                                                                                   Row(
//                                                                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                                                     children: [
//                                                                                       InkWell(
//                                                                                         highlightColor: Colors.transparent,
//                                                                                         hoverColor: Colors.transparent,
//                                                                                         splashColor: Colors.transparent,
//                                                                                         onTap: () {
//                                                                                           BoardController.to.selectImage();
//                                                                                         },
//                                                                                         child: Padding(
//                                                                                           padding: const EdgeInsets.all(15),
//                                                                                           child: Image.asset('assets/images/camera.png', height: 32),
//                                                                                         ),
//                                                                                       ),
//                                                                                       // Padding(
//                                                                                       //   padding: const EdgeInsets.all(15),
//                                                                                       //   child: IconButton(
//                                                                                       //     icon: Icon(Icons.insert_photo_outlined, size: 30, color: Colors.white,),
//                                                                                       //     onPressed: () {
//                                                                                       //       BoardController.to.selectImage();
//                                                                                       //     },
//                                                                                       //   ),
//                                                                                       //   // child: Icon(Icons.insert_photo_outlined, size: 30, color: Colors.white,),
//                                                                                       // ),
//                                                                                       Row(
//                                                                                         children: [
//                                                                                           InkWell(
//                                                                                             highlightColor: Colors.transparent,
//                                                                                             hoverColor: Colors.transparent,
//                                                                                             splashColor: Colors.transparent,
//                                                                                             onTap: () {
//                                                                                               BoardController.to.delBoardIndi(indiDoc);
//                                                                                               for(var con in updIndiControllers)
//                                                                                                 con.hideMenu();
//                                                                                             },
//                                                                                             child: Padding(
//                                                                                               padding: const EdgeInsets.all(15),
//                                                                                               child: Image.asset('assets/images/font_delete.png', height: 32),
//                                                                                             ),
//                                                                                           ),
//                                                                                           // SizedBox(width: 30,),
//                                                                                           InkWell(
//                                                                                             highlightColor: Colors.transparent,
//                                                                                             hoverColor: Colors.transparent,
//                                                                                             splashColor: Colors.transparent,
//                                                                                             onTap: () async{
//                                                                                               await BoardController.to.updBoardIndi(indiDoc);
//                                                                                               /// await 안붙히고 비동기로 처리하면 디비저장전에 hide가 먼저처리되어서 image값이 null 됨
//                                                                                               for(var con in updIndiControllers)
//                                                                                                 con.hideMenu();
//                                                                                             },
//                                                                                             child: Padding(
//                                                                                               padding: const EdgeInsets.all(15),
//                                                                                               child: Image.asset('assets/images/font_upd.png', height: 32),
//                                                                                             ),
//                                                                                           ),
//                                                                                         ],
//                                                                                       ),
//                                                                                       // Padding(
//                                                                                       //   padding: const EdgeInsets.all(15),
//                                                                                       //   child:
//                                                                                       //   ElevatedButton(
//                                                                                       //     style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange,),
//                                                                                       //     onPressed: () {
//                                                                                       //       BoardController.to.delBoardIndi(indiDoc);
//                                                                                       //       for(var con in updIndiControllers)
//                                                                                       //         con.hideMenu();
//                                                                                       //     },
//                                                                                       //     child: Text('삭제',style: TextStyle(fontFamily: 'Jua', fontSize: 17, color: Colors.white),),
//                                                                                       //   ),
//                                                                                       // ),
//
//
//                                                                                       // Padding(
//                                                                                       //   padding: const EdgeInsets.all(15),
//                                                                                       //   child:
//                                                                                       //   ElevatedButton(
//                                                                                       //     style: ElevatedButton.styleFrom(backgroundColor: Color(0xff83B4B5),),
//                                                                                       //     onPressed: () async {
//                                                                                       //       // await 안하면 menutonchange가 먼저 실행되어 titleinput값이 제대로 반영 안됨
//                                                                                       //       await BoardController.to.updBoardIndi(indiDoc);
//                                                                                       //       for(var con in updIndiControllers)
//                                                                                       //         con.hideMenu();
//                                                                                       //     },
//                                                                                       //     child: Text('수정',style: TextStyle(fontFamily: 'Jua', fontSize: 17, color: Colors.white),),
//                                                                                       //   ),
//                                                                                       // ),
//                                                                                     ],
//                                                                                   ),
//                                                                                   /// 제목 수정
//                                                                                   Padding(
//                                                                                     padding: const EdgeInsets.only(top: 0, right: 15),
//                                                                                     child: SizedBox(
//                                                                                       width: 350, height: 30,
//                                                                                       child: TextField(
//                                                                                         controller: updTitleInputControllers[updTitleCnt - 1],
//                                                                                         textAlignVertical: TextAlignVertical.center,
//                                                                                         onChanged: (value) {
//                                                                                           BoardController.to.indiTitleInput = value;
//                                                                                         },
//                                                                                         style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 17, ),
//                                                                                         // minLines: 1,
//                                                                                         maxLines: 1,
//                                                                                         decoration: InputDecoration(
//                                                                                           focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
//                                                                                           enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
//                                                                                           contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//
//                                                                                         ),
//                                                                                       ),
//                                                                                     ),
//                                                                                   ),
//                                                                                   /// 내용 수정
//                                                                                   Padding(
//                                                                                     padding: const EdgeInsets.only(top: 5, right: 15),
//                                                                                     child: SizedBox(
//                                                                                       width: 350, height: 150,
//                                                                                       child: TextField(
//                                                                                         controller: updContentInputControllers[updContentCnt - 1],
//                                                                                         onChanged: (value) {
//                                                                                           BoardController.to.indiContent = value;
//                                                                                         },
//                                                                                         style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 17, ),
//                                                                                         minLines: 10,
//                                                                                         maxLines: null,
//                                                                                         decoration: InputDecoration(
//                                                                                           focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
//                                                                                           enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
//                                                                                         ),
//                                                                                       ),
//                                                                                     ),
//                                                                                   ),
//
//                                                                                 ]
//                                                                             ),
//                                                                           ),
//                                                                         ),
//                                                                       ],
//                                                                     ),
//
//                                                                   ),
//                                                                   ),
//                                                                 ),
//                                                                 pressType: PressType.singleClick,
//                                                                 verticalMargin: -10,
//
//                                                               ) : SizedBox(),
//
//                                                             ],
//                                                           ),
//                                                           SizedBox(height: 5,),
//                                                           /// 내용, 이미지로딩중
//                                                           Obx(() => Stack(children: [
//                                                             indiDoc['content'].length > 0 ?
//                                                             Text(indiDoc['content'],  style: TextStyle(fontFamily: 'Jua', fontSize: 15, color: Colors.black,),) : SizedBox(),
//                                                             BoardController.to.isImageLoading.value == true && indiDoc['number'] == GetStorage().read('number') && index == 0 ?
//                                                             Center(child: Container(
//                                                               height: 40,
//                                                               child: LoadingIndicator(
//                                                                   indicatorType: Indicator.ballPulse,
//                                                                   colors: BoardController.to.kDefaultRainbowColors,
//                                                                   strokeWidth: 2,
//                                                                   backgroundColor: Colors.transparent,
//                                                                   pathBackgroundColor: Colors.transparent
//                                                               ),
//                                                             ),) : SizedBox(),
//                                                             // Container(
//                                                             //   decoration: BoxDecoration(color: Colors.orangeAccent, borderRadius: BorderRadius.circular(10)),
//                                                             //   height: 30,
//                                                             //   width: 100,
//                                                             //   child: Text('이미지 로딩중...', style: TextStyle(color: Colors.black),),
//                                                             // ) : SizedBox(),
//                                                           ],),
//                                                           ),
//
//                                                           SizedBox(height: 5,),
//                                                           /// 이미지
//                                                           indiDoc['imageUrl'].length != 0 ?
//                                                           InkWell(
//                                                             onTap: () {
//                                                               if (GetStorage().read('number') == indiDoc['number']) {
//                                                                 imageDialog(context, indiDoc.id, indiDoc['imageUrl'], true);
//                                                               }else {
//                                                                 imageDialog(context, indiDoc.id, indiDoc['imageUrl'], false);
//                                                               }
//
//                                                             },
//                                                             child: ClipRRect(
//                                                               borderRadius: BorderRadius.circular(5.0),
//                                                               child: Image.network(indiDoc['imageUrl']),
//                                                             ),
//                                                           )
//                                                               : SizedBox(),
//                                                           /// 이모티콘
//                                                           indiDoc['stamp'] == '' ? SizedBox() :
//                                                           Row(
//                                                             children: [
//                                                               Expanded(child: SizedBox()),
//                                                               Container(
//                                                                 height: 32,
//                                                                 child: Image.asset('assets/images/${indiDoc['stamp']}'),
//                                                               ),
//                                                             ],
//                                                           ),
//
//                                                           Divider(color: Colors.black,),
//                                                           Row(
//                                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                             children: [
//                                                               Row(
//                                                                 children: [
//                                                                   InkWell(
//                                                                     highlightColor: Colors.transparent,
//                                                                     hoverColor: Colors.transparent,
//                                                                     splashColor: Colors.transparent,
//                                                                     onTap: () {
//                                                                       if (indiDoc['like'].contains(GetStorage().read('number'))) {
//                                                                         BoardController.to.delLike(indiDoc.id, GetStorage().read('number'), 'board_indi');
//                                                                       }else {
//                                                                         BoardController.to.addLike(indiDoc.id, GetStorage().read('number'), 'board_indi');
//                                                                       }
//                                                                     },
//                                                                     child: Container(
//                                                                       width: 30,
//                                                                       child: indiDoc['like'].contains(GetStorage().read('number')) == true ?
//                                                                       Icon(Icons.favorite, size: 20, color: Colors.red,) :
//                                                                       Icon(Icons.favorite_border_outlined, size: 20, color: Colors.black,),
//                                                                     ),
//                                                                   ),
//                                                                   Text(indiDoc['like'].length.toString(), style: TextStyle(color: Colors.black),),
//                                                                 ],
//                                                               ),
//                                                               GetStorage().read('job') == 'teacher' ?
//                                                               /// 스탬프아이콘
//                                                               InkWell(
//                                                                 highlightColor: Colors.transparent,
//                                                                 hoverColor: Colors.transparent,
//                                                                 splashColor: Colors.transparent,
//                                                                 onTap: () {
//                                                                   if (indiDoc['stamp'] == '') {
//                                                                     BoardController.to.selectedStamp.value = 'stamp1.png';
//                                                                     BoardController.to.addStamp(indiDoc.id, 'board_indi');
//                                                                   }else if (indiDoc['stamp'] == 'stamp1.png') {
//                                                                     BoardController.to.selectedStamp.value = 'stamp2.png';
//                                                                     BoardController.to.addStamp(indiDoc.id, 'board_indi');
//                                                                   }else if (indiDoc['stamp'] == 'stamp2.png') {
//                                                                     BoardController.to.selectedStamp.value = 'stamp3.png';
//                                                                     BoardController.to.addStamp(indiDoc.id, 'board_indi');
//                                                                   }else if (indiDoc['stamp'] == 'stamp3.png') {
//                                                                     BoardController.to.selectedStamp.value = 'stamp4.png';
//                                                                     BoardController.to.addStamp(indiDoc.id, 'board_indi');
//                                                                   }else if (indiDoc['stamp'] == 'stamp4.png') {
//                                                                     BoardController.to.selectedStamp.value = 'stamp5.png';
//                                                                     BoardController.to.addStamp(indiDoc.id, 'board_indi');
//                                                                   }else if (indiDoc['stamp'] == 'stamp5.png') {
//                                                                     BoardController.to.selectedStamp.value = 'stamp6.png';
//                                                                     BoardController.to.addStamp(indiDoc.id, 'board_indi');
//                                                                   } else {
//                                                                     BoardController.to.selectedStamp.value = '';
//                                                                     BoardController.to.delStamp(indiDoc.id, 'board_indi');
//                                                                   }
//                                                                 },
//                                                                 child:  Image.asset('assets/images/stamp.png', width: 28, color: Colors.black.withOpacity(0.7),),
//                                                               ) : SizedBox(),
//                                                             ],
//                                                           ),
//                                                           SizedBox(height: 5,),
//                                                           /// 댓글허용 여부
//                                                           StreamBuilder<QuerySnapshot>(
//                                                               stream: FirebaseFirestore.instance.collection('board_main').where('class_code', isEqualTo: GetStorage().read('class_code'))
//                                                                   .where('main_id', isEqualTo: BoardController.to.selected_main_id).snapshots(),
//                                                               builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                                                                 if (!snapshot.hasData) {
//                                                                   return SizedBox();
//                                                                 }
//                                                                 return
//                                                                   Visibility(
//                                                                     visible: snapshot.data!.docs.first['isAcceptComment'],
//                                                                     child: Column(
//                                                                       children: [
//                                                                         /// 댓글
//                                                                         ListView.builder(
//                                                                             shrinkWrap: true,
//                                                                             itemCount: commentList.length,
//                                                                             itemBuilder: (_, index) {
//                                                                               commentCnt ++;
//                                                                               updCommentControllers.add(CustomPopupMenuController());
//                                                                               updCommentInputCnt ++;
//                                                                               updCommentInputControllers.add(TextEditingController());
//                                                                               return Column(
//                                                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                 children: [
//                                                                                   Row(
//                                                                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                                                     children: [
//                                                                                       Row(
//                                                                                         children: [
//                                                                                           Text(commentList[index]['name'], style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 11),),
//                                                                                           // Text(commentList[index]['name'], style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 11),),
//                                                                                           SizedBox(width: 2,),
//                                                                                           Text('('+commentList[index]['date'].toDate().month.toString()+'.'+commentList[index]['date'].toDate().day.toString()+' '+
//                                                                                               commentList[index]['date'].toDate().hour.toString()+':'+commentList[index]['date'].toDate().minute.toString()+')',
//                                                                                             style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 11),),
//                                                                                         ],
//                                                                                       ),
//                                                                                       GetStorage().read('name') == commentList[index]['name'] ?
//                                                                                       /// 댓글수정아이콘
//                                                                                       CustomPopupMenu(
//                                                                                         menuOnChange: (bool) {
//                                                                                           BoardController.to.indiCommentInput = commentList[index]['comment'];
//                                                                                           // 텍스트필드 커서 뒤로 보내기
//                                                                                           updCommentInputControllers[updCommentInputCnt - 1].text = BoardController.to.indiCommentInput;
//                                                                                           updCommentInputControllers[updCommentInputCnt - 1].selection = TextSelection.fromPosition(TextPosition(offset: updCommentInputControllers[updCommentInputCnt - 1].text.length));
//                                                                                         },
//                                                                                         controller: updCommentControllers[commentCnt-1],
//                                                                                         arrowSize: 20,
//                                                                                         child: Icon(Icons.edit_outlined, size: 17, color: Colors.black.withOpacity(0.3),),
//                                                                                         menuBuilder: () => ClipRRect(
//                                                                                           borderRadius: BorderRadius.circular(15),
//                                                                                           child: Container(
//                                                                                             width: 220,
//                                                                                             height: 200,
//                                                                                             color: Color(0xFF4C4C4C),
//                                                                                             child: IntrinsicWidth(
//                                                                                               child: Column(
//                                                                                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                                                                                   children: [
//                                                                                                     Row(
//                                                                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                                                                       children: [
//                                                                                                         Padding(
//                                                                                                           padding: const EdgeInsets.all(15),
//                                                                                                           child: InkWell(
//                                                                                                             onTap: () async{
//                                                                                                               await BoardController.to.delComment(indiDoc.id, commentList[index], 'board_indi');
//                                                                                                               for(var con in updCommentControllers)
//                                                                                                                 con.hideMenu();
//                                                                                                             },
//                                                                                                             child: Image.asset('assets/images/font_delete.png', height: 25),
//                                                                                                           ),
//                                                                                                           // child: ElevatedButton(
//                                                                                                           //   style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange,),
//                                                                                                           //   onPressed: () async{
//                                                                                                           //     await BoardController.to.delComment(indiDoc.id, commentList[index], 'board_indi');
//                                                                                                           //     for(var con in updCommentControllers)
//                                                                                                           //       con.hideMenu();
//                                                                                                           //   },
//                                                                                                           //   child: Text('삭제',style: TextStyle(fontFamily: 'Jua', fontSize: 15, color: Colors.white),),
//                                                                                                           // ),
//                                                                                                         ),
//                                                                                                         Padding(
//                                                                                                           padding: const EdgeInsets.all(15),
//                                                                                                           child: InkWell(
//                                                                                                             onTap: () async{
//                                                                                                               await BoardController.to.updComment(indiDoc.id, commentList[index], 'board_indi');
//                                                                                                               for(var con in updCommentControllers)
//                                                                                                                 con.hideMenu();
//                                                                                                             },
//                                                                                                             child: Image.asset('assets/images/font_upd.png', height: 25),
//                                                                                                           ),
//                                                                                                           // child: ElevatedButton(
//                                                                                                           //   style: ElevatedButton.styleFrom(backgroundColor: Color(0xff83B4B5),),
//                                                                                                           //   onPressed: () async{
//                                                                                                           //     // await 안하면 menutonchange가 먼저 실행되어 titleinput값이 제대로 반영 안됨
//                                                                                                           //     await BoardController.to.updComment(indiDoc.id, commentList[index], 'board_indi');
//                                                                                                           //     for(var con in updCommentControllers)
//                                                                                                           //       con.hideMenu();
//                                                                                                           //   },
//                                                                                                           //   child: Text('수정',style: TextStyle(fontFamily: 'Jua', fontSize: 15, color: Colors.white),),
//                                                                                                           // ),
//                                                                                                         ),
//                                                                                                       ],
//                                                                                                     ),
//                                                                                                     Padding(
//                                                                                                       padding: const EdgeInsets.only(left:10, right: 10),
//                                                                                                       // padding: const EdgeInsets.only(top: 10, right: 15,),
//                                                                                                       child: Container(
//                                                                                                         width: 200, height: 120,
//                                                                                                         child: TextField(
//                                                                                                           controller: updCommentInputControllers[updCommentInputCnt - 1],
//                                                                                                           textAlignVertical: TextAlignVertical.center,
//                                                                                                           onChanged: (value) {
//                                                                                                             BoardController.to.indiCommentInput = value;
//                                                                                                           },
//                                                                                                           style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 15, ),
//                                                                                                           // minLines: 1,
//                                                                                                           maxLines: 5,
//                                                                                                           decoration: InputDecoration(
//                                                                                                             // hintText: '제목을 입력하세요',
//                                                                                                             // hintStyle: TextStyle(fontSize: 19, color: Colors.grey.withOpacity(0.5)),
//                                                                                                             // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey, ),),
//                                                                                                             focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
//                                                                                                             enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
//                                                                                                             // contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//
//                                                                                                           ),
//                                                                                                         ),
//                                                                                                       ),
//                                                                                                     ),
//
//                                                                                                   ]
//                                                                                               ),
//                                                                                             ),
//                                                                                           ),
//                                                                                         ),
//                                                                                         pressType: PressType.singleClick,
//                                                                                         verticalMargin: -10,
//                                                                                       ) : SizedBox(),
//                                                                                     ],
//                                                                                   ),
//                                                                                   Text(commentList[index]['comment'], style: TextStyle(fontSize: 12, color: Colors.black,),),
//                                                                                   SizedBox(height: 3,),
//                                                                                 ],
//                                                                               );
//                                                                             }
//                                                                         ),
//                                                                         /// 이거 안해주면 index 에러남
//                                                                         Text((updTitleCnt++).toString(), style: TextStyle(fontSize: 0),),
//                                                                         Text((updContentCnt++).toString(), style: TextStyle(fontSize: 0),),
//                                                                         Text((addCommentCnt++).toString(), style: TextStyle(fontSize: 0),),
//                                                                         /// 댓글입력
//                                                                         Container(
//                                                                           height: 28,
//                                                                           child: TextField(
//                                                                             controller: addCommentControllers[addCommentCnt - 1],
//                                                                             textAlignVertical: TextAlignVertical.center,
//                                                                             onSubmitted: (value) {
//                                                                               BoardController.to.saveComment(indiDoc, value, 'board_indi');
//                                                                               for(var con in addCommentControllers)
//                                                                                 con.clear();
//                                                                             },
//
//                                                                             style: TextStyle(fontFamily: 'Jua', color: Colors.black, fontSize: 14, ),
//                                                                             // minLines: 1,
//                                                                             maxLines: 1,
//                                                                             decoration: InputDecoration(
//                                                                               hintText: '댓글 입력',
//                                                                               hintStyle: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.5)),
//                                                                               // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey, ),),
//                                                                               focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
//                                                                               enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
//                                                                               contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//
//                                                                             ),
//                                                                           ),
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                   );
//                                                               }
//                                                           ),
//                                                         ],
//                                                       ),
//
//
//                                                     ),
//                                                   ),
//                                                 );
//                                               }
//                                           ),
//
//                                         ],
//                                       ),
//                                     ),
//                                     );
//                                 }
//                             );
//                           },
//                         ),
//                       ),
//                       SizedBox(height: 40,),
//                     ],
//                   ),
//                   Container(
//                     // color: Colors.red,
//                     width: MediaQuery.of(context).size.width*0.01,
//                     height: MediaQuery.of(context).size.height,
//                   ),
//                 ],
//               ),
//
//             ],
//           ),
//         ),
//       ),
//     );
//
//   }
// }
//
//
//
//
//
//
//
