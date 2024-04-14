import 'package:classdiary2/controller/dashboard_controller.dart';
import 'package:classdiary2/controller/esti_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../controller/signinup_controller.dart';


// ignore_for_file: prefer_const_constructors

class EstimateFolder extends StatelessWidget {

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
                    controller: TextEditingController(text: EstiController.to.folderTitle.value),
                    onChanged: (value) {
                      EstiController.to.folderTitle.value = value;
                    },
                    onSubmitted: (value) {
                      if (value != '') {
                        EstiController.to.updFolderTitle();
                        Navigator.pop(context);
                      }
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),

              ],
            ),
          ),
          // actions:
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
                      child: Center(child: Text('폴더내의 모든 평가가 삭제됩니다. \n정말 삭제하시겠습니까?'))),
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
                      EstiController.to.delEstimate('폴더');
                      Navigator.pop(context);
                    }, // onPressed
                    child: Text('삭제', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black
                    ),),
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
                  EstiController.to.whereToGo.value = 'Estimate';
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
                  child: Center(child: Text(EstiController.to.folderTitle.value, style: TextStyle(), overflow: TextOverflow.ellipsis,)),
                ),
              ),
              IconButton(
                onPressed: () {
                  // EstiController.to.delEstimate('폴더');
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
                .collection('estimate').where('email', isEqualTo: GetStorage().read('email')).where('folderID', isEqualTo: EstiController.to.folderid)
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
                              doc['gubun'] == '폴더' ?
                              Icon(Icons.folder, color: Colors.teal.withOpacity(0.7),) :
                              Icon(Icons.insert_drive_file_outlined, ),
                              SizedBox(width: 10,),
                              InkWell(
                                onTap: () {
                                  EstiController.to.whereToGo.value = 'EstimateDetail';
                                  EstiController.to.whoCall = 'EstimateFolder';
                                  EstiController.to.id = doc.id;
                                  EstiController.to.title.value = doc['title'];
                                  EstiController.to.selectedDate.value = doc['date'];
                                  // checkDialog(context, doc.id);
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



