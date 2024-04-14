// import 'package:classdiary2/controller/dashboard_controller.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:loading_indicator/loading_indicator.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import '../controller/point_controller.dart';
//
// class PointWidget extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('diary').where('class_code', isEqualTo: GetStorage().read('class_code'))
//             .where('number', isEqualTo: GetStorage().read('number')).snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: Container(
//               height: 40,
//               child: LoadingIndicator(
//                   indicatorType: Indicator.ballPulse,
//                   colors: DashboardController.to.kDefaultRainbowColors,
//                   strokeWidth: 2,
//                   backgroundColor: Colors.transparent,
//                   pathBackgroundColor: Colors.transparent
//               ),
//             ),);
//           }
//           PointController.to.diary_point = 0;
//
//           snapshot.data!.docs.forEach((doc) {
//             if(doc['checklist_01'] > 0) PointController.to.diary_point = PointController.to.diary_point + doc['checklist_01'] as int;
//             if(doc['checklist_02'] > 0) PointController.to.diary_point = PointController.to.diary_point + doc['checklist_02'] as int;
//             if(doc['checklist_03'] > 0) PointController.to.diary_point = PointController.to.diary_point + doc['checklist_03'] as int;
//             if(doc['checklist_04'] > 0) PointController.to.diary_point = PointController.to.diary_point + doc['checklist_04'] as int;
//             if(doc['checklist_05'] > 0) PointController.to.diary_point = PointController.to.diary_point + doc['checklist_05'] as int;
//             if(doc['checklist_06'] > 0) PointController.to.diary_point = PointController.to.diary_point + doc['checklist_06'] as int;
//             if(doc['checklist_07'] > 0) PointController.to.diary_point = PointController.to.diary_point + doc['checklist_07'] as int;
//             if(doc['checklist_08'] > 0) PointController.to.diary_point = PointController.to.diary_point + doc['checklist_08'] as int;
//             if(doc['checklist_09'] > 0) PointController.to.diary_point = PointController.to.diary_point + doc['checklist_09'] as int;
//             if(doc['checklist_10'] > 0) PointController.to.diary_point = PointController.to.diary_point + doc['checklist_10'] as int;
//
//           });
//
//           return StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance.collection('point').where('class_code', isEqualTo: GetStorage().read('class_code'))
//                   .where('number', isEqualTo: GetStorage().read('number')).snapshots(),
//               builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(child: Container(
//                     height: 40,
//                     child: LoadingIndicator(
//                         indicatorType: Indicator.ballPulse,
//                         colors: DashboardController.to.kDefaultRainbowColors,
//                         strokeWidth: 2,
//                         backgroundColor: Colors.transparent,
//                         pathBackgroundColor: Colors.transparent
//                     ),
//                   ),);
//                 }
//
//                 PointController.to.point_point = 0;
//                 if (snapshot.data!.docs.length > 0) {
//                   PointController.to.point_point = snapshot.data!.docs.first['point'];
//                 }
//
//                 return StreamBuilder<QuerySnapshot>(
//                     stream: FirebaseFirestore.instance.collection('coupon_buy').where('class_code', isEqualTo: GetStorage().read('class_code'))
//                         .where('number', isEqualTo: GetStorage().read('number')).snapshots(),
//                     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//
//                       if (!snapshot.hasData) {
//                         return Center(child: Container(
//                           height: 40,
//                           child: LoadingIndicator(
//                               indicatorType: Indicator.ballPulse,
//                               colors: DashboardController.to.kDefaultRainbowColors,
//                               strokeWidth: 2,
//                               backgroundColor: Colors.transparent,
//                               pathBackgroundColor: Colors.transparent
//                           ),
//                         ),);
//                       }
//
//                       PointController.to.coupon_point = 0;
//                       snapshot.data!.docs.forEach((doc) {
//                         PointController.to.coupon_point = PointController.to.coupon_point + doc['point'] as int;
//                       });
//
//                       return StreamBuilder<QuerySnapshot>(
//                           stream: FirebaseFirestore.instance.collection('temper_donation').where('class_code', isEqualTo: GetStorage().read('class_code'))
//                               .where('number', isEqualTo: GetStorage().read('number')).snapshots(),
//                           builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                             if (!snapshot.hasData) {
//                               return Center(child: Container(
//                                 height: 40,
//                                 child: LoadingIndicator(
//                                     indicatorType: Indicator.ballPulse,
//                                     colors: DashboardController.to.kDefaultRainbowColors,
//                                     strokeWidth: 2,
//                                     backgroundColor: Colors.transparent,
//                                     pathBackgroundColor: Colors.transparent
//                                 ),
//                               ),);
//                             }
//
//                             PointController.to.temper_point = 0;
//                             snapshot.data!.docs.forEach((doc) {
//                               PointController.to.temper_point = PointController.to.temper_point + doc['point'] as int;
//                             });
//
//                             // PointController.to.point_total = 0;
//                             PointController.to.point_total = PointController.to.diary_point + PointController.to.point_point - PointController.to.coupon_point - PointController.to.temper_point;
//
//                             return Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 Icon(Icons.star, color: Color(0xFFE490A0),),
//                                 SizedBox(width: 3,),
//                                 Text(PointController.to.point_total.toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, ),),
//                                 // Text((PointController.to.diary_point + PointController.to.point_point - PointController.to.coupon_point - PointController.to.temper_point).toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, ),),
//                               ],);
//                           }
//                       );
//                     }
//                 );
//               }
//           );
//
//         }
//     );
//
//   }
// }
//
//
//
