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
import 'package:food_dash_app/features/food/model/notification_model.dart';
import 'package:food_dash_app/features/food/repo/food_repo.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  static final AuthenticationRepo authenticationRepo =
      locator<AuthenticationRepo>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: sizerSp(10)),
        child: ListView(
          // physics: const BouncingScrollPhysics(),
          children: <Widget>[
            SizedBox(height: sizerSp(20.0)),
            const HeaderWidget(iconData: null, title: 'Notifications'),
            SizedBox(height: sizerSp(10.0)),
            PaginateFirestore(
              itemBuilder: (
                int index,
                BuildContext context,
                DocumentSnapshot<Object?> documentSnapshot,
              ) {
                final Map<String, dynamic>? data =
                    documentSnapshot.data() as Map<String, dynamic>?;

                final NotificationModel order =
                    NotificationModel.fromMap(data!);

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
                        argument: order.orderId,
                      ),
                      title: CustomTextWidget(
                        text: '${order.body} \n${foodNameList.join(', ')} '
                            'from ${fastFoodNameList.join(', ')}',
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          CustomTextWidget(
                            text: order.timestamp
                                .toDate()
                                .toString()
                                .split(' ')[0],
                            fontSize: sizerSp(12),
                            fontWeight: FontWeight.w700,
                          ),
                          CustomTextWidget(
                            text: order.timestamp
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
              query: MerchantRepo.userCollectionRef
                  .doc(authenticationRepo.getUserUid().toString())
                  .collection('notifications')
                  .orderBy('timestamp', descending: true),
              itemBuilderType: PaginateBuilderType.listView,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemsPerPage: 10,
            ),
          ],
        ),
      ),
    );
  }
}
