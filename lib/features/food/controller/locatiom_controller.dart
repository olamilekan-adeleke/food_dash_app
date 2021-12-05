import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food_dash_app/cores/utils/snack_bar_service.dart';
import 'package:food_dash_app/features/food/UI/pages/select_location_page.dart';
import 'package:food_dash_app/features/food/model/location_details.dart';
import 'package:food_dash_app/features/food/repo/location_services.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class LocationController extends GetxController {
  final Rx<ControllerState> suggestionState = ControllerState.init.obs;

  final TextEditingController locationController =
      TextEditingController(text: '');
  final RxString queryString = ''.obs;
  final RxString suggestionErrorText = ''.obs;
  Rx<Suggestion>? selectedSuggestion;
  final RxList<Suggestion> suggestion = <Suggestion>[].obs;

  void goToLocationPage() => Get.to(() => SelectLocationScreen());

  Future<void> getSuggestion() async {
    log(queryString.value);

    if (queryString.value.isEmpty) return;

    try {
      suggestionState.value = ControllerState.busy;
      final sessionId = const Uuid().v4();

      final List<Suggestion> result =
          await PlaceApiService(sessionId).fetchSuggestions(queryString.value);

      suggestion.value = result;
      suggestionState.value = ControllerState.success;
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      CustomSnackBarService.showErrorSnackBar(e.toString());
      suggestionState.value = ControllerState.error;
      suggestionErrorText.value = e.toString();
    }
  }

  void selectLocation(Suggestion suggestion) {
    selectedSuggestion = Rx<Suggestion>(suggestion);
    locationController.text = '${suggestion.title} - ${suggestion.description}';
    Get.back();
  }

  @override
  void onReady() {
    debounce(queryString, (_) => getSuggestion(),
        time: const Duration(milliseconds: 700));
    super.onReady();
  }
}

enum ControllerState { busy, error, success, init }
