import 'package:flutter/material.dart';
import 'package:food_dash_app/cores/components/custom_text_widget.dart';
import 'package:food_dash_app/cores/constants/color.dart';
import 'package:food_dash_app/cores/utils/navigator_service.dart';
import 'package:food_dash_app/cores/utils/route_name.dart';
import 'package:food_dash_app/cores/utils/sizer_utils.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    Key? key,
    required this.iconData,
    required this.title,
  }) : super(key: key);

  const HeaderWidget.appbar(
    this.title,
  ) : iconData = null;

  final IconData? iconData;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        if (iconData != null)
          InkWell(
            onTap: () =>
                CustomNavigationService().navigateTo(RouteName.profileScreen),
            child: Icon(
              iconData,
              size: sizerSp(17),
              color: Colors.black,
            ),
          )
        else
          InkWell(
            onTap: () => CustomNavigationService().goBack(),
            child: CircleAvatar(
              radius: sizerSp(12),
              backgroundColor: kcPrimaryColor,
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios,
                  size: sizerSp(11),
                  color: Colors.white,
                ),
              ),
            ),
          ),
        CustomTextWidget(
          text: title,
          fontSize: sizerSp(20),
          fontWeight: FontWeight.bold,
        ),
        if (iconData != null)
          InkWell(
            onTap: () => CustomNavigationService()
                .navigateTo(RouteName.notificationPage),
            child: CircleAvatar(
              radius: sizerSp(12),
              backgroundColor: kcPrimaryColor,
              child: SizedBox(
                height: sizerSp(15),
                width: sizerSp(15),
                child: Icon(
                  Icons.notifications_none_outlined,
                  color: Colors.white,
                  size: sizerSp(12),
                ),
              ),
            ),
          )
        else
          Container(),
      ],
    );
  }
}

class EdgeInserts {}
