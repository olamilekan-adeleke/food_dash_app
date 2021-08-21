import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_dash_app/cores/components/custom_button.dart';
import 'package:food_dash_app/cores/components/custom_scaffold_widget.dart';
import 'package:food_dash_app/cores/components/custom_text_widget.dart';
import 'package:food_dash_app/cores/components/image_widget.dart';
import 'package:food_dash_app/cores/constants/color.dart';
import 'package:food_dash_app/cores/constants/font_size.dart';
import 'package:food_dash_app/cores/utils/buttom_modal.dart';
import 'package:food_dash_app/cores/utils/emums.dart';
import 'package:food_dash_app/cores/utils/locator.dart';
import 'package:food_dash_app/cores/utils/navigator_service.dart';
import 'package:food_dash_app/cores/utils/route_name.dart';
import 'package:food_dash_app/cores/utils/sizer_utils.dart';
import 'package:food_dash_app/cores/utils/snack_bar_service.dart';
import 'package:food_dash_app/features/auth/bloc/bloc/getdeliveryfee_bloc.dart';
import 'package:food_dash_app/features/auth/model/user_details_model.dart';
import 'package:food_dash_app/features/food/UI/pages/authentication_dialog.dart';
import 'package:food_dash_app/features/food/model/cart_model.dart';
import 'package:food_dash_app/features/food/repo/food_repo.dart';
import 'package:food_dash_app/features/food/repo/local_database_repo.dart';
import 'package:get_it/get_it.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);
  static final LocaldatabaseRepo localdatabaseRepo =
      locator<LocaldatabaseRepo>();

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
      body: ValueListenableBuilder<List<CartModel>>(
        valueListenable: LocaldatabaseRepo.cartList,
        builder: (
          BuildContext context,
          List<CartModel> cartList,
          Widget? child,
        ) {
          return CartList(cartList);
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

  @override
  Widget build(BuildContext context) {
    if (cartList.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(width: double.infinity),
          SizedBox(
            height: sizerSp(100),
            width: sizerSp(150),
            child: const CustomImageWidget(
              imageUrl: 'assets/images/empty_cart.png',
              imageTypes: ImageTypes.asset,
            ),
          ),
          SizedBox(height: sizerSp(20)),
          CustomTextWidget(
            text: 'Your cart Is Empty!',
            fontSize: sizerSp(20),
            fontWeight: FontWeight.w600,
            textColor: kcPrimaryColor,
          ),
          CustomTextWidget(
            text: 'Make your cart happy by adding food to it.',
            fontSize: sizerSp(14),
            fontWeight: FontWeight.w200,
          ),
        ],
      );
    }

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

                return CartItemWidget(
                  index: index,
                  cartItem: cartItem,
                  merchantRepo: merchantRepo,
                );
              },
            ),
          ),
        ),
        const CartButtomWidget(),
      ],
    );
  }
}

class CartButtomWidget extends StatelessWidget {
  const CartButtomWidget({Key? key}) : super(key: key);

  static final LocaldatabaseRepo localdatabaseRepo =
      GetIt.instance<LocaldatabaseRepo>();
  static final ValueNotifier<bool> showAddress = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return SizedBox(
      // height: 230,
      child: Material(
        elevation: 15.0,
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        child: ValueListenableBuilder<bool>(
          valueListenable: showAddress,
          builder: (BuildContext context, bool value, Widget? child) {
            if (value) {
              return AddressWidget(
                callback: () => showAddress.value = false,
              );
            }
            return CartItemPriceWidget(
              callback: () => showAddress.value = true,
            );
          },
        ),
      ),
    );
  }
}

class AddressWidget extends StatelessWidget {
  const AddressWidget({
    Key? key,
    required this.callback,
  }) : super(key: key);

