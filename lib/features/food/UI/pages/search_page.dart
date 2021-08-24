import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:food_dash_app/cores/components/custom_text_widget.dart';
import 'package:food_dash_app/cores/components/custom_textfiled.dart';
import 'package:food_dash_app/cores/components/error_widget.dart';
import 'package:food_dash_app/cores/components/loading_indicator.dart';
import 'package:food_dash_app/cores/utils/navigator_service.dart';
import 'package:food_dash_app/cores/utils/route_name.dart';
import 'package:food_dash_app/cores/utils/sizer_utils.dart';
import 'package:food_dash_app/cores/utils/snack_bar_service.dart';
import 'package:food_dash_app/features/food/UI/widgets/popular_food_widget.dart';
import 'package:food_dash_app/features/food/bloc/merchant_bloc/merchant_bloc.dart';
import 'package:food_dash_app/features/food/model/food_product_model.dart';

class FoodSearchScreen extends StatefulWidget {
  const FoodSearchScreen();

  @override
  _FoodSearchScreenState createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> {
  static final TextEditingController controller = TextEditingController();
  MerchantBloc? merchantBloc;
  final List<FoodProductModel> foodProducts = <FoodProductModel>[];
  late ScrollController _controller;

  void _scrollListener() {
    debugPrint(_controller.position.atEdge.toString());
    debugPrint('dddd');
    if (_controller.position.pixels >= _controller.position.maxScrollExtent) {
      if (merchantBloc!.hasMoreSearch == true &&
          merchantBloc!.searchBusy == false) {
        merchantBloc!.add(SearchEvent(controller.text.trim()));
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
              hintText: 'Search For Food',
              labelText: '',
              textInputAction: TextInputAction.search,
              onDone: () {
                foodProducts.clear();
                BlocProvider.of<MerchantBloc>(context)
                    .add(SearchEvent(controller.text.trim()));
              },
            ),
            SizedBox(height: sizerSp(10)),
            Expanded(
              child: BlocConsumer<MerchantBloc, MerchantState>(
                listener: (BuildContext context, MerchantState state) {
                  if (state is SearchLoadedState) {
                    if (state.search.isEmpty) {
                      CustomSnackBarService.showWarningSnackBar(
                          'No Item Was Found!');
                    }
                    foodProducts.addAll(state.search);
                    log(foodProducts.toString());
                  } else if (state is SearchErrorState) {
                    CustomSnackBarService.showErrorSnackBar(state.message);
                  }
                },
                builder: (BuildContext context, MerchantState state) {
                  if (state is SearchLoadingState && foodProducts.isEmpty) {
                    return Center(
                      child: SizedBox(
                        height: sizerSp(50),
                        width: sizerSp(50),
                        child: const CustomLoadingIndicatorWidget(),
                      ),
                    );
                  } else if (state is SearchErrorState) {
                    return SizedBox(
                      child: CustomErrorWidget(
                        message: state.message,
                        callback: () => merchantBloc!
                            .add(SearchEvent(controller.text.trim())),
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
                            if (state is SearchLoadingState) {
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
    if (foodProducts.isEmpty) {
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
            text: 'Search For Food Items!',
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
      itemCount: foodProducts.length,
      staggeredTileBuilder: (int index) {
        return StaggeredTile.fit(2);
      },
      itemBuilder: (BuildContext context, int index) {
        final FoodProductModel foodProduct = foodProducts[index];

        return ItemWidget(
          foodProduct: foodProduct,
          callback: () => CustomNavigationService().navigateTo(
            RouteName.selectedFoodPage,
            argument: foodProduct,
          ),
        );
      },
    );
  }
}
