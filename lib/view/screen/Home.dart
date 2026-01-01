import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/HomeController.dart';
import '../../controller/SearchController1.dart';

import '../widget/HomeAppBar .dart';
import '../widget/HomeTabs.dart';
import '../widget/SearchResultsGrid.dart';

class Home extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  final SearchController1 searchController = Get.put(SearchController1());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      return DefaultTabController(
        length: controller.isOwner ? 3 : 2,
        child: Scaffold(
          floatingActionButton: controller.isOwner
              ? FloatingActionButton(
              onPressed: () => controller.addApartment(context).then((_){controller.loadData();}),
            child: const Icon(Icons.add_home_work, size: 35),
          )
              : null,

          appBar: HomeAppBar(
            controller: controller,
            searchController: searchController,
          ),

          body: Obx(() {
            final isSearching = searchController.isSearching.value;
            final hasQuery = searchController.searchText.text.isNotEmpty;

            if (isSearching && hasQuery) {
              return SearchResultsGrid(
                searchController: searchController,
                controller: controller,
              );
            }

            return HomeTabs(controller: controller);
          }),
        ),
      );
    });
  }
}