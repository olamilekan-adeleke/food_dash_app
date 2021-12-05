import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_dash_app/cores/components/custom_button.dart';
import 'package:food_dash_app/cores/components/custom_text_widget.dart';
import 'package:food_dash_app/cores/components/custom_textfiled.dart';
import 'package:food_dash_app/cores/components/loading_indicator.dart';
import 'package:food_dash_app/cores/utils/buttom_modal.dart';
import 'package:food_dash_app/cores/utils/navigator_service.dart';
import 'package:food_dash_app/cores/utils/route_name.dart';
import 'package:food_dash_app/cores/utils/sizer_utils.dart';
import 'package:food_dash_app/cores/utils/snack_bar_service.dart';
import 'package:food_dash_app/features/food/UI/pages/wallet_page.dart';
import 'package:food_dash_app/features/food/bloc/merchant_bloc/merchant_bloc.dart';
import 'package:food_dash_app/features/food/repo/local_database_repo.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class AuthenticateUserScreen extends StatelessWidget {
  const AuthenticateUserScreen(this.fee, {Key? key}) : super(key: key);

  static final TextEditingController textEditingController =
      TextEditingController(text: '');
  static final LocaldatabaseRepo localdatabaseRepo =
      GetIt.instance<LocaldatabaseRepo>();

  final int fee;

  void show(BuildContext context) {
    Navigator.pop(Get.overlayContext!);
    Get.defaultDialog(
      title: 'Loading Please Wait...',
      onWillPop: () async => false,
      barrierDismissible: false,
      content: Container(
        child: CustomLoadingIndicatorWidget(),
      ),
    );
  }

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
              text: 'Choose Payment Type',
              fontSize: sizerSp(20),
              fontWeight: FontWeight.w700,
            ),
            CustomTextWidget(
              text:
                  'You can choose between two payment types. You can either choose to pay from wallet of pay now with your debit card',
              fontSize: sizerSp(12),
              fontWeight: FontWeight.w300,
            ),
            SizedBox(height: sizerSp(20)),
            // CustomTextField(
            //   textEditingController: textEditingController,
            //   hintText: '12345678',
            //   labelText: '',
            //   textInputType: TextInputType.visiblePassword,
            //   isPassword: true,
            // ),
            // SizedBox(height: sizerSp(10)),
            // Container(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: sizerSp(10.0),
            //     vertical: sizerSp(5.0),
            //   ),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(sizerSp(5.0)),
            //     color: Colors.red.shade100,
            //   ),
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: <Widget>[
            //       Icon(
            //         Icons.info,
            //         color: Colors.white,
            //         size: sizerSp(10.0),
            //       ),
            //       SizedBox(width: sizerSp(5.0)),
            //       Expanded(
            //         child: CustomTextWidget(
            //           text: 'Please do be aware that this amount will be '
            //               'deducted from your wallet balance, and extra fee '
            //               'may be taken for charges',
            //           fontSize: sizerSp(11),
            //           fontWeight: FontWeight.w300,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(height: sizerSp(100)),
            Row(
              children: <Widget>[
                Expanded(
                  child: BlocConsumer<MerchantBloc, MerchantState>(
                    listener: (BuildContext context, MerchantState state) {
                      if (state is MakePaymentLoadedState) {
                        // CustomNavigationService().goBack();
                        // CustomNavigationService().goBack();
                        // CustomNavigationService().goBack();
                        // CustomNavigationService().navigateRecplace(
                        //   RouteName.orderStatus,
                        //   argument: state.id,
                        // );
                      }
                    },
                    builder: (BuildContext context, MerchantState state) {
                      if (state is MakePaymentLoadingState) {
                        return Container();
                      }

                      return CustomButton(
                        onTap: () async {
                          // final bool state = localdatabaseRepo.showFood.value;
                          // final int amount = state
                          //     ? await localdatabaseRepo.getTotalCartItemPrice()
                          //     : await localdatabaseRepo
                          //         .getTotalMarketCartItemPrice();

                          // show(context);
                          CustomButtomModalService.showModal(
                            FundWalletDetailsWidget(
                              amount: fee,
                              enabled: false,
                            ),
                          );
                        },
                        text: 'Card',
                        textFontWeight: FontWeight.bold,
                      );
                    },
                  ),
                ),
                SizedBox(width: sizerSp(10)),
                Expanded(
                  child: BlocConsumer<MerchantBloc, MerchantState>(
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
                          BlocProvider.of<MerchantBloc>(context)
                              .add(MakePaymentEvent(fee, false));
                        },
                        text: 'Wallet',
                        textFontWeight: FontWeight.bold,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
