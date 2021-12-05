import 'package:flutter/material.dart';
import 'package:food_dash_app/cores/components/custom_textfiled.dart';
import 'package:food_dash_app/cores/constants/color.dart';
import 'package:food_dash_app/cores/utils/sizer_utils.dart';
import 'package:food_dash_app/features/food/controller/locatiom_controller.dart';
import 'package:food_dash_app/features/food/model/location_details.dart';
import 'package:get/get.dart';

class SelectLocationScreen extends StatelessWidget {
  const SelectLocationScreen({Key? key}) : super(key: key);

  static final LocationController locationController =
      Get.find<LocationController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Enter Location',
            style: TextStyle(color: kcTextColor),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: kcTextColor),
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.all(sizerSp(10)),
          child: ListView(
            children: [
              CustomTextField(
                textEditingController: locationController.locationController,
                hintText: 'Enter Location name',
                labelText: '',
                onChange: () {
                  locationController.queryString.value =
                      locationController.locationController.text;
                },
              ),
              SizedBox(height: sizerSp(20)),
              SizedBox(
                height: sizerHeight(90),
                child: Obx(() {
                  if (locationController.suggestionState.value ==
                      ControllerState.busy) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (locationController.suggestionState.value ==
                      ControllerState.error) {
                    return Center(
                      child: Text(
                        locationController.suggestionErrorText.value,
                        style: TextStyle(
                          color: kcTextColor,
                          fontSize: sizerSp(20),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  } else if (locationController.suggestion.isEmpty) {
                    return Center(
                      child: Text(
                        'No Location found!',
                        style: TextStyle(
                          color: kcTextColor,
                          fontSize: sizerSp(20),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: locationController.suggestion.length,
                    itemBuilder: (_, int index) {
                      final Suggestion suggestion =
                          locationController.suggestion[index];

                      return ListTile(
                        onTap: () =>
                            locationController.selectLocation(suggestion),
                        title: Text(suggestion.title),
                        subtitle: Text(suggestion.description),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
