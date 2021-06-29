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
import 'package:food_dash_app/features/auth/repo/auth_repo.dart';
import 'package:food_dash_app/features/food/UI/pages/selected_merchant_page.dart';
import 'package:food_dash_app/features/food/bloc/merchant_bloc/merchant_bloc.dart';
import 'package:food_dash_app/features/food/model/merchant_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final Size size = MediaQuery.of(context).size;

    return CustomScaffoldWidget(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const CustomTextWidget(
                  text: '   Are You Hungry..?',
                  fontWeight: FontWeight.bold,
                  fontSize: kfsSuperLarge,
                ),
                CustomButton.smallSized(
                  height: 28,
                  width: 60,
                  text: 'LogOut',
                  textSize: kfsVeryTiny,
                  textFontWeight: FontWeight.w300,
                  onTap: () => AuthenticationRepo().signOut(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: <Widget>[
                  const CustomTextWidget(
                    text: '  Search  ',
                    fontSize: kfsLarge,
                  ),
                  Icon(
                    Icons.search_outlined,
                    size: 20,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const SizedBox(
              height: 200,
              child: Placeholder(),
            ),
            // const SizedBox(height: 10),
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
    merchantBloc!.add(GetMerchantsEvents());
    _controller = ScrollController();
    _controller.addListener(() => _scrollListener());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MerchantBloc, MerchantState>(
      listener: (BuildContext context, MerchantState state) {
        if (state is GetMerchantLoadedState) {
          merchants.addAll(state.merchants);
        }
      },
      builder: (BuildContext context, MerchantState state) {
        if (state is GetMerchantLoadingState) {
          if (merchants.isEmpty) {
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
                MerchantList(
                  controller: _controller,
                  merchants: merchants,
                ),
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

        return MerchantList(
          controller: _controller,
          merchants: merchants,
        );
      },
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
    final Size size = MediaQuery.of(context).size;

    return ListView.builder(
      controller: controller,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: merchants.length,
      itemBuilder: (BuildContext context, int index) {
        final MerchantModel merchant = merchants[index];

        return InkWell(
          onTap: () => CustomNavigationService()
              .navigateTo(RouteName.selectedMerchantPage, argument: merchant),
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 15.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  height: 180,
                  width: size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CustomImageWidget(
                      imageUrl: merchant.image,
                      imageTypes: ImageTypes.network,
                    ),
                  ),
                ),
                const SizedBox(height: 5.0),
                CustomTextWidget(
                  text: merchant.name,
                  fontSize: kfsLarge,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 2.0),
                Row(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        );
      },
    );
  }
}
