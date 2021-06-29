import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_dash_app/cores/components/custom_circular_progress_indicator.dart';
import 'package:food_dash_app/cores/constants/color.dart';
import 'package:food_dash_app/cores/utils/snack_bar_service.dart';
import 'package:food_dash_app/features/food/bloc/merchant_bloc/merchant_bloc.dart';
import 'package:food_dash_app/features/food/model/food_product_model.dart';

class FavouriteButtonWidget extends StatelessWidget {
  const FavouriteButtonWidget(
    this.foodProduct, {
    Key? key,
  }) : super(key: key);

  final FoodProductModel foodProduct;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 60,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(5.0),
      alignment: Alignment.center,
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
              state.id == foodProduct.id) {
            return const SizedBox(
              height: 30,
              width: 30,
              child: CustomCircularProgressIndicator(color: kcPrimaryColor),
            );
          }

          return IconButton(
            icon: Icon(
              Icons.favorite_border_rounded,
              color: Colors.grey[700],
            ),
            onPressed: () => BlocProvider.of<MerchantBloc>(context)
                .add(AddFoodProductToFavouriteEvents(foodProduct)),
          );
        },
      ),
    );
  }
}
