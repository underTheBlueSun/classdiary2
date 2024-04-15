// import 'package:classdiary2/controller/quiz_controller.dart';
// import 'package:classdiary2/quiz/quiz_add_question.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
// import 'package:flutter_math_fork/flutter_math.dart';
// import 'package:flutter_tex/flutter_tex.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:loading_indicator/loading_indicator.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'quiz_upd_question.dart';
//
// class QuizAllDetail extends StatelessWidget {
//   CustomPopupMenuController popup_create_question_controller = CustomPopupMenuController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         /// 왼쪽
//         Container(
//           // width: 280,
//           width: MediaQuery.of(context).size.width*0.15,
//           height: MediaQuery.of(context).size.height,
//           decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey.withOpacity(0.5),width: 2,),), ),
//           child: Column(children: [
//             Container(
//               // width: 245,
//               width: MediaQuery.of(context).size.width*0.14,
//               height: 600,
//               decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.grey.withOpacity(0.2),width: 1,),),
//               child: Column(
//                 children: [
//                   SizedBox(height: 20,),
//                   /// 제목
//                   Container(
//                     // width: 205,
//                     width: MediaQuery.of(context).size.width*0.13,
//                     height: 80,
//                     decoration: BoxDecoration(color: Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(8),),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(QuizController.to.quiz_title, style: TextStyle(color: Colors.black, fontSize: 13,),),
//                     ),
//                   ),
//                   SizedBox(height: 15,),
//                   /// 설명
//                   Container(
//                     // width: 205, // 2048/0.1 = 204.8,
//                     width: MediaQuery.of(context).size.width*0.13,
//                     height: 150,
//                     decoration: BoxDecoration(color: Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(8),),
//                     child: SingleChildScrollView(
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(QuizController.to.quiz_description, style: TextStyle(color: Colors.black, fontSize: 13,),),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 15,),
//                   /// 학년,학기,과목
//                   Container(
//                     // width: 205, // 2048/0.1 = 204.8,
//                     width: MediaQuery.of(context).size.width*0.13,
//                     height: 40,
//                     decoration: BoxDecoration(color: Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(8),),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(QuizController.to.quiz_grade.value + ' / ' + QuizController.to.quiz_semester.value + ' / ' +
//                           QuizController.to.quiz_subject.value, style: TextStyle(color: Colors.black, fontSize: 13,),),
//                     ),
//                   ),
//                   SizedBox(height: 15,),
//                   /// 퀴즈유형
//                   Container(
//                     width: MediaQuery.of(context).size.width*0.13,
//                     height: 40,
//                     decoration: BoxDecoration(color: Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(8),),
//                     child: Row(
//                       children: [
//                         SizedBox(width: 10,),
//                         Text('퀴즈유형 : ', style: TextStyle(color: Colors.black, fontSize: 13,),),
//                         SizedBox(width: 10,),
//                         Text(QuizController.to.quiz_quiz_type.value, style: TextStyle(color: Colors.black, fontSize: 13,),),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 15,),
//                   QuizController.to.quiz_quiz_type.value == '개인' ?
//                   Column(children: [
//                     /// 문제당 시간
//                     Container(
//                       // width: 205, // 2048/0.1 = 204.8,
//                       width: MediaQuery.of(context).size.width*0.13,
//                       height: 40,
//                       decoration: BoxDecoration(color: Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(8),),
//                       child: Row(
//                         children: [
//                           SizedBox(width: 10,),
//                           // Icon(Icons.access_time, color: Colors.black),
//                           Text('문제당 시간(초) : ', style: TextStyle(color: Colors.black, fontSize: 13,),),
//                           SizedBox(width: 10,),
//                           Text(QuizController.to.quiz_indi_timer.value == 'X' ? '시간제한 없음' : QuizController.to.quiz_indi_timer.value + '초', style: TextStyle(color: Colors.black, fontSize: 13,),),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 15,),
//                   ],) :
//                   Column(children: [
//                     /// 퀴즈 총시간
//                     Container(
//                       width: MediaQuery.of(context).size.width*0.13,
//                       height: 40,
//                       decoration: BoxDecoration(color: Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(8),),
//                       child: Row(
//                         children: [
//                           SizedBox(width: 10,),
//                           // Icon(Icons.access_time, color: Colors.black),
//                           Text('퀴즈 총시간 : ', style: TextStyle(color: Colors.black, fontSize: 13,),),
//                           SizedBox(width: 10,),
//                           Text(QuizController.to.quiz_modum_total_timer.value + '분', style: TextStyle(color: Colors.black, fontSize: 13,),),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 15,),
//                     /// 개인당 시간
//                     Container(
//                       width: MediaQuery.of(context).size.width*0.13,
//                       height: 40,
//                       decoration: BoxDecoration(color: Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(8),),
//                       child: Row(
//                         children: [
//                           SizedBox(width: 10,),
//                           // Icon(Icons.access_time, color: Colors.black),
//                           Text('개인당 시간 : ', style: TextStyle(color: Colors.black, fontSize: 13,),),
//                           SizedBox(width: 10,),
//                           Text(QuizController.to.quiz_modum_indi_timer.value + '초', style: TextStyle(color: Colors.black, fontSize: 13,),),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 15,),
//                   ],),
//
//
//
//
//                   /// 공개여부
//                   Container(
//                     // width: 205, // 2048/0.1 = 204.8,
//                     width: MediaQuery.of(context).size.width*0.13,
//                     height: 40,
//                     decoration: BoxDecoration(color: Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(8),),
//                     child: Row(
//                       children: [
//                         SizedBox(width: 10,),
//                         Icon(Icons.share, color: Colors.black),
//                         SizedBox(width: 10,),
//                         Text(QuizController.to.quiz_public_type.value, style: TextStyle(color: Colors.black, fontSize: 13,),),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],),
//         ),
//         /// 오른쪽
//         StreamBuilder<QuerySnapshot>(
//             stream: FirebaseFirestore.instance.collection('quiz_question').where('quiz_id', isEqualTo: QuizController.to.quiz_id).snapshots(),
//             builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//               if (!snapshot.hasData) {
//                 return Center(child: Container(
//                   height: 40,
//                   child: LoadingIndicator(
//                       indicatorType: Indicator.ballPulse,
//                       colors: QuizController.to.kDefaultRainbowColors,
//                       strokeWidth: 2,
//                       backgroundColor: Colors.transparent,
//                       pathBackgroundColor: Colors.transparent
//                   ),
//                 ),);
//               }
//
//               List docs = snapshot.data!.docs.toList();
//               docs.sort((a,b)=> a['date'].compareTo(b['date']));
//               return Flexible(
//                 child: GridView.builder(
//                   primary: false,
//                   shrinkWrap: true,
//                   padding: EdgeInsets.all(15),
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     childAspectRatio: MediaQuery.of(context).size.width > 1700 ? 2/1 : 2/1.5,
//                     // childAspectRatio: MediaQuery.of(context).size.width > 1800 ? 2/1 : 2/1.5,
//                   ),
//                   itemCount: docs.length,
//                   itemBuilder: (context, index) {
//                     DocumentSnapshot doc = docs[index];
//                     return Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Container(
//                         width: MediaQuery.of(context).size.width*0.85/2,
//                         decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
//                           border: Border.all(color: Colors.grey.withOpacity(0.5),width: 1,),
//                           boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.4), spreadRadius: 1, blurRadius: 3, offset: Offset(1, 1),)],
//                         ),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(15),
//                                     child: Row(
//                                       children: [
//                                         Container(
//                                           width: 19,
//                                           child:
//                                           CircleAvatar(
//                                             backgroundColor: Colors.black,
//                                             child: Center(
//                                               child: Text(doc['number'].toString(), style: TextStyle(color: Colors.white, fontSize: 12,),),
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(width: 5,),
//                                         /// 질문
//                                         doc['question'].contains('{') || doc['question'].contains('^2') || doc['question'].contains('[')
//                                             || doc['question'].contains('times') || doc['question'].contains('div') ?
//                                         doc['question'].contains('\n') ?
//                                         Padding(
//                                           padding: const EdgeInsets.all(20),
//                                           child: Column(
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               for (int index = 0; index < doc['question'].split('\n').length; index++)
//                                               /// 모바일은 TeXView 사용. 왜냐 TeXView는 한 화면에 여러개 사용하면 꼬임. 근데 TeXView는 자동으로 줄바꿔주어서 좋음
//                                                 Math.tex(
//                                                   r'' + doc['question'].split('\n')[index].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
//                                                       .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
//                                                   mathStyle: MathStyle.display,
//                                                   textStyle: TextStyle(fontSize: 17, color: Colors.black),
//                                                 ),
//                                             ],
//                                           ),
//                                         ) :
//                                         Container(
//                                           width: MediaQuery.of(context).size.width*0.3,
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(20),
//                                             child: Math.tex(
//                                               r'' + doc['question'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
//                                                   .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
//                                               mathStyle: MathStyle.display, textStyle: TextStyle(fontSize: 17, color: Colors.black),
//                                             ),
//                                           ),
//                                         ):
//                                         Container(
//                                           width: doc['question_image_url'].length > 0 ? MediaQuery.of(context).size.width*0.25 : MediaQuery.of(context).size.width*0.3,
//                                           child: Text(doc['question'], style: TextStyle(fontFamily: 'NanumGothic',  fontSize: 17, color: Colors.black, ),),
//                                         ),
//
//                                       ],
//                                     ),
//                                   ),
//                                   /// 답지
//                                   Padding(
//                                     padding: const EdgeInsets.only(left: 30, top:8, right: 8, bottom: 8),
//                                     child: Row(
//                                       children: [
//                                         Container(
//                                           width: doc['question_image_url'].length > 0 ? MediaQuery.of(context).size.width*0.25 : MediaQuery.of(context).size.width*0.3,
//                                           decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(8),
//                                           ),
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Row(
//                                               children: [
//                                                 doc['question_type'] == '선택형' ? Icon(Icons.filter_1, color: Colors.teal,) :
//                                                 doc['question_type'] == 'OX형' ? Text('예', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),) : SizedBox(),
//                                                 SizedBox(width: 10,),
//                                                 doc['answer1'].contains('{') || doc['answer1'].contains('^2') || doc['answer1'].contains('[')
//                                                     || doc['answer1'].contains('times') || doc['answer1'].contains('div') ?
//                                                 Math.tex(
//                                                   r'' + doc['answer1'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
//                                                       .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
//                                                   mathStyle: MathStyle.display,
//                                                   textStyle: TextStyle(fontSize: 16, color: Colors.black),
//                                                 ) :
//                                                 Container(
//                                                   width: doc['question_image_url'].length > 0 ? MediaQuery.of(context).size.width*0.2 : MediaQuery.of(context).size.width*0.25,
//                                                   child: Text(doc['answer1'], style: TextStyle(fontSize: 15, color: Colors.black, ),),
//                                                 ),
//                                                 Spacer(),
//                                                 doc['answer'] == '1' ? Icon(Icons.circle_outlined, color: Colors.green,) : Icon(Icons.clear, color: Colors.red,),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ],),
//                                   ),
//                                   doc['question_type'] != '단답형' ?
//                                   Padding(
//                                     padding: const EdgeInsets.only(left: 30, top:8, right: 8, bottom: 8),
//                                     child: Row(
//                                       children: [
//                                         Container(
//                                           width: doc['question_image_url'].length > 0 ? MediaQuery.of(context).size.width*0.25 : MediaQuery.of(context).size.width*0.3,
//                                           decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(8),
//                                           ),
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Row(
//                                               children: [
//                                                 doc['question_type'] == '선택형' ? Icon(Icons.filter_2, color: Colors.deepPurple,) :
//                                                 Text('아니오', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
//                                                 // doc['question_type'] == '선택형' ? Icon(Icons.filter_2, color: Colors.deepPurple,) : Icon(Icons.clear  , color: Colors.red,),
//                                                 SizedBox(width: 10,),
//                                                 doc['answer2'].contains('{') || doc['answer2'].contains('^2') || doc['answer2'].contains('[')
//                                                     || doc['answer2'].contains('times') || doc['answer2'].contains('div') ?
//                                                 Math.tex(
//                                                   r'' + doc['answer2'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
//                                                       .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
//                                                   mathStyle: MathStyle.display,
//                                                   textStyle: TextStyle(fontSize: 16, color: Colors.black),
//                                                 ) :
//                                                 Container(
//                                                   width: doc['question_image_url'].length > 0 ? MediaQuery.of(context).size.width*0.2 : MediaQuery.of(context).size.width*0.25,
//                                                   child: Text(doc['answer2'], style: TextStyle(fontSize: 15, color: Colors.black, ),),
//                                                 ),
//                                                 Spacer(),
//                                                 doc['answer'] == '2' ? Icon(Icons.circle_outlined, color: Colors.green,) : Icon(Icons.clear, color: Colors.red,),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ],),
//                                   ) : SizedBox(),
//                                   doc['question_type'] == '선택형' ?
//                                   Padding(
//                                     padding: const EdgeInsets.only(left: 30, top:8, right: 8, bottom: 8),
//                                     child: Row(
//                                       children: [
//                                         Container(
//                                           width: doc['question_image_url'].length > 0 ? MediaQuery.of(context).size.width*0.25 : MediaQuery.of(context).size.width*0.3,
//                                           decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(8),
//                                           ),
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Row(
//                                               children: [
//                                                 Icon(Icons.filter_3, color: Colors.blue,),
//                                                 SizedBox(width: 10,),
//                                                 doc['answer3'].contains('{') || doc['answer3'].contains('^2') || doc['answer3'].contains('[')
//                                                     || doc['answer3'].contains('times') || doc['answer3'].contains('div') ?
//                                                 Math.tex(
//                                                   r'' + doc['answer3'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
//                                                       .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
//                                                   mathStyle: MathStyle.display,
//                                                   textStyle: TextStyle(fontSize: 16, color: Colors.black),
//                                                 ) :
//                                                 Container(
//                                                     width: doc['question_image_url'].length > 0 ? MediaQuery.of(context).size.width*0.2 : MediaQuery.of(context).size.width*0.25,
//                                                     child: Text(doc['answer3'], style: TextStyle(fontSize: 15, color: Colors.black, ),)),
//                                                 Spacer(),
//                                                 doc['answer'] == '3' ? Icon(Icons.circle_outlined, color: Colors.green,) : Icon(Icons.clear, color: Colors.red,),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ],),
//                                   ) : SizedBox(),
//                                   doc['question_type'] == '선택형' ?
//                                   Padding(
//                                     padding: const EdgeInsets.only(left: 30, top:8, right: 8, bottom: 8),
//                                     child: Row(
//                                       children: [
//                                         Container(
//                                           width: doc['question_image_url'].length > 0 ? MediaQuery.of(context).size.width*0.25 : MediaQuery.of(context).size.width*0.3,
//                                           decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(8),),
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Row(
//                                               children: [
//                                                 Icon(Icons.filter_4, color: Colors.orange,),
//                                                 SizedBox(width: 10,),
//                                                 doc['answer4'].contains('{') || doc['answer4'].contains('^2') || doc['answer4'].contains('[')
//                                                     || doc['answer4'].contains('times') || doc['answer4'].contains('div') ?
//                                                 Math.tex(
//                                                   r'' + doc['answer4'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
//                                                       .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
//                                                   mathStyle: MathStyle.display,
//                                                   textStyle: TextStyle(fontSize: 16, color: Colors.black),
//                                                 ) :
//                                                 Container(
//                                                     width: doc['question_image_url'].length > 0 ? MediaQuery.of(context).size.width*0.2 : MediaQuery.of(context).size.width*0.25,
//                                                     child: Text(doc['answer4'], style: TextStyle(fontSize: 15, color: Colors.black, ),)),
//                                                 Spacer(),
//                                                 doc['answer'] == '4' ? Icon(Icons.circle_outlined, color: Colors.green,) : Icon(Icons.clear, color: Colors.red,),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ],),
//                                   ) : SizedBox(),
//                                 ],
//                               ),
//                             ),
//                             Visibility(
//                               visible: doc['question_image_url'].length > 0,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(20),
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(5.0),
//                                   child: Image.network(doc['question_image_url'], fit: BoxFit.cover, width: 180,),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//
//                   },
//
//                 ),
//               );
//
//             }
//         ),
//
//       ],
//     );
//
//   }
// }
//
//
