import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_dash_app/cores/components/custom_button.dart';
import 'package:food_dash_app/cores/components/custom_scaffold_widget.dart';
import 'package:food_dash_app/cores/components/custom_text_widget.dart';
import 'package:food_dash_app/cores/components/custom_textfiled.dart';
import 'package:food_dash_app/cores/utils/locator.dart';
import 'package:food_dash_app/cores/utils/navigator_service.dart';
import 'package:food_dash_app/cores/utils/sizer_utils.dart';
import 'package:food_dash_app/cores/utils/snack_bar_service.dart';
import 'package:food_dash_app/features/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:food_dash_app/features/auth/model/user_details_model.dart';
import 'package:food_dash_app/features/food/UI/widgets/header_widget.dart';
import 'package:food_dash_app/features/food/repo/local_database_repo.dart';

class EditAddressScreen extends StatelessWidget {
  const EditAddressScreen({Key? key}) : super(key: key);

  static final TextEditingController address = TextEditingController(text: '');
  static final LocaldatabaseRepo localdatabaseRepo =
      locator<LocaldatabaseRepo>();

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
                address.text = userDetails!.address ?? '';
                return CustomTextField(
                  textEditingController: address,
                  hintText: 'Enter Address',
                  labelText: 'Address',
                  maxLine: null,
                  textInputType: TextInputType.multiline,
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
                  text: 'Edit',
                  onTap: () async {
                    final UserDetailsModel? userDetails =
                        await localdatabaseRepo.getUserDataFromLocalDB();

                    userDetails!.address = address.text.trim();

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
