import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/SearchController1.dart';


class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final HomeController controller;
  final SearchController1 searchController;

  const HomeAppBar({
    required this.controller,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Obx(() {
        if (!searchController.isSearching.value) {
          return Text("13".tr);
        }

        return Row(
          children: [
            IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: searchController.toggleSearch,
            ),


            Expanded(
              child: TextField(
                controller: searchController.searchText,
                decoration: InputDecoration(
                  hintText: "28".tr,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: searchController.onSearchChanged,
              ),
            ),

            SizedBox(width: 8),

            PopupMenuButton<String>(
              icon: Icon(Icons.filter_list, color: Colors.grey),
              onSelected: searchController.setSearchType,
              itemBuilder: (context) =>  [
                PopupMenuItem(value: "city", child: Text("29".tr)),
                PopupMenuItem(value: "street", child: Text("30".tr)),
                PopupMenuItem(value: "price", child: Text("31".tr)),
                PopupMenuItem(value: "space", child: Text("32".tr)),
              ],
            ),
          ],
        );
      }),

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Obx(() {
          if (searchController.isSearching.value) {
            return SizedBox(height: 0);
          }

          return TabBar(
            tabs: controller.isOwner
                ?  [
              Tab(text: "33".tr),
              Tab(text: "34".tr),
              Tab(text: "35".tr),
            ]
                :  [
              Tab(text: "33".tr),
              Tab(text: "34".tr),
            ],
          );
        }),
      ),

      actions: [
        Obx(() {
          if (searchController.isSearching.value) {
            return SizedBox();
          }

          return Row(children: [IconButton(onPressed: (){controller.goToConversations(int.parse(controller.userId??"0"));}, icon: Icon(Icons.message)),IconButton(
          icon: Icon(Icons.search),
          onPressed: searchController.toggleSearch,
          )],);
        }),

        PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == "lang") controller.toggleLanguage();
            if (value == "theme") controller.toggleTheme();
            if (value == "logout") await controller.logout(context);
          },
          itemBuilder: (context) =>  [
            PopupMenuItem(value: "lang", child: Text("17".tr)),
            PopupMenuItem(value: "theme", child: Text("19".tr)),
            PopupMenuItem(value: "logout", child: Text("18".tr)),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}