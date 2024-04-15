import 'package:classdiary2/controller/dashboard_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:get/get.dart';

import '../controller/diary_controller.dart';

class Chart extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 왼쪽 챠트
          Container(
            width: MediaQuery.of(context).size.width * 0.65,
            child: Column(
              children: [
                Text('아침 감정곡선', ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  // height: 200,
                  child: LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: DiaryController.to.morning_charts.length - 1,
                      // maxX: 365,
                      minY: 0,
                      maxY: 7,
                      lineTouchData: LineTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false),),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false),),
                        // leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false),),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                const style = TextStyle(
                                  fontSize: 9,
                                );
                                String text;
                                switch (value.toInt()) {
                                  case 0: text = '흐림'; break;
                                  case 7: text = '맑음'; break;
                                  default:
                                    return Container();
                                }
                                return Text(text, style: style, textAlign: TextAlign.start);
                              }
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1, /// 1일마다
                              getTitlesWidget: (double value, TitleMeta meta) {
                                const style = TextStyle(fontSize: 12, );
                                String text;
                                if (value.toInt() == 0) {
                                  text = DiaryController.to.chart_morning_start_date;
                                }
                                else if (value.toInt() == (DiaryController.to.morning_charts.length/2).floor()) {
                                  text = DiaryController.to.chart_morning_middle_date;
                                }
                                else if (value.toInt() == DiaryController.to.morning_charts.length - 1) {
                                  // else if (value.toInt() == DiaryController.to.charts.length - 1) {
                                  text = DiaryController.to.chart_morning_end_date;
                                }else{
                                  text = '';
                                }

                                // switch (value.toInt()) {
                                //   case 0: text = DiaryController.to.chart_start_date; break;
                                //   case 60: text = DiaryController.to.chart_middle_date; break;
                                //   case 90: text = DiaryController.to.chart_end_date; break;
                                //   default:
                                //     return Container();
                                // }
                                return Text(text, style: style, textAlign: TextAlign.center);
                              }
                          ),
                        ),
                      ),
                      // titlesData: LineTitles.getTitleData(),
                      gridData: FlGridData(
                        show: true,
                        verticalInterval: 30.0, /// 30일 단위로 세로선
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.transparent,
                            // color: const Color(0xff37434d),
                            strokeWidth: 1,
                          );
                        },
                        drawVerticalLine: true,
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: const Color(0xff37434d),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            for ( var item in DiaryController.to.morning_charts )
                              FlSpot(item['index'].toDouble(), item['point'].toDouble()),
                          ],
                          isCurved: true,
                          color: Color(0xff457E8F),
                          barWidth: 3,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: false,
                            color: Color(0xffDC1A27),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40,),
                Text('체크리스트', ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  // height: 200,
                  child: LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: DiaryController.to.checklist_charts.length - 1,
                      // maxX: 365,
                      minY: -10,
                      maxY: 10,
                      lineTouchData: LineTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false),),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false),),
                        // leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false),),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                const style = TextStyle(
                                  
                                  fontSize: 9,
                                );
                                String text;
                                switch (value.toInt()) {
                                  case -10: text = '낮음'; break;
                                  case 10: text = '높음'; break;
                                  default:
                                    return Container();
                                }
                                return Text(text, style: style, textAlign: TextAlign.start);
                              }
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1, /// 1일마다
                              getTitlesWidget: (double value, TitleMeta meta) {
                                const style = TextStyle(fontSize: 12, );
                                String text;
                                if (value.toInt() == 0) {
                                  text = DiaryController.to.chart_checklist_start_date;
                                }
                                else if (value.toInt() == (DiaryController.to.checklist_charts.length/2).floor()) {
                                  text = DiaryController.to.chart_checklist_middle_date;
                                }
                                else if (value.toInt() == DiaryController.to.checklist_charts.length - 1) {
                                  // else if (value.toInt() == DiaryController.to.charts.length - 1) {
                                  text = DiaryController.to.chart_checklist_end_date;
                                }else{
                                  text = '';
                                }
                                return Text(text, style: style, textAlign: TextAlign.center);
                              }
                          ),
                        ),
                      ),
                      // titlesData: LineTitles.getTitleData(),
                      gridData: FlGridData(
                        show: true,
                        verticalInterval: 30.0, /// 30일 단위로 세로선
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.transparent,
                            // color: const Color(0xff37434d),
                            strokeWidth: 1,
                          );
                        },
                        drawVerticalLine: true,
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: const Color(0xff37434d),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            for ( var item in DiaryController.to.checklist_charts )
                              FlSpot(item['index'].toDouble(), item['point'].toDouble()),
                          ],
                          isCurved: true,
                          color: Colors.orangeAccent,
                          barWidth: 3,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: false,
                            color: Color(0xffDC1A27),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40,),
                Text('일과후 감정곡선', ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  // height: 200,
                  child: LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: DiaryController.to.after_charts.length - 1,
                      // maxX: 365,
                      minY: 0,
                      maxY: 7,
                      lineTouchData: LineTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false),),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false),),
                        // leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false),),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                const style = TextStyle(
                                  
                                  fontSize: 9,
                                );
                                String text;
                                switch (value.toInt()) {
                                  case 0: text = '흐림'; break;
                                  case 7: text = '맑음'; break;
                                  default:
                                    return Container();
                                }
                                return Text(text, style: style, textAlign: TextAlign.start);
                              }
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1, /// 1일마다
                              getTitlesWidget: (double value, TitleMeta meta) {
                                const style = TextStyle(fontSize: 12, );
                                String text;
                                if (value.toInt() == 0) {
                                  text = DiaryController.to.chart_after_start_date;
                                }
                                else if (value.toInt() == (DiaryController.to.after_charts.length/2).floor()) {
                                  text = DiaryController.to.chart_after_middle_date;
                                }
                                else if (value.toInt() == DiaryController.to.after_charts.length - 1) {
                                  // else if (value.toInt() == DiaryController.to.charts.length - 1) {
                                  text = DiaryController.to.chart_after_end_date;
                                }else{
                                  text = '';
                                }

                                // switch (value.toInt()) {
                                //   case 0: text = DiaryController.to.chart_start_date; break;
                                //   case 60: text = DiaryController.to.chart_middle_date; break;
                                //   case 90: text = DiaryController.to.chart_end_date; break;
                                //   default:
                                //     return Container();
                                // }
                                return Text(text, style: style, textAlign: TextAlign.center);
                              }
                          ),
                        ),
                      ),
                      // titlesData: LineTitles.getTitleData(),
                      gridData: FlGridData(
                        show: true,
                        verticalInterval: 30.0, /// 30일 단위로 세로선
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.transparent,
                            // color: const Color(0xff37434d),
                            strokeWidth: 1,
                          );
                        },
                        drawVerticalLine: true,
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: const Color(0xff37434d),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            for ( var item in DiaryController.to.after_charts )
                              FlSpot(item['index'].toDouble(), item['point'].toDouble()),
                          ],
                          isCurved: true,
                          color: Colors.green,
                          barWidth: 3,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: false,
                            color: Color(0xffDC1A27),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 30,),
          /// 오른쪽 내용
          Expanded(
            child: Obx(() => Column(
              children: [
                /// 선택 탭
                Row(
                  children: [
                    InkWell(
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        DiaryController.to.diary_gubun.value = '아침감정내용';
                      },
                      child: Container(
                        decoration: BoxDecoration(color: DiaryController.to.diary_gubun.value == '아침감정내용' ? Colors.teal : Colors.transparent, border: Border(left: BorderSide(width: 1, ),
                          right: BorderSide(width: 1, ),top: BorderSide(width: 1, ),
                        ),),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text('아침감정내용', style: TextStyle(color: DiaryController.to.diary_gubun.value == '아침감정내용' ? Colors.white : Colors.grey),),
                        ),
                      ),
                    ),
                    InkWell(
                      highlightColor: Colors.transparent, 
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        DiaryController.to.diary_gubun.value = '체크리스트';
                      },
                      child: Container(
                        decoration: BoxDecoration(color: DiaryController.to.diary_gubun.value == '체크리스트' ? Colors.teal : Colors.transparent, border: Border(right: BorderSide(width: 1, ),
                          top: BorderSide(width: 1, ),),),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text('체크리스트', style: TextStyle(color: DiaryController.to.diary_gubun.value == '체크리스트' ? Colors.white : Colors.grey),),
                        ),
                      ),
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        DiaryController.to.diary_gubun.value = '일과후감정내용';
                      },
                      child: Container(
                        decoration: BoxDecoration(color: DiaryController.to.diary_gubun.value == '일과후감정내용' ? Colors.teal : Colors.transparent, border: Border(right: BorderSide(width: 1, ),
                          top: BorderSide(width: 1, ),),),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text('일과후감정내용', style: TextStyle(color: DiaryController.to.diary_gubun.value == '일과후감정내용' ? Colors.white : Colors.grey),),
                        ),
                      ),
                    ),
                  ],
                ),
                /// 내용
                Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  // width: MediaQuery.of(context).size.width * 0.35,
                  decoration: BoxDecoration(border: Border.all(width: 1, ),),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('diary').where('class_code', isEqualTo: GetStorage().read('class_code'))
                          .where('number', isEqualTo: DiaryController.to.number).snapshots(),
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
                        }

                        List sorted_doc = [];
                        if (snapshot.data!.docs.length > 0) {
                          sorted_doc = snapshot.data!.docs;
                          sorted_doc.sort((a, b) => b['date'].compareTo(a['date']));

                        }

                        if (DiaryController.to.diary_gubun.value == '아침감정내용') {
                          return ListView.separated(
                              primary: false,
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(25),
                              itemCount: sorted_doc.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      width: 60,
                                      child: Column(
                                        children: [
                                          sorted_doc[index]['morning_emotion_icon'].length > 0 ?
                                          Image.asset('assets/images/emotion/${sorted_doc[index]['morning_emotion_icon']}.png', height: 30,) : SizedBox(),
                                          Text(sorted_doc[index]['morning_emotion_name'], ),
                                        ],
                                      ),
                                    ),
                                    Expanded(child: Text(sorted_doc[index]['morning_emotion_content'], )),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      width: 50,
                                      child: Column(
                                        children: [
                                          Text(sorted_doc[index]['date'].substring(0,2)+'.'+ sorted_doc[index]['date'].substring(4,6), ),
                                          Text(sorted_doc[index]['date'].substring(7,10), ),
                                        ],
                                      ),
                                    )
                                  ],
                                ) ;
                              },
                              separatorBuilder: (BuildContext context, int index) { return Divider(thickness: 1, color: Colors.grey.withOpacity(0.5),); }

                          );
                        }else if (DiaryController.to.diary_gubun.value == '체크리스트') {
                          return ListView.builder(
                            itemCount: sorted_doc.length,
                            itemBuilder: (context, index) {
                              DiaryController.to.checklist_points = [];
                              DiaryController.to.checklist_points.add(sorted_doc[index]['checklist_01']);
                              DiaryController.to.checklist_points.add(sorted_doc[index]['checklist_02']);
                              DiaryController.to.checklist_points.add(sorted_doc[index]['checklist_03']);
                              DiaryController.to.checklist_points.add(sorted_doc[index]['checklist_04']);
                              DiaryController.to.checklist_points.add(sorted_doc[index]['checklist_05']);
                              DiaryController.to.checklist_points.add(sorted_doc[index]['checklist_06']);
                              DiaryController.to.checklist_points.add(sorted_doc[index]['checklist_07']);
                              DiaryController.to.checklist_points.add(sorted_doc[index]['checklist_08']);
                              DiaryController.to.checklist_points.add(sorted_doc[index]['checklist_09']);
                              DiaryController.to.checklist_points.add(sorted_doc[index]['checklist_10']);
                              return Padding(
                                padding: const EdgeInsets.all(20),
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width,
                                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.5)), borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    children: [
                                      Text(sorted_doc[index]['date'], ),
                                      Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: ListView.separated(
                                          primary: false,
                                          shrinkWrap: true,
                                          itemCount: DiaryController.to.checklist.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            String checklist_good = 'checklist_good_01';
                                            String checklist_bad = 'checklist_bad_01';
                                            if (DiaryController.to.checklist_points[index] == 1) {
                                              checklist_good = 'checklist_good_02';
                                              checklist_bad = 'checklist_bad_01';
                                            }else if (DiaryController.to.checklist_points[index] == 0){
                                              checklist_good = 'checklist_good_01';
                                              checklist_bad = 'checklist_bad_01';
                                            }else{
                                              checklist_good = 'checklist_good_01';
                                              checklist_bad = 'checklist_bad_02';
                                            }
                                            return Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(DiaryController.to.checklist[index], ),
                                                Row(
                                                  children: [
                                                    checklist_good == 'checklist_good_01' ?
                                                    Image.asset('assets/images/emotion/${checklist_good}.png', height: 20, color: Colors.white.withOpacity(0.2), colorBlendMode: BlendMode.modulate) :
                                                    Image.asset('assets/images/emotion/${checklist_good}.png', height: 20, ),
                                                    SizedBox(width: 15,),
                                                    checklist_bad == 'checklist_bad_01' ?
                                                    Image.asset('assets/images/emotion/${checklist_bad}.png', height: 20, color: Colors.white.withOpacity(0.2), colorBlendMode: BlendMode.modulate) :
                                                    Image.asset('assets/images/emotion/${checklist_bad}.png', height: 20, ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          }, separatorBuilder: (BuildContext context, int index) {
                                          return Divider(thickness: 0.5, color: Colors.grey.withOpacity(0.5),);
                                        },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ) ;

                            },

                          );
                        }else { /// 방과후 감정
                          return ListView.separated(
                              primary: false,
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(25),
                              itemCount: sorted_doc.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      width: 60,
                                      child: Column(
                                        children: [
                                          sorted_doc[index]['after_emotion_icon'].length > 0 ?
                                          Image.asset('assets/images/emotion/${sorted_doc[index]['after_emotion_icon']}.png', height: 30,) : SizedBox(),
                                          Text(sorted_doc[index]['after_emotion_name'], ),
                                        ],
                                      ),
                                    ),
                                    Expanded(child: Text(sorted_doc[index]['after_emotion_content'], )),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      width: 50,
                                      child: Column(
                                        children: [
                                          Text(sorted_doc[index]['date'].substring(0,2)+'.'+ sorted_doc[index]['date'].substring(4,6), ),
                                          Text(sorted_doc[index]['date'].substring(7,10), ),
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) { return Divider(thickness: 1); }

                          );
                        }

                      }
                  ),
                ),
              ],
            ),
            ),
          ),

        ],
      ),
    );

  }
}


