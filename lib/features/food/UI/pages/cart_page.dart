import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_dash_app/cores/components/custom_button.dart';
import 'package:food_dash_app/cores/components/custom_scaffold_widget.dart';
import 'package:food_dash_app/cores/components/custom_text_widget.dart';
import 'package:food_dash_app/cores/components/error_widget.dart';
import 'package:food_dash_app/cores/components/image_widget.dart';
import 'package:food_dash_app/cores/components/loading_indicator.dart';
import 'package:food_dash_app/cores/constants/font_size.dart';
import 'package:food_dash_app/cores/utils/emums.dart';
import 'package:food_dash_app/cores/utils/navigator_service.dart';
import 'package:food_dash_app/features/food/UI/pages/selected_food_page.dart';
import 'package:food_dash_app/features/food/UI/widgets/cart_button.dart';
import 'package:food_dash_app/features/food/bloc/merchant_bloc/merchant_bloc.dart';
import 'package:food_dash_app/features/food/model/cart_model.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    BlocProvider.of<MerchantBloc>(context).add(GetCartItemEvents());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

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
      body: BlocConsumer<MerchantBloc, MerchantState>(
        listener: (BuildContext context, MerchantState state) {},
        builder: (BuildContext context, MerchantState state) {
          if (state is GetCartItemLoadingState) {
            return const SizedBox(
              height: 50,
              width: 50,
              child: CustomLoadingIndicatorWidget(),
            );
          } else if (state is GetCartItemErrorState) {
            return SizedBox(
              height: 150,
              child: CustomErrorWidget(
                message: state.message,
                callback: () => BlocProvider.of<MerchantBloc>(context)
                    .add(GetCartItemEvents()),
              ),
            );
          } else if (state is GetCartItemLoadedState) {
            return CartList(state.cartList);
          }

          return Container();
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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            // height: size.height * 0.55,
            color: Colors.grey[50],
            child: ListView.builder(
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
                                      text: '\u20A6 ${cartItem.price}',
                                      fontWeight: FontWeight.w300,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        ItemCountButton(
                                          iconData: Icons.remove,
                                          callback: () {},
                                        ),
                                        const SizedBox(width: 10.0),
                                        const CustomTextWidget(text: '1'),
                                        const SizedBox(width: 10.0),
                                        ItemCountButton(
                                          iconData: Icons.add,
                                          callback: () {},
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
          child: Expanded(
            // width: size.width,
            // height: size.height * 0.355,

            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const <Widget>[
                      CustomTextWidget(
                        text: 'SubTotal',
                        fontSize: kfsLarge,
                        fontWeight: FontWeight.bold,
                      ),
                      CustomTextWidget(
                        text: '\u20A6 2,500',
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
                    children: const <Widget>[
                      CustomTextWidget(
                        text: 'Total',
                        fontSize: kfsSuperLarge,
                        fontWeight: FontWeight.bold,
                      ),
                      CustomTextWidget(
                        text: '\u20A6 3,000',
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  CustomButton(text: 'CHECKOUT', onTap: () {}),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
