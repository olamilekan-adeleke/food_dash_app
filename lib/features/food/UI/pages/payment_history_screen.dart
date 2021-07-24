import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_dash_app/cores/components/custom_scaffold_widget.dart';
import 'package:food_dash_app/cores/components/custom_text_widget.dart';
import 'package:food_dash_app/cores/utils/locator.dart';
import 'package:food_dash_app/cores/utils/sizer_utils.dart';
import 'package:food_dash_app/features/auth/repo/auth_repo.dart';
import 'package:food_dash_app/features/food/UI/widgets/header_widget.dart';
import 'package:food_dash_app/features/food/model/paymaent_history.dart';
import 'package:food_dash_app/features/food/repo/food_repo.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen();

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
            const HeaderWidget(iconData: null, title: 'Payment History'),
            SizedBox(height: sizerSp(10.0)),
            PaginateFirestore(
              itemBuilder: (
                int index,
                BuildContext context,
                DocumentSnapshot<Object?> documentSnapshot,
              ) {
                final Map<String, dynamic>? data =
                    documentSnapshot.data() as Map<String, dynamic>?;

                final PaymentModel payment = PaymentModel.fromMap(data!);

                return Card(
                  elevation: 5.0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: sizerSp(5.0),
                      vertical: sizerSp(5.0),
                    ),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomTextWidget(
                            text: '\u20A6 ${payment.amount}',
                            fontSize: sizerSp(16),
                            fontWeight: FontWeight.w500,
                            textColor:
                                payment.paying ? Colors.green : Colors.red,
                          ),
                          CustomTextWidget(
                            text: payment.message,
                          ),
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          CustomTextWidget(
                            text: payment.dateTime.toString().split(' ')[0],
                            fontSize: sizerSp(12),
                            fontWeight: FontWeight.w700,
                          ),
                          CustomTextWidget(
                            text: payment.dateTime
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
                  .collection('payment_history'),
              itemBuilderType: PaginateBuilderType.listView,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            ),
          ],
        ),
      ),
    );
  }
}
