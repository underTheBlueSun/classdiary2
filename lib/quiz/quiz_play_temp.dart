// import 'package:classdiary2/controller/quiz_controller.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:collection/collection.dart';
// import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
// import 'package:flutter_math_fork/flutter_math.dart';
// import 'package:loading_indicator/loading_indicator.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:timer_count_down/timer_count_down.dart';
//
// class QuizPlay extends StatelessWidget {
//   CustomPopupMenuController popup_create_question_controller = CustomPopupMenuController();
//
//   Stack buildCountDowntText(time) {
//     if (time == '0') {
//       return Stack(
//         children: <Widget>[
//           Container(
//             alignment: Alignment.topCenter,
//             width: 300,
//             child: Text('출발!', style: TextStyle(fontSize: 150, fontFamily: 'Jua',
//               foreground: Paint()
//                 ..style = PaintingStyle.stroke
//                 ..strokeWidth = 10
//                 ..color = Colors.black,
//             ),
//             ),
//           ),
//           Container(
//               alignment: Alignment.topCenter,
//               width: 300,
//               child: Text('출발!', style: TextStyle(fontSize: 150, fontFamily: 'Jua', color: Colors.orange,),)),
//         ],
//       );
//     }else {
//       return Stack(
//         children: <Widget>[
//           Container(
//             alignment: Alignment.topCenter,
//             width: 200,
//             child: Text(time, style: TextStyle(fontSize: 150, fontFamily: 'Jua',
//               foreground: Paint()
//                 ..style = PaintingStyle.stroke
//                 ..strokeWidth = 10
//                 ..color = Colors.black,
//             ),
//             ),
//           ),
//           Container(
//               alignment: Alignment.topCenter,
//               width: 200,
//               child: Text(time, style: TextStyle(fontSize: 150, fontFamily: 'Jua', color: Colors.orange,),)),
//         ],
//       );
//     }
//   }
//
//   Stack buildTimerText(time) {
//     return Stack(
//       children: <Widget>[
//         Text(time, style: TextStyle(fontSize: 60, fontFamily: 'Jua',
//           foreground: Paint()
//             ..style = PaintingStyle.stroke
//             ..strokeWidth = 6
//             ..color = Colors.black.withOpacity(0.5),
//         ),
//         ),
//         Text(time, style: TextStyle(fontSize: 60, fontFamily: 'Jua', color: Colors.yellow.withOpacity(0.5),),),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('quiz_question').where('quiz_id', isEqualTo: QuizController.to.quiz_id).where('state', isEqualTo: 'active').snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: Container(
//               height: 40,
//               child: LoadingIndicator(
//                   indicatorType: Indicator.ballPulse,
//                   colors: QuizController.to.kDefaultRainbowColors,
//                   strokeWidth: 2,
//                   backgroundColor: Colors.transparent,
//                   pathBackgroundColor: Colors.transparent
//               ),
//             ),);
//           }
//           List docs = snapshot.data!.docs.toList();
//
//           /// updActiveQuestion 에서 이전것 furture delay 에서 active 지우면 streambuilder에서 에러남. 그래서 active는 안지우고 처음에 시작할때만 지움
//           docs.sort((a,b)=> a['number'].compareTo(b['number']));
//           DocumentSnapshot doc = docs.last;
//           if (doc['state'] == 'active') {
//             QuizController.to.is_visible_timer.value = true;
//           }
//
//           return Stack(
//             alignment: AlignmentDirectional.center,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// 왼쪽
//                   Container(
//                     width: MediaQuery.of(context).size.width*0.4,
//                     height: MediaQuery.of(context).size.height,
//                     // decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey.withOpacity(0.5),width: 2,),), ),
//                     child: Column(children: [
//                       SizedBox(height: 20,),
//                       Container(
//                         width: MediaQuery.of(context).size.width*0.38,
//                         // height: 200,
//                         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8),
//                           border: Border.all(color: Colors.grey.withOpacity(0.2),width: 1,),
//                           boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.4), spreadRadius: 1, blurRadius: 3, offset: Offset(1, 1),)],
//                         ),
//                         child : Row(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 SizedBox(height: 20,),
//                                 /// 제목
//                                 Text('  ● ' + QuizController.to.quiz_title, style: TextStyle(color: Colors.black, fontSize: 20,),),
//                                 SizedBox(height: 5,),
//                                 SizedBox(height: 5,),
//                                 /// 학년,학기,과목
//                                 Text('  ● ' + QuizController.to.quiz_grade.value + ' / ' + QuizController.to.quiz_semester.value + ' / ' +
//                                     QuizController.to.quiz_subject.value, style: TextStyle(color: Colors.black, fontSize: 20,),),
//                                 SizedBox(height: 5,),
//                                 /// 타이머
//                                 Text(QuizController.to.quiz_timer.value == 'X' ? '  ● 시간제한 없음' : '  ● ' + QuizController.to.quiz_timer.value + '초', style: TextStyle(color: Colors.black, fontSize: 20,),),
//                                 SizedBox(height: 5,),
//                                 /// 공개여부
//                                 Text('  ● ' + QuizController.to.quiz_public_type.value, style: TextStyle(color: Colors.black, fontSize: 20,),),
//                                 SizedBox(height: 15,),
//                               ],
//                             ),
//                             Spacer(),
//                             /// 타이머
//                             Obx(() => Visibility(
//                               visible: QuizController.to.is_visible_timer.value,
//                               child: Countdown(
//                                 seconds: 5,
//                                 // seconds: int.parse(QuizController.to.quiz_timer.value),
//                                 build: (BuildContext context, double time) {
//                                   return Padding(
//                                     padding: const EdgeInsets.all(10),
//                                     child: Row(children: [
//                                       Icon(Icons.timer),
//                                       SizedBox(width: 10,),
//                                       Container(
//                                           width: 30,
//                                           child: Text(time.toString(), style: TextStyle(color: Colors.black, fontSize: 20),))
//                                     ],),
//                                   );
//                                   // return buildTimerText(time.toString());
//                                 },
//                                 interval: Duration(milliseconds: 1000),
//                                 onFinished: () {
//                                   // QuizController.to.is_visible_start_btn.value = true;
//                                 },
//                               ),
//                             ),
//                             ),
//                             SizedBox(width: 50,),
//                           ],
//                         ),
//                       ),
//                       /// 문제
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           width: MediaQuery.of(context).size.width*0.38,
//                           decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8),
//                             border: Border.all(color: Colors.grey.withOpacity(0.5),width: 1,),
//                             boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.4), spreadRadius: 1, blurRadius: 3, offset: Offset(1, 1),)],
//                           ),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.all(15),
//                                       child: Row(
//                                         children: [
//                                           Container(
//                                             width: 19,
//                                             child:
//                                             CircleAvatar(
//                                               backgroundColor: Colors.black,
//                                               child: Center(
//                                                 child: Text(doc['number'].toString(), style: TextStyle(color: Colors.white, fontSize: 12,),),
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(width: 5,),
//                                           /// 질문
//                                           doc['question'].contains('\n') ?
//                                           Padding(
//                                             padding: const EdgeInsets.all(20),
//                                             child: Column(
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: [
//                                                 for (int index = 0; index < doc['question'].split('\n').length; index++)
//                                                   Math.tex(
//                                                     r'' + doc['question'].split('\n')[index].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
//                                                         .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
//                                                     mathStyle: MathStyle.display,
//                                                     textStyle: TextStyle(fontSize: 25, color: Colors.black),
//                                                   ),
//                                               ],
//                                             ),
//                                           ) :
//                                           Padding(
//                                             padding: const EdgeInsets.all(20),
//                                             child: Math.tex(
//                                               r'' + doc['question'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
//                                                   .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
//                                               mathStyle: MathStyle.display,
//                                               textStyle: TextStyle(fontSize: 25, color: Colors.black),
//                                             ),
//                                           )
//
//                                         ],
//                                       ),
//                                     ),
//                                     /// 답지
//                                     Padding(
//                                       padding: const EdgeInsets.only(left: 30, top:8, right: 8, bottom: 8),
//                                       child: Row(
//                                         children: [
//                                           Container(
//                                             width: 500,
//                                             decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(8),
//                                             ),
//                                             child: Padding(
//                                               padding: const EdgeInsets.all(8.0),
//                                               child: Row(
//                                                 children: [
//                                                   doc['question_type'] == '선택형' ? Icon(Icons.filter_1, color: Colors.teal,) :
//                                                   doc['question_type'] == 'OX형' ? Icon(Icons.circle_outlined, color: Colors.teal,) : SizedBox(),
//                                                   SizedBox(width: 10,),
//                                                   Math.tex(
//                                                     r'' + doc['answer1'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
//                                                         .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
//                                                     mathStyle: MathStyle.display,
//                                                     textStyle: TextStyle(fontSize: 23, color: Colors.black),
//                                                   ),
//                                                   Spacer(),
//                                                   doc['answer'] == '1' ? Icon(Icons.circle_outlined, color: Colors.green,) : Icon(Icons.clear, color: Colors.red,),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ],),
//                                     ),
//                                     doc['question_type'] != '단답형' ?
//                                     Padding(
//                                       padding: const EdgeInsets.only(left: 30, top:8, right: 8, bottom: 8),
//                                       child: Row(
//                                         children: [
//                                           Container(
//                                             width: 500,
//                                             decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(8),
//                                             ),
//                                             child: Padding(
//                                               padding: const EdgeInsets.all(8.0),
//                                               child: Row(
//                                                 children: [
//                                                   doc['question_type'] == '선택형' ? Icon(Icons.filter_2, color: Colors.deepPurple,) : Icon(Icons.circle_outlined, color: Colors.teal,),
//                                                   SizedBox(width: 10,),
//                                                   Math.tex(
//                                                     r'' + doc['answer2'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
//                                                         .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
//                                                     mathStyle: MathStyle.display,
//                                                     textStyle: TextStyle(fontSize: 23, color: Colors.black),
//                                                   ),
//                                                   Spacer(),
//                                                   doc['answer'] == '2' ? Icon(Icons.circle_outlined, color: Colors.green,) : Icon(Icons.clear, color: Colors.red,),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ],),
//                                     ) : SizedBox(),
//                                     doc['question_type'] == '선택형' ?
//                                     Padding(
//                                       padding: const EdgeInsets.only(left: 30, top:8, right: 8, bottom: 8),
//                                       child: Row(
//                                         children: [
//                                           Container(
//                                             width: 500,
//                                             decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(8),
//                                             ),
//                                             child: Padding(
//                                               padding: const EdgeInsets.all(8.0),
//                                               child: Row(
//                                                 children: [
//                                                   Icon(Icons.filter_3, color: Colors.blue,),
//                                                   SizedBox(width: 10,),
//                                                   Math.tex(
//                                                     r'' + doc['answer3'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
//                                                         .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
//                                                     mathStyle: MathStyle.display,
//                                                     textStyle: TextStyle(fontSize: 23, color: Colors.black),
//                                                   ),
//                                                   Spacer(),
//                                                   doc['answer'] == '3' ? Icon(Icons.circle_outlined, color: Colors.green,) : Icon(Icons.clear, color: Colors.red,),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ],),
//                                     ) : SizedBox(),
//                                     doc['question_type'] == '선택형' ?
//                                     Padding(
//                                       padding: const EdgeInsets.only(left: 30, top:8, right: 8, bottom: 8),
//                                       child: Row(
//                                         children: [
//                                           Container(
//                                             width: 500,
//                                             decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(8),),
//                                             child: Padding(
//                                               padding: const EdgeInsets.all(8.0),
//                                               child: Row(
//                                                 children: [
//                                                   Icon(Icons.filter_4, color: Colors.orange,),
//                                                   SizedBox(width: 10,),
//                                                   Math.tex(
//                                                     r'' + doc['answer4'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
//                                                         .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
//                                                     mathStyle: MathStyle.display,
//                                                     textStyle: TextStyle(fontSize: 23, color: Colors.black),
//                                                   ),
//                                                   Spacer(),
//                                                   doc['answer'] == '4' ? Icon(Icons.circle_outlined, color: Colors.green,) : Icon(Icons.clear, color: Colors.red,),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ],),
//                                     ) : SizedBox(),
//                                     SizedBox(height: 20,),
//                                   ],
//                                 ),
//                               ),
//                               Visibility(
//                                 visible: doc['question_image_url'].length > 0,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(20),
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(5.0),
//                                     child: Image.network(doc['question_image_url'], fit: BoxFit.cover, width: 200,),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20,),
//                       /// 다음문제
//                       Container(
//                         width: 200,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(backgroundColor: Color(0xff3E6888), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),),
//                           onPressed: () async{
//                             QuizController.to.updQuestionState(doc['number'], 'ready');
//                             // await QuizController.to.updActiveQuestion(doc['number'], 'ready');
//                             QuizController.to.is_visible_timer.value = false;
//                             QuizController.to.is_visible_count_down.value = true;
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.only(top: 10, bottom: 10, left: 11, right: 8),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(Icons.play_circle, color: Colors.white, size: 20,),
//                                 SizedBox(width: 10,),
//                                 Text('다음문제',style: TextStyle(fontFamily: 'Jua', fontSize: 17,  color: Colors.white),),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                     ),
//                   ),
//                   /// 오른쪽
//                   Container(
//                     width: MediaQuery.of(context).size.width*0.56,
//                     child: Text('afdsfdsf'),
//                   ),
//                 ],
//               ),
//               Obx(() => Visibility(
//                 visible: QuizController.to.is_visible_count_down.value,
//                 child: Countdown(
//                   seconds: 3,
//                   build: (BuildContext context, double time) {
//                     return buildCountDowntText(time.toString());
//                   },
//                   interval: Duration(milliseconds: 1000),
//                   onFinished: () {
//                     QuizController.to.updQuestionState(doc['number'], 'active');
//                     // QuizController.to.updActiveQuestion(doc['number'], 'active');
//                     QuizController.to.is_visible_count_down.value = false;
//                     // QuizController.to.is_visible_timer.value = false;
//                   },
//                 ),
//               ),
//               ),
//             ],);
//
//
//         }
//     );
//   }
// }
//
//
