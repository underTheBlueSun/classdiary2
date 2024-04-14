import 'package:classdiary2/controller/quiz_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizSearchBar extends StatelessWidget {
  CustomPopupMenuController popupGradeController = CustomPopupMenuController();
  CustomPopupMenuController popupSemesterController = CustomPopupMenuController();
  CustomPopupMenuController popupSubjectController = CustomPopupMenuController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// 검색어
        Container(
          width: 500,
          height: 40,
          child: TextField(
            // textAlignVertical: TextAlignVertical.center,
            onChanged: (value) {
              QuizController.to.search_title = value;
            },
            onSubmitted: (value) {
              QuizController.to.search_gubun = 'search';
              QuizController.to.dummy_search_date.value = DateTime.now().toString();
            },
            style: TextStyle(fontFamily: 'Jua', fontSize: 15, ),
            maxLines: 1,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: '검색어를 입력하세요',
              hintStyle: TextStyle(fontSize: 19, color: Colors.grey.withOpacity(0.5)),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.withOpacity(0.6), ),),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.6), width: 2 ),),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.6), width: 2 ),),
              contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 5),

            ),
          ),
        ),
        SizedBox(width: 40,),
        /// 학년
        Obx(() => CustomPopupMenu(
            controller: popupGradeController,
            arrowSize: 20,
            child: Container(
              padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              width: 55,
              height: 35,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.6), width: 2), borderRadius: BorderRadius.circular(8)),
              child: Text(QuizController.to.search_grade.value, style: TextStyle(color: Colors.grey, fontFamily: 'Jua', fontSize: 16,),),
            ),
            menuBuilder: () => ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 90,
                height: 240,
                color: Color(0xFF4C4C4C),
                child: IntrinsicWidth(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                        children: [
                          for ( var grade in QuizController.to.search_grades )
                            TextButton(
                              style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
                              onPressed: () {
                                QuizController.to.search_grade.value = grade;
                                if (grade == '전체') {
                                  QuizController.to.grade_list = ['전체','1학년','2학년','3학년','4학년','5학년','6학년'];
                                }else{
                                  QuizController.to.grade_list = [grade];
                                }

                                popupGradeController.hideMenu();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(grade, style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 16, ),),
                              ),
                            ),
                        ]
                    ),
                  ),
                ),
              ),
            ),
            pressType: PressType.singleClick,
            verticalMargin: -10,

          ),
        ),
        SizedBox(width: 10,),
        /// 학기
        Obx(() => CustomPopupMenu(
          controller: popupSemesterController,
          arrowSize: 20,
          child: Container(
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            width: 55,
            height: 35,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.6), width: 2), borderRadius: BorderRadius.circular(8)),
            child: Text(QuizController.to.search_semester.value, style: TextStyle(color: Colors.grey, fontFamily: 'Jua', fontSize: 16,),),
          ),
          menuBuilder: () => ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 90,
              height: 120,
              color: Color(0xFF4C4C4C),
              child: IntrinsicWidth(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                      children: [
                        for ( var semester in QuizController.to.search_semesters )
                          TextButton(
                            style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
                            onPressed: () {
                              QuizController.to.search_semester.value = semester;
                              if (semester == '전체') {
                                QuizController.to.semester_list = ['전체','1학기', '2학기'];
                              }else{
                                QuizController.to.semester_list = [semester];
                              }

                              popupSemesterController.hideMenu();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(semester, style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 16, ),),
                            ),
                          ),
                      ]
                  ),
                ),
              ),
            ),
          ),
          pressType: PressType.singleClick,
          verticalMargin: -10,

        ),
        ),
        SizedBox(width: 10,),
        /// 과목
        Obx(() => CustomPopupMenu(
          controller: popupSubjectController,
          arrowSize: 20,
          child: Container(
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            width: 55,
            height: 35,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.6), width: 2), borderRadius: BorderRadius.circular(8)),
            child: Text(QuizController.to.search_subject.value, style: TextStyle(color: Colors.grey, fontFamily: 'Jua', fontSize: 16,),),
          ),
          menuBuilder: () => ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 90,
              height: 350,
              color: Color(0xFF4C4C4C),
              child: IntrinsicWidth(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                      children: [
                        for ( var subject in QuizController.to.search_subjects )
                          TextButton(
                            style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
                            onPressed: () {
                              QuizController.to.search_subject.value = subject;
                              if (subject == '전체') {
                                QuizController.to.subject_list = ['전체','국어','수학','사회','과학','영어','실과','체육','음악','미술','창체'];
                              }else{
                                QuizController.to.subject_list = [subject];
                              }


                              popupSubjectController.hideMenu();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(subject, style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 16, ),),
                            ),
                          ),
                      ]
                  ),
                ),
              ),
            ),
          ),
          pressType: PressType.singleClick,
          verticalMargin: -10,

        ),
        ),
        SizedBox(width: 20,),
        InkWell(
          onTap: () {
            QuizController.to.search_gubun = 'search';
            QuizController.to.dummy_search_date.value = DateTime.now().toString();
          },
          child: Container(
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            width: 55,
            height: 35,
            decoration: BoxDecoration(color: Color(0xff76B8C3),borderRadius: BorderRadius.circular(8)),
            child: Text('검색', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 16,),),
          ),
        ),

      ],);

  }
}


