import 'package:classdiary2/controller/dashboard_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore_for_file: prefer_const_constructors

class AnimListController extends GetxController {
  static AnimListController get to => Get.find();

  final GlobalKey<AnimatedListState> todoKey = GlobalKey();
  List items = [];

  @override
  void onInit() async {
    super.onInit();

  }

  void addItem(Map map) {
    var selectedYMD = map['date'].toDate();
    var cnt = items.where((item) => item['date'].toDate().compareTo(selectedYMD) < 0 ).length;
    items.insert(cnt, map);
    todoKey.currentState!.insertItem(0, duration: const Duration(milliseconds: 200));
  }

  void removeItem(int index) {
    todoKey.currentState!.removeItem(index, (_, animation) {
      return SizeTransition(
        sizeFactor: animation,
        child: SizedBox(
          height: 30, width: 50,
        ),
      );
    },

    duration: const Duration(milliseconds: 200));
    items.removeAt(index);
  }
}