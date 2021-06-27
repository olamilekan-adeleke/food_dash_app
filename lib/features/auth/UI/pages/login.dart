import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_dash_app/cores/components/custom_button.dart';
import 'package:food_dash_app/cores/components/custom_scaffold_widget.dart';
import 'package:food_dash_app/cores/components/custom_textfiled.dart';
import 'package:food_dash_app/cores/components/snack_bar_service.dart';
import 'package:food_dash_app/cores/utils/navigator_service.dart';

import 'package:food_dash_app/cores/utils/validator.dart';
import 'package:food_dash_app/features/auth/UI/pages/forgot_password_page.dart';
import 'package:food_dash_app/features/auth/UI/pages/sig_up_page.dart';
import 'package:food_dash_app/features/auth/bloc/auth_bloc/auth_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static final TextEditingController emailTextEditingController =
      TextEditingController();
  static final TextEditingController passwordTextEditingController =
      TextEditingController();
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                CustomTextField(
                  textEditingController: emailTextEditingController,
                  hintText: 'Enter email address',
                  labelText: 'Email',
                  validator: (String? text) =>
                      formFieldValidator(text, 'Email', 3),
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
                    if (state is AuthLoginLoadedState) {
                      SnackBarService.showSuccessSnackBar(state.message);
                    } else if (state is AuthLoginErrorState) {
                      SnackBarService.showErrorSnackBar(state.message);
                    }
                  },
                  builder: (BuildContext context, AuthState state) {
                    if (state is AuthLoginLoadingState) {
                      return const CustomButton.loading(busy: true);
                    }

                    return CustomButton(
                      text: 'Log In',
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          BlocProvider.of<AuthBloc>(context).add(
                            LoginUserEvent(
                              email: emailTextEditingController.text.trim(),
                              password:
                                  passwordTextEditingController.text.trim(),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 20.0),
                CustomButton(
                  text: 'Sign Up',
                  onTap: () => NavigationService()
                      .navigateReplaceDefault(context, const SignUpPage()),
                ),
                const SizedBox(height: 10.0),
                TextButton(
                  onPressed: () => NavigationService()
                      .navigateToDefault(context, const ForgotPasswordPage()),
                  child: const Text('Forgot Password!?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}