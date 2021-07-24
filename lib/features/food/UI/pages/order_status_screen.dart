import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_dash_app/cores/components/custom_button.dart';
import 'package:food_dash_app/cores/components/custom_circular_progress_indicator.dart';
import 'package:food_dash_app/cores/components/custom_scaffold_widget.dart';
import 'package:food_dash_app/cores/components/custom_text_widget.dart';
import 'package:food_dash_app/cores/utils/emums.dart';
import 'package:food_dash_app/cores/utils/extenions.dart';
import 'package:food_dash_app/cores/utils/locator.dart';
import 'package:food_dash_app/cores/utils/navigator_service.dart';
import 'package:food_dash_app/cores/utils/route_name.dart';
import 'package:food_dash_app/cores/utils/sizer_utils.dart';
import 'package:food_dash_app/features/food/UI/widgets/header_widget.dart';
import 'package:food_dash_app/features/food/model/order_model.dart';
import 'package:food_dash_app/features/food/repo/food_repo.dart';

class OrderStatusScreen extends StatelessWidget {
  const OrderStatusScreen(this.orderId, {Key? key}) : super(key: key);

  static final MerchantRepo merchantRepo = locator<MerchantRepo>();
  final String orderId;

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: sizerSp(10.0)),
        child: ListView(
          children: <Widget>[
            SizedBox(height: sizerSp(20.0)),
            const HeaderWidget(iconData: null, title: 'Order Status'),
            SizedBox(height: sizerSp(20.0)),
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: merchantRepo.orderSteam(orderId),
              builder: (
                BuildContext context,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
              ) {
                if (snapshot.hasData) {
                  final OrderModel order =
                      OrderModel.fromMap(snapshot.data!.data() ?? {});
                  final int index =
                      OrderStatusExtension.eumnToInt(order.orderStatus);
                  // log('data: ${order.toMap()}');
                  log('data: ${order.orderStatus}');
                  log('data: ${index}');

                  return Stepper(
                    controlsBuilder: (
                      BuildContext context, {
                      VoidCallback? onStepContinue,
                      VoidCallback? onStepCancel,
                    }) {
                      return Container();
                    },
                    currentStep: index,
                    steps: <Step>[
                      Step(
                        title: CustomTextWidget(
                          text: 'Order Sent',
                          fontSize: sizerSp(15),
                          fontWeight: FontWeight.bold,
                        ),
                        content: const OrderPendingWidget(),
                        isActive: order.orderStatus == OrderStatusEunm.pending,
                        state:
                            index < 1 ? StepState.indexed : StepState.complete,
                      ),
                      Step(
                        title: CustomTextWidget(
                          text: 'Order Accepted',
                          fontSize: sizerSp(15),
                        ),
                        content: const OrderAcceptedWidget(),
                        isActive: order.orderStatus == OrderStatusEunm.accepted,
                        state:
                            index < 2 ? StepState.indexed : StepState.complete,
                      ),
                      Step(
                        title: CustomTextWidget(
                          text: 'Order Processing',
                          fontSize: sizerSp(15),
                        ),
                        content: const OrderProcessingWidget(),
                        isActive:
                            order.orderStatus == OrderStatusEunm.processing,
                        state:
                            index < 3 ? StepState.indexed : StepState.complete,
                      ),
                      Step(
                        title: CustomTextWidget(
                          text: 'Order Enroute',
                          fontSize: sizerSp(15),
                        ),
                        content: const OrderEnrouteWidget(),
                        isActive: order.orderStatus == OrderStatusEunm.enroute,
                        state:
                            index < 4 ? StepState.indexed : StepState.complete,
                      ),
                      Step(
                        title: CustomTextWidget(
                          text: 'Order Completed',
                          fontSize: sizerSp(15),
                        ),
                        content: OrderCompletedWidget(
                          orderId: order.id,
                          riderId: order.riderDetails?.uid ?? '123456',
                        ),
                        isActive:
                            order.orderStatus == OrderStatusEunm.completed,
                        state:
                            index < 5 ? StepState.indexed : StepState.complete,
                      ),
                    ],
                  );
                }

                return const Center(child: CustomCircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OrderPendingWidget extends StatelessWidget {
  const OrderPendingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SvgPicture.asset(
          'assets/images/loading.svg',
          height: sizerSp(100),
          width: sizerSp(150),
        ),
        SizedBox(height: sizerSp(10.0)),
        CustomTextWidget(
          text: 'Your order has been sent successfully, waiting'
              ' for a rider to accept your order',
          fontSize: sizerSp(12),
          fontWeight: FontWeight.w200,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class OrderAcceptedWidget extends StatelessWidget {
  const OrderAcceptedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SvgPicture.asset(
          'assets/images/confirmed.svg',
          height: sizerSp(100),
          width: sizerSp(150),
        ),
        SizedBox(height: sizerSp(10.0)),
        CustomTextWidget(
          text: 'CONGRATULATIONS!!! \nYour order has been accepted by a rider!',
          fontSize: sizerSp(12),
          fontWeight: FontWeight.w200,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class OrderProcessingWidget extends StatelessWidget {
  const OrderProcessingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SvgPicture.asset(
          'assets/images/processing.svg',
          height: sizerSp(100),
          width: sizerSp(150),
        ),
        SizedBox(height: sizerSp(10.0)),
        CustomTextWidget(
          text: "Resturant's has received your order and have started working"
              ' on it. \nRider is on his way to pick up your order!',
          fontSize: sizerSp(12),
          fontWeight: FontWeight.w200,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class OrderEnrouteWidget extends StatelessWidget {
  const OrderEnrouteWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SvgPicture.asset(
          'assets/images/enroute.svg',
          height: sizerSp(100),
          width: sizerSp(150),
        ),
        SizedBox(height: sizerSp(10.0)),
        CustomTextWidget(
          text: 'Your order has been pickup by the rider. Rider has '
              'picked up your order and is now enroute to your location',
          fontSize: sizerSp(12),
          fontWeight: FontWeight.w200,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class OrderCompletedWidget extends StatelessWidget {
  const OrderCompletedWidget({
    Key? key,
    required this.orderId,
    required this.riderId,
  }) : super(key: key);

  final String orderId;
  final String riderId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SvgPicture.asset(
          'assets/images/delivered.svg',
          height: sizerSp(100),
          width: sizerSp(150),
        ),
        SizedBox(height: sizerSp(10.0)),
        CustomTextWidget(
          text: 'Your order has been completed. Have a great meal!',
          fontSize: sizerSp(12),
          fontWeight: FontWeight.w200,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: sizerSp(10.0)),
        Row(
          children: <Widget>[
            Expanded(
              child: CustomButton(
                text: 'Review',
                onTap: () => CustomNavigationService().navigateTo(
                    RouteName.reviewScreen,
                    argument: <String, dynamic>{
                      'orderId': orderId,
                      'riderId': riderId,
                    }),
              ),
            ),
            SizedBox(width: sizerSp(10.0)),
            Expanded(
              child: CustomButton(
                text: 'Home',
                onTap: () => CustomNavigationService().goBack(),
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
