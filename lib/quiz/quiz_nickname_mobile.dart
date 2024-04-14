// import 'package:classdiary2/controller/quiz_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class QuizNicknameMobile extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     return
//       Center(
//         child: Container(
//           width: 330,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(
//                 width: 330,
//                 child: TextField(
//                   maxLength: 20,
//                   textAlignVertical: TextAlignVertical.center,
//                   onChanged: (value) {
//                     QuizController.to.nickname_input = value;
//                   },
//                   style: TextStyle(color: Colors.black , fontSize: 25, fontFamily: 'Jua' ),
//                   // style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 19, ),
//                   maxLines: 1,
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Colors.white,
//                     hintText: '이름을 입력하세요(3글자이상)',
//                     hintStyle: TextStyle(fontSize: 20, color: Colors.grey.withOpacity(0.5)),
//                     focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.orange, width: 2 ),),
//                     enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.orange, width: 2 ),),
//                     contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//
//                   ),
//                 ),
//               ),
//               SizedBox(height: 50,),
//               Container(
//                 width: 330,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(backgroundColor: Color(0xff3E6888), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),),
//                   onPressed: () async{
//                     if (QuizController.to.nickname_input.trim().length > 2) {
//                       QuizController.to.saveAnonymous(quiz_id);
//                     }
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 10, bottom: 10, left: 11, right: 8),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.arrow_circle_right, color: Colors.white, size: 25,),
//                         SizedBox(width: 10,),
//                         Text('입장',style: TextStyle(fontFamily: 'Jua', fontSize: 30,  color: Colors.white),),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//
//   }
// }
//
//
