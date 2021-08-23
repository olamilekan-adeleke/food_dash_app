import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_dash_app/cores/components/custom_scaffold_widget.dart';
import 'package:food_dash_app/cores/components/custom_text_widget.dart';
import 'package:food_dash_app/cores/utils/locator.dart';
import 'package:food_dash_app/cores/utils/navigator_service.dart';
import 'package:food_dash_app/cores/utils/route_name.dart';
import 'package:food_dash_app/cores/utils/sizer_utils.dart';
import 'package:food_dash_app/features/auth/repo/auth_repo.dart';
import 'package:food_dash_app/features/food/UI/widgets/header_widget.dart';
import 'package:food_dash_app/features/food/model/cart_model.dart';
import 'package:food_dash_app/features/food/model/order_model.dart';
import 'package:food_dash_app/features/food/repo/food_repo.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen();

  static AuthenticationRepo authenticationRepo = locator<AuthenticationRepo>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: sizerSp(10)),
        child: ListView(
          // physics: const BouncingScrollPhysics(),
          children: <Widget>[
            SizedBox(height: sizerSp(20.0)),
            const HeaderWidget(iconData: null, title: 'Order History'),
            SizedBox(height: sizerSp(10.0)),
            PaginateFirestore(
              itemBuilder: (
                int index,
                BuildContext context,
                DocumentSnapshot<Object?> documentSnapshot,
              ) {
                final Map<String, dynamic>? data =
                    documentSnapshot.data() as Map<String, dynamic>?;

                final OrderModel order = OrderModel.fromMap(data!);
                final List<String> foodNameList =
                    order.items.map((CartModel cart) => cart.name).toList();
                final List<String?> fastFoodNameList = order.items
                    .map((CartModel cart) => cart.fastFoodName)
                    .toList();

                return Card(
                  elevation: 5.0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: sizerSp(5.0),
                      vertical: sizerSp(5.0),
                    ),
                    child: ListTile(
                      onTap: () => CustomNavigationService().navigateTo(
                        RouteName.orderStatus,
                        argument: order.id,
                      ),
                      title: CustomTextWidget(
                        text: 'Food order of ${foodNameList.join(', ')},'
                            ' from ${fastFoodNameList.join(', ')}',
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          CustomTextWidget(
                            text: order.timestamp!
                                .toDate()
                                .toString()
                                .split(' ')[0],
                            fontSize: sizerSp(12),
                            fontWeight: FontWeight.w700,
                          ),
                          CustomTextWidget(
                            text: order.timestamp!
                                .toDate()
                                .toString()
                                .split(' ')[1]
                                .substring(0, 5),
                            fontSize: sizerSp(12),
                            fontWeight: FontWeight.w700,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              query: MerchantRepo.orderCollectionRef
                  .where('user_id', isEqualTo: authenticationRepo.getUserUid())
                  .orderBy('timestamp', descending: true),
              itemBuilderType: PaginateBuilderType.listView,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemsPerPage: 10,
              isLive: true,
            ),
          ],
        ),
      ),
    );
  }
}
