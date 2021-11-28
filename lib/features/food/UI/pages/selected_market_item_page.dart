import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
import 'package:food_dash_app/features/food/UI/widgets/market_fav_button.dart';
import 'package:food_dash_app/features/food/bloc/merchant_bloc/merchant_bloc.dart';
import 'package:food_dash_app/features/food/model/cart_model.dart';
import 'package:food_dash_app/features/food/model/market_item_model.dart';

class SelectedMarketItmePage extends StatelessWidget {
  const SelectedMarketItmePage({Key? key, required this.marketItem})
      : super(key: key);

  final MarketItemModel marketItem;
  static bool toCart = false;

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
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                  child: Container(
                    color: Colors.yellow,
                    width: size.width,
                    height: size.height * 0.35,
                    child: CarouselSlider(
                      options: CarouselOptions(
                        viewportFraction: 1.0,
                        autoPlay: true,
                        enableInfiniteScroll: false,
                        aspectRatio: 2 / 2,
                      ),
                      items: marketItem.images.map((String image) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              child: CustomImageWidget(
                                imageUrl: image,
                                imageTypes: ImageTypes.network,
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
                // child: ClipRRect(
                //   borderRadius: const BorderRadius.only(
                //     bottomLeft: Radius.circular(20.0),
                //     bottomRight: Radius.circular(20.0),
                //   ),
                //   child: CustomImageWidget(
                //     imageUrl: marketItem.images.first,
                //     imageTypes: ImageTypes.network,
                //   ),
                // ),
                // ),
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
                        MarketFavouriteButtonWidget(marketItem),
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
                  text: marketItem.name,
                  fontSize: kfsSuperLarge,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: sizerSp(10.0)),
                CustomTextWidget(
                  text: 'Price: \u20A6 ${marketItem.price}',
                  fontWeight: FontWeight.bold,
                  fontSize: kfsExtraLarge,
                  textColor: kcPrimaryColor,
                ),
                SizedBox(height: sizerSp(10.0)),
                CustomTextWidget(
                  text: marketItem.description * 6,
                  fontWeight: FontWeight.w300,
                ),
                SizedBox(height: sizerSp(20.0)),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              // BlocConsumer<MerchantBloc, MerchantState>(
              //   listener: (BuildContext context, MerchantState state) {
              //     if (state is AddFoodProductToCartLoadedState) {
              //       if (toCart) {
              //         CustomNavigationService().navigateTo(RouteName.cartPage);
              //       }
              //     }
              //   },
              //   builder: (BuildContext context, MerchantState state) {
              //     if (state is AddFoodProductToCartLoadingState) {
              //       return const CustomButton.loading();
              //     }

              //     return ClipRRect(
              //       borderRadius: BorderRadius.only(
              //         topRight: Radius.circular(sizerSp(20)),
              //         bottomRight: Radius.circular(sizerSp(20)),
              //       ),
              //       child: CustomButton.smallSized(
              //         text: 'Add And Proceed To Check Out',
              //         width: sizerWidth(45),
              //         onTap: () {
              //           final CartModel cart = CartModel(
              //             category: marketItem.category,
              //             id: marketItem.id,
              //             count: 1,
              //             description: marketItem.description,
              //             image: marketItem.images.first,
              //             name: marketItem.name,
              //             price: marketItem.price,
              //             fastFoodName: '',
              //             fastFoodId: '',
              //           );

              //           toCart = true;

              //           BlocProvider.of<MerchantBloc>(context)
              //               .add(AddMarketItemProductToCartEvents(cart));
              //         },
              //       ),
              //     );
              //   },
              // ),
              // //
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
                          category: marketItem.category,
                          id: marketItem.id,
                          count: 1,
                          description: marketItem.description,
                          image: marketItem.images.first,
                          name: marketItem.name,
                          price: marketItem.price,
                          fastFoodName: marketItem.name,
                          fastFoodId: '',
                        );

                        BlocProvider.of<MerchantBloc>(context)
                            .add(AddMarketItemProductToCartEvents(cart));

                        toCart = false;
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: sizerSp(20.0)),
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
