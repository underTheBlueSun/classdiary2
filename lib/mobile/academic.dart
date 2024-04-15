import 'package:classdiary2/controller/academic_controller.dart';
import 'package:classdiary2/mobile/bottom_navibar_widget.dart';
import 'package:classdiary2/mobile/popupmenu_widget.dart';
import 'package:classdiary2/mobile/tablecalendar_widget.dart';
import 'package:classdiary2/mobile/todo_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../controller/dashboard_controller.dart';
import '../controller/signinup_controller.dart';

class Academic extends StatelessWidget {

  var controller = TextEditingController();

  void calendarDialog(BuildContext context, gubun) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Container(
            height: 400,
            width: 300,
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
                    SizedBox(width: 10,),
                  ],),
                TableCalendarWidget(gubun: gubun,),
              ],
            ),
          ),
        );
      },
    );
  }

  void academicDialog(BuildContext context, CalendarTapDetails) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: SingleChildScrollView(
            child: Obx(() =>
                Container(
                  width: 500,
                  // height: 400,
                  child: AcademicController.to.isUpdateView.value == false
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                          SizedBox(width: 10,),
                        ],
                      ),
                      // Text(CalendarTapDetails.date.toString().substring(0,10)),
                      // Divider(color: Colors.grey.withOpacity(0.7),),
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: CalendarTapDetails.appointments.length,
                        itemBuilder: (_, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ListTile(
                              visualDensity: VisualDensity(vertical: -4),
                              tileColor: CalendarTapDetails.appointments[index].background,
                              title: InkWell(
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  if (CalendarTapDetails.appointments[index].background == Color(0xFF026259)) {
                                    AcademicController.to.selectedColor.value = 'color1';
                                  }else if (CalendarTapDetails.appointments[index].background == Color(0xFFA3556B)) {
                                    AcademicController.to.selectedColor.value = 'color2';
                                  }else if (CalendarTapDetails.appointments[index].background == Color(0xFF25A2E7)) {
                                    AcademicController.to.selectedColor.value = 'color3';
                                  }else if (CalendarTapDetails.appointments[index].background == Color(0xFFB6CD43)) {
                                    AcademicController.to.selectedColor.value = 'color4';
                                  }
                                  // updDialog(context, CalendarTapDetails.appointments[index]);
                                  AcademicController.to.eventName = CalendarTapDetails.appointments[index].eventName;
                                  AcademicController.to.docID = CalendarTapDetails.appointments[index].docID;
                                  AcademicController.to.isUpdateView.value = true;
                                  AcademicController.to.input = CalendarTapDetails.appointments[index].eventName;
                                },
                                child: Text(CalendarTapDetails.appointments[index].eventName, style: TextStyle(color: Colors.white),),
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  AcademicController.to.delAcademic(CalendarTapDetails.appointments[index].docID);
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.delete_outline, color: Colors.white,),
                              ),
                              shape: RoundedRectangleBorder(
                                // side: BorderSide(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 10,),
                      Obx(() =>
                          Row(
                            children: [
                              Expanded(child: SizedBox()),
                              InkWell(
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  AcademicController.to.selectedColor.value = 'color1';
                                },
                                child: SizedBox(
                                  width: 20, height: 20,
                                  child: CircleAvatar(
                                    backgroundColor: Color(0xFF0B556B),
                                    child: Center(
                                      child: Icon(Icons.check, size: 15,
                                        color: AcademicController.to.selectedColor.value == 'color1' ? Colors.white : Colors.transparent,),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              InkWell(
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  AcademicController.to.selectedColor.value = 'color2';
                                },
                                child: SizedBox(
                                  width: 20, height: 20,
                                  child: CircleAvatar(
                                    backgroundColor: Color(0xFFA3556B),
                                    child: Center(
                                      child: Icon(Icons.check, size: 15,
                                        color: AcademicController.to.selectedColor.value == 'color2' ? Colors.white : Colors.transparent,),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              InkWell(
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  AcademicController.to.selectedColor.value = 'color3';
                                },
                                child: SizedBox(
                                  width: 20, height: 20,
                                  child: CircleAvatar(
                                    backgroundColor: Color(0xFF25A2E7),
                                    child: Center(
                                      child: Icon(Icons.check, size: 15,
                                        color: AcademicController.to.selectedColor.value == 'color3' ? Colors.white : Colors.transparent,),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              InkWell(
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  AcademicController.to.selectedColor.value = 'color4';
                                },
                                child: SizedBox(
                                  width: 20, height: 20,
                                  child: CircleAvatar(
                                    backgroundColor: Color(0xFFB6CD43),
                                    child: Center(
                                      child: Icon(Icons.check, size: 15,
                                        color: AcademicController.to.selectedColor.value == 'color4' ? Colors.white : Colors.transparent,),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 15,),
                            ],
                          ),
                      ),
                      SizedBox(height: 10,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // SizedBox(width: 10,),
                          Text('•  ', style: TextStyle(fontSize: 20, color: Colors.orange.withOpacity(0.7).withOpacity(0.7)),),
                          Text('기간: ${CalendarTapDetails.date.toString().substring(5,10)} ~ '),
                          Obx(() => Text(AcademicController.to.toDate.value.substring(5,10))),
                          SizedBox(width: 10,),
                          InkWell(
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              calendarDialog(context, 'academic');
                            },
                            child: Container(
                              width: 18,
                              child: Icon(Icons.calendar_month, color: Colors.teal.withOpacity(0.7), size: 25,),
                            ),
                          ),

                        ],
                      ),

                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Text('•', style: TextStyle(fontSize: 20, color: Colors.orange.withOpacity(0.7).withOpacity(0.7)),),
                          Container(
                            width: 220,
                            child: TextField(
                              // maxLength: 1,
                              autofocus: true,
                              onSubmitted: (value) {
                                if (AcademicController.to.input.length > 0) {
                                  AcademicController.to.saveAcademic(CalendarTapDetails.date, value);
                                  Navigator.pop(context);
                                }
                              },
                              onChanged: (value) {
                                AcademicController.to.input = value;
                              },
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent,),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent,),
                                ),
                                hintText: '일정을 입력하세요(저장은 엔터키)',
                                hintStyle: TextStyle(fontSize: 14, color: Colors.grey,),
                                contentPadding: EdgeInsets.all(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                          SizedBox(width: 10,),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Obx(() => Row(
                        children: [
                          InkWell(
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              AcademicController.to.selectedColor.value = 'color1';
                            },
                            child: SizedBox(
                              width: 25, height: 25,
                              child: CircleAvatar(
                                backgroundColor: Color(0xFF0B556B),
                                child: Center(
                                  child: Icon(Icons.check,
                                    color: AcademicController.to.selectedColor.value == 'color1' ? Colors.white : Colors.transparent,),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          InkWell(
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              AcademicController.to.selectedColor.value = 'color2';
                            },
                            child: SizedBox(
                              width: 25, height: 25,
                              child: CircleAvatar(
                                backgroundColor: Color(0xFFA3556B),
                                child: Center(
                                  child: Icon(Icons.check,
                                    color: AcademicController.to.selectedColor.value == 'color2' ? Colors.white : Colors.transparent,),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          InkWell(
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              AcademicController.to.selectedColor.value = 'color3';
                            },
                            child: SizedBox(
                              width: 25, height: 25,
                              child: CircleAvatar(
                                backgroundColor: Color(0xFF25A2E7),
                                child: Center(
                                  child: Icon(Icons.check,
                                    color: AcademicController.to.selectedColor.value == 'color3' ? Colors.white : Colors.transparent,),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          InkWell(
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              AcademicController.to.selectedColor.value = 'color4';
                            },
                            child: SizedBox(
                              width: 25, height: 25,
                              child: CircleAvatar(
                                backgroundColor: Color(0xFFB6CD43),
                                child: Center(
                                  child: Icon(Icons.check,
                                    color: AcademicController.to.selectedColor.value == 'color4' ? Colors.white : Colors.transparent,),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 15,),
                        ],
                      ),
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Text('•', style: TextStyle(fontSize: 20, color: Colors.orange.withOpacity(0.7)),),
                          Container(
                            width: 220,
                            child: TextField(
                              autofocus: true,
                              controller: TextEditingController(text: AcademicController.to.eventName),
                              style: TextStyle(height: 1.0, fontWeight: FontWeight.bold,
                              ),
                              onSubmitted: (value) {
                                if (AcademicController.to.input.length > 0) {
                                  AcademicController.to.updAcademic(AcademicController.to.docID, value);
                                  Navigator.pop(context);
                                }
                              },
                              onChanged: (value) {
                                AcademicController.to.input = value;
                              },
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent,),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent,),
                                ),
                                hintText: '일정을 입력하세요(저장은 엔터키)',
                                hintStyle: TextStyle(fontSize: 14, color: Colors.grey,),
                                contentPadding: EdgeInsets.all(10),
                              ),
                            ),
                          ),
                        ],
                      ),


                    ],
                  ),
                ),
            ),
          ),
        );
      },
    );
  }

  void todoDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return ToDoWidget();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AcademicController.to.toDate.value = AcademicController.to.selectedDate.value;
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false, /// back button 제거
          elevation: 0,
          title: Text('학사일정', style: TextStyle(fontWeight: FontWeight.bold),),
          actions: [
            Row(
              children: [
                Obx(() => Row(
                    children: [
                      Text('주 시작', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black
                      ),),
                      InkWell(
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          AcademicController.to.firstWeekChoice.value = 7;
                        },
                        child: SizedBox(
                          height: 20,
                          child: CircleAvatar(
                            backgroundColor: AcademicController.to.firstWeekChoice.value == 7
                                ? Colors.orange.withOpacity(0.7).withOpacity(0.7)
                                : Colors.grey.withOpacity(0.3),
                            child: Text('일', style: TextStyle(fontSize: 11, color: Colors.white),),
                          ),
                        ),
                      ),
                      InkWell(
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          AcademicController.to.firstWeekChoice.value = 1;
                        },
                        child: SizedBox(
                          height: 20,
                          child: CircleAvatar(
                            backgroundColor: AcademicController.to.firstWeekChoice.value == 1
                                ? Colors.orange.withOpacity(0.7).withOpacity(0.7)
                                : Colors.black.withOpacity(0.6),
                            child: Text('월', style: TextStyle(fontSize: 11, color: Colors.white),),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                PopUpMenuWidget(),
              ],
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('academic').where('email', isEqualTo: GetStorage().read('email')).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Container(
                  height: 40,
                  child: LoadingIndicator(
                      indicatorType: Indicator.ballPulse,
                      colors: DashboardController.to.kDefaultRainbowColors,
                      strokeWidth: 2,
                      backgroundColor: Colors.transparent,
                      pathBackgroundColor: Colors.transparent
                  ),
                ),);
                // return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.withOpacity(0.5))));
              }
              AcademicController.to.meetings = [];
              for(var doc in snapshot.data!.docs)
                if (doc['color'] == 'color1') {
                  AcademicController.to.meetings.add(Meeting(doc['title'], doc['startTime'].toDate(), doc['endTime'].toDate(),
                      Color(0xFF026259), false, doc.id));
                }else if (doc['color'] == 'color2') {
                  AcademicController.to.meetings.add(Meeting(doc['title'], doc['startTime'].toDate(), doc['endTime'].toDate(),
                      Color(0xFFA3556B), false, doc.id));
                }else if (doc['color'] == 'color3') {
                  AcademicController.to.meetings.add(Meeting(doc['title'], doc['startTime'].toDate(), doc['endTime'].toDate(),
                      Color(0xFF25A2E7), false, doc.id));
                }else if (doc['color'] == 'color4') {
                  AcademicController.to.meetings.add(Meeting(doc['title'], doc['startTime'].toDate(), doc['endTime'].toDate(),
                      Color(0xFFB6CD43), false, doc.id));
                }
              // AcademicController.to.meetings.add(Meeting(doc['title'], doc['startTime'].toDate(), doc['endTime'].toDate(),
              //   Color(0xFF026259), false, doc.id));

              return Obx(() => Container(
                  height: 500,
                  child: SfCalendar(
                    todayHighlightColor: Colors.orange.withOpacity(0.7).withOpacity(0.7),
                    view: CalendarView.month,
                    showNavigationArrow: true,
                    dataSource: MeetingDataSource(AcademicController.to.meetings),
                    onTap: (CalendarTapDetails) {
                      AcademicController.to.selectedColor.value = 'color1';
                      AcademicController.to.isUpdateView.value = false;
                      academicDialog(context, CalendarTapDetails);
                      AcademicController.to.toDate.value = CalendarTapDetails.date.toString();
                      AcademicController.to.input = '';
                    },
                    selectionDecoration: BoxDecoration(color: Colors.transparent,
                      border: Border.all(color: Color.fromARGB(255, 68, 140, 255), width: 2),
                    ),
                    headerHeight: 35,
                    headerStyle: CalendarHeaderStyle(textStyle: TextStyle(fontSize: 15)), //  August 2022
                    appointmentTextStyle: TextStyle(fontSize: 10, color: Colors.white),
                    todayTextStyle: TextStyle(color: Colors.white, fontSize: 10),
                    firstDayOfWeek: AcademicController.to.firstWeekChoice.value,  // 월요일부터 시작
                    // firstDayOfWeek: 1,  // 월요일부터 시작
                    monthViewSettings: MonthViewSettings(
                      // numberOfWeeksInView: 6,
                      appointmentDisplayCount:  3,
                      dayFormat: 'E', //  MON, TUE
                      monthCellStyle:  MonthCellStyle(
                        textStyle: TextStyle(fontSize: 10, color: Colors.grey),
                        trailingDatesTextStyle: TextStyle(fontSize: 10, color: Colors.black),
                        leadingDatesTextStyle: TextStyle(fontSize: 10, color: Colors.black),
                      ),
                      appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                    ),

                  ),
                ),
              );
            }
        ),
        bottomNavigationBar: BottomNaviBarWidget(),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 30,),
            FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: () {
                todoDialog(context);
              },
              child: const Text('할일'),
            ),
          ],
        )
    );

  }
}

