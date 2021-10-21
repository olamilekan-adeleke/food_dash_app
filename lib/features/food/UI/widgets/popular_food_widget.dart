import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:food_dash_app/cores/components/custom_text_widget.dart';
import 'package:food_dash_app/cores/components/error_widget.dart';
import 'package:food_dash_app/cores/components/image_widget.dart';
import 'package:food_dash_app/cores/components/loading_indicator.dart';
import 'package:food_dash_app/cores/constants/color.dart';
import 'package:food_dash_app/cores/utils/currency_formater.dart';
import 'package:food_dash_app/cores/utils/emums.dart';
import 'package:food_dash_app/cores/utils/navigator_service.dart';
import 'package:food_dash_app/cores/utils/route_name.dart';
import 'package:food_dash_app/cores/utils/sizer_utils.dart';
import 'package:food_dash_app/cores/utils/snack_bar_service.dart';
import 'package:food_dash_app/features/food/UI/widgets/favourite_button.dart';
import 'package:food_dash_app/features/food/bloc/merchant_bloc/merchant_bloc.dart';
import 'package:food_dash_app/features/food/model/cart_model.dart';
import 'package:food_dash_app/features/food/model/food_product_model.dart';

class PopularFoodWidgets extends StatefulWidget {
  const PopularFoodWidgets({Key? key}) : super(key: key);

  @override
  _PopularFoodWidgetsState createState() => _PopularFoodWidgetsState();
}

class _PopularFoodWidgetsState extends State<PopularFoodWidgets> {
  List<FoodProductModel> foodList = <FoodProductModel>[];
  late ScrollController _controller;

  // void _scrollListener() {
  //   final MerchantBloc merchantBloc = BlocProvider.of<MerchantBloc>(context);
  //   debugPrint(_controller.position.atEdge.toString());
  //   debugPrint('dddd');
  //   if (_controller.position.pixels >= _controller.position.maxScrollExtent) {
  //     if (merchantBloc.hasMoreFavFood == true &&
  //         merchantBloc.foodFavBusy == false) {
  //       merchantBloc.add(GetPopularFoodEvents());
  //     }
  //   }
  // }

