import 'package:classdiary2/controller/academic_controller.dart';
import 'package:classdiary2/controller/attendance_controller.dart';
import 'package:classdiary2/controller/checklist_controller.dart';
import 'package:classdiary2/controller/dashboard_controller.dart';
import 'package:classdiary2/controller/esti_controller.dart';
import 'package:classdiary2/controller/thisweek_controller.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class TableCalendarWidget extends StatelessWidget {
  const TableCalendarWidget({Key? key, required this.gubun,}) : super(key: key);
  final String gubun;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      daysOfWeekHeight : 22.0,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        leftChevronVisible: true,
        rightChevronVisible: true,
      ),
      startingDayOfWeek: StartingDayOfWeek.monday,
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: DateTime.now(),
      onDaySelected: (DateTime day, DateTime day1) {
        if (gubun == 'todo') {
          DashboardController.to.isSelectedDate.value = true;
          DashboardController.to.selectedDateTodo.value = day.toString().substring(0,23);
        }else if(gubun == 'thisweek') {
          ThisWeekController.to.selectedDate.value = day.toString().substring(0,23);
          ThisWeekController.to.getThisWeeks();
        }else if(gubun == 'absent') {
          AttendanceController.to.selectedDate.value = day.toString().substring(0,23);
          AttendanceController.to.getAbsentCnt();
        }else if(gubun == 'checklist') {
          ChecklistController.to.selectedDate.value = day.toString().substring(0,23);
          ChecklistController.to.updDate();
        }else if(gubun == 'estimate') {
          EstiController.to.selectedDate.value = day.toString().substring(0,23);
          EstiController.to.updDate();
        }else if(gubun == 'academic') {
          AcademicController.to.toDate.value = day.toString().substring(0,23);
        }

        Navigator.pop(context);
      },
      locale: 'ko-KR',
      // locale: Localizations.localeOf(context).languageCode,
      calendarStyle: const CalendarStyle(
        weekendTextStyle: TextStyle(color: Colors.orange),
      ),

    );
  }
}