import 'package:classdiary2/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    return Obx(() => AnimatedContainer(
        duration: Duration(microseconds: 1000),
        width: DashboardController.to.isSearchFolded.value ? 35 : 250,
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: DashboardController.to.isSearchFolded.value == true ? Colors.transparent : Colors.white,
          boxShadow: DashboardController.to.isSearchFolded.value == true ? null : kElevationToShadow[1],
        ),
        child: Row(children: [
          Expanded(
            child: Container(
              height: 30,
              padding: EdgeInsets.only(left: 16),
              child: !DashboardController.to.isSearchFolded.value
                ? TextField(
                    onSubmitted: (value) {
                      DashboardController.to.isSearchSubmit.value = true;
                      DashboardController.to.searchInput = value;

                    },
                    controller: searchController,
                    style: TextStyle(fontSize: 13, color: Colors.black),
                    autofocus: true,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: '검색어 입력',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                      border: InputBorder.none,
                    ),
              )
              : null,
            ),
          ),
          AnimatedContainer(
            duration: Duration(microseconds: 1000),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () {
                  DashboardController.to.isSearchFolded.value = !DashboardController.to.isSearchFolded.value;
                  searchController.clear();
                  DashboardController.to.isSearchSubmit.value = false;
                },
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(DashboardController.to.isSearchFolded.value ? 32 : 0),
                  topRight: Radius.circular(32),
                  bottomLeft: Radius.circular(DashboardController.to.isSearchFolded.value ? 32 : 0),
                  bottomRight: Radius.circular(32),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    DashboardController.to.isSearchFolded.value ? Icons.search : Icons.close,
                    color: Colors.orange.withOpacity(0.7),
                  ),
                ),
              ),
            ),
          )
        ],
        ),
      ),
    );
  }
}