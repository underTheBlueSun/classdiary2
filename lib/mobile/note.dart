import 'package:classdiary2/controller/dashboard_controller.dart';
import 'package:classdiary2/controller/note_controller.dart';
import 'package:classdiary2/mobile/bottom_navibar_widget.dart';
import 'package:classdiary2/mobile/note_detail.dart';
import 'package:classdiary2/mobile/popupmenu_widget.dart';
import 'package:classdiary2/mobile/todo_widget.dart';
import 'package:classdiary2/mobile/search_bar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';


// ignore_for_file: prefer_const_constructors

class Note extends StatelessWidget {

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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false, /// back button 제거
        elevation: 0,
        title: Text('노트', style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          PopUpMenuWidget(),
        ],
      ),
      body: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            /// 이거 안해주면 obx 안됨.
            Text(DashboardController.to.isSearchSubmit.value.toString(), style: TextStyle(fontSize: 1, color: Colors.transparent),),
            SizedBox(height: 10,),
            SearchBarWidget(),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('note').where('email', isEqualTo: GetStorage().read('email')).orderBy('date', descending: true).snapshots(),
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
                  var results;
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent)));
                  }
                  if (DashboardController.to.isSearchSubmit.value == true) {
                    results = snapshot.data!.docs.where((doc) => doc['content'].contains(DashboardController.to.searchInput)).toList();
                  }else{
                    results = snapshot.data!.docs;
                  }

                  return ListView.separated(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: results.length,
                    itemBuilder: (_, index) {
                      DocumentSnapshot doc = results[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child:
                        InkWell(
                          onTap: () {
                            // NoteController.to.whereToGo.value = 'NoteDetail';
                            Get.to(() => NoteDetail(), arguments: 'update');
                            NoteController.to.id = doc.id;
                            NoteController.to.noteInput = doc['content'];
                          },
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 310,
                                      child: Text(doc['content'], overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(fontSize: 17),),
                                  ),
                                  Text(doc['date'].substring(2,4) + '.' + doc['date'].substring(5,7) + '.' + doc['date'].substring(8,10) + '(' +
                                      DateFormat.E('ko_KR').format(DateTime.parse(doc['date'])) + ')',
                                    style: TextStyle(fontSize: 12, color: Colors.grey,),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, index) {
                      return Divider(color: Colors.grey.withOpacity(0.7),);
                    },

                  );
                }
            ),
          ],
        ),
      ),
        bottomNavigationBar: BottomNaviBarWidget(),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 30,),
            FloatingActionButton(
              heroTag: "note",
              backgroundColor: Colors.green,
              onPressed: () {
                todoDialog(context);
              },
              child: const Text('할일'),
            ),
            Expanded(child: SizedBox()),
            FloatingActionButton(
              heroTag: "consult",
              backgroundColor: Colors.orange.withOpacity(0.7),
              onPressed: () {
                NoteController.to.noteInput = '';
                Get.to(() => NoteDetail(), arguments: 'add');
              },
              child: const Icon(Icons.add, color: Colors.white,),
            ),
          ],
        )
    );
  }

}



