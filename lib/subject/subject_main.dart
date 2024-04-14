import 'package:classdiary2/subject/subject_diary.dart';
import 'package:classdiary2/subject/subject_edit.dart';
import 'package:classdiary2/subject/subject_top_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/subject_controller.dart';

class SubjectMain extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// top menu
            Container(
              // color: Colors.grey.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top:15, bottom: 15),
                child: SubjectTopMenu(),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 화면전환
                Padding(
                  padding: const EdgeInsets.only(left:20, right: 30, top:10, bottom: 20),
                  child: SubjectController.to.active_screen.value == 'subject' ? SubjectDiary() :
                  SubjectController.to.active_screen.value == 'subject_edit' ? SubjectEdit() :
                  SizedBox(),
                ),
              ],
            ),

          ],
        ),
      ),
    ),
    );

  }
}


