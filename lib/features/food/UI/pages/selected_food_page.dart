import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_dash_app/cores/components/custom_button.dart';
import 'package:food_dash_app/cores/components/custom_scaffold_widget.dart';
import 'package:food_dash_app/cores/components/custom_text_widget.dart';
import 'package:food_dash_app/cores/components/image_widget.dart';
import 'package:food_dash_app/cores/constants/color.dart';
import 'package:food_dash_app/cores/constants/font_size.dart';
import 'package:food_dash_app/cores/utils/emums.dart';
import 'package:food_dash_app/cores/utils/navigator_service.dart';
import 'package:food_dash_app/cores/utils/route_name.dart';
import 'package:food_dash_app/cores/utils/sizer_utils.dart';
import 'package:food_dash_app/features/food/UI/widgets/favourite_button.dart';
import 'package:food_dash_app/features/food/bloc/merchant_bloc/merchant_bloc.dart';
import 'package:food_dash_app/features/food/model/cart_model.dart';
import 'package:food_dash_app/features/food/model/food_product_model.dart';

class SelectedFoodPage extends StatelessWidget {
  SelectedFoodPage({Key? key, required this.foodProduct}) : super(key: key);

  final FoodProductModel? foodProduct;
  static bool navigateToCartPage = false;
  ValueNotifier<int> itemCount = ValueNotifier<int>(1);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    foodProduct!.ingredientsList.sort();

