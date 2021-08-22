import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

class FavouriteFoodListWidget extends StatefulWidget {
  const FavouriteFoodListWidget({Key? key}) : super(key: key);

  @override
  _FavouriteFoodListWidgetState createState() =>
      _FavouriteFoodListWidgetState();
}

class _FavouriteFoodListWidgetState extends State<FavouriteFoodListWidget> {
  final List<FoodProductModel> foodList = <FoodProductModel>[];
  MerchantBloc? merchantBloc;
  late ScrollController _controller;

  void _scrollListener() {
    debugPrint(_controller.position.atEdge.toString());
    debugPrint('dddd');
    if (_controller.position.pixels >= _controller.position.maxScrollExtent) {
      if (merchantBloc!.hasMoreMerchant == true &&
          merchantBloc!.merchantBusy == false) {
        merchantBloc!.add(GetFavouritesItemEvents());
      }
    }
  }

  @override
  void initState() {
    BlocProvider.of<MerchantBloc>(context).add(GetFavouritesItemEvents());

    merchantBloc = BlocProvider.of<MerchantBloc>(context);

    _controller = ScrollController();
    _controller.addListener(() => _scrollListener());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MerchantBloc, MerchantState>(
      listener: (BuildContext context, MerchantState state) {
        if (state is GetFavouriteLoadedState) {
          foodList.addAll(state.cartList);
        } else if (state is GetFavouriteErrorState) {
          CustomSnackBarService.showErrorSnackBar(state.message);
        }
      },
      builder: (BuildContext context, MerchantState state) {
        if (state is GetFavouriteLoadingState) {
          return Center(
            child: SizedBox(
              height: sizerSp(50),
              width: sizerSp(50),
              child: const CustomLoadingIndicatorWidget(),
            ),
          );
        } else if (state is GetFavouriteErrorState) {
          return CustomErrorWidget(
            message: state.message,
            callback: () => BlocProvider.of<MerchantBloc>(context)
                .add(GetFavouritesItemEvents()),
          );
        }

        return Stack(
          children: <Widget>[
            FavouriteFoodItemWidget(foodList),
            Align(
              alignment: Alignment.bottomCenter,
              child: BlocConsumer<MerchantBloc, MerchantState>(
                listener: (BuildContext context, MerchantState state) {},
                builder: (BuildContext context, MerchantState state) {
                  if (state is GetFavouriteLoadingState) {
                    return Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(10),
                      color: Colors.grey.shade600,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          SizedBox(
                            height: 18,
                            width: 18,
                            child: CustomLoadingIndicatorWidget(),
                          ),
                          SizedBox(width: 20),
                          CustomTextWidget(
                            text: 'Loading More...',
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
    );
  }
}

class FavouriteFoodItemWidget extends StatelessWidget {
  const FavouriteFoodItemWidget(this.foodProducts, {Key? key})
      : super(key: key);

  final List<FoodProductModel> foodProducts;

  @override
  Widget build(BuildContext context) {
    if (foodProducts.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(width: double.infinity, height: sizerHeight(20)),
          SvgPicture.asset(
            'assets/images/empty.svg',
            height: sizerSp(100),
            width: sizerSp(150),
          ),
          SizedBox(height: sizerSp(20)),
          const CustomTextWidget(
            text: 'No Item Was Found!',
            fontWeight: FontWeight.bold,
          ),
        ],
      );
    }

    return StaggeredGridView.countBuilder(
      // gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
      //   maxCrossAxisExtent: sizerSp(260),
      //   childAspectRatio: 0.68,
      // ),
      // controller: _controller,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      staggeredTileBuilder: (int index) {
        return StaggeredTile.fit(2);
      },
      itemCount: foodProducts.length,
      crossAxisCount: 4,
      itemBuilder: (BuildContext context, int index) {
        final FoodProductModel foodProduct = foodProducts[index];

        return InkWell(
          onTap: () => CustomNavigationService().navigateTo(
            RouteName.selectedFoodPage,
            argument: foodProduct,
          ),
          child: SizedBox(
            height: sizerSp(205),
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
                        height: sizerSp(100),
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
                          CustomSnackBarService.showErrorSnackBar(
                              state.message);
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
          ),
        );
      },
    );
  }
}
