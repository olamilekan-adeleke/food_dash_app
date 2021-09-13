import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_dash_app/cores/components/custom_text_widget.dart';
import 'package:food_dash_app/cores/components/error_widget.dart';
import 'package:food_dash_app/cores/components/image_widget.dart';
import 'package:food_dash_app/cores/components/loading_indicator.dart';
import 'package:food_dash_app/cores/constants/color.dart';
import 'package:food_dash_app/cores/utils/emums.dart';
import 'package:food_dash_app/cores/utils/navigator_service.dart';
import 'package:food_dash_app/cores/utils/route_name.dart';
import 'package:food_dash_app/cores/utils/sizer_utils.dart';
import 'package:food_dash_app/features/food/bloc/merchant_bloc/merchant_bloc.dart';
import 'package:food_dash_app/features/food/model/merchant_model.dart';

class PopularRestaurantWidgets extends StatefulWidget {
  const PopularRestaurantWidgets({Key? key}) : super(key: key);

  @override
  _PopularRestaurantWidgetsState createState() =>
      _PopularRestaurantWidgetsState();
}

class _PopularRestaurantWidgetsState extends State<PopularRestaurantWidgets> {
  List<MerchantModel> merchants = <MerchantModel>[];

  @override
  void initState() {
    BlocProvider.of<MerchantBloc>(context)
        .add(GetMerchantsEvents(true, isHome: true));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CustomTextWidget(
              text: 'Popular Restaurant',
              fontSize: sizerSp(14),
              fontWeight: FontWeight.bold,
            ),
            InkWell(
              onTap: () => CustomNavigationService()
                  .navigateTo(RouteName.restaurantPage),
              child: CustomTextWidget(
                text: 'See All ',
                fontSize: sizerSp(12),
                textColor: kcPrimaryColor,
              ),
            ),
          ],
        ),
        SizedBox(height: sizerSp(5)),
        SizedBox(
          width: double.infinity,
          height: sizerSp(40),
          child: BlocConsumer<MerchantBloc, MerchantState>(
            listener: (BuildContext context, MerchantState state) {
              if (state is GetMerchantLoadedState) {
                merchants = state.merchants;
              }
            },
            builder: (BuildContext context, MerchantState state) {
              if (state is GetMerchantLoadingState &&
                  state.isHome != null &&
                  state.isHome == true) {
                return const Center(child: CustomLoadingIndicatorWidget());
              } else if (state is GetMerchantErrorState) {
                return CustomErrorWidget(
                  message: 'Opps, an error occurred!',
                  callback: () => BlocProvider.of<MerchantBloc>(context)
                      .add(GetMerchantsEvents(true, isHome: true)),
                );
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: merchants.length,
                itemBuilder: (BuildContext context, int index) {
                  return PopularRestaurantItemWidget(merchants[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class PopularRestaurantItemWidget extends StatelessWidget {
  const PopularRestaurantItemWidget(this.merchant, {Key? key})
      : super(key: key);

  final MerchantModel merchant;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => CustomNavigationService().navigateTo(
        RouteName.selectedMerchantPage,
        argument: merchant,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: sizerSp(10),
          vertical: sizerSp(5),
        ),
        margin: EdgeInsets.only(right: sizerSp(10)),
        decoration: BoxDecoration(
          color: kcPrimaryColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(sizerSp(5.0)),
        ),
        height: sizerSp(50),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CustomImageWidget(
              imageUrl: merchant.image,
              imageTypes: ImageTypes.network,
            ),
            SizedBox(width: sizerSp(5)),
            CustomTextWidget(
              text: merchant.name,
              fontSize: sizerSp(10),
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}
