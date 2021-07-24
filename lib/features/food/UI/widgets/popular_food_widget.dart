import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  void initState() {
    BlocProvider.of<MerchantBloc>(context).add(GetPopularFoodEvents());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: BlocConsumer<MerchantBloc, MerchantState>(
        listener: (BuildContext context, MerchantState state) {
          if (state is GetPopularFoodLoadedState) {
            foodList = state.foodList;
          }
        },
        builder: (BuildContext context, MerchantState state) {
          if (state is GetPopularFoodLoadingState) {
            return const Center(child: CustomLoadingIndicatorWidget());
          } else if (state is GetPopularFoodErrorState) {
            return CustomErrorWidget(
              message: state.message,
              callback: () => BlocProvider.of<MerchantBloc>(context)
                  .add(GetPopularFoodEvents()),
            );
          }

          return foodItemWidget();
        },
      ),
    );
  }

  Widget foodItemWidget() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: sizerSp(260),
        childAspectRatio: 0.68,
      ),
      // controller: _controller,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: foodList.length,
      itemBuilder: (BuildContext context, int index) {
        final FoodProductModel foodProduct = foodList[index];

        return InkWell(
          onTap: () => CustomNavigationService().navigateTo(
            RouteName.selectedFoodPage,
            argument: foodProduct,
          ),
          child: Stack(
            children: <Widget>[
              Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 150,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: CustomImageWidget(
                          imageUrl: foodProduct.image,
                          imageTypes: ImageTypes.network,
                        ),
                      ),
                    ),
                    SizedBox(height: sizerSp(5)),
                    CustomTextWidget(
                      text: foodProduct.name,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: sizerSp(2)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: sizerSp(5)),
                      child: CustomTextWidget(
                        text: foodProduct.description,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: sizerSp(5)),
                    CustomTextWidget(
                      text: '\u20A6 ${currencyFormatter(foodProduct.price)}',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      textColor: kcPrimaryColor,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: sizerSp(12)),
                  ],
                ),
              ),
              Positioned(
                bottom: sizerSp(2),
                left: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: kcPrimaryColor,
                  child: BlocConsumer<MerchantBloc, MerchantState>(
                    listener: (BuildContext context, MerchantState state) {
                      if (state is AddFoodProductToCartLoadedState) {
                        CustomSnackBarService.showSuccessSnackBar(
                            'Added To Cart!');
                      } else if (state is AddFoodProductToCartErrorState) {
                        CustomSnackBarService.showErrorSnackBar(state.message);
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
                        child: const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
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

// Widget foodItemWidget() {
//   return GridView.builder(
//     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//       maxCrossAxisExtent: sizerSp(260),
//       childAspectRatio: 0.68,
//     ),
//     controller: _controller,
//     physics: const NeverScrollableScrollPhysics(),
//     shrinkWrap: true,
//     itemCount: foodProducts.length,
//     itemBuilder: (BuildContext context, int index) {
//       final FoodProductModel foodProduct = foodProducts[index];

//       return InkWell(
//         onTap: () => CustomNavigationService().navigateTo(
//           RouteName.selectedFoodPage,
//           argument: foodProduct,
//         ),
//         child: Stack(
//           children: <Widget>[
//             Card(
//               elevation: 5.0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   SizedBox(
//                     height: 150,
//                     width: double.infinity,
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(5.0),
//                       child: CustomImageWidget(
//                         imageUrl: foodProduct.image,
//                         imageTypes: ImageTypes.network,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: sizerSp(5)),
//                   CustomTextWidget(
//                     text: foodProduct.name,
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   SizedBox(height: sizerSp(2)),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: sizerSp(5)),
//                     child: CustomTextWidget(
//                       text: foodProduct.description,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w300,
//                       maxLines: 2,
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   SizedBox(height: sizerSp(5)),
//                   CustomTextWidget(
//                     text: '\u20A6 ${currencyFormatter(foodProduct.price)}',
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     textColor: kcPrimaryColor,
//                     maxLines: 2,
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: sizerSp(12)),
//                 ],
//               ),
//             ),
//             Positioned(
//               bottom: sizerSp(2),
//               left: 0,
//               right: 0,
//               child: CircleAvatar(
//                 radius: 25,
//                 backgroundColor: kcPrimaryColor,
//                 child: BlocConsumer<MerchantBloc, MerchantState>(
//                   listener: (BuildContext context, MerchantState state) {
//                     if (state is AddFoodProductToCartLoadedState) {
//                       CustomSnackBarService.showSuccessSnackBar(
//                           'Added To Cart!');
//                     } else if (state is AddFoodProductToCartErrorState) {
//                       CustomSnackBarService.showErrorSnackBar(state.message);
//                     }
//                   },
//                   builder: (BuildContext context, MerchantState state) {
//                     if (state is AddFoodProductToCartLoadingState) {
//                       return const CustomLoadingIndicatorWidget();
//                     }

//                     return InkWell(
//                       onTap: () {
//                         final CartModel cart = CartModel(
//                           category: foodProduct.category,
//                           id: foodProduct.id,
//                           count: 1,
//                           description: foodProduct.description,
//                           image: foodProduct.image,
//                           name: foodProduct.name,
//                           price: foodProduct.price,
//                           fastFoodName: foodProduct.fastFoodname,
//                           fastFoodId: foodProduct.fastFoodId,
//                         );

//                         BlocProvider.of<MerchantBloc>(context)
//                             .add(AddFoodProductToCartEvents(cart));
//                       },
//                       child: const Icon(
//                         Icons.shopping_cart,
//                         color: Colors.white,
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }

