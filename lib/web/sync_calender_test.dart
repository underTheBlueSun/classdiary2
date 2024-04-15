
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class SyncCalendarTest extends StatelessWidget {

  void academicDialog(BuildContext context, CalendarTapDetails) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Container(
            height: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close_outlined, color: Colors.grey,),
                    ),
                  ],
                ),
                Text(CalendarTapDetails.date.toString()),
                for(var appointment in CalendarTapDetails.appointments)
                  Text(appointment.eventName),
                Container(
                  width: 500, height: 40,
                  child: TextField(
                    // maxLength: 1,
                    autofocus: true,
                    style: TextStyle(color: Colors.black.withOpacity(0.7),
                      height: 1.0,
                      fontWeight: FontWeight.bold,
                    ),
                    onSubmitted: (value) {
                      // toDoValidate(context);
                    },
                    onChanged: (value) {
                      // DashboardController.to.todoContent = value;
                    },
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent,),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent,),
                      ),
                      hintText: '일정을 입력하세요',
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey,),
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
              ],
            ),
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      // toDoValidate(context);
                    }, // onPressed
                    style: OutlinedButton.styleFrom(side: BorderSide(
                        width: 1, color: Colors.black.withOpacity(0.6)),),
                    child: Text('저장', style: TextStyle(color: Colors.black),),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400, height: 380,
      child: SfCalendar(
        onTap: (CalendarTapDetails) {
          academicDialog(context, CalendarTapDetails);
        },
        selectionDecoration: BoxDecoration(color: Colors.transparent,
          border: Border.all(
              color: const Color.fromARGB(255, 68, 140, 255), width: 2),
          // borderRadius: const BorderRadius.all(Radius.circular(4)), shape: BoxShape.rectangle,
        ),
        headerHeight: 30,
        headerStyle: CalendarHeaderStyle(textStyle: TextStyle(fontSize: 15)),
        //  August 2022
        appointmentTextStyle: TextStyle(fontSize: 9, color: Colors.white),
        todayTextStyle: TextStyle(color: Colors.red, fontSize: 10),
        firstDayOfWeek: 1,
        // 월요일부터 시작
        view: CalendarView.month,
        // dataSource: MeetingDataSource(_getDataSource()),
        monthViewSettings: const MonthViewSettings(
          appointmentDisplayCount: 2,
          dayFormat: 'EEE', //  MON, TUE
          monthCellStyle: MonthCellStyle(textStyle: TextStyle(fontSize: 10)),
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        ),

      ),
    );
  }


}
