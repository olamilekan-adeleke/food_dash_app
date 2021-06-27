import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_dash_app/cores/components/custom_button.dart';
import 'package:food_dash_app/cores/components/custom_scaffold_widget.dart';
import 'package:food_dash_app/cores/components/custom_textfiled.dart';
import 'package:food_dash_app/cores/components/snack_bar_service.dart';
import 'package:food_dash_app/cores/utils/navigator_service.dart';
import 'package:food_dash_app/cores/utils/validator.dart';
import 'package:food_dash_app/features/auth/bloc/auth_bloc/auth_bloc.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  static final TextEditingController emailTextEditingController =
      TextEditingController();
  static final TextEditingController passwordTextEditingController =
      TextEditingController();
  static final TextEditingController firstNameTextEditingController =
      TextEditingController();
  static final TextEditingController lastNameTextEditingController =
      TextEditingController();
  static final TextEditingController numberTextEditingController =
      TextEditingController();
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      emailTextEditingController.text = 'ola100@gmail.com';
      passwordTextEditingController.text = '123456';
      firstNameTextEditingController.text = 'ola';
      lastNameTextEditingController.text = 'kod';
      numberTextEditingController.text = '09088776655';
    }
    return CustomScaffoldWidget(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 250.0,
                  child: Placeholder(),
                ),
                const SizedBox(height: 50.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: CustomTextField(
                        textEditingController: firstNameTextEditingController,
                        hintText: 'Enter first name',
                        labelText: 'First Name',
                        validator: (String? text) =>
                            formFieldValidator(text, 'First Name', 2),
                      ),
                    ),
                    const SizedBox(width: 5.0),
                    Expanded(
                      child: CustomTextField(
                        textEditingController: lastNameTextEditingController,
                        hintText: 'Enter last name',
                        labelText: 'Last Name',
                        validator: (String? text) =>
                            formFieldValidator(text, 'Last Name', 2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                CustomTextField(
                  textEditingController: emailTextEditingController,
                  hintText: 'Enter email address',
                  labelText: 'Email',
                  validator: (String? text) =>
                      formFieldValidator(text, 'Email', 3),
                ),
                const SizedBox(height: 20.0),
                CustomTextField(
                  textEditingController: numberTextEditingController,
                  hintText: 'Enter Phone Number',
                  labelText: 'Phone Number',
                  validator: (String? text) =>
                      formFieldValidator(text, 'Phone Number', 10),
                ),
                const SizedBox(height: 20.0),
                CustomTextField(
                  textEditingController: passwordTextEditingController,
                  hintText: 'Enter Password',
                  labelText: 'Pasword',
                  isPassword: true,
                  validator: (String? text) =>
                      formFieldValidator(text, 'Password', 5),
                ),
                const SizedBox(height: 80.0),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (BuildContext context, AuthState state) {
                    if (state is AuthSignUpLoadedState) {
                      SnackBarService.showSuccessSnackBar(state.message);
                      NavigationService().goBackDefault(context);
                    } else if (state is AuthSignUpErrorState) {
                      SnackBarService.showErrorSnackBar(state.message);
                    }
                  },
                  builder: (BuildContext context, AuthState state) {
                    if (state is AuthSignUpLoadingState) {
                      return const CustomButton.loading();
                    }

                    return CustomButton(
                      text: 'Sign Up',
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          final String fullName =
                              '${firstNameTextEditingController.text.trim()}'
                              ' ${lastNameTextEditingController.text.trim()}';
                          BlocProvider.of<AuthBloc>(context).add(
                            SignUpUserEvent(
                              email: emailTextEditingController.text.trim(),
                              password:
                                  passwordTextEditingController.text.trim(),
                              fullName: fullName,
                              number: int.parse(
                                  numberTextEditingController.text.trim()),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 20.0),
                CustomButton(
                  color: Colors.grey[300],
                  text: 'Log In',
                  onTap: () => NavigationService().goBackDefault(context),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