  final Function() callback;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserDetailsModel?>(
      valueListenable: LocaldatabaseRepo.userDetail,
      builder: (
        BuildContext context,
        UserDetailsModel? userDetails,
        Widget? child,
      ) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: sizerSp(10),
            vertical: sizerSp(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(width: double.infinity),
              CustomTextWidget(
                text: 'Address',
                fontSize: sizerSp(16),
                fontWeight: FontWeight.w500,
              ),
              CustomTextWidget(
                text: userDetails!.address ?? 'No Address Was Found! ',
                fontSize: sizerSp(12),
                fontWeight: FontWeight.w300,
              ),
              SizedBox(height: sizerSp(5)),
              InkWell(
                onTap: () =>
                    CustomNavigationService().navigateTo(RouteName.editAddress),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.edit, size: sizerSp(15), color: kcPrimaryColor),
                    SizedBox(width: sizerSp(5.0)),
                    CustomTextWidget(
                      text: 'Edit',
                      fontSize: sizerSp(12),
                      fontWeight: FontWeight.bold,
                      textColor: kcPrimaryColor,
                    ),
                  ],
                ),
              ),
              SizedBox(height: sizerSp(20)),
              CustomTextWidget(
                text: 'Phone Number',
                fontSize: sizerSp(16),
                fontWeight: FontWeight.w500,
              ),
              CustomTextWidget(
                text: '+234${userDetails.phoneNumber.toString()}',
                fontSize: sizerSp(12),
                fontWeight: FontWeight.w300,
              ),
              SizedBox(height: sizerSp(20)),
              CustomButton(
                text: 'Proceed',
                onTap: () {
                  if (userDetails.address != null) {
                    callback();
                  } else {
                    CustomSnackBarService.showWarningSnackBar(
                        'Please Enter An Address!');
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class CartItemPriceWidget extends StatefulWidget {
  const CartItemPriceWidget({
    Key? key,
    required this.callback,
  }) : super(key: key);

  static final LocaldatabaseRepo localdatabaseRepo =
      GetIt.instance<LocaldatabaseRepo>();

  final Function() callback;

  @override
  _CartItemPriceWidgetState createState() => _CartItemPriceWidgetState();
}

class _CartItemPriceWidgetState extends State<CartItemPriceWidget> {
  int? fee;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetdeliveryfeeBloc>(context).add(GetFeeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<CartModel>>(
      valueListenable: LocaldatabaseRepo.cartList,
      builder: (
        BuildContext context,
        List<CartModel> cartList,
        Widget? child,
      ) {
        int allProductPrice = 0;

        for (final CartModel cart in cartList) {
          final int currentItemPrice = cart.price;
          final int currentItemCount = cart.count;

          allProductPrice =
              allProductPrice + (currentItemPrice * currentItemCount);
        }

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                onTap: () => widget.callback(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(Icons.edit, size: sizerSp(15), color: kcPrimaryColor),
                    SizedBox(width: sizerSp(5.0)),
                    CustomTextWidget(
                      text: 'Edit',
                      fontSize: sizerSp(12),
                      fontWeight: FontWeight.bold,
                      textColor: kcPrimaryColor,
                    ),
                  ],
                ),
              ),
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
                children: <Widget>[
                  const CustomTextWidget(
                    text: 'Delivery',
                    fontSize: kfsLarge,
                    fontWeight: FontWeight.bold,
                  ),
                  BlocConsumer<GetdeliveryfeeBloc, GetdeliveryfeeState>(
                    listener:
                        (BuildContext context, GetdeliveryfeeState state) {
                      if (state is GetdeliveryfeeError) {
                        CustomSnackBarService.showErrorSnackBar(state.message);
                      } else if (state is GetdeliveryfeeLoaded) {
                        fee = state.fee;
                        setState(() {});
                      }
                    },
                    builder: (BuildContext context, GetdeliveryfeeState state) {
                      if (state is GetdeliveryfeeError) {
                        return InkWell(
                          onTap: () =>
                              BlocProvider.of<GetdeliveryfeeBloc>(context)
                                  .add(GetFeeEvent()),
                          child: CustomTextWidget(
                            text: '\u20A6 Error! Click to Re-try.',
                            fontWeight: FontWeight.w300,
                            fontSize: sizerSp(12),
                          ),
                        );
                      } else if (state is GetdeliveryfeeLoaded) {
                        return CustomTextWidget(
                          text: '\u20A6 ${state.fee}',
                          fontWeight: FontWeight.w300,
                          // fontSize: sizerSp(12),
                        );
                      }

                      return CustomTextWidget(
                        text: '\u20A6 Calculating...',
                        fontWeight: FontWeight.w200,
                        fontSize: sizerSp(12),
                      );
                    },
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
                    text: '\u20A6 ${allProductPrice + (fee ?? 0)}',
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
                      onTap: () =>
                          CartItemPriceWidget.localdatabaseRepo.clearCartItem(),
                      color: Colors.grey[300],
                      textColor: kcTextColor,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: CustomButton(
                      text: 'CHECKOUT',
                      onTap: () {
                        if (cartList.isNotEmpty) {
                          if (fee == null) {
                            CustomSnackBarService.showWarningSnackBar(
                                'Still loading delivery fee');
                            return;
                          }

                          CustomButtomModalService.showModal(
                              AuthenticateUserScreen(fee!));
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        );
      },
    );
  }
}

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({
    Key? key,
    required this.cartItem,
    required this.merchantRepo,
    required this.index,
  }) : super(key: key);

  final CartModel cartItem;
  final int index;
  final MerchantRepo merchantRepo;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Card(
      elevation: 5.0,
      child: SizedBox(
        width: size.width,
        height: sizerSp(80),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: size.width * 0.30,
                height: sizerSp(70),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: CustomImageWidget(
                    imageUrl: cartItem.image,
                    imageTypes: ImageTypes.network,
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: sizerSp(10.0)),
                  CustomTextWidget(
                    text: cartItem.name,
                    fontSize: sizerSp(13),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    maxLines: 1,
                  ),
                  SizedBox(height: sizerSp(2.0)),
                  CustomTextWidget(
                    text: cartItem.fastFoodName ?? 'Restaurant name',
                    fontSize: sizerSp(12),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w300,
                    maxLines: 1,
                  ),
                  SizedBox(height: sizerSp(2.0)),
                  CustomTextWidget(
                    text: '\u20A6 '
                        '${cartItem.price * cartItem.count}',
                    fontWeight: FontWeight.bold,
                    fontSize: sizerSp(20),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: kcPrimaryColor,
                  borderRadius: BorderRadius.circular(sizerSp(10)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CartButton(
                      iconData: Icons.add,
                      callback: () {
                        if (cartItem.count == 10) return;

                        final CartModel updatedCartItem = cartItem.copyWith(
                          count: cartItem.count + 1,
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
                      fontWeight: FontWeight.bold,
                      textColor: Colors.white,
                    ),
                    const SizedBox(width: 10.0),
                    CartButton(
                      iconData: Icons.remove,
                      callback: () {
                        if (cartItem.count == 1) return;

                        final CartModel updatedCartItem = cartItem.copyWith(
                          count: cartItem.count - 1,
                        );

                        merchantRepo.updateCartItem(
                          updatedCartItem,
                          index,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
