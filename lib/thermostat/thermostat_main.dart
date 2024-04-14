import 'package:classdiary2/controller/quiz_controller.dart';
import 'package:classdiary2/frac_test2.dart';
import 'package:classdiary2/quiz/quiz_all.dart';
import 'package:classdiary2/quiz/quiz_all_detail.dart';
import 'package:classdiary2/quiz/quiz_detail.dart';
import 'package:classdiary2/quiz/quiz_favorite.dart';
import 'package:classdiary2/quiz/quiz_myquiz.dart';
import 'package:classdiary2/quiz/quiz_nickname_mobile.dart';
import 'package:classdiary2/quiz/quiz_play.dart';
import 'package:classdiary2/quiz/quiz_ready.dart';
import 'package:classdiary2/quiz/quiz_search.dart';
import 'package:classdiary2/quiz/quiz_test.dart';
import 'package:classdiary2/quiz/quiz_top_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../frac_test.dart';

class ThermostatMain extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    if (GetStorage().read('job') == 'teacher') {
      return Scaffold(
        // backgroundColor: Color(0xFFF7F7F7),
        backgroundColor:Color(0xFFEEE9DF),
        body: SingleChildScrollView(
          child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              QuizController.to.active_screen.value == 'ready' || QuizController.to.active_screen.value == 'play' || QuizController.to.active_screen.value == 'detail'
                  || QuizController.to.active_screen.value == 'all_detail'?
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),),
                      onPressed: () {
                        if (QuizController.to.before_screen.value == 'myquiz') {
                          QuizController.to.active_screen.value = 'myquiz';
                        }else if (QuizController.to.before_screen.value == 'all' ) {
                          QuizController.to.active_screen.value = 'all';
                        }else if (QuizController.to.before_screen.value == 'favorite' ) {
                          QuizController.to.active_screen.value = 'favorite';
                        }else {
                          QuizController.to.active_screen.value = 'myquiz';
                        }

                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 11, right: 8),
                        child: Text('닫기',style: TextStyle(fontFamily: 'Jua', fontSize: 20,  color: Colors.white),),
                      ),
                    ),
                  )
              ) :
              /// top menu
              Container(
                color: Colors.grey.withOpacity(0.2),
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top:15, bottom: 15),
                  child: QuizTopMenu(),
                ),
              ),
              /// 컨테이너에서 높이 지정 안해주면 singlescrollview 오버플로우 남.
              Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 검색
                  QuizController.to.active_screen.value == 'all_detail' || QuizController.to.active_screen.value == 'detail' || QuizController.to.active_screen.value == 'play'
                      || QuizController.to.active_screen.value == 'ready' ? SizedBox() :
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: QuizSearch(),
                  ),
                  /// 화면전환
                  Padding(
                    padding: const EdgeInsets.only(left:20, right: 30, top:10, bottom: 20),
                    child: QuizController.to.active_screen.value == 'all' ? QuizAll() :
                    QuizController.to.active_screen.value == 'favorite' ? QuizFavorite() :
                    QuizController.to.active_screen.value == 'myquiz' ? QuizMyQuiz() :
                    QuizController.to.active_screen.value == 'ready' ? QuizReady() :
                    QuizController.to.active_screen.value == 'detail' ? QuizDetail() :
                    // QuizController.to.active_screen.value == 'all_detail' ? QuizAllDetail() :
                    QuizController.to.active_screen.value == 'play' ? QuizPlay() : FracTest2(),
                  ),
                ],
              ),
              ),

            ],
          ),
          ),
        ),
      );
    }else {
      return
        MediaQuery.of(context).size.width > 600 ?
        Scaffold(
          backgroundColor: Color(0xFFF7F7F7),
          body: Text('태블릿'),
        ) :
        Scaffold(
          backgroundColor: Color(0xFFF7F7F7),
          body: Text('스마트폰'),
        );
    }


  }
}


