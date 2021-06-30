import 'package:flutter/material.dart';
import 'package:food_dash_app/cores/components/custom_button.dart';
import 'package:food_dash_app/cores/components/custom_scaffold_widget.dart';
import 'package:food_dash_app/cores/components/custom_text_widget.dart';
import 'package:food_dash_app/cores/components/image_widget.dart';
import 'package:food_dash_app/cores/constants/color.dart';
import 'package:food_dash_app/cores/constants/font_size.dart';
import 'package:food_dash_app/cores/utils/config.dart';
import 'package:food_dash_app/cores/utils/emums.dart';
import 'package:food_dash_app/cores/utils/navigator_service.dart';
import 'package:food_dash_app/features/food/model/cart_model.dart';
import 'package:food_dash_app/features/food/repo/food_repo.dart';
import 'package:food_dash_app/features/food/repo/local_database_repo.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      appBar: AppBar(
        title: const CustomTextWidget(
          text: 'Cart Page',
          fontWeight: FontWeight.bold,
          fontSize: kfsSuperLarge,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => CustomNavigationService().goBack(),
          color: Colors.black,
        ),
      ),
      body: ValueListenableBuilder<Box<Map<String, dynamic>>>(
        valueListenable:
            Hive.box<Map<String, dynamic>>(Config.cartDataBox).listenable(),
        builder: (
          BuildContext context,
          Box<Map<String, dynamic>> value,
          dynamic child,
        ) {
          final List<Map<String, dynamic>> valuesList =
              value.values.map((Map<String, dynamic> data) => data).toList();

          final List<CartModel> _cartList = valuesList
              .map((Map<String, dynamic> data) =>
                  CartModel.fromMap(data, data['id'].toString()))
              .toList();

          return CartList(_cartList);
        },
      ),
    );
  }
}

class CartList extends StatelessWidget {
  const CartList(
    this.cartList, {
    Key? key,
  }) : super(key: key);

  final List<CartModel> cartList;
  static final MerchantRepo merchantRepo = GetIt.instance<MerchantRepo>();
  static final LocaldatabaseRepo localdatabaseRepo =
      GetIt.instance<LocaldatabaseRepo>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            color: Colors.grey[50],
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: cartList.length,
              itemBuilder: (BuildContext context, int index) {
                final CartModel cartItem = cartList[index];

                return Card(
                  elevation: 5.0,
                  child: SizedBox(
                    width: size.width,
                    height: size.height * 0.10,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: size.width * 0.30,
                            height: size.height * 0.08,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: CustomImageWidget(
                                imageUrl: cartItem.image,
                                imageTypes: ImageTypes.network,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const SizedBox(height: 10.0),
                                    CustomTextWidget(
                                      text: cartItem.name,
                                      fontSize: kfsTiny,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    const SizedBox(height: 5.0),
                                    CustomTextWidget(
                                      text: '\u20A6 '
                                          '${cartItem.price * cartItem.count}',
                                      fontWeight: FontWeight.w300,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        CartButton(
                                          iconData: Icons.remove,
                                          callback: () {
                                            if (cartItem.count == 1) return;

                                            final CartModel updatedCartItem =
                                                cartItem.copyWith(
                                              count: cartItem.count - 1,
                                            );

                                            merchantRepo.updateCartItem(
                                              updatedCartItem,
                                              index,
                                            );
                                          },
                                        ),
                                        const SizedBox(width: 10.0),
                                        CustomTextWidget(
                                          text: cartItem.count.toString(),
                                          fontWeight: FontWeight.w300,
                                        ),
                                        const SizedBox(width: 10.0),
                                        CartButton(
                                          iconData: Icons.add,
                                          callback: () {
                                            if (cartItem.count == 10) return;

                                            final CartModel updatedCartItem =
                                                cartItem.copyWith(
                                              count: cartItem.count + 1,
                                            );

                                            merchantRepo.updateCartItem(
                                              updatedCartItem,
                                              index,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Material(
          elevation: 15.0,
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          child: ValueListenableBuilder<Box<Map<String, dynamic>>>(
            valueListenable:
                Hive.box<Map<String, dynamic>>(Config.cartDataBox).listenable(),
            builder: (
              BuildContext context,
              Box<Map<String, dynamic>> value,
              dynamic child,
            ) {
              final List<Map<String, dynamic>> valuesList = value.values
                  .map((Map<String, dynamic> data) => data)
                  .toList();

              int allProductPrice = 0;

              for (final Map<String, dynamic> data in valuesList) {
                final int currentItemPrice = data['price'] as int;
                final int currentItemCount = data['count'] as int;

                allProductPrice =
                    allProductPrice + (currentItemPrice * currentItemCount);
              }

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const CustomTextWidget(
                            text: 'SubTotal',
                            fontSize: kfsLarge,
                            fontWeight: FontWeight.bold,
                          ),
                          CustomTextWidget(
                            text: '\u20A6 $allProductPrice',
                            fontWeight: FontWeight.w300,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const <Widget>[
                          CustomTextWidget(
                            text: 'Delivery',
                            fontSize: kfsLarge,
                            fontWeight: FontWeight.bold,
                          ),
                          CustomTextWidget(
                            text: '\u20A6 500',
                            fontWeight: FontWeight.w300,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      const Divider(thickness: 0.5),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const CustomTextWidget(
                            text: 'Total',
                            fontSize: kfsSuperLarge,
                            fontWeight: FontWeight.bold,
                          ),
                          CustomTextWidget(
                            text: '\u20A6 ${allProductPrice + 500}',
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: CustomButton(
                              text: 'Clear Cart',
                              onTap: () => localdatabaseRepo.clearCartItem(),
                              color: Colors.grey[300],
                              textColor: kcTextColor,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: CustomButton(
                              text: 'CHECKOUT',
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class CartButton extends StatelessWidget {
  const CartButton({Key? key, required this.iconData, required this.callback})
      : super(key: key);

  final IconData iconData;
  final void Function() callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => callback(),
      child: Container(
        height: 30.0,
        width: 30.0,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: kcPrimaryColor,
        ),
        child: Icon(
          iconData,
          size: 13,
          color: Colors.white,
        ),
      ),
    );
  }
}
