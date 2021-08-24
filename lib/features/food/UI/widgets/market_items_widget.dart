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
import 'package:food_dash_app/features/food/bloc/merchant_bloc/merchant_bloc.dart';
import 'package:food_dash_app/features/food/model/cart_model.dart';
import 'package:food_dash_app/features/food/model/food_product_model.dart';
import 'package:food_dash_app/features/food/model/market_item_model.dart';

class MarketItemsWidgets extends StatefulWidget {
  const MarketItemsWidgets({Key? key}) : super(key: key);

  @override
  _MarketItemsWidgetsState createState() => _MarketItemsWidgetsState();
}

class _MarketItemsWidgetsState extends State<MarketItemsWidgets> {
  List<MarketItemModel> marketItems = <MarketItemModel>[];
  late ScrollController _controller;

  void _scrollListener() {
    final MerchantBloc merchantBloc = BlocProvider.of<MerchantBloc>(context);
    debugPrint(_controller.position.atEdge.toString());
    debugPrint('dddd');
    if (_controller.position.pixels >= _controller.position.maxScrollExtent) {
      if (merchantBloc.hasMoreMarket == true &&
          merchantBloc.marketBusy == false) {
        merchantBloc.add(GetMarketItemsEvent());
      }
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    BlocProvider.of<MerchantBloc>(context).add(GetMarketItemsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocConsumer<MerchantBloc, MerchantState>(
        listener: (BuildContext context, MerchantState state) {
          if (state is GetMarketItemLoadedState) {
            marketItems.addAll(state.items);
            log(marketItems.toString());
          } else if (state is GetMarketItemErrorState) {
            CustomSnackBarService.showErrorSnackBar(state.message);
          }
        },
        builder: (BuildContext context, MerchantState state) {
          if (state is GetMarketItemLoadingState && marketItems.isEmpty) {
            return const Center(child: CustomLoadingIndicatorWidget());
          } else if (state is GetMarketItemErrorState && marketItems.isEmpty) {
            return CustomErrorWidget(
              message: state.message,
              callback: () => BlocProvider.of<MerchantBloc>(context)
                  .add(GetMarketItemsEvent()),
            );
          }

          return Stack(
            children: <Widget>[
              foodItemWidget(),
              Align(
                alignment: Alignment.bottomCenter,
                child: BlocConsumer<MerchantBloc, MerchantState>(
                  listener: (BuildContext context, MerchantState state) {},
                  builder: (BuildContext context, MerchantState state) {
                    if (state is GetMarketItemLoadingState) {
                      return Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade600,
                          borderRadius: BorderRadius.circular(sizerSp(3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            SizedBox(
                              height: 18,
                              width: 18,
                              child: CupertinoActivityIndicator(),
                            ),
                            SizedBox(width: 20),
                            CustomTextWidget(
                              text: 'Loading More',
                              textColor: Colors.white,
                            ),
                          ],
                        ),
                      );
                    }

                    return Container();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget foodItemWidget() {
    return StaggeredGridView.countBuilder(
      // gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
      //   maxCrossAxisExtent: sizerSp(260),
      //   childAspectRatio: 0.69,
      // ),
      controller: _controller,
      // physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 4,
      staggeredTileBuilder: (int index) {
        return StaggeredTile.fit(2);
      },
      itemCount: marketItems.length,

      itemBuilder: (BuildContext context, int index) {
        final MarketItemModel marketItem = marketItems[index];

        return ItemWidget(
          marketItem: marketItem,
          callback: () => CustomNavigationService().navigateTo(
            RouteName.selectedMarketItemPage,
            argument: marketItem,
          ),
        );
      },
    );
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    Key? key,
    required this.marketItem,
    required this.callback,
  }) : super(key: key);

  final MarketItemModel marketItem;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            onTap: () => callback(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: sizerSp(100),
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: CustomImageWidget(
                      imageUrl: marketItem.images.first,
                      imageTypes: ImageTypes.network,
                    ),
                  ),
                ),
                SizedBox(height: sizerSp(5)),
                CustomTextWidget(
                  text: marketItem.name,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: sizerSp(2)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: sizerSp(5)),
                  child: CustomTextWidget(
                    text: marketItem.description,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: sizerSp(5)),
                CustomTextWidget(
                  text: '\u20A6 ${currencyFormatter(marketItem.price)}',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  textColor: kcPrimaryColor,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          ///
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sizerSp(5.0)),
            child: Container(
              height: sizerSp(23),
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: sizerSp(5.0)),
              padding: EdgeInsets.symmetric(vertical: sizerSp(5.0)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(sizerSp(5.0)),
                color: kcPrimaryColor,
              ),
              child: BlocConsumer<MerchantBloc, MerchantState>(
                listener: (BuildContext context, MerchantState state) {
                  if (state is AddMarketItemToCartLoadedState) {
                    CustomSnackBarService.showSuccessSnackBar('Added To Cart!');
                  } else if (state is AddMarketItemToCartErrorState) {
                    CustomSnackBarService.showErrorSnackBar(state.message);
                  }
                },
                builder: (BuildContext context, MerchantState state) {
                  if (state is AddMarketItemToCartInitialState) {
                    return const CustomLoadingIndicatorWidget();
                  }

                  return InkWell(
                    onTap: () {
                      final CartModel cart = CartModel(
                        category: marketItem.category,
                        id: marketItem.id,
                        count: 1,
                        description: marketItem.description,
                        image: marketItem.images.first,
                        name: marketItem.name,
                        price: marketItem.price,
                        fastFoodName: '',
                        fastFoodId: '',
                      );

                      BlocProvider.of<MerchantBloc>(context)
                          .add(AddMarketItemProductToCartEvents(cart));
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
          ),
        ],
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

