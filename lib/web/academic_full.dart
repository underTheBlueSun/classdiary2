import 'package:classdiary2/controller/academic_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';

import '../controller/dashboard_controller.dart';
import '../controller/signinup_controller.dart';
import 'tablecalendar_widget.dart';

class AcademicFull extends StatelessWidget {

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
            child: Obx(() => Container(
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
                        // return Row(
                        //   children: [
                        //     Text(CalendarTapDetails.appointments[index].eventName),
                        //     Expanded(child: SizedBox()),
                        //     OutlinedButton(
                        //       onPressed: () {
                        //         AcademicController.to.delAcademic(CalendarTapDetails.appointments[index].docID);
                        //         Navigator.pop(context);
                        //       }, // onPressed
                        //       style: OutlinedButton.styleFrom(side: BorderSide(width: 1, color: Colors.black.withOpacity(0.6)),),
                        //       child: Text('삭제', style: TextStyle(color: Colors.black),),
                        //     ),
                        //   ],
                        // );
                      },
                      // separatorBuilder: (_, index) {
                      //   return Divider(color: Colors.grey.withOpacity(0.7),);
                      // },
                    ),
                    // SizedBox(height: 20,),
                    // Divider(color: Colors.grey.withOpacity(0.7),),
                    SizedBox(height: 10,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('•  ', style: TextStyle(fontSize: 20, color: Colors.orange.withOpacity(0.7)),),
                        Text('기간: ${CalendarTapDetails.date.toString().substring(2,10)} ~ '),
                        Obx(() => Text(AcademicController.to.toDate.value.substring(2,10))),
                        SizedBox(width: 10,),
                        Container(
                          height: 22,
                          child: OutlinedButton(
                            onPressed: () {
                              calendarDialog(context, 'academic');
                            }, // onPressed
                            child: Text('날짜선택', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),),
                          ),
                        ),
                        // InkWell(
                        //   highlightColor: Colors.transparent,
                        //   hoverColor: Colors.transparent,
                        //   splashColor: Colors.transparent,
                        //   onTap: () {
                        //     calendarDialog(context, 'academic');
                        //   },
                        //   child: Container(
                        //     width: 18,
                        //     child: Icon(Icons.calendar_month, color: Colors.teal.withOpacity(0.7), size: 25,),
                        //   ),
                        // ),
                        Expanded(child: SizedBox()),
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
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Text('•', style: TextStyle(fontSize: 20, color: Colors.orange.withOpacity(0.7)),),
                        Container(
                          width: 420,
                          child: TextField(
                            // maxLength: 1,
                            autofocus: true,
                            style: TextStyle(color: Colors.black.withOpacity(0.7), height: 1.0, fontWeight: FontWeight.bold,
                            ),
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
                              hintText: '일정을 입력하세요',
                              hintStyle: TextStyle(fontSize: 14, color: Colors.grey,),
                              contentPadding: EdgeInsets.all(10),
                            ),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            if (AcademicController.to.input.length > 0) {
                              AcademicController.to.saveAcademic(CalendarTapDetails.date, AcademicController.to.input);
                              Navigator.pop(context);
                            }
                          }, // onPressed
                          child: Text('저장', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),),
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
                          width: 420,
                          child: TextField(
                            autofocus: true,
                            controller: TextEditingController(text: AcademicController.to.eventName),
                            style: TextStyle(color: Colors.black.withOpacity(0.7), height: 1.0, fontWeight: FontWeight.bold,
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
                              hintText: '일정을 입력하세요',
                              hintStyle: TextStyle(fontSize: 14, color: Colors.grey,),
                              contentPadding: EdgeInsets.all(10),
                            ),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            if (AcademicController.to.input.length > 0) {
                              AcademicController.to.updAcademic(AcademicController.to.docID, AcademicController.to.input);
                              Navigator.pop(context);
                            }
                          }, // onPressed
                          style: OutlinedButton.styleFrom(side: BorderSide(width: 1, color: Colors.black.withOpacity(0.6)),),
                          child: Text('저장', style: TextStyle(color: Colors.black),),
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

  // void updDialog(BuildContext context, appointment) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(15.0))),
  //         content: SingleChildScrollView(
  //           child: Container(
  //             width: 400,
  //             // height: 400,
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.end,
  //                   children: [
  //                     InkWell(
  //                       highlightColor: Colors.transparent,
  //                       hoverColor: Colors.transparent,
  //                       splashColor: Colors.transparent,
  //                       onTap: () {
  //                         Navigator.pop(context);
  //                       },
  //                       child: Icon(Icons.close_outlined, color: Colors.grey,),
  //                     ),
  //                     SizedBox(width: 10,),
  //                   ],
  //                 ),
  //                 SizedBox(height: 10,),
  //                 Obx(() => Row(
  //                   children: [
  //                     InkWell(
  //                       highlightColor: Colors.transparent,
  //                       hoverColor: Colors.transparent,
  //                       splashColor: Colors.transparent,
  //                       onTap: () {
  //                         AcademicController.to.selectedColor.value = 'color1';
  //                       },
  //                       child: SizedBox(
  //                         width: 25, height: 25,
  //                         child: CircleAvatar(
  //                           backgroundColor: Color(0xFF0B556B),
  //                           child: Center(
  //                             child: Icon(Icons.check,
  //                               color: AcademicController.to.selectedColor.value == 'color1' ? Colors.white : Colors.transparent,),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(width: 10,),
  //                     InkWell(
  //                       highlightColor: Colors.transparent,
  //                       hoverColor: Colors.transparent,
  //                       splashColor: Colors.transparent,
  //                       onTap: () {
  //                         AcademicController.to.selectedColor.value = 'color2';
  //                       },
  //                       child: SizedBox(
  //                         width: 25, height: 25,
  //                         child: CircleAvatar(
  //                           backgroundColor: Color(0xFFA3556B),
  //                           child: Center(
  //                             child: Icon(Icons.check,
  //                               color: AcademicController.to.selectedColor.value == 'color2' ? Colors.white : Colors.transparent,),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(width: 10,),
  //                     InkWell(
  //                       highlightColor: Colors.transparent,
  //                       hoverColor: Colors.transparent,
  //                       splashColor: Colors.transparent,
  //                       onTap: () {
  //                         AcademicController.to.selectedColor.value = 'color3';
  //                       },
  //                       child: SizedBox(
  //                         width: 25, height: 25,
  //                         child: CircleAvatar(
  //                           backgroundColor: Color(0xFF25A2E7),
  //                           child: Center(
  //                             child: Icon(Icons.check,
  //                               color: AcademicController.to.selectedColor.value == 'color3' ? Colors.white : Colors.transparent,),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(width: 10,),
  //                     InkWell(
  //                       highlightColor: Colors.transparent,
  //                       hoverColor: Colors.transparent,
  //                       splashColor: Colors.transparent,
  //                       onTap: () {
  //                         AcademicController.to.selectedColor.value = 'color4';
  //                       },
  //                       child: SizedBox(
  //                         width: 25, height: 25,
  //                         child: CircleAvatar(
  //                           backgroundColor: Color(0xFFB6CD43),
  //                           child: Center(
  //                             child: Icon(Icons.check,
  //                               color: AcademicController.to.selectedColor.value == 'color4' ? Colors.white : Colors.transparent,),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(width: 15,),
  //                   ],
  //                 ),
  //                 ),
  //                 SizedBox(height: 10,),
  //                 Row(
  //                   children: [
  //                     Text('•', style: TextStyle(fontSize: 20, color: Colors.orange.withOpacity(0.7)),),
  //                     Container(
  //                       width: 350,
  //                       child: TextField(
  //                         autofocus: true,
  //                         controller: TextEditingController(text: appointment.eventName),
  //                         style: TextStyle(color: Colors.black.withOpacity(0.7), height: 1.0, fontWeight: FontWeight.bold,
  //                         ),
  //                         onSubmitted: (value) {
  //                           AcademicController.to.updAcademic(appointment.docID, value);
  //                           Navigator.pop(context);
  //                         },
  //                         onChanged: (value) {
  //                           // DashboardController.to.todoContent = value;
  //                         },
  //                         decoration: InputDecoration(
  //                           enabledBorder: OutlineInputBorder(
  //                             borderSide: BorderSide(color: Colors.transparent,),
  //                           ),
  //                           focusedBorder: OutlineInputBorder(
  //                             borderSide: BorderSide(color: Colors.transparent,),
  //                           ),
  //                           hintText: '일정을 입력하세요 (저장은 엔터키)',
  //                           hintStyle: TextStyle(fontSize: 14, color: Colors.grey,),
  //                           contentPadding: EdgeInsets.all(10),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //
  //
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    AcademicController.to.toDate.value = AcademicController.to.selectedDate.value;
    return StreamBuilder<QuerySnapshot>(
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
            //     Color(0xFF026259), false, doc.id));

          return Obx(() => Container(
              height: 750,
              child: SfCalendar(
                todayHighlightColor: Colors.orange.withOpacity(0.7),
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
                headerDateFormat: 'yyyy년 MM월',
                headerHeight: 50,
                headerStyle: CalendarHeaderStyle(textStyle: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.center), //  August 2022
                appointmentTextStyle: TextStyle(fontSize: 11, color: Colors.white),
                todayTextStyle: TextStyle(color: Colors.white, fontSize: 10),
                firstDayOfWeek: AcademicController.to.firstWeekChoice.value,  // 월요일부터 시작
                // firstDayOfWeek: 1,  // 월요일부터 시작
                monthViewSettings: MonthViewSettings(
                  // numberOfWeeksInView: 6,
                  appointmentDisplayCount:  5,
                  dayFormat: 'E', //  MON, TUE
                  monthCellStyle:  MonthCellStyle(
                    textStyle: TextStyle(fontSize: 11,fontWeight: FontWeight.bold, color: Colors.grey),
                    trailingDatesTextStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.withOpacity(0.5)),
                    leadingDatesTextStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.withOpacity(0.5)),
                  ),
                  appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                ),

              ),
            ),
          );
        }
    );

  }
}
