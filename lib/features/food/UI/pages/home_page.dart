import 'package:flutter/material.dart';
import 'package:food_dash_app/cores/components/custom_scaffold_widget.dart';
import 'package:food_dash_app/cores/components/custom_text_widget.dart';
import 'package:food_dash_app/cores/utils/sizer_utils.dart';
import 'package:food_dash_app/features/food/UI/pages/selected_merchant_page.dart';
import 'package:food_dash_app/features/food/UI/widgets/header_widget.dart';
import 'package:food_dash_app/features/food/UI/widgets/popular_food_widget.dart';
import 'package:food_dash_app/features/food/UI/widgets/popular_resturant_widget.dart';
import 'package:food_dash_app/features/food/UI/widgets/search_bar.dart';

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
            const HeaderWidget(iconData: Icons.menu_outlined, title: 'Home'),
            const SizedBox(height: 10),
            const SearchBarWidget(),
            SizedBox(height: sizerSp(10)),
            const PopularRestaurantWidgets(),
            SizedBox(height: sizerSp(10)),
            CustomTextWidget(
              text: 'Most Popular Foods',
              fontSize: sizerSp(16),
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: sizerSp(5)),
            const PopularFoodWidgets(),

            // const SizedBox(height: 10),
            // const MerchantListView(),
          ],
        ),
      ),
    );
  }
}
