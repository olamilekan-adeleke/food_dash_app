import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_dash_app/cores/components/custom_button.dart';
import 'package:food_dash_app/cores/components/custom_circular_progress_indicator.dart';
import 'package:food_dash_app/cores/constants/color.dart';
import 'package:food_dash_app/cores/utils/snack_bar_service.dart';
import 'package:food_dash_app/features/food/bloc/merchant_bloc/merchant_bloc.dart';
import 'package:food_dash_app/features/food/model/cart_model.dart';
import 'package:food_dash_app/features/food/model/food_product_model.dart';

class CartButtonWidget extends StatelessWidget {
  const CartButtonWidget(
    this.foodProduct, {
    Key? key,
  }) : super(key: key);

  final FoodProductModel foodProduct;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MerchantBloc, MerchantState>(
      listener: (BuildContext context, MerchantState state) {
        if (state is AddFoodProductToCartErrorState) {
          CustomSnackBarService.showErrorSnackBar(state.message);
        } else if (state is AddFoodProductToCartLoadedState) {
          CustomSnackBarService.showSuccessSnackBar('Item Added To Cart!');
        }
      },
      builder: (BuildContext context, MerchantState state) {
        if (state is AddFoodProductToCartLoadingState &&
            state.id == foodProduct.id) {
          return const SizedBox(
            height: 30,
            width: 30,
            child: CustomCircularProgressIndicator(color: kcPrimaryColor),
          );
        }

        return CustomButton.icon(
          height: 30,
          width: 60,
          iconData: Icons.shopping_cart_rounded,
          onTap: () {
            final CartModel cart = CartModel(
              category: foodProduct.category,
              id: foodProduct.id,
              count: 1,
              description: foodProduct.description,
              image: foodProduct.image,
              name: foodProduct.name,
              price: foodProduct.price,
            );
            BlocProvider.of<MerchantBloc>(context)
                .add(AddFoodProductToCartEvents(cart));
          },
        );
      },
    );
  }
}
