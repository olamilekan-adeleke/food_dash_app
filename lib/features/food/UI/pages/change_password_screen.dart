import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_dash_app/cores/components/custom_button.dart';
import 'package:food_dash_app/cores/components/custom_text_widget.dart';
import 'package:food_dash_app/cores/components/custom_textfiled.dart';
import 'package:food_dash_app/cores/utils/sizer_utils.dart';
import 'package:food_dash_app/cores/utils/snack_bar_service.dart';
import 'package:food_dash_app/cores/utils/validator.dart';
import 'package:food_dash_app/features/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:food_dash_app/features/food/UI/widgets/header_widget.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static final TextEditingController emailTextEditingController =
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
              const HeaderWidget(iconData: null, title: 'Change Password'),
              SizedBox(height: sizerSp(40.0)),
              CustomTextWidget(
                text: 'Enter You Email Address Below',
                fontWeight: FontWeight.bold,
                fontSize: sizerSp(15),
              ),
              CustomTextWidget(
                text: 'Your email adddress will be sent a link, Please open'
                    ' the email to change your password',
                fontWeight: FontWeight.w200,
                fontSize: sizerSp(14),
              ),
              SizedBox(height: sizerSp(10.0)),
              CustomTextField(
                textEditingController: emailTextEditingController,
                hintText: 'Enter email address',
                labelText: 'Email',
                validator: (String? text) =>
                    formFieldValidator(text, 'Email', 3),
              ),
              const SizedBox(height: 80.0),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (BuildContext context, AuthState state) {
                  if (state is AuthForgotPasswordLoadedState) {
                    CustomSnackBarService.showSuccessSnackBar(state.message);
                  } else if (state is AuthForgotPasswordErrorState) {
                    CustomSnackBarService.showErrorSnackBar(state.message);
                  }
                },
                builder: (BuildContext context, AuthState state) {
                  if (state is AuthForgotPasswordLoadingState) {
                    return const CustomButton.loading();
                  }

                  return CustomButton(
                    text: 'Save',
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        BlocProvider.of<AuthBloc>(context).add(
                          ForgotPasswordEvent(
                              emailTextEditingController.text.trim()),
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
