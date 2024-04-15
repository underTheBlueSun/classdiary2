import 'package:classdiary2/controller/checklist_controller.dart';
import 'package:classdiary2/controller/dashboard_controller.dart';
import 'package:classdiary2/controller/esti_controller.dart';
import 'package:classdiary2/web/search_bar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';

// ignore_for_file: prefer_const_constructors

class Estimate extends StatelessWidget {

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
                  .collection('estimate').where('email', isEqualTo: GetStorage().read('email')).where('gubun', isNotEqualTo: '폴더파일')
                  .orderBy('gubun', descending: true).orderBy('date', descending: true).snapshots(),
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
                              EstiController.to.whereToGo.value = 'EstimateFolder';
                              EstiController.to.folderid = doc.id;
                              EstiController.to.folderTitle.value = doc['title'];
                              // EstiController.to.esti = doc['esti'];
                            }else {
                              EstiController.to.whereToGo.value = 'EstimateDetail';
                              EstiController.to.whoCall = 'Estimate';
                            }

                            EstiController.to.id = doc.id;
                            EstiController.to.title.value = doc['title'];
                            EstiController.to.selectedDate.value = doc['date'];
                            EstiController.to.esti.value = doc['esti'];
                          },
                          child: Obx(() =>
                          doc['esti'] == 'tripple'
                              ? Row(
                              children: [
                              doc['gubun'] == '폴더' ?
                              Icon(Icons.folder, color: Colors.teal.withOpacity(0.7),) :
                              Icon(Icons.insert_drive_file_outlined, ),
                              SizedBox(width: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 250,
                                    child: Text(doc['title'],
                                      overflow: TextOverflow.ellipsis,
                                    ),
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
                              EstiController.to.chartSelections1.contains(doc.id)
                                  ? InkWell(
                                onTap: () {
                                  EstiController.to.chartSelections1.remove(doc.id);
                                },
                                child: Icon(Icons.stacked_bar_chart, color: Colors.orange.withOpacity(0.7),),
                              )
                                  : InkWell(
                                onTap: () {
                                  EstiController.to.chartSelections1.add(doc.id);
                                },
                                child: Icon(Icons.stacked_bar_chart, color: Colors.grey.withOpacity(0.5),),
                              ),
                            ],
                          )
                            : Row(
                            children: [
                              doc['gubun'] == '폴더' ?
                              Icon(Icons.folder, color: Colors.teal.withOpacity(0.7),) :
                              Icon(Icons.insert_drive_file_outlined, ),
                              SizedBox(width: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 250,
                                    child: Text(doc['title'],
                                      overflow: TextOverflow.ellipsis,
                                    ),
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
                              EstiController.to.chartSelections2.contains(doc.id)
                                  ? InkWell(
                                onTap: () {
                                  EstiController.to.chartSelections2.remove(doc.id);
                                },
                                child: Icon(Icons.stacked_bar_chart, color: Colors.teal,),
                              )
                                  : InkWell(
                                onTap: () {
                                  EstiController.to.chartSelections2.add(doc.id);
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






