import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_dash_app/cores/components/custom_button.dart';
import 'package:food_dash_app/cores/components/custom_scaffold_widget.dart';
import 'package:food_dash_app/cores/components/custom_text_widget.dart';
import 'package:food_dash_app/cores/components/custom_textfiled.dart';
import 'package:food_dash_app/cores/components/error_widget.dart';
import 'package:food_dash_app/cores/utils/locator.dart';
import 'package:food_dash_app/cores/utils/navigator_service.dart';
import 'package:food_dash_app/cores/utils/sizer_utils.dart';
import 'package:food_dash_app/cores/utils/snack_bar_service.dart';
import 'package:food_dash_app/features/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:food_dash_app/features/auth/model/user_details_model.dart';
import 'package:food_dash_app/features/food/UI/widgets/header_widget.dart';
import 'package:food_dash_app/features/food/controller/locatiom_controller.dart';
import 'package:food_dash_app/features/food/model/location_details.dart';
import 'package:food_dash_app/features/food/repo/local_database_repo.dart';
import 'package:get/get.dart';

class EditAddressScreen extends StatefulWidget {
  const EditAddressScreen({Key? key}) : super(key: key);

  static final TextEditingController address = TextEditingController(text: '');
  static final TextEditingController phone = TextEditingController(text: '');
  static final TextEditingController location = TextEditingController(text: '');

  static final LocaldatabaseRepo localdatabaseRepo =
      locator<LocaldatabaseRepo>();

  @override
  _EditAddressScreenState createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  List<String> addresses = <String>[];
  final LocationController locationController = Get.find<LocationController>();

  @override
  void initState() {
    // BlocProvider.of<AuthBloc>(context).add(GetAddressDataEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: sizerSp(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: sizerSp(20.0)),
            const HeaderWidget(iconData: null, title: 'Edit Address'),
            SizedBox(height: sizerSp(40.0)),
            CustomTextWidget(
              text: 'Enter You Address Below.',
              fontWeight: FontWeight.bold,
              fontSize: sizerSp(15),
            ),
            CustomTextWidget(
              text: 'Your adddress will be updated after doing so!',
              fontWeight: FontWeight.w200,
              fontSize: sizerSp(14),
            ),
            SizedBox(height: sizerSp(10.0)),

            //
            ValueListenableBuilder<UserDetailsModel?>(
              valueListenable: LocaldatabaseRepo.userDetail,
              builder: (
                BuildContext context,
                UserDetailsModel? userDetails,
                Widget? child,
              ) {
                EditAddressScreen.address.text = userDetails?.address ?? '';
                EditAddressScreen.phone.text =
                    '${userDetails?.phoneNumber ?? ''}';
                locationController.locationController.text =
                    userDetails?.location?.description ?? '';

                if (userDetails?.location != null) {
                  locationController.selectedSuggestion =
                      Rx<Suggestion>(userDetails!.location!);
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: sizerSp(20.0)),
                    CustomTextWidget(
                      text: 'Select Location',
                      fontWeight: FontWeight.bold,
                      fontSize: sizerSp(15),
                    ),
                    SizedBox(height: sizerSp(10.0)),
                    CustomTextField(
                      textEditingController:
                          locationController.locationController,
                      hintText: 'Tap to select location',
                      labelText: 'Location',
                      enable: false,
                      maxLine: null,
                      onTap: () {
                        locationController.goToLocationPage();
                      },
                    ),
                    SizedBox(height: sizerSp(20.0)),
                    CustomTextWidget(
                      text: 'Enter addres in details',
                      fontWeight: FontWeight.bold,
                      fontSize: sizerSp(15),
                    ),
                    SizedBox(height: sizerSp(10.0)),
                    CustomTextField(
                      textEditingController: EditAddressScreen.address,
                      hintText: 'Enter Address',
                      labelText: 'Address',
                      maxLine: null,
                      textInputType: TextInputType.multiline,
                    ),
                    SizedBox(height: sizerSp(20.0)),
                    CustomTextWidget(
                      text: 'Phone number',
                      fontWeight: FontWeight.bold,
                      fontSize: sizerSp(15),
                    ),
                    SizedBox(height: sizerSp(10.0)),
                    CustomTextField(
                      textEditingController: EditAddressScreen.phone,
                      hintText: 'Enter Phone number',
                      labelText: 'Phone number',
                      textInputType: TextInputType.number,
                    ),
                  ],
                );
              },
            ),

            const Spacer(),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (BuildContext context, AuthState state) {
                if (state is UpdateUserDataLoadedState) {
                  CustomSnackBarService.showSuccessSnackBar('Address Updated!');
                  CustomNavigationService().goBack();
                } else if (state is UpdateUserDataErrorState) {
                  CustomSnackBarService.showErrorSnackBar(state.message);
                }
              },
              builder: (BuildContext context, AuthState state) {
                if (state is UpdateUserDataLoadingState) {
                  return const CustomButton.loading();
                }

                return CustomButton(
                  text: 'Save',
                  onTap: () async {
                    if (EditAddressScreen.address.text.isEmpty) {
                      CustomSnackBarService.showWarningSnackBar(
                        'Enter Address',
                      );

                      return;
                    }
                    if (EditAddressScreen.phone.text.isEmpty) {
                      CustomSnackBarService.showWarningSnackBar(
                        'Enter a phone number',
                      );

                      return;
                    }
                    if (locationController.selectedSuggestion?.value == null &&
                        locationController.locationController.text.isEmpty) {
                      CustomSnackBarService.showWarningSnackBar(
                        'Enter location',
                      );

                      return;
                    }

                    UserDetailsModel? userDetails = await EditAddressScreen
                        .localdatabaseRepo
                        .getUserDataFromLocalDB();

                    userDetails = userDetails!.copyWith(
                      address: EditAddressScreen.address.text.trim(),
                      phoneNumber:
                          int.parse(EditAddressScreen.phone.text.trim()),
                      region:
                          locationController.selectedSuggestion?.value.title,
                      location: locationController.selectedSuggestion!.value,
                    );

                    BlocProvider.of<AuthBloc>(context)
                        .add(UpdateUserDataEvent(userDetails));
                  },
                );
              },
            ),
            SizedBox(height: sizerSp(40.0)),
          ],
        ),
      ),
    );
  }
}
