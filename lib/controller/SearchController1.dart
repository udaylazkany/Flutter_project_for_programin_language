import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../core/components/crud.dart';
import '../core/constant/linkapi.dart';

class SearchController1 extends GetxController {
  RxBool isSearching = false.obs;
  RxString searchType = "city".obs;
  TextEditingController searchText = TextEditingController();

  final Crud crud = Crud();

  RxBool isLoading = false.obs;
  RxList results = [].obs;
  RxBool noResults = false.obs;

  Timer? _debounce;

  void toggleSearch() {
    isSearching.value = !isSearching.value;

    if (isSearching.value) {
      results.clear();
      noResults.value = false;
    } else {
      searchText.clear();
      results.clear();
      noResults.value = false;
    }
  }

  void setSearchType(String type) {
    searchType.value = type;
  }

  void onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 600), () {
      performSearch();
    });
  }

  Future<void> performSearch() async {
    final query = searchText.text.trim();

    if (query.isEmpty) {
      results.clear();
      noResults.value = false;
      return;
    }

    Map<String, dynamic> params = {};

    switch (searchType.value) {
      case "city":
        params["city"] = query;
        break;
      case "street":
        params["streetName"] = query;
        break;
      case "price":
        params["price"] = int.tryParse(query) ?? 0;
        break;
      case "space":
        params["space"] = int.tryParse(query) ?? 0;
        break;
    }

    isLoading.value = true;

    var response = await crud.postRequest(linkefilter, params);

    if (response["status"] == true) {
      results.value = response["data"];
      noResults.value = results.isEmpty;
    } else {
      results.clear();
      noResults.value = true;
    }

    isLoading.value = false;
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}