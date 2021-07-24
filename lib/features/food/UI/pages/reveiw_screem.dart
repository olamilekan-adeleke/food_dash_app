import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_dash_app/cores/components/custom_button.dart';
import 'package:food_dash_app/cores/components/custom_scaffold_widget.dart';
import 'package:food_dash_app/cores/components/custom_text_widget.dart';
import 'package:food_dash_app/cores/constants/color.dart';
import 'package:food_dash_app/cores/utils/navigator_service.dart';
import 'package:food_dash_app/cores/utils/sizer_utils.dart';
import 'package:food_dash_app/cores/utils/snack_bar_service.dart';
import 'package:food_dash_app/features/food/UI/widgets/header_widget.dart';
import 'package:food_dash_app/features/food/bloc/merchant_bloc/merchant_bloc.dart';

class ReviewScreen extends StatelessWidget {
  ReviewScreen({
    Key? key,
    required this.orderId,
    required this.riderId,
  }) : super(key: key);

  final String orderId;
  final String riderId;
  double rating = 0;

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: sizerSp(10)),
        child: Column(
          children: <Widget>[
            SizedBox(height: sizerSp(20.0)),
            const HeaderWidget(iconData: null, title: 'Review'),
            SizedBox(height: sizerSp(40.0)),
            Card(
              elevation: 5.0,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: sizerSp(30),
                  horizontal: sizerSp(40),
                ),
                width: sizerSp(347),
                child: Column(
                  children: <Widget>[
                    CustomTextWidget(
                      text: 'Rate Rider',
                      fontSize: sizerSp(15),
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.center,
                    ),
                    CustomTextWidget(
                      text: 'How was rider delivery service?',
                      fontSize: sizerSp(13),
                      fontWeight: FontWeight.w200,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: sizerSp(20.0)),
                    RatingBar.builder(
                      minRating: 1,
                      allowHalfRating: true,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (_, __) => const Icon(
                        Icons.star,
                        color: kcPrimaryColor,
                      ),
                      onRatingUpdate: (double val) => rating = val,
                      unratedColor: Colors.grey.shade200,
                      glow: false,
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            BlocConsumer<MerchantBloc, MerchantState>(
              listener: (BuildContext context, MerchantState state) {
                if (state is RateRiderLoadedState) {
                  CustomSnackBarService.showSuccessSnackBar(
                    'Sucsessfully Rate Rider!',
                  );
                } else if (state is RateRiderErrorState) {
                  CustomSnackBarService.showErrorSnackBar(state.message);
                }
              },
              builder: (BuildContext context, MerchantState state) {
                if (state is RateRiderLoadingState) {
                  return const CustomButton.loading();
                }

                return CustomButton(
                  text: 'Submit',
                  onTap: () {
                    if (rating == 0.0) {
                      CustomSnackBarService.showWarningSnackBar(
                          'Please Select Rating!');
                    } else {
                      BlocProvider.of<MerchantBloc>(context)
                          .add(RateRiderEvent(orderId, riderId, rating));
                    }
                  },
                );
              },
            ),
            SizedBox(height: sizerSp(10.0)),
            CustomButton(
              text: 'Home',
              onTap: () => CustomNavigationService().goBack(),
              textColor: kcPrimaryColor,
              color: Colors.grey.shade50,
              textFontWeight: FontWeight.w600,
              textSize: sizerSp(14),
            ),
            SizedBox(height: sizerSp(20.0)),
          ],
        ),
      ),
    );
  }
}
