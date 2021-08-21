import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_dash_app/cores/components/custom_button.dart';
import 'package:food_dash_app/cores/components/custom_text_widget.dart';
import 'package:food_dash_app/cores/components/custom_textfiled.dart';
import 'package:food_dash_app/cores/utils/navigator_service.dart';
import 'package:food_dash_app/cores/utils/route_name.dart';
import 'package:food_dash_app/cores/utils/sizer_utils.dart';
import 'package:food_dash_app/cores/utils/snack_bar_service.dart';
import 'package:food_dash_app/features/food/bloc/merchant_bloc/merchant_bloc.dart';

class AuthenticateUserScreen extends StatelessWidget {
  const AuthenticateUserScreen(this.fee, {Key? key}) : super(key: key);
  static final TextEditingController textEditingController =
      TextEditingController(text: '');

  final int fee;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: sizerSp(10.0),
          vertical: sizerSp(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomTextWidget(
              text: 'Enter Your Password',
              fontSize: sizerSp(20),
              fontWeight: FontWeight.w700,
            ),
            CustomTextWidget(
              text: 'To confrim you are the one making this transaction we '
                  'require you to end the password for this account.',
              fontSize: sizerSp(12),
              fontWeight: FontWeight.w300,
            ),
            SizedBox(height: sizerSp(20)),
            CustomTextField(
              textEditingController: textEditingController,
              hintText: '12345678',
              labelText: '',
              textInputType: TextInputType.visiblePassword,
              isPassword: true,
            ),
            SizedBox(height: sizerSp(10)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: sizerSp(10.0),
                vertical: sizerSp(5.0),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(sizerSp(5.0)),
                color: Colors.red.shade100,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.info,
                    color: Colors.white,
                    size: sizerSp(10.0),
                  ),
                  SizedBox(width: sizerSp(5.0)),
                  Expanded(
                    child: CustomTextWidget(
                      text: 'Please do be aware that this amount will be '
                          'deducted from your wallet balance, and extra fee '
                          'may be taken for charges',
                      fontSize: sizerSp(11),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: sizerSp(100)),
            BlocConsumer<MerchantBloc, MerchantState>(
              listener: (BuildContext context, MerchantState state) {
                if (state is MakePaymentLoadedState) {
                  CustomNavigationService().goBack();
                  CustomNavigationService().navigateTo(
                    RouteName.orderStatus,
                    argument: state.id,
                  );
                }
              },
              builder: (BuildContext context, MerchantState state) {
                if (state is MakePaymentLoadingState) {
                  return const CustomButton.loading();
                }

                return CustomButton(
                  onTap: () {
                    final String password = textEditingController.text.trim();
                    if (password.isNotEmpty) {
                      BlocProvider.of<MerchantBloc>(context)
                          .add(MakePaymentEvent(password, fee));
                    } else {
                      CustomSnackBarService.showWarningSnackBar(
                        'Please Input Password',
                      );
                    }
                  },
                  text: 'Proceed',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
