import 'package:flutter/material.dart';
import 'package:food_dash_app/cores/components/custom_scaffold_widget.dart';
import 'package:food_dash_app/cores/utils/sizer_utils.dart';
import 'package:food_dash_app/features/food/UI/widgets/header_widget.dart';
import 'package:food_dash_app/features/food/UI/widgets/market_items_widget.dart';
import 'package:food_dash_app/features/food/UI/widgets/search_bar.dart';

class MarketHomeScreen extends StatelessWidget {
  const MarketHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // shrinkWrap: true,
          // physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            const SizedBox(height: 10),
            const HeaderWidget(
                iconData: Icons.menu_outlined, title: 'Market Place'),
            const SizedBox(height: 10),
            const SearchBarWidget(extra: 'Items'),
            SizedBox(height: sizerSp(10)),
            const MarketItemsWidgets(),
          ],
        ),
      ),
    );
  }
}
