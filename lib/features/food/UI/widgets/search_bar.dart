import 'package:flutter/material.dart';
import 'package:food_dash_app/cores/components/custom_text_widget.dart';
import 'package:food_dash_app/cores/constants/color.dart';
import 'package:food_dash_app/cores/utils/navigator_service.dart';
import 'package:food_dash_app/cores/utils/route_name.dart';
import 'package:food_dash_app/cores/utils/sizer_utils.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CustomNavigationService().navigateTo(RouteName.searchScreen),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: sizerSp(10)),
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.search_outlined,
              size: 20,
              color: Colors.grey[600],
            ),
            SizedBox(width: sizerSp(10)),
            CustomTextWidget(
              text: 'Search',
              fontSize: sizerSp(13.64),
              textColor: kcTextColor.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}
