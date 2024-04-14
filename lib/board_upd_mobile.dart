import '../controller/board_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'dart:js' as js;

import 'auction/auction_indi.dart';
import 'board_indi.dart';
import 'board_modum.dart';

class BoardUpdMoblie extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    /// index.html에서 테마색깔 지정, 폰 제일 위 색깔 마추기위해
    js.context.callMethod("setMetaThemeColor", ["#4C4C4C"]);
    return
      Scaffold(
        backgroundColor: Color(0xFF4C4C4C),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          backgroundColor: Color(0xFF4C4C4C),
          elevation: 0,
          title:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  Get.back();
                },
                child: Image.asset('assets/images/font_before.png', height: 32),
              ),
              Row(
                children: [
                  /// 사진
                  InkWell(
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      BoardController.to.selectImage();
                    },
                    child: Image.asset('assets/images/camera.png', height: 32),
                  ),
                  SizedBox(width: 20,),
                  /// 수정
                  InkWell(
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      if(Get.arguments['type'] == 'indi') {
                        BoardController.to.updBoardIndi(Get.arguments['indiDoc']);
                        if (BoardController.to.param_gubun == 'board') {
                          Get.off(() => BoardIndi(), arguments: {'title' : Get.arguments['title'], 'main_id' : Get.arguments['main_id'], 'background': Get.arguments['background'],
                            'content': Get.arguments['content'], 'id': Get.arguments['id'], 'gubun': Get.arguments['gubun']});
                        }else{
                          Get.off(() => AuctionIndi(), arguments: {'title' : Get.arguments['title'], 'main_id' : Get.arguments['main_id'], 'background': Get.arguments['background'],
                            'content': Get.arguments['content'], 'id': Get.arguments['id'], 'gubun': Get.arguments['gubun']});
                        }


                      }else {
                        BoardController.to.updBoardModum(Get.arguments['indiDoc']);
                        Get.off(() => BoardModum(), arguments: {'title' : Get.arguments['title'], 'main_id' : Get.arguments['main_id'], 'background': Get.arguments['background'],
                          'content': Get.arguments['content'], 'id': Get.arguments['id'], 'modums': Get.arguments['modums'], 'gubun': Get.arguments['gubun']});
                      }
                      BoardController.to.imageModel.value.imageInt8 == null;
                      // Get.back();
                    },
                    child: Image.asset('assets/images/font_upd.png', height: 32),
                  ),
                ],
              ),

              // SizedBox(
              //   height: 30,
              //   child: OutlinedButton(
              //     style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.white),),
              //     onPressed: () {
              //        BoardController.to.selectImage();
              //     }, // onPressed
              //     child: Text('사진', style: TextStyle(color: Colors.white, fontSize: 15),),
              //   ),
              // ),
              // SizedBox(width: 15,),
              // SizedBox(
              //   height: 30,
              //   child: OutlinedButton(
              //     style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.white),),
              //     onPressed: () {
              //       if(Get.arguments['type'] == 'indi') {
              //        BoardController.to.updBoardIndi(Get.arguments['indiDoc']);
              //        // Get.off(() => BoardIndi(), arguments: {'title' : Get.arguments['title'], 'main_id' : Get.arguments['main_id'], 'background': Get.arguments['background'],
              //        //   'content': Get.arguments['content'], 'id': Get.arguments['id']});
              //
              //     }else {
              //          BoardController.to.updBoardModum(Get.arguments['indiDoc']);
              //          // Get.off(() => BoardModum(), arguments: {'title' : Get.arguments['title'], 'main_id' : Get.arguments['main_id'], 'background': Get.arguments['background'],
              //          //   'content': Get.arguments['content'], 'id': Get.arguments['id'], 'modums': Get.arguments['modums']});
              //     }
              //       BoardController.to.imageModel.value.imageInt8 == null;
              //       Get.back();
              //     }, // onPressed
              //     child: Text('수정', style: TextStyle(color: Colors.white, fontSize: 15),),
              //   ),
              // ),
              // ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18, right: 18, top: 18),
                  child: SizedBox(
                    // width: 350,
                    height: 30,
                    child: TextField(
                      controller: TextEditingController(text: Get.arguments['indiDoc']['title']),
                      onChanged: (value) {
                        BoardController.to.indiTitleInput = value;
                      },
                      style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 17, ),
                      // minLines: 1,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: '제목을 입력하세요',
                        hintStyle: TextStyle(fontSize: 17, color: Colors.grey.withOpacity(0.5)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
                        // focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent, ),),
                        // enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
                        // contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18, right: 18),
                  child: Divider(color: Colors.grey.withOpacity(0.3),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18, right: 18, bottom: 10),
                  child: SizedBox(
                    // width: 350,
                    height: 250,
                    child: TextField(
                      // autofocus: true,  // 폰에서 안먹음
                      controller: TextEditingController(text: Get.arguments['indiDoc']['content']),
                      onChanged: (value) {
                        BoardController.to.indiContent = value;
                      },
                      style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 17, ),
                      minLines: 10,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: '내용을 입력하세요',
                        hintStyle: TextStyle(fontSize: 17, color: Colors.grey.withOpacity(0.5)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
                        // focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent, ),),
                        // enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
                      ),
                    ),
                  ),
                ),

                Obx(() => Column(
                    children: [
                      SizedBox(height: 5,),
                      Get.arguments['indiDoc']['imageUrl'].length == 0 && BoardController.to.imageModel.value.imageInt8 == null ?
                      SizedBox() :
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8, right: 15, left: 15),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: BoardController.to.imageModel.value.imageInt8 == null ?
                          ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(Get.arguments['indiDoc']['imageUrl'], fit: BoxFit.cover)) :
                          ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.memory(BoardController.to.imageModel.value.imageInt8!, fit: BoxFit.cover)),
                        ),
                      ),
                      Text(BoardController.to.dummy.value.toString(), style: TextStyle(fontSize: 0),),
                    ],
                  ),
                ),

                InkWell(
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    if(Get.arguments['type'] == 'indi') {
                      BoardController.to.delBoardIndi(Get.arguments['indiDoc']);
                      if (BoardController.to.param_gubun == 'board') {
                        Get.off(() => BoardIndi(), arguments: {'title' : Get.arguments['title'], 'main_id' : Get.arguments['main_id'], 'background': Get.arguments['background'],
                          'content': Get.arguments['content'], 'id': Get.arguments['id'], 'gubun': Get.arguments['gubun']});
                      }else {
                        Get.off(() => AuctionIndi(), arguments: {'title' : Get.arguments['title'], 'main_id' : Get.arguments['main_id'], 'background': Get.arguments['background'],
                          'content': Get.arguments['content'], 'id': Get.arguments['id'], 'gubun': Get.arguments['gubun']});
                      }

                    }else {
                      BoardController.to.delBoardModum(Get.arguments['indiDoc']);
                      Get.off(() => BoardModum(), arguments: {'title' : Get.arguments['title'], 'main_id' : Get.arguments['main_id'], 'background': Get.arguments['background'],
                        'content': Get.arguments['content'], 'id': Get.arguments['id'], 'modums': Get.arguments['modums'], 'gubun': Get.arguments['gubun']});
                    }
                    BoardController.to.imageModel.value.imageInt8 == null;
                    // Get.back();
                  },
                  child: Image.asset('assets/images/font_delete.png', height: 32),
                ),
                SizedBox(height: 50,),

                // SizedBox(
                //   width: 100,
                //   height: 30,
                //   child: OutlinedButton(
                //     style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.red),),
                //     onPressed: () {
                //       if(Get.arguments['type'] == 'indi') {
                //     BoardController.to.delBoardIndi(Get.arguments['indiDoc']);
                //   }else {
                //     BoardController.to.delBoardModum(Get.arguments['indiDoc']);
                //   }
                //   Get.back();
                //     }, // onPressed
                //     child: Text('삭제', style: TextStyle(color: Colors.red, fontSize: 13),),
                //   ),
                // ),

              ]
          ),
        ),
      );

  }
}


