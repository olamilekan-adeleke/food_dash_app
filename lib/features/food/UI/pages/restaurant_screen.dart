import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_dash_app/cores/components/custom_scaffold_widget.dart';
import 'package:food_dash_app/cores/components/custom_text_widget.dart';
import 'package:food_dash_app/cores/components/error_widget.dart';
import 'package:food_dash_app/cores/components/image_widget.dart';
import 'package:food_dash_app/cores/components/loading_indicator.dart';
import 'package:food_dash_app/cores/constants/color.dart';
import 'package:food_dash_app/cores/utils/emums.dart';
import 'package:food_dash_app/cores/utils/navigator_service.dart';
import 'package:food_dash_app/cores/utils/route_name.dart';
import 'package:food_dash_app/cores/utils/sizer_utils.dart';
import 'package:food_dash_app/features/food/UI/widgets/favourite_button.dart';
import 'package:food_dash_app/features/food/UI/widgets/header_widget.dart';
import 'package:food_dash_app/features/food/UI/widgets/search_bar.dart';
import 'package:food_dash_app/features/food/bloc/merchant_bloc/merchant_bloc.dart';
import 'package:food_dash_app/features/food/model/merchant_model.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: sizerSp(10),
          // vertical: sizerSp(10),
        ),
        child: Column(
          // shrinkWrap: true,
          children: <Widget>[
            SizedBox(height: sizerSp(10)),
            const HeaderWidget.appbar('Restaurants'),
            SizedBox(height: sizerSp(10)),
            const SearchBarWidget(),
            SizedBox(height: sizerSp(10)),
            const MerchantListView(),
          ],
        ),
      ),
    );
  }
}

class MerchantListView extends StatefulWidget {
  const MerchantListView({Key? key}) : super(key: key);

  @override
  _MerchantListViewState createState() => _MerchantListViewState();
}

class _MerchantListViewState extends State<MerchantListView> {
  MerchantBloc? merchantBloc;
  final List<MerchantModel> merchants = <MerchantModel>[];
  late ScrollController _controller;

  void _scrollListener() {
    debugPrint(_controller.position.atEdge.toString());
    debugPrint('dddd');
    if (_controller.position.pixels >= _controller.position.maxScrollExtent) {
      if (merchantBloc!.hasMoreMerchant == true &&
          merchantBloc!.merchantBusy == false) {
        merchantBloc!.add(GetMerchantsEvents(false));
      }
    }
  }

  @override
  void initState() {
    super.initState();

    merchantBloc = BlocProvider.of<MerchantBloc>(context);
    merchantBloc!.add(GetMerchantsEvents(true));
    _controller = ScrollController();
    _controller.addListener(() => _scrollListener());
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocConsumer<MerchantBloc, MerchantState>(
        listener: (BuildContext context, MerchantState state) {
          if (state is GetMerchantLoadedState) {
            merchants.addAll(state.merchants);
            log(merchants.toString());
          }
        },
        builder: (BuildContext context, MerchantState state) {
          if (state is GetMerchantLoadingState && merchants.isEmpty) {
            return Column(
              children: const <Widget>[
                SizedBox(height: 100),
                Center(child: CustomLoadingIndicatorWidget()),
              ],
            );
          } else if (state is GetMerchantErrorState) {
            return SizedBox(
              height: 400,
              child: CustomErrorWidget(
                message: state.message,
                callback: () => merchantBloc!.add(GetMerchantsEvents(true)),
              ),
            );
          }

          return Stack(
            children: <Widget>[
              RefreshIndicator(
                onRefresh: () async {
                  merchants.clear();
                  BlocProvider.of<MerchantBloc>(context)
                      .add(GetMerchantsEvents(false));
                },
                child: MerchantList(
                  controller: _controller,
                  merchants: merchants,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: BlocConsumer<MerchantBloc, MerchantState>(
                  listener: (BuildContext context, MerchantState state) {},
                  builder: (BuildContext context, MerchantState state) {
                    if (state is GetPopularFoodLoadingState) {
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
    );
  }
}

class MerchantList extends StatelessWidget {
  const MerchantList({
    Key? key,
    required this.controller,
    required this.merchants,
  }) : super(key: key);

  final ScrollController controller;
  final List<MerchantModel> merchants;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: sizerSp(260),
        childAspectRatio: 0.8,
      ),
      controller: controller,
      // physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: merchants.length,
      itemBuilder: (BuildContext context, int index) {
        final MerchantModel merchant = merchants[index];

        return InkWell(
          onTap: () => CustomNavigationService()
              .navigateTo(RouteName.selectedMerchantPage, argument: merchant),
          child: Container(
            padding: const EdgeInsets.all(2.0),
            child: Card(
              elevation: 5.0,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: sizerSp(2.0),
                      vertical: sizerSp(5.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Center(
                          child: SizedBox(
                            height: sizerSp(77),
                            width: sizerSp(84),
                            child: CustomImageWidget(
                              imageUrl: merchant.image,
                              imageTypes: ImageTypes.network,
                            ),
                          ),
                        ),
                        SizedBox(height: sizerSp(5)),
                        CustomTextWidget(
                          text: merchant.name,
                          maxLines: 1,
                          fontSize: sizerSp(12),
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: sizerSp(10)),
                        CustomTextWidget(
                          text: 'See Meun',
                          fontSize: sizerSp(10),
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.center,
                          textColor: Colors.red,
                        ),
                        SizedBox(height: sizerSp(5)),
                        RatingBar.builder(
                          itemSize: sizerSp(15),
                          allowHalfRating: true,
                          initialRating: merchant.rating,
                          ignoreGestures: true,
                          unratedColor: Colors.grey,
                          onRatingUpdate: (double rate) {},
                          itemBuilder: (_, __) => const Icon(
                            Icons.star,
                            color: kcPrimaryColor,
                          ),
                        ),
                        SizedBox(height: sizerSp(15)),
                      ],
                    ),
                  ),
                  const Align(
                    alignment: Alignment.topRight,
                    child: FavouriteButtonWidget(null, small: true),
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
