
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../common/sliverGridDelegateWithFixedCrossAxisCountAndFixedHeight.dart';
import '../controller/attendance_controller.dart';
import '../controller/board_controller.dart';
import '../controller/dashboard_controller.dart';
import '../controller/diary_controller.dart';
import 'chart.dart';

class Diary extends StatelessWidget {

  void chartDialog(context) {
    /// 전체화면에서 다이어로그 띄우기
    showGeneralDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      pageBuilder: (_,__,___) {
        return Scaffold(
          // backgroundColor: Color(0xFF5E5E5E).withOpacity(0.8),
          appBar: AppBar(
            centerTitle: false, // 왼쪽에 두기위해
            automaticallyImplyLeading: false,
            elevation: 0,
            // backgroundColor: Color(0xFF5E5E5E).withOpacity(0.8),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, size: 30,),),
                ),
                Text(DiaryController.to.name, style: TextStyle(color: Colors.white),),
                Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.transparent,size: 30,),),
              ],
            ),
          ),
          body: Chart(),
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            /// obx 때문에 추가
            Text(DiaryController.to.diary_days[DiaryController.to.current_page_index.value], style: TextStyle(color: Colors.transparent, fontSize: 1),),
            Padding(
              padding: const EdgeInsets.all(10),
              // padding: const EdgeInsets.only(left:40, right:40, top:20, bottom: 40),
              child: GridView.builder(
                  primary: false,
                  shrinkWrap: true,
                  // padding: const EdgeInsets.all(10),
                  gridDelegate:
                  /// 어떤 디바이스에도 일정한 높이 간격 유지
                  SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                    /// 그램 1707 * 910/ 왼컴 2048*1030/ 오컴 1920*957, 아이맥 2048, 한성 1920
                    /// 아이패드 가로/세로 = 1180/820, 아이패드프로 가로/세로 = 1366/1024
                    // crossAxisCount: 6,
                    crossAxisCount: MediaQuery.of(context).size.width >= 1920 ? 6 : MediaQuery.of(context).size.width >= 1700 ? 5 :
                    MediaQuery.of(context).size.width >= 1300 ? 4 : MediaQuery.of(context).size.width > 1100 ? 3 : MediaQuery.of(context).size.width > 600 ? 2 : 1,
                    // crossAxisCount: MediaQuery.of(context).size.width > 1100 ? 3 : MediaQuery.of(context).size.width > 600 ? 2 : 1,
                    // crossAxisCount: MediaQuery.of(context).size.width > 1100 ? 3 : MediaQuery.of(context).size.width > 600 ? 2 : 1,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    height: 750,  /// 높이 지정
                  ),
                  // SliverGridDelegateWithFixedCrossAxisCount(
                  //   /// 아이패드(1180/820, 프로 12.9인치= 1366/1024)가 가로면? 세로면? 아이폰이면
                  //   crossAxisCount: 6,
                  //   // crossAxisCount: MediaQuery.of(context).size.width > 1100 ? 3 : MediaQuery.of(context).size.width > 600 ? 2 : 1,
                  //   childAspectRatio:  1/2.2, //item 의 가로, 세로 의 비율
                  //   // childAspectRatio: MediaQuery.of(context).size.width > 1300 ? 1/1.9 : 1/2.2, //item 의 가로, 세로 의 비율
                  // ),
                  itemCount: AttendanceController.to.attendanceDocs.length,
                  itemBuilder: (_, index) {
                    DocumentSnapshot attendanceDoc = AttendanceController.to.attendanceDocs[index];
                    String current_date = DiaryController.to.diary_days[DiaryController.to.current_page_index.value];
                    return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('diary').where('class_code', isEqualTo: GetStorage().read('class_code'))
                            .where('date', isEqualTo: current_date).where('number', isEqualTo: attendanceDoc['number']).snapshots(),
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
                          DiaryController.to.morning_emotion_icon = '';
                          DiaryController.to.morning_emotion_name = '';
                          DiaryController.to.morning_emotion_content = '';
                          // DiaryController.to.checklist_points = [0,0,0,0,0,0,0,0,0,0];
                          DiaryController.to.learning = '';
                          DiaryController.to.notice = '';
                          DiaryController.to.after_emotion_icon = '';
                          DiaryController.to.after_emotion_name = '';
                          DiaryController.to.after_emotion_content = '';

                          List checklist_points = [0,0,0,0,0,0,0,0,0,0];

                          if (snapshot.data!.docs.length > 0) {
                            DiaryController.to.morning_emotion_icon = snapshot.data!.docs.first['morning_emotion_icon'];
                            DiaryController.to.morning_emotion_name = snapshot.data!.docs.first['morning_emotion_name'];
                            DiaryController.to.morning_emotion_content = snapshot.data!.docs.first['morning_emotion_content'];
                            /// 감정내용이 있을때 onhover하면 보이게
                            DiaryController.to.morning_emotion_content_list.value[index] = DiaryController.to.morning_emotion_content;

                            // DiaryController.to.checklist_points = [];
                            // DiaryController.to.checklist_points.add(snapshot.data!.docs.first['checklist_01']);
                            // DiaryController.to.checklist_points.add(snapshot.data!.docs.first['checklist_02']);
                            // DiaryController.to.checklist_points.add(snapshot.data!.docs.first['checklist_03']);
                            // DiaryController.to.checklist_points.add(snapshot.data!.docs.first['checklist_04']);
                            // DiaryController.to.checklist_points.add(snapshot.data!.docs.first['checklist_05']);
                            // DiaryController.to.checklist_points.add(snapshot.data!.docs.first['checklist_06']);
                            // DiaryController.to.checklist_points.add(snapshot.data!.docs.first['checklist_07']);
                            // DiaryController.to.checklist_points.add(snapshot.data!.docs.first['checklist_08']);
                            // DiaryController.to.checklist_points.add(snapshot.data!.docs.first['checklist_09']);
                            // DiaryController.to.checklist_points.add(snapshot.data!.docs.first['checklist_10']);

                            /// DiaryController.to.checklist_points 이걸로 하면 처음 main_list에서 클릭하면 데이터 못 가져옴. 왜 그렇지?
                            checklist_points = [];
                            checklist_points.add(snapshot.data!.docs.first['checklist_01']);
                            checklist_points.add(snapshot.data!.docs.first['checklist_02']);
                            checklist_points.add(snapshot.data!.docs.first['checklist_03']);
                            checklist_points.add(snapshot.data!.docs.first['checklist_04']);
                            checklist_points.add(snapshot.data!.docs.first['checklist_05']);
                            checklist_points.add(snapshot.data!.docs.first['checklist_06']);
                            checklist_points.add(snapshot.data!.docs.first['checklist_07']);
                            checklist_points.add(snapshot.data!.docs.first['checklist_08']);
                            checklist_points.add(snapshot.data!.docs.first['checklist_09']);
                            checklist_points.add(snapshot.data!.docs.first['checklist_10']);

                            DiaryController.to.learning = snapshot.data!.docs.first['learning'];
                            DiaryController.to.notice = snapshot.data!.docs.first['notice'];
                            DiaryController.to.after_emotion_icon = snapshot.data!.docs.first['after_emotion_icon'];
                            DiaryController.to.after_emotion_name = snapshot.data!.docs.first['after_emotion_name'];
                            DiaryController.to.after_emotion_content = snapshot.data!.docs.first['after_emotion_content'];

                            /// 감정내용이 있을때 onhover하면 보이게
                            DiaryController.to.after_emotion_content_list.value[index] = DiaryController.to.after_emotion_content;
                          }
                          return Padding(
                            padding: MediaQuery.of(context).size.width > 600 ? EdgeInsets.all(8.0) : EdgeInsets.all(0),
                            child: Column(
                              children: [
                                /// 번호, 이름, 추가아이콘
                                Container(
                                  height: 30,
                                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        color: Colors.transparent,
                                        width: 70,
                                      ),
                                      Text('${attendanceDoc['number']}번  ${attendanceDoc['name']}',  style: TextStyle(fontFamily: 'Jua', fontSize: 16, color: Colors.white),),
                                      InkWell(
                                        highlightColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        onTap: () async{
                                          DiaryController.to.number = attendanceDoc['number'];
                                          DiaryController.to.name = attendanceDoc['name'];
                                          await DiaryController.to.getMorningEmotionChart();
                                          await DiaryController.to.getChecklistEmotionChart();
                                          await DiaryController.to.getAfterEmotionChart();
                                          chartDialog(context);
                                        },
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          color: Colors.transparent,
                                          width: 70,
                                          child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Image.asset('assets/images/emotion/chart.png'),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5,),
                                /// 아침 감정날씨
                                InkWell(
                                  onTap: () {
                                    // print('aaaa');
                                  },
                                  onHover: (is_hovering) {
                                    if(is_hovering == true){
                                      DiaryController.to.is_visible_morning_emotion_contents.value[index] = true;
                                      DiaryController.to.is_hovering_morning.value = true;
                                      /// List 를 obx로 받으려면 더미를 추가해야 되네.
                                      DiaryController.to.dummy_date.value = DateTime.now().toString();
                                    }else{
                                      DiaryController.to.is_visible_morning_emotion_contents.value[index] = false;
                                      DiaryController.to.is_hovering_morning.value = false;
                                      DiaryController.to.dummy_date.value = DateTime.now().toString();
                                    }
                                  },

                                  child: Stack(
                                    children: [
                                      Container(
                                        width: MediaQuery.sizeOf(context).width,
                                        height: 60,
                                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.5)), borderRadius: BorderRadius.circular(10)),
                                        // decoration: BoxDecoration(color: Color(0xFF5E5E5E).withOpacity(0.8), borderRadius: BorderRadius.circular(10)),
                                        child: DiaryController.to.morning_emotion_icon.length > 0 ?
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset('assets/images/emotion/${DiaryController.to.morning_emotion_icon}.png', height: 40,),
                                              SizedBox(width: 10,),
                                              Text(DiaryController.to.morning_emotion_name, style: TextStyle( fontSize: 12),),
                                            ],
                                          )
                                        ) :
                                        Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Row(
                                            children: [
                                              Image.asset('assets/images/emotion/weather.png', height: 30,),
                                              SizedBox(width: 10,),
                                              Text('오늘 아침의 마음날씨는 어떤가요?', style: TextStyle( fontSize: 12),),
                                            ],
                                          ),
                                        ),
                                      ),
                                      /// 아침감정내용이 있으면
                                      Obx(() => Visibility(
                                          visible: DiaryController.to.is_visible_morning_emotion_contents.value[index] &&
                                              DiaryController.to.morning_emotion_content_list.value[index].length > 0,
                                          child: Container(
                                            width: MediaQuery.sizeOf(context).width,
                                            height: 150,
                                            // height: 60,
                                            decoration: BoxDecoration(color: Color(0xFF76B8C3), border: Border.all(color: Colors.grey.withOpacity(0.5)), borderRadius: BorderRadius.circular(10)),
                                            child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      Text(DiaryController.to.dummy_date.value, style: TextStyle( fontSize: 0, color: Colors.transparent),),
                                                      Text(DiaryController.to.morning_emotion_content_list.value[index], style: TextStyle( fontSize: 12),),
                                                    ],
                                                  ),
                                                ),
                                                // child: Text(DiaryController.to.morning_emotion_content, style: TextStyle( fontSize: 12),),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5,),
                                /// 체크리스트
                                Container(
                                  width: MediaQuery.sizeOf(context).width,
                                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.5)), borderRadius: BorderRadius.circular(10)),
                                  // decoration: BoxDecoration(color: Color(0xFF5E5E5E).withOpacity(0.8), borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: ListView.separated(
                                      primary: false,
                                      shrinkWrap: true,
                                      itemCount: DiaryController.to.checklist.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        String checklist_good = 'checklist_good_01';
                                        String checklist_bad = 'checklist_bad_01';
                                        if (checklist_points[index] == 1) {
                                          checklist_good = 'checklist_good_02';
                                          checklist_bad = 'checklist_bad_01';
                                        }else if (checklist_points[index] == 0){
                                          checklist_good = 'checklist_good_01';
                                          checklist_bad = 'checklist_bad_01';
                                        }else{
                                          checklist_good = 'checklist_good_01';
                                          checklist_bad = 'checklist_bad_02';
                                        }
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(DiaryController.to.checklist[index], style: TextStyle( fontSize: 11),),
                                            Row(
                                              children: [
                                                checklist_good == 'checklist_good_01' ?
                                                Image.asset('assets/images/emotion/${checklist_good}.png', height: 20, ) :
                                                Image.asset('assets/images/emotion/${checklist_good}.png', height: 20, ),
                                                SizedBox(width: 10,),
                                                checklist_bad == 'checklist_bad_01' ?
                                                Image.asset('assets/images/emotion/${checklist_bad}.png', height: 20, ) :
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
                                ),
                                SizedBox(height: 5,),
                                /// 방과후 감정날씨
                                InkWell(
                                  onTap: () {
                                    // print('aaaa');
                                  },
                                  onHover: (is_hovering) {
                                    if(is_hovering == true){
                                      DiaryController.to.is_visible_after_emotion_contents.value[index] = true;
                                      DiaryController.to.is_hovering_after.value = true;
                                      /// List 를 obx로 받으려면 더미를 추가해야 되네.
                                      DiaryController.to.dummy_date.value = DateTime.now().toString();
                                    }else{
                                      DiaryController.to.is_visible_after_emotion_contents.value[index] = false;
                                      DiaryController.to.is_hovering_after.value = false;
                                      DiaryController.to.dummy_date.value = DateTime.now().toString();
                                    }
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: MediaQuery.sizeOf(context).width,
                                        height: 60,
                                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.5)), borderRadius: BorderRadius.circular(10)),
                                        // decoration: BoxDecoration(color: Color(0xFF5E5E5E).withOpacity(0.8), borderRadius: BorderRadius.circular(10)),
                                        child: DiaryController.to.after_emotion_icon.length > 0 ?
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset('assets/images/emotion/${DiaryController.to.after_emotion_icon}.png', height: 40,),
                                              SizedBox(width: 10,),
                                              Text(DiaryController.to.after_emotion_name, style: TextStyle( fontSize: 12),),
                                            ],
                                          ),
                                        ) :
                                        Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Row(
                                            // mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset('assets/images/emotion/weather.png', height: 30,),
                                              SizedBox(width: 10,),
                                              Text('일과를 마친 지금 마음날씨는 어떤가요?', style: TextStyle( fontSize: 12),),
                                            ],
                                          ),
                                        ),
                                      ),
                                      /// 방과후감정내용이 있으면
                                      Obx(() => Visibility(
                                          visible: DiaryController.to.is_visible_after_emotion_contents.value[index] &&
                                              DiaryController.to.after_emotion_content_list.value[index].length > 0,
                                          child: Container(
                                            width: MediaQuery.sizeOf(context).width,
                                            height: 150,
                                            decoration: BoxDecoration(color: Color(0xFF76B8C3), border: Border.all(color: Colors.grey.withOpacity(0.5)), borderRadius: BorderRadius.circular(10)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    Text(DiaryController.to.dummy_date.value, style: TextStyle( fontSize: 0, color: Colors.transparent),),
                                                    Text(DiaryController.to.after_emotion_content_list.value[index], style: TextStyle( fontSize: 12),),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 5,),
                                /// 배운내용
                                Container(
                                  width: MediaQuery.sizeOf(context).width,
                                  /// 길이를 고정해야 함
                                  height: 90,
                                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.5)), borderRadius: BorderRadius.circular(10)),
                                  // decoration: BoxDecoration(color: Color(0xFF5E5E5E).withOpacity(0.8), borderRadius: BorderRadius.circular(10)),
                                  child: DiaryController.to.learning.length > 0 ?
                                  SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Text(DiaryController.to.learning, style: TextStyle( fontSize: 12),),
                                    ),
                                  ) :
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset('assets/images/emotion/pencil.png', height: 20,),
                                        SizedBox(width: 10,),
                                        Text('오늘 배운 내용중에 새롭게 알게 되었거나\n기억에 남는 것을 적어 보세요', style: TextStyle( fontSize: 12),),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5,),
                                /// 알림장
                                Obx(() => Visibility(
                                    visible: !(DiaryController.to.is_visible_morning_emotion_contents.value[index] && DiaryController.to.morning_emotion_content_list.value[index].length > 0)
                                        &&
                                        !(DiaryController.to.is_visible_after_emotion_contents.value[index] && DiaryController.to.after_emotion_content_list.value[index].length > 0),
                                    child: Container(
                                      width: MediaQuery.sizeOf(context).width,
                                      height: 90,
                                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.5)), borderRadius: BorderRadius.circular(10)),
                                      // decoration: BoxDecoration(color: Color(0xFF5E5E5E).withOpacity(0.8), borderRadius: BorderRadius.circular(10)),
                                      child: DiaryController.to.notice.length > 0 ?
                                      SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Text(DiaryController.to.notice, style: TextStyle( fontSize: 12),),
                                        ),
                                      ) :
                                      Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Row(
                                          // mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset('assets/images/emotion/notice.png', height: 20,),
                                            SizedBox(width: 10,),
                                            Text('알림장을 적어 보세요', style: TextStyle( fontSize: 12),),
                                            Text(DiaryController.to.dummy_date.value, style: TextStyle( fontSize: 0, color: Colors.transparent),),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30,),
                              ],
                            ),
                          );
                        }
                    );
                  }
              ),
            ),
            SizedBox(height: 100,),
          ],
        ),
      ),


    ),
    );

  }
}







