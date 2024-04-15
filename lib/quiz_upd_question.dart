// import 'dart:typed_data';
//
// import 'package:classdiary2/controller/quiz_controller.dart';
// import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_math_fork/flutter_math.dart';
// import 'package:flutter_tex/flutter_tex.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class QuizUpdQuestion extends StatelessWidget {
//   List math_befores = ['+', '-', 'times', 'div', '[]', '{1/2}', '2{1/2}', 'cm^2'];
//   List math_afters = [r'+', r'-', r'\times', r'\div', r'\Box', r'{1 \over 2}', r'2{1 \over 2}', r'{cm^2}'];
//   CustomPopupMenuController popup_create_question_controller = CustomPopupMenuController();
//
//   void mathDialog(context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Color(0xFF4C4C4C),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               TextButton(
//                 style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: Text('닫기',style: TextStyle(fontFamily: 'Jua', fontSize: 20,  color: Colors.white, ),),
//               ),
//             ],
//           ),
//           content: Container(
//             width: 500,
//             height: 700,
//             child: Padding(
//               padding: const EdgeInsets.all(15),
//               child: Column(
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.5),width: 1,),), ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text('입력',style: TextStyle(fontFamily: 'Jua', fontSize: 18,  color: Colors.white, ),),
//                           Text('결과',style: TextStyle(fontFamily: 'Jua', fontSize: 18,  color: Colors.white, ),),
//                         ],),
//                     ),
//                   ),
//                   for (int index = 0; index < math_befores.length; index++)
//                     Container(
//                       decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.5),width: 1,),), ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(15),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(math_befores[index],style: TextStyle(fontSize: 18,  color: Colors.white, ),),
//                             Math.tex(math_afters[index], mathStyle: MathStyle.display, textStyle: TextStyle(fontSize: 18, color: Colors.orange),),
//                           ],),
//                       ),
//                     ),
//                   Container(
//                     decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.5),width: 1,),), ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(15),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text('1{5/6} div {1/4} times 2를 (엔터) \n계산하세요',style: TextStyle(fontSize: 18,  color: Colors.white, ),),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Math.tex(r'1{5 \over 6} \div {1 \over 4} \times 2를', mathStyle: MathStyle.display, textStyle: TextStyle(fontSize: 18, color: Colors.orange),),
//                               Math.tex(r'계산하세요', mathStyle: MathStyle.display, textStyle: TextStyle(fontSize: 18, color: Colors.orange),),
//                             ],
//                           ),
//                         ],),
//                     ),
//                   ),
//                 ],),
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
//     return Column(
//         children: [
//           SizedBox(height: 10,),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               TextButton(
//                 style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
//                 onPressed: () {
//                   QuizController.to.imageInt8.value = Uint8List(0);
//                   QuizController.to.imageInt8_answer1.value = Uint8List(0);
//                   QuizController.to.imageInt8_answer2.value = Uint8List(0);
//                   QuizController.to.imageInt8_answer3.value = Uint8List(0);
//                   QuizController.to.imageInt8_answer4.value = Uint8List(0);
//                   // QuizController.to.question_tex.value = '';
//                   // QuizController.to.answer1_tex.value = '';
//                   // QuizController.to.answer2_tex.value = '';
//                   // QuizController.to.answer3_tex.value = '';
//                   // QuizController.to.answer4_tex.value = '';
//                   QuizController.to.answer.value = '';
//                   QuizController.to.answer1.value = '';
//                   QuizController.to.answer2.value = '';
//                   QuizController.to.answer3.value = '';
//                   QuizController.to.answer4.value = '';
//                   Navigator.pop(context);
//                 },
//                 child: Text('취소',style: TextStyle(fontFamily: 'Jua', fontSize: 20,  color: Colors.white, ),),
//               ),
//               Row(
//                 children: [
//                   TextButton(
//                     style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
//                     onPressed: () {
//                       mathDialog(context);
//                     },
//                     child: Text('수식표',style: TextStyle(fontFamily: 'Jua', fontSize: 20,  color: Colors.white, ),),
//                   ),
//                   SizedBox(width: 20,),
//                   TextButton(
//                     style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
//                     onPressed: () {
//                       QuizController.to.selectImage('질문');
//                     },
//                     child: Text('사진',style: TextStyle(fontFamily: 'Jua', fontSize: 20,  color: Colors.white, ),),
//                   ),
//                   SizedBox(width: 20,),
//                   TextButton(
//                     style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
//                     onPressed: () async{
//                       await QuizController.to.updQuestionSelect();
//                       Navigator.pop(context);
//                     },
//                     child: Text('저장',style: TextStyle(fontFamily: 'Jua', fontSize: 20,  color: Colors.white, ),),
//                   ),
//                 ],
//               ),
//
//             ],
//           ),
//           SizedBox(height: 20,),
//           /// 질문,수식
//           Container(
//             width: 680,
//             decoration: BoxDecoration(color: Color(0xff3C3C3C), borderRadius: BorderRadius.circular(10)),
//             child: Column(
//               children: [
//                 SizedBox(
//                   width: 680,
//                   child: TextField(
//                     controller: TextEditingController(text: QuizController.to.question.value),
//                     textAlignVertical: TextAlignVertical.center,
//                     onChanged: (value) {
//                       QuizController.to.question.value = value;
//                       QuizController.to.question_tex.value = r'' + value.replaceAll('{', r'\({').replaceAll('}', r'}\)').replaceAll('/', r'\over').replaceAll('\n', r'$$ $$')
//                           .replaceAll('[', '□').replaceAll(']', '').replaceAll('times', '×').replaceAll('div', '÷').replaceAll('^2', r'\({^2}\)');
//                     },
//                     style: TextStyle(color: Colors.white , fontSize: 18, ),
//                     // style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 19, ),
//                     keyboardType: TextInputType.multiline,
//                     maxLines: null,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Color(0xff3C3C3C),
//                       hintText: '질문을 입력하세요',
//                       hintStyle: TextStyle(fontSize: 17, color: Colors.grey.withOpacity(0.5)),
//                       focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Color(0xff3C3C3C),  ),),
//                       enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Color(0xff3C3C3C),  ),),
//                       contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//
//                     ),
//                   ),
//                 ),
//                 Obx(() => Visibility(
//                   visible: QuizController.to.question.value.contains('{') || QuizController.to.question.value.contains('times') || QuizController.to.question.value.contains('div')
//                       || QuizController.to.question.value.contains('[') || QuizController.to.question.value.contains('^2') ,
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 15, right: 15),
//                         child: Divider(color: Color(0xff4C4C4C), thickness: 1,),
//                       ),
//                       QuizController.to.question.value.contains('\n') ?
//                       Padding(
//                         padding: const EdgeInsets.all(10),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             for (int index = 0; index < QuizController.to.question.value.split('\n').length; index++)
//                               Container(
//                                 width: 680,
//                                 child: Math.tex(
//                                   r'' + QuizController.to.question.value.split('\n')[index].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
//                                       .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
//                                   mathStyle: MathStyle.display,
//                                   textStyle: TextStyle(fontSize: 17, color: Colors.orange),
//                                 ),
//                               ),
//
//                           ],
//                         ),
//                       ) :
//                       Padding(
//                         padding: const EdgeInsets.all(10),
//                         child: Container(
//                           width: 680,
//                           child: Math.tex(
//                             r'' + QuizController.to.question.value.replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
//                                 .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
//                             mathStyle: MathStyle.display,
//                             textStyle: TextStyle(fontSize: 17, color: Colors.orange),
//                           ),
//                         ),
//                       ),
//
//
//                     ],
//                   ),
//                 ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 20,),
//           /// 사진 이미지
//           Obx(() => Visibility(
//             visible: QuizController.to.imageInt8.value.length > 0 || QuizController.to.question_image_url.value.length > 0,
//             child: Stack(
//                 children: [
//                   QuizController.to.imageInt8.value.length > 0 ?
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(5.0),
//                     child: Image.memory(QuizController.to.imageInt8.value!, fit: BoxFit.cover, width: 250,),
//                   ) :
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(5.0),
//                     child: Image.network(QuizController.to.question_image_url.value, fit: BoxFit.cover, width: 250,),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.delete_forever), color: Colors.black, iconSize: 40,
//                     onPressed: () {
//                       if (QuizController.to.imageInt8.value.length > 0) {
//                         QuizController.to.imageInt8.value = Uint8List(0);
//                       }else {
//                         QuizController.to.question_image_url.value = '';
//                       }
//                     },
//                   ),
//                 ]
//             ),
//           ),),
//           SizedBox(height: 20,),
//           /// 답지
//           QuizController.to.question_type.value == '선택형' ?
//           Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// 1번
//                   Container(
//                     width: 330,
//                     decoration: BoxDecoration(color: Color(0xff3C3C3C), borderRadius: BorderRadius.circular(10),),
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             SizedBox(
//                               width: 290,
//                               child: TextField(
//                                 controller: TextEditingController(text: QuizController.to.answer1.value),
//                                 textAlignVertical: TextAlignVertical.center,
//                                 onChanged: (value) {
//                                   QuizController.to.answer1.value = value;
//                                   QuizController.to.answer1_tex.value = r'' + value.replaceAll('{', r'\({').replaceAll('}', r'}\)').replaceAll('/', r'\over').replaceAll('\n', r'$$ $$')
//                                       .replaceAll('[', '□').replaceAll(']', '').replaceAll('times', '×').replaceAll('div', '÷').replaceAll('^2', r'\({^2}\)');
//                                 },
//                                 style: TextStyle(color: Colors.white , fontSize: 16, ),
//                                 // style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 19, ),
//                                 keyboardType: TextInputType.multiline,
//                                 maxLines: null,
//                                 decoration: InputDecoration(
//                                   prefixIcon: IconButton(
//                                     splashColor: Colors.transparent,
//                                     highlightColor: Colors.transparent,
//                                     icon: Icon(Icons.filter_1), color:  Colors.teal,
//                                     onPressed: () {
//                                       QuizController.to.answer.value = '1';
//                                     },
//                                   ),
//                                   suffixIcon: Obx(() => QuizController.to.answer.value == '1' ? Icon(Icons.circle_outlined, color: Colors.green,) : Icon(Icons.clear, color: Colors.red,),
//                                   ),
//                                   filled: true,
//                                   fillColor: Color(0xff3C3C3C),
//                                   hintText: '1번 선택지 입력',
//                                   hintStyle: TextStyle(fontSize: 16, color: Colors.grey.withOpacity(0.5)),
//                                   focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Color(0xff3C3C3C),  ),),
//                                   enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Color(0xff3C3C3C),  ),),
//                                   contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 40,
//                               child: IconButton(splashColor: Colors.transparent, highlightColor: Colors.transparent, icon: Icon(Icons.photo), color: Colors.white.withOpacity(0.5),
//                                 onPressed: () {
//                                   QuizController.to.selectImage('답지1');
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                         Obx(() => Visibility(
//                             visible: QuizController.to.answer1.value.contains('{') || QuizController.to.answer1.value.contains('times') || QuizController.to.answer1.value.contains('div')
//                                 || QuizController.to.answer1.value.contains('[') || QuizController.to.answer1.value.contains('^2') ,
//                             child: Column(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 15, right: 15),
//                                   child: Divider(color: Color(0xff4C4C4C), thickness: 1,),
//                                 ),
//                                 QuizController.to.answer1.value.contains('\n') ?
//                                 Padding(
//                                   padding: const EdgeInsets.all(10),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       for (int index = 0; index < QuizController.to.answer1.value.split('\n').length; index++)
//                                         Container(
//                                           width: 680,
//                                           child: Math.tex(
//                                             r'' + QuizController.to.answer1.value.split('\n')[index].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
//                                                 .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
//                                             mathStyle: MathStyle.display,
//                                             textStyle: TextStyle(fontSize: 17, color: Colors.orange),
//                                           ),
//                                         ),
//
//                                     ],
//                                   ),
//                                 ) :
//                                 Padding(
//                                   padding: const EdgeInsets.all(10),
//                                   child: Container(
//                                     width: 680,
//                                     child: Math.tex(
//                                       r'' + QuizController.to.answer1.value.replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
//                                           .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
//                                       mathStyle: MathStyle.display,
//                                       textStyle: TextStyle(fontSize: 17, color: Colors.orange),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Obx(() => Visibility(
//                             visible: QuizController.to.imageInt8_answer1.value.length > 0 || QuizController.to.answer1_image_url.length > 0,
//                             child: Column(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 15, right: 15),
//                                   child: Divider(color: Color(0xff4C4C4C), thickness: 1,),
//                                 ),
//                                 Stack(
//                                     children: [
//                                       QuizController.to.imageInt8_answer1.value.length > 0 ?
//                                       ClipRRect(
//                                         borderRadius: BorderRadius.circular(5.0),
//                                         child: Image.memory(QuizController.to.imageInt8_answer1.value!, fit: BoxFit.cover, width: 330,),
//                                       ) :
//                                       ClipRRect(
//                                         borderRadius: BorderRadius.circular(5.0),
//                                         child: Image.network(QuizController.to.answer1_image_url, fit: BoxFit.cover, width: 330,),
//                                       ),
//                                       IconButton(
//                                         icon: Icon(Icons.delete_forever), color: Colors.black, iconSize: 40,
//                                         onPressed: () {
//                                           if (QuizController.to.imageInt8_answer1.value.length > 0) {
//                                             QuizController.to.imageInt8_answer1.value = Uint8List(0);
//                                           }else {
//                                             QuizController.to.answer1_image_url = '';
//                                           }
//
//                                         },
//                                       ),
//                                     ]
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   /// 2번
//                   Container(
//                     width: 330,
//                     decoration: BoxDecoration(color: Color(0xff3C3C3C), borderRadius: BorderRadius.circular(10)),
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             SizedBox(
//                               width: 290,
//                               child: TextField(
//                                 controller: TextEditingController(text: QuizController.to.answer2.value),
//                                 textAlignVertical: TextAlignVertical.center,
//                                 onChanged: (value) {
//                                   QuizController.to.answer2.value = value;
//                                   QuizController.to.answer2_tex.value = r'' + value.replaceAll('{', r'\({').replaceAll('}', r'}\)').replaceAll('/', r'\over').replaceAll('\n', r'$$ $$')
//                                       .replaceAll('[', '□').replaceAll(']', '').replaceAll('times', '×').replaceAll('div', '÷').replaceAll('^2', r'\({^2}\)');
//                                 },
//                                 style: TextStyle(color: Colors.white , fontSize: 16, ),
//                                 keyboardType: TextInputType.multiline,
//                                 maxLines: null,
//                                 decoration: InputDecoration(
//                                   prefixIcon: IconButton(
//                                     splashColor: Colors.transparent,
//                                     highlightColor: Colors.transparent,
//                                     icon: Icon(Icons.filter_2), color:  Colors.deepPurple,
//                                     onPressed: () {
//                                       QuizController.to.answer.value = '2';
//                                     },
//                                   ),
//                                   suffixIcon: Obx(() => QuizController.to.answer.value == '2' ? Icon(Icons.circle_outlined, color: Colors.green,) : Icon(Icons.clear, color: Colors.red,),
//                                   ),
//                                   filled: true,
//                                   fillColor: Color(0xff3C3C3C),
//                                   hintText: '2번 선택지 입력',
//                                   hintStyle: TextStyle(fontSize: 16, color: Colors.grey.withOpacity(0.5)),
//                                   focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Color(0xff3C3C3C),  ),),
//                                   enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Color(0xff3C3C3C),  ),),
//                                   contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 40,
//                               child: IconButton(splashColor: Colors.transparent, highlightColor: Colors.transparent, icon: Icon(Icons.photo), color: Colors.white.withOpacity(0.5),
//                                 onPressed: () {
//                                   QuizController.to.selectImage('답지2');
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                         Obx(() => Visibility(
//                             visible: QuizController.to.answer2.value.contains('{') || QuizController.to.answer2.value.contains('times') || QuizController.to.answer2.value.contains('div')
//                                 || QuizController.to.answer2.value.contains('[') || QuizController.to.answer2.value.contains('^2') ,
//                             child: Column(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 15, right: 15),
//                                   child: Divider(color: Color(0xff4C4C4C), thickness: 1,),
//                                 ),
//                                 QuizController.to.answer2.value.contains('\n') ?
//                                 Padding(
//                                   padding: const EdgeInsets.all(10),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       for (int index = 0; index < QuizController.to.answer2.value.split('\n').length; index++)
//                                         Container(
//                                           width: 680,
//                                           child: Math.tex(
//                                             r'' + QuizController.to.answer2.value.split('\n')[index].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
//                                                 .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
//                                             mathStyle: MathStyle.display,
//                                             textStyle: TextStyle(fontSize: 17, color: Colors.orange),
//                                           ),
//                                         ),
//
//                                     ],
//                                   ),
//                                 ) :
//                                 Padding(
//                                   padding: const EdgeInsets.all(10),
//                                   child: Container(
//                                     width: 680,
//                                     child: Math.tex(
//                                       r'' + QuizController.to.answer2.value.replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
//                                           .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
//                                       mathStyle: MathStyle.display,
//                                       textStyle: TextStyle(fontSize: 17, color: Colors.orange),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Obx(() => Visibility(
//                             visible: QuizController.to.imageInt8_answer2.value.length > 0 || QuizController.to.answer2_image_url.length > 0,
//                             child: Column(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 15, right: 15),
//                                   child: Divider(color: Color(0xff4C4C4C), thickness: 1,),
//                                 ),
//                                 Stack(
//                                     children: [
//                                       QuizController.to.imageInt8_answer2.value.length > 0 ?
//                                       ClipRRect(
//                                         borderRadius: BorderRadius.circular(5.0),
//                                         child: Image.memory(QuizController.to.imageInt8_answer2.value!, fit: BoxFit.cover, width: 330,),
//                                       ) :
//                                       ClipRRect(
//                                         borderRadius: BorderRadius.circular(5.0),
//                                         child: Image.network(QuizController.to.answer2_image_url, fit: BoxFit.cover, width: 330,),
//                                       ),
//                                       IconButton(
//                                         icon: Icon(Icons.delete_forever), color: Colors.black, iconSize: 40,
//                                         onPressed: () {
//                                           if (QuizController.to.imageInt8_answer2.value.length > 0) {
//                                             QuizController.to.imageInt8_answer2.value = Uint8List(0);
//                                           }else {
//                                             QuizController.to.answer2_image_url = '';
//                                           }
//
//                                         },
//                                       ),
//                                     ]
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 10,),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// 3번
//                   Container(
//                     width: 330,
//                     decoration: BoxDecoration(color: Color(0xff3C3C3C), borderRadius: BorderRadius.circular(10)),
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             SizedBox(
//                               width: 290,
//                               child: TextField(
//                                 controller: TextEditingController(text: QuizController.to.answer3.value),
//                                 textAlignVertical: TextAlignVertical.center,
//                                 onChanged: (value) {
//                                   QuizController.to.answer3.value = value;
//                                   QuizController.to.answer3_tex.value = r'' + value.replaceAll('{', r'\({').replaceAll('}', r'}\)').replaceAll('/', r'\over').replaceAll('\n', r'$$ $$')
//                                       .replaceAll('[', '□').replaceAll(']', '').replaceAll('times', '×').replaceAll('div', '÷').replaceAll('^2', r'\({^2}\)');
//                                 },
//                                 style: TextStyle(color: Colors.white , fontSize: 16, ),
//                                 // style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 19, ),
//                                 keyboardType: TextInputType.multiline,
//                                 maxLines: null,
//                                 decoration: InputDecoration(
//                                   prefixIcon: IconButton(
//                                     splashColor: Colors.transparent,
//                                     highlightColor: Colors.transparent,
//                                     icon: Icon(Icons.filter_3), color:  Colors.blue,
//                                     onPressed: () {
//                                       QuizController.to.answer.value = '3';
//                                     },
//                                   ),
//                                   suffixIcon: Obx(() => QuizController.to.answer.value == '3' ? Icon(Icons.circle_outlined, color: Colors.green,) : Icon(Icons.clear, color: Colors.red,),
//                                   ),
//                                   filled: true,
//                                   fillColor: Color(0xff3C3C3C),
//                                   hintText: '3번 선택지 입력',
//                                   hintStyle: TextStyle(fontSize: 16, color: Colors.grey.withOpacity(0.5)),
//                                   focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Color(0xff3C3C3C),  ),),
//                                   enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Color(0xff3C3C3C),  ),),
//                                   contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 40,
//                               child: IconButton(splashColor: Colors.transparent, highlightColor: Colors.transparent, icon: Icon(Icons.photo), color: Colors.white.withOpacity(0.5),
//                                 onPressed: () {
//                                   QuizController.to.selectImage('답지3');
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//
//                         Obx(() => Visibility(
//                             visible: QuizController.to.answer3.value.contains('{') || QuizController.to.answer3.value.contains('times') || QuizController.to.answer3.value.contains('div')
//                                 || QuizController.to.answer3.value.contains('[') || QuizController.to.answer3.value.contains('^2') ,
//                             child: Column(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 15, right: 15),
//                                   child: Divider(color: Color(0xff4C4C4C), thickness: 1,),
//                                 ),
//                                 QuizController.to.answer3.value.contains('\n') ?
//                                 Padding(
//                                   padding: const EdgeInsets.all(10),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       for (int index = 0; index < QuizController.to.answer3.value.split('\n').length; index++)
//                                         Container(
//                                           width: 680,
//                                           child: Math.tex(
//                                             r'' + QuizController.to.answer3.value.split('\n')[index].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
//                                                 .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
//                                             mathStyle: MathStyle.display,
//                                             textStyle: TextStyle(fontSize: 17, color: Colors.orange),
//                                           ),
//                                         ),
//
//                                     ],
//                                   ),
//                                 ) :
//                                 Padding(
//                                   padding: const EdgeInsets.all(10),
//                                   child: Container(
//                                     width: 680,
//                                     child: Math.tex(
//                                       r'' + QuizController.to.answer3.value.replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
//                                           .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
//                                       mathStyle: MathStyle.display,
//                                       textStyle: TextStyle(fontSize: 17, color: Colors.orange),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Obx(() => Visibility(
//                             visible: QuizController.to.imageInt8_answer3.value.length > 0 || QuizController.to.answer3_image_url.length > 0,
//                             child: Column(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 15, right: 15),
//                                   child: Divider(color: Color(0xff4C4C4C), thickness: 1,),
//                                 ),
//                                 Stack(
//                                     children: [
//                                       QuizController.to.imageInt8_answer3.value.length > 0 ?
//                                       ClipRRect(
//                                         borderRadius: BorderRadius.circular(5.0),
//                                         child: Image.memory(QuizController.to.imageInt8_answer3.value!, fit: BoxFit.cover, width: 330,),
//                                       ) :
//                                       ClipRRect(
//                                         borderRadius: BorderRadius.circular(5.0),
//                                         child: Image.network(QuizController.to.answer3_image_url, fit: BoxFit.cover, width: 330,),
//                                       ),
//                                       IconButton(
//                                         icon: Icon(Icons.delete_forever), color: Colors.black, iconSize: 40,
//                                         onPressed: () {
//                                           if (QuizController.to.imageInt8_answer3.value.length > 0) {
//                                             QuizController.to.imageInt8_answer3.value = Uint8List(0);
//                                           }else {
//                                             QuizController.to.answer3_image_url = '';
//                                           }
//
//                                         },
//                                       ),
//                                     ]
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   /// 4번
//                   Container(
//                     width: 330,
//                     decoration: BoxDecoration(color: Color(0xff3C3C3C), borderRadius: BorderRadius.circular(10)),
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             SizedBox(
//                               width: 290,
//                               child: TextField(
//                                 controller: TextEditingController(text: QuizController.to.answer4.value),
//                                 textAlignVertical: TextAlignVertical.center,
//                                 onChanged: (value) {
//                                   QuizController.to.answer1.value = value;
//                                   QuizController.to.answer4_tex.value = r'' + value.replaceAll('{', r'\({').replaceAll('}', r'}\)').replaceAll('/', r'\over').replaceAll('\n', r'$$ $$')
//                                       .replaceAll('[', '□').replaceAll(']', '').replaceAll('times', '×').replaceAll('div', '÷').replaceAll('^2', r'\({^2}\)');
//                                 },
//                                 style: TextStyle(color: Colors.white , fontSize: 16, ),
//                                 // style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 19, ),
//                                 keyboardType: TextInputType.multiline,
//                                 maxLines: null,
//                                 decoration: InputDecoration(
//                                   prefixIcon: IconButton(
//                                     splashColor: Colors.transparent,
//                                     highlightColor: Colors.transparent,
//                                     icon: Icon(Icons.filter_4), color:  Colors.orange,
//                                     onPressed: () {
//                                       QuizController.to.answer.value = '4';
//                                     },
//                                   ),
//                                   suffixIcon: Obx(() => QuizController.to.answer.value == '4' ? Icon(Icons.circle_outlined, color: Colors.green,) : Icon(Icons.clear, color: Colors.red,),
//                                   ),
//                                   filled: true,
//                                   fillColor: Color(0xff3C3C3C),
//                                   hintText: '4번 선택지 입력',
//                                   hintStyle: TextStyle(fontSize: 16, color: Colors.grey.withOpacity(0.5)),
//                                   focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Color(0xff3C3C3C),  ),),
//                                   enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Color(0xff3C3C3C),  ),),
//                                   contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 40,
//                               child: IconButton(splashColor: Colors.transparent, highlightColor: Colors.transparent, icon: Icon(Icons.photo), color: Colors.white.withOpacity(0.5),
//                                 onPressed: () {
//                                   QuizController.to.selectImage('답지4');
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//
//                         Obx(() => Visibility(
//                             visible: QuizController.to.answer4.value.contains('{') || QuizController.to.answer4.value.contains('times') || QuizController.to.answer4.value.contains('div')
//                                 || QuizController.to.answer4.value.contains('[') || QuizController.to.answer4.value.contains('^2') ,
//                             child: Column(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 15, right: 15),
//                                   child: Divider(color: Color(0xff4C4C4C), thickness: 1,),
//                                 ),
//                                 QuizController.to.answer4.value.contains('\n') ?
//                                 Padding(
//                                   padding: const EdgeInsets.all(10),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       for (int index = 0; index < QuizController.to.answer4.value.split('\n').length; index++)
//                                         Container(
//                                           width: 680,
//                                           child: Math.tex(
//                                             r'' + QuizController.to.answer4.value.split('\n')[index].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
//                                                 .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
//                                             mathStyle: MathStyle.display,
//                                             textStyle: TextStyle(fontSize: 17, color: Colors.orange),
//                                           ),
//                                         ),
//
//                                     ],
//                                   ),
//                                 ) :
//                                 Padding(
//                                   padding: const EdgeInsets.all(10),
//                                   child: Container(
//                                     width: 680,
//                                     child: Math.tex(
//                                       r'' + QuizController.to.answer4.value.replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
//                                           .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
//                                       mathStyle: MathStyle.display,
//                                       textStyle: TextStyle(fontSize: 17, color: Colors.orange),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Obx(() => Visibility(
//                             visible: QuizController.to.imageInt8_answer4.value.length > 0 || QuizController.to.answer4_image_url.length > 0,
//                             child: Column(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 15, right: 15),
//                                   child: Divider(color: Color(0xff4C4C4C), thickness: 1,),
//                                 ),
//                                 Stack(
//                                     children: [
//                                       QuizController.to.imageInt8_answer4.value.length > 0 ?
//                                       ClipRRect(
//                                         borderRadius: BorderRadius.circular(5.0),
//                                         child: Image.memory(QuizController.to.imageInt8_answer4.value!, fit: BoxFit.cover, width: 330,),
//                                       ) :
//                                       ClipRRect(
//                                         borderRadius: BorderRadius.circular(5.0),
//                                         child: Image.network(QuizController.to.answer4_image_url, fit: BoxFit.cover, width: 330,),
//                                       ),
//                                       IconButton(
//                                         icon: Icon(Icons.delete_forever), color: Colors.black, iconSize: 40,
//                                         onPressed: () {
//                                           if (QuizController.to.imageInt8_answer4.value.length > 0) {
//                                             QuizController.to.imageInt8_answer4.value = Uint8List(0);
//                                           }else {
//                                             QuizController.to.answer4_image_url = '';
//                                           }
//
//                                         },
//                                       ),
//                                     ]
//                                 ),
//
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ) :
//           QuizController.to.question_type.value == 'OX형' ?
//           Column(children: [
//             Text('ox형')
//           ],) : SizedBox(),
//         ]
//     );
//
//   }
// }
//
//
//
//
//
