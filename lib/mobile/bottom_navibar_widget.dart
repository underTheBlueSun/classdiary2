import 'package:classdiary2/controller/checklist_controller.dart';
import 'package:classdiary2/controller/esti_controller.dart';
import 'package:classdiary2/controller/mobile_main_controller.dart';
import 'package:classdiary2/controller/thisweek_controller.dart';
import 'package:classdiary2/mobile/absent.dart';
import 'package:classdiary2/mobile/checklist.dart';
import 'package:classdiary2/mobile/todo.dart';
import 'package:classdiary2/mobile/estimate.dart';
import 'package:classdiary2/mobile/thisweek.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNaviBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
      elevation: 0,
        type: BottomNavigationBarType.fixed,
        // 3이상이면 타입 고정해야
        // unselectedItemColor: Colors.white,
        // selectedItemColor: const Color(0xFF5AAEC4),
        // backgroundColor: Color(0xFF2B2D30),
        onTap: (index) {
          MobileMainController.to.bottomNaviCurrentIndex.value = index;
          if (index == 0) {
            Get.to(() => Absent());
          }else if (index == 1) {
            ChecklistController.to.chartSelections.value = [];
            Get.to(() => Checklist());
          }else if (index == 2) {
            EstiController.to.chartSelections1.value = [];
            EstiController.to.chartSelections2.value = [];
            Get.to(() => Estimate());
          }else if (index == 3) {
            ThisWeekController.to.selectedDate.value = DateTime.now().toString();
            ThisWeekController.to.getThisWeeks();
            ThisWeekController.to.getTimeTable();
            Get.to(() => ThisWeek());
          }else if (index == 4) {
            Get.to(() => ToDo());
          }

        },
        currentIndex: MobileMainController.to.bottomNaviCurrentIndex.value,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: '출결',
            icon: Icon(Icons.groups_rounded),
          ),
          BottomNavigationBarItem(
            label: '체크',
            icon: Icon(Icons.task_alt),
          ),
          BottomNavigationBarItem(
            label: '평가',
            icon: Icon(Icons.style_outlined),
          ),
          BottomNavigationBarItem(
            label: '이번주',
            icon: Icon(Icons.today_outlined),
          ),
          BottomNavigationBarItem(
            label: '할일',
            icon: Icon(Icons.circle_outlined),
          ),
          // BottomNavigationBarItem(
          //   label: '더보기',
          //   icon: Icon(Icons.menu),
          // ),
        ],
      ),
    );
  }
}