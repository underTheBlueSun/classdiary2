
import 'package:classdiary2/controller/dashboard_controller.dart';
import 'package:classdiary2/controller/notice_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

import '../controller/signinup_controller.dart';


class NoticeDetail extends StatelessWidget {

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
                        NoticeController.to.delNotice();
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close_outlined, color: Colors.grey,),
                    ),
                    SizedBox(width: 10,),
                  ],
                ),
                Expanded(
                  child: Container(
                      child: Center(child: Text('정말 삭제하시겠습니까?'))),
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
                      NoticeController.to.delNotice();
                      Navigator.pop(context);
                      // NoticeController.to.whereToGo.value = 'Notice';
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
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  GetStorage().write('popup-id', NoticeController.to.doc?.id);
                  NoticeController.to.addCnt();
                  // NoticeController.to.addRead();
                  Navigator.pop(context);
                },
                child: Icon(Icons.close_outlined, color: Colors.grey,),
              ),

              GetStorage().read('email') == 'umssam00@gmail.com'
                  ? IconButton(
                onPressed: () {
                  delDialog(context);
                },
                icon: Icon(Icons.delete_outline, color: Colors.grey,),
              )
                  : SizedBox(),
            ],
          ),
          NoticeController.to.doc!['content'].length > 0 ?
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: TextField(
              controller: TextEditingController(text: NoticeController.to.doc!['content']),
              onChanged: (value) {
                NoticeController.to.noticeInput = value;
              },
              /// 라인수만큼
              maxLines: '\n'.allMatches(NoticeController.to.doc!['content']).length + 1,
              // maxLines: 35,
              style: TextStyle(fontSize: 15.0,),
              decoration: InputDecoration(
                hintText: "내용을 입력하세요",
                hintStyle: TextStyle(color: Colors.grey,
                  fontSize: 13.0,
                ),
                border: InputBorder.none,
              ),
            ),
          ) :
          SizedBox(),
          NoticeController.to.doc!['image_url1'].length > 0 ?
          Container(
            width: MediaQuery.of(context).size.width,
            /// 다크모드일때랑 아닐땐 다른 이미지
            child: SignInUpController.to.isDarkMode.value == false ?
            Image.network(NoticeController.to.doc!['image_url1']) :
            Image.network(NoticeController.to.doc!['image_url2']),
          ) :
          SizedBox(),
          //
          // NoticeController.to.doc!['image_url2'].length > 0 ?
          // Container(
          //   width: MediaQuery.of(context).size.width,
          //   child: Image.network(NoticeController.to.doc!['image_url2']),
          // ) :
          // SizedBox(),
          //
          // NoticeController.to.doc!['image_url3'].length > 0 ?
          // Container(
          //   width: MediaQuery.of(context).size.width,
          //   child: Image.network(NoticeController.to.doc!['image_url3']),
          // ) :
          // SizedBox(),
          //
          // NoticeController.to.doc!['image_url4'].length > 0 ?
          // Container(
          //   width: MediaQuery.of(context).size.width,
          //   child: Image.network(NoticeController.to.doc!['image_url4']),
          // ) :
          // SizedBox(),
          //
          // NoticeController.to.doc!['image_url5'].length > 0 ?
          // Container(
          //   width: MediaQuery.of(context).size.width,
          //   child: Image.network(NoticeController.to.doc!['image_url5']),
          // ) :
          // SizedBox(),
        ],
      ),
    );
  }
}


