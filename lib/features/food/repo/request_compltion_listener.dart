import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_dash_app/cores/components/custom_button.dart';
import 'package:food_dash_app/cores/components/loading_indicator.dart';
import 'package:food_dash_app/cores/utils/snack_bar_service.dart';
import 'package:food_dash_app/features/auth/model/user_details_model.dart';
import 'package:food_dash_app/features/food/model/cart_model.dart';
import 'package:food_dash_app/features/food/model/order_model.dart';
import 'package:food_dash_app/features/food/repo/food_repo.dart';
import 'package:food_dash_app/features/food/repo/local_database_repo.dart';
import 'package:get/get.dart';
import 'package:stacked_services/stacked_services.dart';

class RequestCompletionListener {
  RequestCompletionListener() {
    setUpListener();
  }

  // static final SnackbarService _snackbarService =
  //     GetIt.instance<SnackbarService>();

  static final CollectionReference<Map<String, dynamic>> ordersRef =
      FirebaseFirestore.instance.collection('orders');

  Future<void> setUpListener() async {
    final UserDetailsModel? user =
        await LocaldatabaseRepo().getUserDataFromLocalDB();

    if (user == null) return;

    ordersRef
        .where('user_id', isEqualTo: user.uid.toString())
        .where('pay_status', isEqualTo: 'pending')
        .snapshots()
        .listen((QuerySnapshot event) {
      log('checking for for request_completion');
      log('${event.docs}');
      if (event.docs.isNotEmpty) {
        log('got data for request_completion');

        // pop any prevous opened dialog

        // if (StackedService.navigatorKey!.currentState!.canPop()) {
        //   Navigator.pop(Get.overlayContext!);
        // }

        final Map<String, dynamic> firstData =
            event.docs.first.data() as Map<String, dynamic>;

        Get.defaultDialog(
          title: 'Confrimation Alert',
          content: AlertWidget(firstData),
          barrierDismissible: false,
          radius: 5.0,
          onWillPop: () async => false,
        );
      } else {
        if (StackedService.navigatorKey!.currentState!.canPop()) {
          Navigator.pop(Get.overlayContext!);
        }
      }
    });
  }
}

class AlertWidget extends StatelessWidget {
  const AlertWidget(
    this.data,
  );

  final Map<String, dynamic> data;
  static final ValueNotifier<bool> busy = ValueNotifier<bool>(false);

  void confrim(bool confrim) async {
    busy.value = true;
    try {
      final OrderModel order = OrderModel.fromMap(data);

      await MerchantRepo().completeOrder(order.id, confrim);

      if (StackedService.navigatorKey!.currentState!.canPop()) {
        Navigator.pop(Get.overlayContext!);
      }

      CustomSnackBarService.showSuccessSnackBar('Order Completion Confirmed!');

      busy.value = false;
      // showPopUp(riderId, delivery.id.toString());
    } catch (e) {
      CustomSnackBarService.showErrorSnackBar(e.toString());
      busy.value = false;
    }
    busy.value = false;
  }

  // void showPopUp(String riderId, String orderId) {
  //   Get.bottomSheet(
  //     Rating(riderId, orderId),
  //     // barrierColor: Colors.transparent,
  //     isDismissible: false,
  //     backgroundColor: Colors.black,
  //     elevation: 5.0,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(10),
  //         topRight: Radius.circular(10),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final OrderModel delivery = OrderModel.fromMap(data);

    List<String> items = delivery.items
        .toList()
        .map((CartModel e) => e.name.toString())
        .toList();

    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Your order for ${items.join(', ')} has been marked completed by'
              ' the rider. Click confirm if you have gotten your package.',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontFamily: 'SofiaPro',
                fontSize: 15.0,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ValueListenableBuilder<bool>(
                valueListenable: busy,
                builder: (context, bool loading, _) {
                  if (loading)
                    return Center(
                      child: CustomLoadingIndicatorWidget(),
                    );

                  return Row(
                    children: <Widget>[
                      Expanded(
                        child: CustomButton(
                          onTap: () => confrim(false),
                          text: 'Cancel',
                          color: Colors.grey,
                          textColor: Colors.white,
                          width: double.infinity,
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: CustomButton(
                          text: 'Confrim',
                          onTap: () => confrim(true),
                          color: Colors.black,
                          textColor: Colors.white,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  );
                }),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
