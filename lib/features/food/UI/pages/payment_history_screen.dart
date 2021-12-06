import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_dash_app/cores/components/custom_scaffold_widget.dart';
import 'package:food_dash_app/cores/components/custom_text_widget.dart';
import 'package:food_dash_app/cores/utils/locator.dart';
import 'package:food_dash_app/cores/utils/sizer_utils.dart';
import 'package:food_dash_app/features/auth/repo/auth_repo.dart';
import 'package:food_dash_app/features/food/model/paymaent_history.dart';
import 'package:food_dash_app/features/food/repo/food_repo.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen();

  static AuthenticationRepo authenticationRepo = locator<AuthenticationRepo>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      body: PaginateFirestore(
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
                title: CustomTextWidget(
                  text: payment.message,
                  fontSize: sizerSp(14),
                  fontWeight: FontWeight.w400,
                ),
                subtitle: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CustomTextWidget(
                      text: payment.dateTime
                          .toString()
                          .split(' ')[1]
                          .substring(0, 5),
                      fontSize: sizerSp(12),
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(width: sizerSp(10)),
                    CustomTextWidget(
                      text: payment.dateTime.toString().split(' ')[0],
                      fontSize: sizerSp(12),
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
                trailing: CustomTextWidget(
                  text:
                      '${payment.paying ? '+' : '-'} \u20A6 ${payment.amount}',
                  fontSize: sizerSp(16),
                  fontWeight: FontWeight.w500,
                  textColor: payment.paying ? Colors.green : Colors.red,
                ),
              ),
            ),
          );
        },
        query: MerchantRepo.userCollectionRef
            .doc(authenticationRepo.getUserUid().toString())
            .collection('payment_history')
            .orderBy('dateTime', descending: true),
        itemBuilderType: PaginateBuilderType.listView,
        isLive: true,
        physics: const BouncingScrollPhysics(),
      ),
    );
  }
}
