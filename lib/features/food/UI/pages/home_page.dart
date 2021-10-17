import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_dash_app/cores/components/custom_scaffold_widget.dart';
import 'package:food_dash_app/cores/components/custom_text_widget.dart';
import 'package:food_dash_app/cores/utils/sizer_utils.dart';
import 'package:food_dash_app/features/food/UI/widgets/header_widget.dart';
import 'package:food_dash_app/features/food/UI/widgets/popular_food_widget.dart';
import 'package:food_dash_app/features/food/UI/widgets/popular_resturant_widget.dart';
import 'package:food_dash_app/features/food/UI/widgets/search_bar.dart';
import 'package:food_dash_app/features/food/bloc/merchant_bloc/merchant_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController _controller;

  void _scrollListener() {
    final MerchantBloc merchantBloc = BlocProvider.of<MerchantBloc>(context);
    debugPrint(_controller.position.atEdge.toString());
    debugPrint('dddd');
    if (_controller.position.pixels >= _controller.position.maxScrollExtent) {
      if (merchantBloc.hasMoreFavFood == true &&
          merchantBloc.foodFavBusy == false) {
        merchantBloc.add(GetPopularFoodEvents());
      }
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    BlocProvider.of<MerchantBloc>(context).add(GetPopularFoodEvents());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SizedBox(
          height: sizerHeight(98),
          child: RefreshIndicator(
            onRefresh: () async {},
            child: Stack(
              children: <Widget>[
                ListView(
                  controller: _controller,
                  addAutomaticKeepAlives: true,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: <Widget>[
                    SizedBox(height: sizerSp(10)),
                    const HeaderWidget(
                      iconData: Icons.menu_outlined,
                      title: 'Fast Food',
                    ),
                    SizedBox(height: sizerSp(10)),
                    const SearchBarWidget(extra: 'for food'),
                    SizedBox(height: sizerSp(10)),
                    const PopularRestaurantWidgets(),
                    SizedBox(height: sizerSp(10)),
                    CustomTextWidget(
                      text: 'Most Popular Foods',
                      fontSize: sizerSp(14),
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: sizerSp(5)),
                    const PopularFoodWidgets(),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: BlocConsumer<MerchantBloc, MerchantState>(
                    listener: (BuildContext context, MerchantState state) {},
                    builder: (BuildContext context, MerchantState state) {
                      if (state is GetPopularFoodLoadingState) {
                        return Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
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
            ),
          ),
        ),
      ),
    );
  }
}
