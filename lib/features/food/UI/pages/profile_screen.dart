import 'package:flutter/material.dart';
import 'package:food_dash_app/cores/components/custom_scaffold_widget.dart';
import 'package:food_dash_app/cores/components/custom_text_widget.dart';
import 'package:food_dash_app/cores/utils/locator.dart';
import 'package:food_dash_app/cores/utils/navigator_service.dart';
import 'package:food_dash_app/cores/utils/route_name.dart';
import 'package:food_dash_app/cores/utils/sizer_utils.dart';
import 'package:food_dash_app/features/auth/model/user_details_model.dart';
import 'package:food_dash_app/features/auth/repo/auth_repo.dart';
import 'package:food_dash_app/features/food/UI/pages/wallet_page.dart';
import 'package:food_dash_app/features/food/UI/widgets/header_widget.dart';
import 'package:food_dash_app/features/food/repo/local_database_repo.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen();

  static final LocaldatabaseRepo localdatabaseRepo =
      locator<LocaldatabaseRepo>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: sizerSp(10)),
        child: Column(
          children: <Widget>[
            SizedBox(height: sizerSp(20.0)),
            const HeaderWidget(iconData: null, title: 'Profile '),
            SizedBox(height: sizerSp(10.0)),
            CircleAvatar(
              backgroundColor: Colors.grey[200],
              radius: sizerSp(45),
              child: Icon(
                Icons.person,
                size: sizerSp(40),
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: sizerSp(20.0)),
            ValueListenableBuilder<UserDetailsModel?>(
              valueListenable: LocaldatabaseRepo.userDetail,
              builder: (
                BuildContext context,
                UserDetailsModel? user,
                Widget? child,
              ) {
                if (user == null) {
                  return Container();
                }

                return Column(
                  children: <Widget>[
                    CustomTextWidget(
                      text: user.fullName,
                      fontSize: sizerSp(14),
                      fontWeight: FontWeight.bold,
                    ),
                    CustomTextWidget(
                      text: user.email,
                      fontSize: sizerSp(13),
                      fontWeight: FontWeight.w200,
                    ),
                    CustomTextWidget(
                      text: user.phoneNumber.toString(),
                      fontSize: sizerSp(13),
                      fontWeight: FontWeight.w200,
                    )
                  ],
                );
              },
            ),
            SizedBox(height: sizerSp(40.0)),
            WalletOptionItemWidget(
              title: 'Edit Profile',
              callback: () => CustomNavigationService()
                  .navigateTo(RouteName.editProfileScreen),
              color: Colors.white,
            ),
            SizedBox(height: sizerSp(10.0)),
            WalletOptionItemWidget(
              title: 'Add Delivery Address',
              callback: () =>
                  CustomNavigationService().navigateTo(RouteName.editAddress),
            ),
            SizedBox(height: sizerSp(10.0)),
            WalletOptionItemWidget(
              title: 'Order History',
              callback: () => CustomNavigationService()
                  .navigateTo(RouteName.oderHistoryScreen),
            ),
            SizedBox(height: sizerSp(10.0)),
            WalletOptionItemWidget(
              title: 'Chnage Password',
              callback: () => CustomNavigationService()
                  .navigateTo(RouteName.changePasswordScreen),
            ),
            SizedBox(height: sizerSp(40.0)),
            WalletOptionItemWidget(
              title: 'Log Out',
              callback: () => AuthenticationRepo().signOut(),
            ),
          ],
        ),
      ),
    );
  }
}
