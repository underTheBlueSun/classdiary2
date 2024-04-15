import 'package:classdiary2/controller/checklist_controller.dart';
import 'package:classdiary2/controller/dashboard_controller.dart';
import 'package:classdiary2/mobile/checklist_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../controller/signinup_controller.dart';


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
                SizedBox(height: 20,),
                Text('저장은 엔터키', style: TextStyle(fontSize: 11, color: Colors.grey),),
              ],
            ),
          ),
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
                      child: Center(child: Text('폴더내의 모든 체크리스트가 \n삭제됩니다. \n정말 삭제하시겠습니까?'))),
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
                  SizedBox(
                    height: 28,
                    child: OutlinedButton(
                      onPressed: () {
                        ChecklistController.to.delChecklist('폴더');
                        // Navigator.pop(context);
                      }, // onPressed
                      child: Text('삭제', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void checkDialog(BuildContext context, gubun) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Container(
            height: 80.0,
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
                Container(
                  width: 300,
                  child: TextField(
                    autofocus: true,
                    onChanged: (value) {
                      ChecklistController.to.title.value = value;
                    },
                    onSubmitted: (value) {
                      if (value != '') {
                        ChecklistController.to.saveFolerFile(gubun);
                        Navigator.pop(context);
                      }
                    },
                    // style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 20.0, fontWeight: FontWeight.bold,),
                    decoration: InputDecoration(
                      hintText:
                      gubun == '폴더' ?
                      '폴더명을 입력하세요' :
                      '제목을 입력하세요',
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey, ),
                      border: InputBorder.none,
                    ),
                  ),
                ),

              ],
            ),
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      if (ChecklistController.to.title != '') {
                        ChecklistController.to.saveFolerFile(gubun);  //  폴더와 파일은 폴더아이디는 없다 (폴더파일만 폴더아이디를 가진다)
                        Navigator.pop(context);
                      }
                    }, // onPressed
                    child: Text('저장', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ?  Colors.white : Colors.black),),
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true, /// back button
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey,),
        title: InkWell(
          onTap: () {
            updTitleDialog(context);
          },
          child: Container(
            width: 200,
            child: Obx(() => Center(child: Text(ChecklistController.to.folderTitle.value,  overflow: TextOverflow.ellipsis,),)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      // ChecklistController.to.delChecklist('폴더');
                      delDialog(context);
                    },
                    icon: Icon(Icons.delete_outline, color: Colors.grey,),
                  ),
                ],
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

                        ListView.separated(
                          scrollDirection: Axis.vertical,
                          primary: false,
                          shrinkWrap: true,
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
                                      // ChecklistController.to.whereToGo.value = 'ChecklistDetail';
                                      Get.to(() => ChecklistDetail());
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
                      ],
                    );
                  }
              ),
            ],
          ),
        ),
      ),

        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "btn4",
              backgroundColor: Colors.orange.withOpacity(0.7),
              onPressed: () {
                checkDialog(context, '폴더파일');
              },
              child: const Icon(Icons.add, color: Colors.white,),
            ),
          ],
        ),

    );

  }

}



