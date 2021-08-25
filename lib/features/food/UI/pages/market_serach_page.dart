import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:food_dash_app/cores/components/custom_text_widget.dart';
import 'package:food_dash_app/cores/components/custom_textfiled.dart';
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
import 'package:food_dash_app/features/food/model/market_item_model.dart';

class MarketSearchScreen extends StatefulWidget {
  const MarketSearchScreen();

  @override
  _MarketSearchScreenState createState() => _MarketSearchScreenState();
}

class _MarketSearchScreenState extends State<MarketSearchScreen> {
  static final TextEditingController controller = TextEditingController();
  MerchantBloc? merchantBloc;
  final List<MarketItemModel> items = <MarketItemModel>[];
  late ScrollController _controller;

  void _scrollListener() {
    debugPrint(_controller.position.atEdge.toString());
    debugPrint('dddd');
    if (_controller.position.pixels >= _controller.position.maxScrollExtent) {
      if (merchantBloc!.hasMoreMarketSearch == true &&
          merchantBloc!.searchMarketBusy == false) {
        merchantBloc!.add(SearchMarketEvent(controller.text.trim()));
      }
    }
  }

  @override
  void initState() {
    super.initState();

    merchantBloc = BlocProvider.of<MerchantBloc>(context);
    _controller = ScrollController();
    _controller.addListener(() => _scrollListener());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: sizerSp(10)),
        child: Column(
          children: <Widget>[
            CustomTextField(
              textEditingController: controller,
              hintText: 'Search For Item',
              labelText: '',
              textInputAction: TextInputAction.search,
              onDone: () {
                items.clear();
                BlocProvider.of<MerchantBloc>(context)
                    .add(SearchMarketEvent(controller.text.trim()));
              },
            ),
            SizedBox(height: sizerSp(10)),
            Expanded(
              child: BlocConsumer<MerchantBloc, MerchantState>(
                listener: (BuildContext context, MerchantState state) {
                  if (state is SearchMarketLoadedState) {
                    if (state.search.isEmpty) {
                      CustomSnackBarService.showWarningSnackBar(
                          'No Item Was Found!');
                    }
                    items.addAll(state.search);
                    log(items.toString());
                  } else if (state is SearchMarketErrorState) {
                    CustomSnackBarService.showErrorSnackBar(state.message);
                  }
                },
                builder: (BuildContext context, MerchantState state) {
                  if (state is SearchMarketLoadingState && items.isEmpty) {
                    return Center(
                      child: SizedBox(
                        height: sizerSp(50),
                        width: sizerSp(50),
                        child: const CustomLoadingIndicatorWidget(),
                      ),
                    );
                  } else if (state is SearchMarketErrorState) {
                    return SizedBox(
                      child: CustomErrorWidget(
                        message: state.message,
                        callback: () => merchantBloc!
                            .add(SearchMarketEvent(controller.text.trim())),
                      ),
                    );
                  }

                  return Stack(
                    children: <Widget>[
                      foodItemWidget(),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: BlocConsumer<MerchantBloc, MerchantState>(
                          listener:
                              (BuildContext context, MerchantState state) {},
                          builder: (BuildContext context, MerchantState state) {
                            if (state is SearchMarketLoadingState) {
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget foodItemWidget() {
    if (items.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Icon(
              Icons.search,
              color: Colors.grey.shade200,
              size: 40,
            ),
          ),
          CustomTextWidget(
            text: 'Search For Items!',
            fontSize: sizerSp(16),
            fontWeight: FontWeight.w200,
          ),
        ],
      );
    }

    return StaggeredGridView.countBuilder(
      // gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
      //   maxCrossAxisExtent: sizerSp(260),
      //   childAspectRatio: 0.69,
      // ),
      controller: _controller,
      // physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 4,
      itemCount: items.length,
      staggeredTileBuilder: (int index) {
        return StaggeredTile.fit(2);
      },
      itemBuilder: (BuildContext context, int index) {
        final MarketItemModel marketItemModel = items[index];

        return ItemWidget(
          marketItem: marketItemModel,
          callback: () => CustomNavigationService().navigateTo(
            RouteName.selectedMarketItemPage,
            argument: marketItemModel,
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
