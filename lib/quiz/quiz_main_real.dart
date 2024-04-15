import 'package:classdiary2/controller/quiz_controller.dart';
import 'package:classdiary2/quiz/quiz_play_mobile.dart';
import 'package:classdiary2/quiz/quiz_ready_mobile.dart';
import 'package:classdiary2/quiz/quiz_score_mobile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizMainReal extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        backgroundColor:Color(0xFFEEE9DF),
        body:
            /// 실명은 바로 ready 상태로 진입
        // QuizController.to.active_screen_mobile.value == 'entrance' ? RealEntrance() :
        QuizController.to.active_screen_mobile.value == 'entrance' ? QuizReadyMobile() :
        QuizController.to.active_screen_mobile.value == 'ready' ? QuizReadyMobile() :
        QuizController.to.active_screen_mobile.value == 'active' ? QuizPlayMobile() :
        // QuizController.to.active_screen_mobile.value == 'play' ? QuizPlay() :
        QuizController.to.active_screen_mobile.value == 'score' ? QuizScoreMobile() : SizedBox()
    ),
    );

  }
}


