import 'package:classdiary2/controller/checklist_controller.dart';
import 'package:classdiary2/controller/dashboard_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import 'tablecalendar_widget.dart';

// ignore_for_file: prefer_const_constructors

class ChecklistFolder extends StatelessWidget {

  void updTitleDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Container(
            height: 150.0,
            child: Column(
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
                Text('제목 수정'),
                Container(
                  width: 300,
                  child: TextField(
                    autofocus: true,
                    controller: TextEditingController(text: ChecklistController.to.folderTitle.value),
                    onChanged: (value) {
                      ChecklistController.to.folderTitle.value = value;
                    },
                    onSubmitted: (value) {
                      if (value != '') {
                        ChecklistController.to.updFolderTitle();
                        Navigator.pop(context);
                      }
                    },
                    // style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 20.0, fontWeight: FontWeight.bold,),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),

              ],
            ),
          ),
          // actions: <Widget>[
          //   Container(
          //     margin: EdgeInsets.all(20.0),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.end,
          //       children: [
          //         OutlinedButton(
          //           onPressed: () {
          //             if (ChecklistController.to.title.value != '') {
          //               ChecklistController.to.updTitle('폴더');  //  폴더와 파일은 폴더아이디는 없다 (폴더파일만 폴더아이디를 가진다)
          //               Navigator.pop(context);
          //             }
          //           }, // onPressed
          //           style: OutlinedButton.styleFrom(side: BorderSide(width: 1, color: Colors.black.withOpacity(0.6)),),
          //           child: Text('수정', style: TextStyle(color: Colors.black),),
          //         ),
          //       ],
          //     ),
          //   ),
          // ],
        );
      },
    );
  }

  void delDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Container(
            height: 100,
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
                  ],
                ),
                Expanded(
                  child: Container(
                      child: Center(child: Text('폴더내의 모든 체크리스트가 삭제됩니다. \n정말 삭제하시겠습니까?'))),
                ),
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
                      ChecklistController.to.delChecklist('폴더');
                      Navigator.pop(context);
                    }, // onPressed
                    style: OutlinedButton.styleFrom(side: BorderSide(width: 1, color: Colors.black.withOpacity(0.6)),),
                    child: Text('삭제', style: TextStyle(color: Colors.black),),
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
    return Column(
      children: [
        Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  ChecklistController.to.whereToGo.value = 'Checklist';
                  DashboardController.to.isSearchSubmit.value = false;
                  DashboardController.to.isSearchFolded.value = true;
                },
                icon: Icon(Icons.arrow_circle_left_outlined, color: Colors.grey,),
              ),
              InkWell(
                onTap: () {
                  updTitleDialog(context);
                },
                child: Container(
                  width: 200,
                  child: Center(child: Text(ChecklistController.to.folderTitle.value, style: TextStyle(), overflow: TextOverflow.ellipsis,)),
                ),
              ),
              IconButton(
                onPressed: () {
                  // ChecklistController.to.delChecklist('폴더');
                  delDialog(context);
                },
                icon: Icon(Icons.delete_outline, color: Colors.grey,),
              ),
            ],
          ),
        ),
        SizedBox(height: 20,),
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('checklist').where('email', isEqualTo: GetStorage().read('email')).where('folderID', isEqualTo: ChecklistController.to.folderid)
                .orderBy('date', descending: true).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.withOpacity(0.5))));
              }
              return Column(
                children: [

                  Container(
                    height: 500,
                    child: ListView.separated(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (_, index) {
                        DocumentSnapshot doc = snapshot.data!.docs[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child:
                          Row(
                            children: [
                              Icon(Icons.insert_drive_file_outlined, ),
                              SizedBox(width: 10,),
                              InkWell(
                                onTap: () {
                                  ChecklistController.to.whereToGo.value = 'ChecklistDetail';
                                  ChecklistController.to.whoCall = 'ChecklistFolder';
                                  ChecklistController.to.id = doc.id;
                                  ChecklistController.to.title.value = doc['title'];
                                  ChecklistController.to.selectedDate.value = doc['date'];
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 210,
                                      child: Text(doc['title'],
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(doc['date'].substring(2,4) + '.' +
                                        doc['date'].substring(5,7) + '.' +
                                        doc['date'].substring(8,10) + '(' +
                                        DateFormat.E('ko_KR').format(DateTime.parse(doc['date'])) + ')',
                                      style: TextStyle(fontSize: 12, color: Colors.grey,),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(child: SizedBox(),),
                              Text(doc['numArray'].length.toString(), style: TextStyle(fontSize: 20, color: Colors.orange.withOpacity(0.7)),),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (_, index) {
                        return Divider(color: Colors.grey.withOpacity(0.7),);
                      },

                    ),
                  ),
                ],
              );
            }
        ),
      ],
    );
  }

}



