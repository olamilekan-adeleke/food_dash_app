import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_dash_app/cores/components/custom_button.dart';
import 'package:food_dash_app/cores/components/custom_scaffold_widget.dart';
import 'package:food_dash_app/cores/components/custom_text_widget.dart';
import 'package:food_dash_app/cores/components/image_widget.dart';
import 'package:food_dash_app/cores/constants/font_size.dart';
import 'package:food_dash_app/cores/utils/emums.dart';
import 'package:food_dash_app/cores/utils/snack_bar_service.dart';
import 'package:food_dash_app/features/food/UI/widgets/favourite_button.dart';
import 'package:food_dash_app/features/food/bloc/merchant_bloc/merchant_bloc.dart';
import 'package:food_dash_app/features/food/model/cart_model.dart';
import 'package:food_dash_app/features/food/model/food_product_model.dart';

class SelectedFoodPage extends StatelessWidget {
  SelectedFoodPage({Key? key, required this.foodProduct}) : super(key: key);

  final FoodProductModel? foodProduct;
  final ValueNotifier<int> _foodCount = ValueNotifier<int>(1);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return CustomScaffoldWidget(
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: size.height * 0.35,
            width: size.width,
            child: Stack(
              children: <Widget>[
                SizedBox(
                  width: size.width,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                    child: CustomImageWidget(
                      imageUrl: foodProduct!.image,
                      imageTypes: ImageTypes.network,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: FavouriteButtonWidget(foodProduct!),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomTextWidget(
                  text: foodProduct!.name,
                  fontSize: kfsSuperLarge,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 10.0),
                CustomTextWidget(
                  text: foodProduct!.description * 6,
                  fontWeight: FontWeight.w300,
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: <Widget>[
                    CustomTextWidget(
                      text: 'Price: \u20A6 ${foodProduct!.price}',
                      fontWeight: FontWeight.bold,
                      fontSize: kfsLarge,
                    ),
                    const Spacer(),
                    Row(
                      children: <Widget>[
                        ItemCountButton(
                          callback: () {
                            if (_foodCount.value > 1) {
                              _foodCount.value--;
                            } else {
                              CustomSnackBarService.showWarningSnackBar(
                                '1 item is the minmimun allowed number',
                              );
                            }
                          },
                          iconData: Icons.remove,
                        ),
                        const SizedBox(width: 10.0),
                        ValueListenableBuilder<int>(
                          valueListenable: _foodCount,
                          builder: (
                            BuildContext context,
                            int value,
                            dynamic child,
                          ) {
                            return CustomTextWidget(
                              text: '$value',
                              fontSize: kfsLarge,
                              fontWeight: FontWeight.bold,
                            );
                          },
                        ),
                        const SizedBox(width: 10.0),
                        ItemCountButton(
                          callback: () {
                            if (_foodCount.value < 10) {
                              _foodCount.value++;
                            } else {
                              CustomSnackBarService.showWarningSnackBar(
                                '10 items is the maximun allowed number',
                              );
                            }
                          },
                          iconData: Icons.add,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40.0),
                BlocConsumer<MerchantBloc, MerchantState>(
                  listener: (BuildContext context, MerchantState state) {},
                  builder: (BuildContext context, MerchantState state) {
                    if (state is AddFoodProductToCartLoadingState) {
                      return const CustomButton.loading();
                    }

                    return CustomButton(
                      text: 'Add To Cart',
                      onTap: () {
                        final CartModel cart = CartModel(
                          category: foodProduct!.category,
                          id: foodProduct!.id,
                          count: 1,
                          description: foodProduct!.description,
                          image: foodProduct!.image,
                          name: foodProduct!.name,
                          price: foodProduct!.price,
                        );

                        BlocProvider.of<MerchantBloc>(context)
                            .add(AddFoodProductToCartEvents(cart));
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ItemCountButton extends StatelessWidget {
  const ItemCountButton({
    Key? key,
    required this.iconData,
    required this.callback,
    this.rounded = false,
  }) : super(key: key);

  final IconData iconData;
  final void Function() callback;
  final bool rounded;

  @override
  Widget build(BuildContext context) {
    return CustomButton.icon(
      iconData: iconData,
      height: 26,
      width: 50,
      iconSize: 13,
      circular: rounded,
      onTap: () => callback(),
    );
  }
}
