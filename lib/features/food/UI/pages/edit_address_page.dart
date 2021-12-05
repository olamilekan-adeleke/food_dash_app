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
import 'package:food_dash_app/features/food/repo/local_database_repo.dart';

class EditAddressScreen extends StatefulWidget {
  const EditAddressScreen({Key? key}) : super(key: key);

  static final TextEditingController address = TextEditingController(text: '');
  static final LocaldatabaseRepo localdatabaseRepo =
      locator<LocaldatabaseRepo>();
  static final ValueNotifier<String> selectedVal = ValueNotifier<String>('');

  @override
  _EditAddressScreenState createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  List<String> addresses = <String>[];
  @override
  void initState() {
    BlocProvider.of<AuthBloc>(context).add(GetAddressDataEvent());

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
                EditAddressScreen.address.text = userDetails!.address ?? '';
                return CustomTextField(
                  textEditingController: EditAddressScreen.address,
                  hintText: 'Enter Address',
                  labelText: 'Address',
                  maxLine: null,
                  textInputType: TextInputType.multiline,
                );
              },
            ),

            SizedBox(height: sizerSp(20.0)),
            CustomTextWidget(
              text: 'Select Region',
              fontWeight: FontWeight.bold,
              fontSize: sizerSp(15),
            ),
            SizedBox(height: sizerSp(10.0)),

            BlocConsumer<AuthBloc, AuthState>(
                listener: (BuildContext context, AuthState state) {
              if (state is GetAddressDataLoadedState) {
                addresses = state.address;
              } else if (state is GetAddressDataErrorState) {
                CustomSnackBarService.showErrorSnackBar(state.message);
              }
            }, builder: (BuildContext context, AuthState state) {
              if (state is GetAddressDataLoadingState) {
                return const CustomButton.loading();
              } else if (state is GetAddressDataErrorState) {
                return CustomErrorWidget(
                  message: state.message,
                  callback: () => BlocProvider.of<AuthBloc>(context)
                      .add(GetAddressDataEvent()),
                );
              }
              return ValueListenableBuilder<String>(
                valueListenable: EditAddressScreen.selectedVal,
                builder: (
                  BuildContext context,
                  String value,
                  Widget? child,
                ) {
                  // return SearchableDropdown<String>.single(
                  //   items: locationList
                  //       .map(
                  //         (String e) => DropdownMenuItem<String>(
                  //           child: CustomTextWidget(
                  //             text: e,
                  //             fontWeight: FontWeight.w200,
                  //             fontSize: sizerSp(13),
                  //           ),
                  //         ),
                  //       )
                  //       .toList(),
                  //   value: value,
                  //   hint: 'Select one',
                  //   searchHint: 'Select one',
                  //   onChanged: (String value) => selectedVal.value = value,
                  //   isExpanded: true,
                  // );

                  return DropdownSearch<String>(
                    mode: Mode.BOTTOM_SHEET,
                    showSelectedItem: true,
                    items: addresses,
                    // label: 'Menu mode',
                    hint: 'Select Region',
                    onChanged: (String? val) =>
                        EditAddressScreen.selectedVal.value = val ?? '',
                    selectedItem: value != '' ? value : null,
                  );
                },
              );
            }),

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
                    print(EditAddressScreen.selectedVal.value);

                    if (EditAddressScreen.selectedVal.value.isEmpty ||
                        EditAddressScreen.address.text.isEmpty) {
                      CustomSnackBarService.showWarningSnackBar(
                          'Enter Address and Select a Region');

                      return;
                    }
                    UserDetailsModel? userDetails = await EditAddressScreen
                        .localdatabaseRepo
                        .getUserDataFromLocalDB();

                    userDetails = userDetails!.copyWith(
                      address: EditAddressScreen.address.text.trim(),
                      region: EditAddressScreen.selectedVal.value,
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
