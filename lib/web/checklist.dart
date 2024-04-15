import 'package:classdiary2/controller/checklist_controller.dart';
import 'package:classdiary2/controller/dashboard_controller.dart';
import 'package:classdiary2/web/search_bar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';

// ignore_for_file: prefer_const_constructors

class Checklist extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Obx(() => SingleChildScrollView(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            /// 이거 안해주면 obx 안됨.
            Text(DashboardController.to.isSearchSubmit.value.toString(), style: TextStyle(fontSize: 1, color: Colors.transparent),),
            SizedBox(height: 10,),
            SearchBarWidget(),
            SizedBox(height: 20,),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('checklist').where('email', isEqualTo: GetStorage().read('email')).where('gubun', isNotEqualTo: '폴더파일')
                    .orderBy('gubun', descending: true).orderBy('date', descending: true)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  var results;
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
                  if (DashboardController.to.isSearchSubmit.value == true) {
                    results = snapshot.data!.docs.where((doc) => doc['title'].contains(DashboardController.to.searchInput)).toList();
                  }else{
                    /// 1월, 2월 전학년도 처리 및 이번 학년도만 가져오기
                    /// 1월,2월이면 올해~전년 3월까지, 그외달은 올해 3월부터 가져오기

                    if(DateTime.now().month == 1 || DateTime.now().month == 2) {
                      var from_date = DateTime(DateTime.now().year - 1, 3, 0).toString();
                      var to_date = DateTime(DateTime.now().year, 3, 0).toString();
                      results = snapshot.data!.docs.where((doc) => doc['date'].compareTo(from_date) > 0 )
                          .where((doc) => doc['date'].compareTo(to_date) < 0 ).toList();
                    }else{
                      var from_date = DateTime(DateTime.now().year, 3, 0).toString();
                      var to_date = DateTime(DateTime.now().year + 1, 3, 0).toString();
                      results = snapshot.data!.docs.where((doc) => doc['date'].compareTo(from_date) > 0 )
                          .where((doc) => doc['date'].compareTo(to_date) < 0 ).toList();
                    }

                  }

                  return Container(
                    height: 600,
                    child: ListView.separated(
                      itemCount: results.length,
                      itemBuilder: (_, index) {
                        DocumentSnapshot doc = results[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child:
                          InkWell(

                            onTap: () {
                              if (doc['gubun'] == '폴더') {
                                ChecklistController.to.whereToGo.value = 'ChecklistFolder';
                                ChecklistController.to.folderid = doc.id;
                                ChecklistController.to.folderTitle.value = doc['title'];
                              }else {
                                ChecklistController.to.whereToGo.value = 'ChecklistDetail';
                                ChecklistController.to.whoCall = 'Checklist';
                              }

                              ChecklistController.to.id = doc.id;
                              ChecklistController.to.title.value = doc['title'];
                              ChecklistController.to.selectedDate.value = doc['date'];
                            },
                            child: Obx(() => Row(
                              children: [
                                doc['gubun'] == '폴더' ?
                                Icon(Icons.folder, color: Colors.teal.withOpacity(0.7),) :
                                Icon(Icons.insert_drive_file_outlined, ),
                                SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 210,
                                          child: Text(doc['title'], overflow: TextOverflow.ellipsis,),
                                        ),
                                      ],
                                    ),
                                    doc['gubun'] == '폴더'
                                        ? SizedBox()
                                        : Text(doc['date'].substring(2,4) + '.' +
                                        doc['date'].substring(5,7) + '.' +
                                        doc['date'].substring(8,10) + '(' +
                                        DateFormat.E('ko_KR').format(DateTime.parse(doc['date'])) + ')',
                                      style: TextStyle(fontSize: 12, color: Colors.grey,),
                                    ),
                                  ],
                                ),
                                Expanded(child: SizedBox(),),
                                doc['gubun'] == '파일'
                                    ? Text(doc['numArray'].length.toString(), style: TextStyle(fontSize: 20, color: Colors.orange.withOpacity(0.7)),)
                                    : SizedBox(),
                                SizedBox(width: 15,),

                                ChecklistController.to.chartSelections.contains(doc.id)
                                    ? InkWell(

                                  onTap: () {
                                    ChecklistController.to.chartSelections.remove(doc.id);
                                  },
                                  child: Icon(Icons.stacked_bar_chart, color: Colors.orange.withOpacity(0.7),),
                                )
                                    : InkWell(

                                  onTap: () {
                                    ChecklistController.to.chartSelections.add(doc.id);
                                  },
                                  child: Icon(Icons.stacked_bar_chart, color: Colors.grey.withOpacity(0.5),),
                                ),
                              ],
                            ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, index) {
                        return Divider(color: Colors.grey.withOpacity(0.7),);
                      },

                    ),
                  );
                  return Text('aaa');
                }
            ),
          ],
        ),
    ),
    );
  }

}