  // @override
  // void initState() {
  //   _controller = ScrollController();
  //   _controller.addListener(_scrollListener);
  //   BlocProvider.of<MerchantBloc>(context).add(GetPopularFoodEvents());
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MerchantBloc, MerchantState>(
      listener: (BuildContext context, MerchantState state) {
        if (state is GetPopularFoodLoadedState) {
          foodList.addAll(state.foodList);
          log(foodList.toString());
        } else if (state is GetPopularFoodLoadingState) {
          log('loading food');
        } else if (state is GetPopularFoodErrorState) {
          CustomSnackBarService.showErrorSnackBar(state.message);
        }
      },
      builder: (BuildContext context, MerchantState state) {
        if (state is GetPopularFoodLoadingState && foodList.isEmpty) {
          return const Center(child: CustomLoadingIndicatorWidget());
        } else if (state is GetPopularFoodErrorState && foodList.isEmpty) {
          return CustomErrorWidget(
            message: state.message,
            callback: () => BlocProvider.of<MerchantBloc>(context)
                .add(GetPopularFoodEvents()),
          );
        }

        return foodItemWidget();
      },
    );
  }

  Widget foodItemWidget() {
    return RefreshIndicator(
      onRefresh: () async {
        foodList.clear();
        BlocProvider.of<MerchantBloc>(context).add(GetPopularFoodEvents());
      },
      child: StaggeredGridView.countBuilder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 4,
        staggeredTileBuilder: (int index) {
          return StaggeredTile.fit(2);
        },
        itemCount: foodList.length,
        itemBuilder: (BuildContext context, int index) {
          final FoodProductModel foodProduct = foodList[index];

          return ItemWidget(
            foodProduct: foodProduct,
            callback: () => CustomNavigationService().navigateTo(
              RouteName.selectedFoodPage,
              argument: foodProduct,
            ),
          );
        },
      ),
    );
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    Key? key,
    required this.foodProduct,
    required this.callback,
  }) : super(key: key);

  final FoodProductModel foodProduct;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: SizedBox(
        height: sizerSp(190),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            InkWell(
              onTap: () => callback(),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: sizerSp(90),
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(sizerSp(5.0)),
                      child: CustomImageWidget(
                        imageUrl: foodProduct.image,
                        imageTypes: ImageTypes.network,
                      ),
                    ),
                  ),
                  SizedBox(height: sizerSp(3)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: sizerSp(5)),
                    child: CustomTextWidget(
                      text: foodProduct.name,
                      fontSize: sizerSp(11),
                      fontWeight: FontWeight.bold,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // SizedBox(height: sizerSp(2)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: sizerSp(5)),
                    child: CustomTextWidget(
                      text: foodProduct.description,
                      fontSize: sizerSp(10),
                      fontWeight: FontWeight.w300,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: sizerSp(2)),
                  // const Spacer(),
                  CustomTextWidget(
                    text: '\u20A6 ${currencyFormatter(foodProduct.price)}',
                    fontSize: sizerSp(12),
                    fontWeight: FontWeight.bold,
                    textColor: kcPrimaryColor,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Spacer(),

            ///
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sizerSp(5.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FavouriteButtonWidget(
                    foodProduct,
                    square: true,
                    small: true,
                    margin: EdgeInsets.symmetric(vertical: sizerSp(5.0)),
                    padding: EdgeInsets.symmetric(vertical: sizerSp(5.0)),
                  ),
                  Container(
                    height: sizerSp(23),
                    width: sizerSp(50),
                    margin: EdgeInsets.symmetric(vertical: sizerSp(5.0)),
                    padding: EdgeInsets.symmetric(vertical: sizerSp(5.0)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(sizerSp(5.0)),
                      color: kcPrimaryColor,
                    ),
                    child: BlocConsumer<MerchantBloc, MerchantState>(
                      listener: (BuildContext context, MerchantState state) {
                        if (state is AddFoodProductToCartLoadedState) {
                          CustomSnackBarService.showSuccessSnackBar(
                            'Added To Cart!',
                          );
                        } else if (state is AddFoodProductToCartErrorState) {
                          CustomSnackBarService.showErrorSnackBar(
                            state.message,
                          );
                        }
                      },
                      builder: (BuildContext context, MerchantState state) {
                        if (state is AddFoodProductToCartLoadingState) {
                          return const CustomLoadingIndicatorWidget();
                        }

                        return InkWell(
                          onTap: () {
                            final CartModel cart = CartModel(
                              category: foodProduct.category,
                              id: foodProduct.id,
                              count: 1,
                              description: foodProduct.description,
                              image: foodProduct.image,
                              name: foodProduct.name,
                              price: foodProduct.price,
                              fastFoodName: foodProduct.fastFoodname,
                              fastFoodId: foodProduct.fastFoodId,
                            );

                            BlocProvider.of<MerchantBloc>(context)
                                .add(AddFoodProductToCartEvents(cart));
                          },
                          child: Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                            size: sizerSp(12),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PopularFoodItemWidget extends StatelessWidget {
  const PopularFoodItemWidget(this.merchant, {Key? key}) : super(key: key);

  final FoodProductModel merchant;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: sizerSp(10),
          vertical: sizerSp(5),
        ),
        margin: EdgeInsets.only(right: sizerSp(10)),
        decoration: BoxDecoration(
          color: kcPrimaryColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(sizerSp(5.0)),
        ),
        height: sizerSp(50),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CustomImageWidget(
              imageUrl: merchant.image,
              imageTypes: ImageTypes.network,
            ),
            CustomTextWidget(
              text: merchant.name,
              fontSize: sizerSp(10),
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}
