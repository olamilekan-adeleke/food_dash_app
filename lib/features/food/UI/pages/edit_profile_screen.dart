import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_dash_app/cores/components/custom_button.dart';
import 'package:food_dash_app/cores/components/custom_text_widget.dart';
import 'package:food_dash_app/cores/components/custom_textfiled.dart';
import 'package:food_dash_app/cores/utils/sizer_utils.dart';
import 'package:food_dash_app/cores/utils/snack_bar_service.dart';
import 'package:food_dash_app/cores/utils/validator.dart';
import 'package:food_dash_app/features/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:food_dash_app/features/auth/model/user_details_model.dart';
import 'package:food_dash_app/features/food/UI/widgets/header_widget.dart';
import 'package:food_dash_app/features/food/repo/local_database_repo.dart';

class EditprofileScreen extends StatelessWidget {
  const EditprofileScreen();

  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static final TextEditingController fullNameTextEditingController =
      TextEditingController();
  static final TextEditingController phoneTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: sizerSp(20.0)),
              const HeaderWidget(iconData: null, title: 'Edit Profile'),
              SizedBox(height: sizerSp(40.0)),
              CustomTextWidget(
                text: 'Enter Fullname and Phone number',
                fontWeight: FontWeight.bold,
                fontSize: sizerSp(15),
              ),
              CustomTextWidget(
                text: 'Your Fullname and Phone number will be updated!',
                fontWeight: FontWeight.w200,
                fontSize: sizerSp(14),
              ),
              SizedBox(height: sizerSp(10.0)),
              CustomTextField(
                textEditingController: fullNameTextEditingController,
                hintText: 'Enter fullname',
                labelText: 'FullName',
                validator: (String? text) =>
                    formFieldValidator(text, 'FullName', 3),
              ),
              const SizedBox(height: 20.0),
              CustomTextField(
                textEditingController: phoneTextEditingController,
                hintText: 'Enter Phone Number',
                labelText: '+23455667788',
                textInputType: TextInputType.number,
                validator: (String? text) =>
                    formFieldValidator(text, 'Phone Number', 10),
              ),
              const SizedBox(height: 80.0),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (BuildContext context, AuthState state) {
                  if (state is UpdateUserDataLoadedState) {
                    CustomSnackBarService.showSuccessSnackBar('Update Done!');
                  } else if (state is UpdateUserDataErrorState) {
                    CustomSnackBarService.showErrorSnackBar(state.message);
                  }
                },
                builder: (BuildContext context, AuthState state) {
                  if (state is UpdateUserDataLoadingState) {
                    return const CustomButton.loading();
                  }

                  return CustomButton(
                    text: 'Save Changes',
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        final UserDetailsModel? user =
                            LocaldatabaseRepo.userDetail.value;

                        if (user == null) return;

                        BlocProvider.of<AuthBloc>(context).add(
                          UpdateUserDataEvent(
                            user.copyWith(
                              phoneNumber: int.parse(
                                phoneTextEditingController.text.trim(),
                              ),
                              fullName:
                                  fullNameTextEditingController.text.trim(),
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
