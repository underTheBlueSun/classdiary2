import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import '../controller/subject_controller.dart';

class SubjectEdit extends StatelessWidget {

  void saveSubjectDialog(context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Container(
            width: 150,
            height: 170,
            // color: Color(0xFF5E5E5E),
            child: Material(
              color: Colors.transparent,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 170,
                      child: TextField(
                        controller: TextEditingController(text: SubjectController.to.subject.value),
                        onChanged: (value) {
                          SubjectController.to.subject.value = value;
                        },
                        style: TextStyle(fontFamily: 'Jua',  ),
                        maxLines: 10,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent, ),),
                        ),
                      ),
                    ),

                  ]
              ),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(isDefaultAction: true, child: Text('닫기'), onPressed: () {
              Navigator.pop(context);
            }),
            CupertinoDialogAction(isDefaultAction: true, child: Text('저장', ), onPressed: () async{
              await SubjectController.to.saveSubject();
              await SubjectController.to.getSubjects();
              SubjectController.to.dummy_date.value = DateTime.now().toString();
              Navigator.pop(context);
            }),

          ],
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => SingleChildScrollView(
      child: Column(
        children: [
          /// 더미
          Text(SubjectController.to.dummy_date.value, style: TextStyle(fontSize: 0),),
          Padding(
            padding: const EdgeInsets.all(8),
            child: AlignedGridView.count(
                shrinkWrap: true,
                primary: false,
                physics: NeverScrollableScrollPhysics(),
                /// 교실 작은 컴퓨터가 1920이라서 5로 하면 너무 사이가 벌어져서 내용이 삐져나옴
                crossAxisCount: MediaQuery.of(context).size.width > 1800 ? 7 :
                // crossAxisCount: MediaQuery.of(context).size.width > 2000 ? 7 :
                MediaQuery.of(context).size.width < 1000 ? 4: 5,
                crossAxisSpacing: 15,
                itemCount: SubjectController.to.subjects.length,
                itemBuilder: (_, index) {
                  var mmdd = SubjectController.to.subjects[index].mmdd;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        SubjectController.to.subject_id.value = SubjectController.to.subjects[index].id;
                        SubjectController.to.mmdd = SubjectController.to.subjects[index].mmdd;
                        SubjectController.to.subject.value = SubjectController.to.subjects[index].subject;
                        saveSubjectDialog(context);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 70,
                                height: 20,
                                decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))),
                                child: Text('  ' + mmdd.substring(0,2) + '.' + mmdd.substring(2,4), style: TextStyle(fontFamily: 'Jua', fontSize: 14, color: Colors.orangeAccent),),
                              ),

                            ],
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            decoration: BoxDecoration(color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8), topRight: Radius.circular(8))),
                            // decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(SubjectController.to.subjects[index].subject,  maxLines: 2,
                                overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'Jua', fontSize: 16, color: Colors.white),),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
            ),
          ),
          SizedBox(height: 100,),
        ],
      ),
    ),
    );

  }
}



