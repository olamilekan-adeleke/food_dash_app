import 'package:flutter/material.dart';
import 'package:food_dash_app/cores/components/custom_scaffold_widget.dart';
import 'package:food_dash_app/cores/components/custom_text_widget.dart';
import 'package:food_dash_app/cores/utils/sizer_utils.dart';
import 'package:food_dash_app/features/food/UI/widgets/favourite_food_list_widet.dart';
import 'package:food_dash_app/features/food/UI/widgets/header_widget.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: sizerSp(10)),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // shrinkWrap: true,
          children: <Widget>[
            SizedBox(height: sizerSp(10)),
            const HeaderWidget(iconData: Icons.menu, title: 'Favourites'),
            SizedBox(height: sizerSp(20)),
            // CustomTextWidget(
            //   text: 'Favourites Restaurants',
            //   fontSize: sizerSp(16),
            //   fontWeight: FontWeight.bold,
            // ),
            // SizedBox(height: sizerSp(5)),
            // SizedBox(
            //   height: sizerSp(80),
            //   child: ListView.builder(
            //     scrollDirection: Axis.horizontal,
            //     shrinkWrap: true,
            //     itemCount: 4,
            //     itemBuilder: (BuildContext context, int index) {
            //       return Container(
            //         margin: EdgeInsets.only(right: sizerSp(10)),
            //         width: sizerSp(100),
            //         child:
            //             const Placeholder(color: kcTextColor,
            // strokeWidth: 1.5),
            //       );
            //     },
            //   ),
            // ),
            // SizedBox(height: sizerSp(20)),
            CustomTextWidget(
              text: 'Favourites Food',
              fontSize: sizerSp(14),
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: sizerSp(5)),
            const FavouriteFoodListWidget(),
          ],
        ),
      ),
    );
  }
}
