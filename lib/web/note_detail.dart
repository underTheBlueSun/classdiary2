
import 'package:classdiary2/controller/consult_controller.dart';
import 'package:classdiary2/controller/dashboard_controller.dart';
import 'package:classdiary2/controller/note_controller.dart';
import 'package:flutter/material.dart';

import '../controller/signinup_controller.dart';


class NoteDetail extends StatelessWidget {

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
                      NoteController.to.delNote();
                      Navigator.pop(context);
                      NoteController.to.whereToGo.value = 'Note';
                    }, // onPressed
                    style: OutlinedButton.styleFrom(side: BorderSide(width: 1, color: Colors.black.withOpacity(0.6)),),
                    child: Text('삭제', style: TextStyle(color: SignInUpController.to.isDarkMode.value == true ? Colors.grey : Colors.white,),),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                NoteController.to.whereToGo.value = 'Note';
                DashboardController.to.isSearchSubmit.value = false;
                DashboardController.to.isSearchFolded.value = true;
              },
              icon: Icon(Icons.arrow_circle_left_outlined, color: Colors.grey,),
            ),
            IconButton(
              onPressed: () {
                delDialog(context);
              },
              icon: Icon(Icons.delete_outline, color: Colors.grey,),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: TextField(
            // controller: TextEditingController(text: NoteController.to.noteInput_before),
            controller: TextEditingController(text: NoteController.to.noteInput),
            onChanged: (value) {
              NoteController.to.noteInput = value;
            },
            minLines: 35, /// 배포시 만약 6으로 하면 6번째 라인에서 한글이 깨짐
            maxLines: 35,
            // maxLines: null,
            decoration: InputDecoration(
              hintText: "내용을 입력하세요",
              hintStyle: TextStyle(color: Colors.grey, fontSize: 13.0,  ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}


