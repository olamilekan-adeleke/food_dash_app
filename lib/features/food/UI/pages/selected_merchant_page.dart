import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_dash_app/cores/components/custom_button.dart';
import 'package:food_dash_app/cores/components/custom_scaffold_widget.dart';
import 'package:food_dash_app/cores/components/custom_text_widget.dart';
import 'package:food_dash_app/cores/components/error_widget.dart';
import 'package:food_dash_app/cores/components/image_widget.dart';
import 'package:food_dash_app/cores/components/loading_indicator.dart';
import 'package:food_dash_app/cores/constants/color.dart';
import 'package:food_dash_app/cores/constants/font_size.dart';
import 'package:food_dash_app/cores/utils/emums.dart';
import 'package:food_dash_app/cores/utils/navigator_service.dart';
import 'package:food_dash_app/cores/utils/route_name.dart';
import 'package:food_dash_app/features/food/UI/widgets/cart_button.dart';
import 'package:food_dash_app/features/food/bloc/merchant_bloc/merchant_bloc.dart';
import 'package:food_dash_app/features/food/model/food_product_model.dart';
import 'package:food_dash_app/features/food/model/merchant_model.dart';

class SelectedMerchantPage extends StatelessWidget {
  const SelectedMerchantPage(
    this.merchant, {
    Key? key,
  }) : super(key: key);

  final MerchantModel merchant;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return CustomScaffoldWidget(
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: size.height * 0.30,
            child: Stack(
              children: <Widget>[
                SizedBox(
                  height: size.height * 0.25,
                  width: double.infinity,
                  child: CustomImageWidget(
                    imageUrl: merchant.image,
                    imageTypes: ImageTypes.network,
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    child: CustomButton.icon(
                      iconData: Icons.shopping_cart_rounded,
                      height: 50,
                      width: 50.0,
                      circular: true,
                      color: Colors.grey[200],
                      iconColor: Colors.grey[700],
                      onTap: ()=> CustomNavigationService()
                          .navigateTo(RouteName.cartPage),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Card(
                    child: Container(
                      height: size.height * 0.1,
                      width: size.width * 0.80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          const SizedBox(height: 5.0),
                          CustomTextWidget(
                            text: merchant.name,
                            fontSize: kfsLarge,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 2.0),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const CustomTextWidget(
                                text: '\$\$',
                                fontSize: kfsLarge,
                                fontWeight: FontWeight.w300,
                              ),
                              ...merchant.categories
                                  .map(
                                    (String category) => CustomTextWidget(
                                      text: '    $category    ',
                                      fontSize: kfsLarge,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  )
                                  .toList(),
                            ],
                          ),
                          const SizedBox(height: 2.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  CustomTextWidget(
                                    text: '${merchant.rating}',
                                    fontSize: kfsLarge,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  const Icon(
                                    Icons.star,
                                    color: kcPrimaryColor,
                                    size: 18,
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10.0),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  CustomTextWidget(
                                    text: '${merchant.numberOfRating}+',
                                    fontSize: kfsLarge,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const CustomTextWidget(
                                    text: ' Ratings',
                                    fontSize: kfsLarge,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10.0),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: const <Widget>[
                                  Icon(
                                    Icons.timelapse,
                                    color: Colors.grey,
                                    size: 18,
                                  ),
                                  CustomTextWidget(
                                    text: ' 25 Mins',
                                    fontSize: kfsLarge,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10.0),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: const <Widget>[
                                  Icon(
                                    Icons.monetization_on,
                                    color: Colors.grey,
                                    size: 18,
                                  ),
                                  CustomTextWidget(
                                    text: '  Free',
                                    fontSize: kfsLarge,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          const CustomTextWidget(
            text: 'Food Items',
            fontSize: kfsSuperLarge,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
          const Divider(),
          FoodProductsListView(merchantId: merchant.id),
        ],
      ),
    );
  }
}

class FoodProductsListView extends StatefulWidget {
  const FoodProductsListView({Key? key, required this.merchantId})
      : super(key: key);

  final String merchantId;

  @override
  _FoodProductsListViewState createState() => _FoodProductsListViewState();
}

class _FoodProductsListViewState extends State<FoodProductsListView> {
  MerchantBloc? merchantBloc;
  final List<FoodProductModel> foodProducts = <FoodProductModel>[];
  late ScrollController _controller;

  void _scrollListener() {
    debugPrint(_controller.position.atEdge.toString());
    debugPrint('dddd');
    if (_controller.position.pixels >= _controller.position.maxScrollExtent) {
      // merchantBloc!.hasMoreMerchant == true &&
      // merchantBloc!.merchantBusy == false
      print('got here');
      // merchantBloc!.add(GetMerchantsEvents());
    }
  }

  @override
  void initState() {
    super.initState();

    merchantBloc = BlocProvider.of<MerchantBloc>(context);
    merchantBloc!.add(GetFoodProductsEvents(widget.merchantId));
    _controller = ScrollController();
    _controller.addListener(() => _scrollListener());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MerchantBloc, MerchantState>(
      listener: (BuildContext context, MerchantState state) {
        if (state is GetFoodProductsLoadedState) {
          foodProducts.addAll(state.merchants);
        }
      },
      builder: (BuildContext context, MerchantState state) {
        if (state is GetFoodProductsLoadingState) {
          if (foodProducts.isEmpty) {
            return Column(
              children: const <Widget>[
                SizedBox(height: 100),
                Center(child: CustomLoadingIndicatorWidget()),
              ],
            );
          } else {
            return ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                foodItemWidget(),
                const SizedBox(height: 10.0),
                const Center(child: CustomLoadingIndicatorWidget()),
              ],
            );
          }
        } else if (state is GetMerchantErrorState) {
          return SizedBox(
            height: 400,
            child: CustomErrorWidget(
              message: state.message,
              callback: () => merchantBloc!.add(GetMerchantsEvents()),
            ),
          );
        }

        return foodItemWidget();
      },
    );
  }

  Widget foodItemWidget() {
    final Size size = MediaQuery.of(context).size;

    return ListView.builder(
      controller: _controller,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: foodProducts.length,
      itemBuilder: (BuildContext context, int index) {
        final FoodProductModel foodProduct = foodProducts[index];

        return InkWell(
          onTap: () => CustomNavigationService().navigateTo(
            RouteName.selectedFoodPage,
            argument: foodProduct,
          ),
          child: Card(
            child: Container(
              height: size.height * 0.12,
              width: size.width,
              margin: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 15.0,
              ),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    height: size.height * 0.12,
                    width: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: CustomImageWidget(
                        imageUrl: foodProduct.image,
                        imageTypes: ImageTypes.network,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CustomTextWidget(
                          text: foodProduct.name,
                          fontSize: kfsLarge,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 5.0),
                        CustomTextWidget(
                          text: foodProduct.description * 4,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            CustomTextWidget(
                              text: '\u20A6 ${foodProduct.price}',
                              fontWeight: FontWeight.w300,
                            ),
                            CartButtonWidget(foodProduct),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
