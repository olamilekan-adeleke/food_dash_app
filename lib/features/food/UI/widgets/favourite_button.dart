import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_dash_app/cores/components/custom_circular_progress_indicator.dart';
import 'package:food_dash_app/cores/constants/color.dart';
import 'package:food_dash_app/cores/utils/sizer_utils.dart';
import 'package:food_dash_app/cores/utils/snack_bar_service.dart';
import 'package:food_dash_app/features/food/bloc/merchant_bloc/merchant_bloc.dart';
import 'package:food_dash_app/features/food/model/food_product_model.dart';

class FavouriteButtonWidget extends StatelessWidget {
  const FavouriteButtonWidget(
    this.foodProduct, {
    this.small = false,
    this.square = false,
    this.width,
    this.height,
    this.padding,
    this.margin,
    Key? key,
  }) : super(key: key);

  final FoodProductModel? foodProduct;
  final bool small;
  final bool square;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? sizerSp(small ? 23 : 40),
      width: width ?? sizerSp(small ? 50 : 60),
      decoration: BoxDecoration(
        color: square ? kcPrimaryColor : Colors.grey[300],
        borderRadius: square ? BorderRadius.circular(sizerSp(5)) : null,
        shape: square ? BoxShape.rectangle : BoxShape.circle,
      ),
      padding: padding ?? const EdgeInsets.all(5.0),
      margin: margin ?? null,
      // alignment: Alignment.center,
      child: BlocConsumer<MerchantBloc, MerchantState>(
        listener: (BuildContext context, MerchantState state) {
          if (state is AddFoodProductToFavouriteErrorState) {
            CustomSnackBarService.showErrorSnackBar(state.message);
          } else if (state is AddFoodProductToFavouriteLoadedState) {
            CustomSnackBarService.showSuccessSnackBar(
                'Item Added To Favourite!');
          }
        },
        builder: (BuildContext context, MerchantState state) {
          if (state is AddFoodProductToFavouriteLoadingState &&
              state.id == foodProduct?.id) {
            return SizedBox(
              // height: small ? 20 : 30,
              // width: small ? 20 : 30,
              child: Center(
                  child: const CustomCircularProgressIndicator(
                      color: kcPrimaryColor)),
            );
          }

          return Center(
            child: InkWell(
              child: Icon(
                Icons.bookmark_add_outlined,
                color: square ? Colors.white : Colors.grey[700],
                size: small ? 15 : 25,
              ),
              onTap: () {
                if (foodProduct != null) {
                  BlocProvider.of<MerchantBloc>(context)
                      .add(AddFoodProductToFavouriteEvents(foodProduct!));
                }
              },
            ),
          );
        },
      ),
    );
  }
}