    return CustomScaffoldWidget(
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              SizedBox(
                height: size.height * 0.35,
                width: size.width,
                child: Stack(
                  children: <Widget>[
                    SizedBox(
                      width: size.width,
                      height: double.infinity,
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
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              onTap: () => CustomNavigationService().goBack(),
                              child: CircleAvatar(
                                radius: sizerSp(12),
                                backgroundColor: kcPrimaryColor,
                                child: Center(
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    size: sizerSp(11),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            FavouriteButtonWidget(foodProduct),
                          ],
                        ),
                      ),
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
                      text: 'Item Name',
                      fontSize: kfsSuperLarge,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomTextWidget(
                      text: foodProduct!.name,
                      fontSize: kfsExtraLarge,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: sizerSp(20.0)),
                    CustomTextWidget(
                      text: 'Description',
                      fontSize: kfsSuperLarge,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomTextWidget(
                      text: foodProduct!.description,
                      fontWeight: FontWeight.w300,
                    ),
                    SizedBox(height: sizerSp(20.0)),
                    CustomTextWidget(
                      text: 'Price',
                      fontSize: kfsSuperLarge,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: sizerSp(5.0)),
                    ValueListenableBuilder<int>(
                      valueListenable: itemCount,
                      builder: (_, int value, __) {
                        return Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                if (itemCount.value > 1) {
                                  itemCount.value--;
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(sizerSp(5)),
                                decoration: BoxDecoration(
                                  color: itemCount.value <= 1
                                      ? kcPrimaryColor.withOpacity(0.5)
                                      : kcPrimaryColor,
                                  borderRadius:
                                      BorderRadius.circular(sizerSp(2)),
                                ),
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                  size: sizerSp(15),
                                ),
                              ),
                            ),
                            SizedBox(width: sizerSp(10.0)),
                            CustomTextWidget(
                              text: '${itemCount.value}',
                              fontWeight: FontWeight.bold,
                              fontSize: kfsExtraLarge,
                              // textColor: kcPrimaryColor,
                            ),
                            SizedBox(width: sizerSp(10.0)),
                            GestureDetector(
                              onTap: () {
                                if (itemCount.value < 10) {
                                  itemCount.value++;
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(sizerSp(5)),
                                decoration: BoxDecoration(
                                  color: kcPrimaryColor,
                                  borderRadius:
                                      BorderRadius.circular(sizerSp(2)),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: sizerSp(15),
                                ),
                              ),
                            ),
                            const Spacer(),
                            CustomTextWidget(
                              text:
                                  '\u20A6 ${foodProduct!.price * itemCount.value}',
                              fontWeight: FontWeight.bold,
                              fontSize: kfsExtraLarge,
                              // textColor: kcPrimaryColor,
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: sizerSp(20.0)),
                    foodProduct!.ingredientsList.isNotEmpty
                        ? CustomTextWidget(
                            text: 'Ingredients',
                            fontWeight: FontWeight.bold,
                            fontSize: kfsExtraLarge,
                            // textColor: kcPrimaryColor,
                          )
                        : Container(),
                    SizedBox(height: sizerSp(10.0)),
                    SizedBox(
                      width: sizerWidth(90),
                      // height: sizerSp(10),
                      child: Wrap(
                        runSpacing: sizerSp(5),
                        spacing: sizerSp(5),
                        verticalDirection: VerticalDirection.down,
                        children: <Widget>[
                          ...foodProduct!.ingredientsList.map((String e) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: sizerSp(10),
                                vertical: sizerSp(5),
                              ),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(sizerSp(20)),
                                color: Colors.grey.shade200,
                              ),
                              child: CustomTextWidget(
                                text: e,
                                fontWeight: FontWeight.w300,
                                fontSize: sizerSp(13),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                    SizedBox(height: sizerSp(20.0)),
                  ],
                ),
              ),
              SizedBox(height: sizerSp(40.0)),
            ],
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: sizerSp(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                BlocConsumer<MerchantBloc, MerchantState>(
                  listener: (BuildContext context, MerchantState state) {
                    if (state is AddFoodProductToCartLoadedState &&
                        navigateToCartPage == true) {
                      CustomNavigationService().navigateTo(RouteName.cartPage);
                    }
                  },
                  builder: (BuildContext context, MerchantState state) {
                    if (state is AddFoodProductToCartLoadingState) {
                      return const CustomButton.loading();
                    }

                    return ClipRRect(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(sizerSp(20)),
                        bottomRight: Radius.circular(sizerSp(20)),
                      ),
                      child: CustomButton.smallSized(
                        text: 'Add And Proceed To Check Out',
                        width: sizerWidth(45),
                        onTap: () {
                          final CartModel cart = CartModel(
                            category: foodProduct!.category,
                            id: foodProduct!.id,
                            count: itemCount.value,
                            description: foodProduct!.description,
                            image: foodProduct!.image,
                            name: foodProduct!.name,
                            price: foodProduct!.price,
                            fastFoodName: foodProduct!.fastFoodname,
                            fastFoodId: foodProduct!.fastFoodId,
                          );

                          navigateToCartPage = true;

                          BlocProvider.of<MerchantBloc>(context)
                              .add(AddFoodProductToCartEvents(cart));
                        },
                      ),
                    );
                  },
                ),
                //
                BlocConsumer<MerchantBloc, MerchantState>(
                  listener: (BuildContext context, MerchantState state) {},
                  builder: (BuildContext context, MerchantState state) {
                    if (state is AddFoodProductToCartLoadingState) {
                      return const CustomButton.loading();
                    }

                    return ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(sizerSp(20)),
                        bottomLeft: Radius.circular(sizerSp(20)),
                      ),
                      child: CustomButton.smallSized(
                        text: 'Add To Cart',
                        width: sizerWidth(45),
                        onTap: () {
                          final CartModel cart = CartModel(
                            category: foodProduct!.category,
                            id: foodProduct!.id,
                            count: itemCount.value,
                            description: foodProduct!.description,
                            image: foodProduct!.image,
                            name: foodProduct!.name,
                            price: foodProduct!.price,
                            fastFoodName: foodProduct!.fastFoodname,
                            fastFoodId: foodProduct!.fastFoodId,
                          );

                          navigateToCartPage = false;

                          BlocProvider.of<MerchantBloc>(context)
                              .add(AddFoodProductToCartEvents(cart));
                        },
                      ),
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
