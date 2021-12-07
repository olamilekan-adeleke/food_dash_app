import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutterwave/flutterwave.dart';
import 'package:flutterwave/models/responses/charge_response.dart';
import 'package:food_dash_app/cores/utils/config.dart';
import 'package:food_dash_app/cores/utils/locator.dart';
import 'package:food_dash_app/cores/utils/navigator_service.dart';
import 'package:food_dash_app/cores/utils/route_name.dart';
import 'package:food_dash_app/cores/utils/snack_bar_service.dart';
import 'package:food_dash_app/env.dart';
import 'package:food_dash_app/features/auth/model/user_details_model.dart';
import 'package:food_dash_app/features/auth/repo/auth_repo.dart';
import 'package:food_dash_app/features/food/model/paymaent_history.dart';
import 'package:food_dash_app/features/food/repo/food_repo.dart';

import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

const String publicKey = 'pk_test_783f909da670ff1ad0ec676ef617ead054d113e8';
const String secretKey = 'sk_test_33dfdc0d792c01298c04c42bbc2dcabba2bf8913';

class PaymentRepo {
  static final MerchantRepo merchantRepo = locator<MerchantRepo>();
  static AuthenticationRepo authenticationRepo = locator<AuthenticationRepo>();
  static final String currency = FlutterwaveCurrency.NGN;

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().microsecondsSinceEpoch}';
  }

  Future<String> createAccessCode(
    String skTest,
    String _getReference,
    int amount,
    String email,
  ) async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $skTest'
    };

    final Map<String, dynamic> data = <String, dynamic>{
      'amount': amount,
      'email': email,
      'reference': _getReference
    };

    final String payload = json.encode(data);
    final http.Response response = await http.post(
      Uri.parse('https://api.paystack.co/transaction/initialize'),
      headers: headers,
      body: payload,
    );

    final Map<String, dynamic> _data =
        jsonDecode(response.body) as Map<String, dynamic>;
    final String accessCode = Map<String, dynamic>.from(
        _data['data'] as Map<String, dynamic>)['access_code'] as String;

    return accessCode;
  }

  Future<void> _verifyOnServer(
    String? reference, {
    required BuildContext context,
    required bool isWalletTop,
    int? amount,
    bool isForFood = false,
  }) async {
    const String skTest = secretKey;

    if (reference == null) return;

    try {
      final Map<String, String> headers = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $skTest',
      };

      if (isForFood) {
        await CustomNavigationService().show();
      }

      final http.Response response = await http.get(
        Uri.parse('https://api.paystack.co/transaction/verify/$reference'),
        headers: headers,
      );

      final Map<String, dynamic> body =
          json.decode(response.body) as Map<String, dynamic>;

      if (body['data']['status'] == 'success') {
        if (isForFood) {
          CustomSnackBarService.showSuccessSnackBar('Payment SucessFull');
          final PaymentModel paymentModel = PaymentModel(
            id: const Uuid().v1(),
            amount: amount!,
            dateTime: DateTime.now(),
            message: 'Food Purchase',
          );

          String id =
              await merchantRepo.makePayment(0, isWalletTop, cardPayment: true);
          await merchantRepo.addPaymentHistory(paymentModel);

          // await CustomNavigationService().goBack();
          // await CustomNavigationService().goBack();
          // await CustomNavigationService().goBack();
          // await CustomNavigationService().navigateTo(RouteName.hometab);
          CustomNavigationService().popShow();
          await CustomNavigationService().clearTillFirstAndShow(
            RouteName.orderStatus,
            argument: id,
          );


          CustomSnackBarService.showSuccessSnackBar('Payment SucessFull');
        } else {
          CustomSnackBarService.showSuccessSnackBar('Payment SucessFull');
          final PaymentModel paymentModel = PaymentModel(
            id: const Uuid().v1(),
            amount: amount!,
            dateTime: DateTime.now(),
            message: 'Wallet Top up',
          );

          await merchantRepo.updateUserWallet(amount);
          await merchantRepo.addPaymentHistory(paymentModel);

          CustomNavigationService().goBack();
        }
      } else {
        CustomSnackBarService.showErrorSnackBar('Error Occured In Payment');
        CustomNavigationService().goBack();
        throw Exception();
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      CustomSnackBarService.showErrorSnackBar('Error: ${e.toString()}');
    }
  }

  Future<void> chargeCard({
    required int price,
    required BuildContext context,
    required String userEmail,
    required bool isWalletTop,
    bool isForFood = false,
  }) async {
    bool result = false;

    final Charge charge = Charge()
      ..amount = (price * 100).toInt()
      ..reference = _getReference()
      ..accessCode = await createAccessCode(
        secretKey,
        _getReference(),
        (price * 100).toInt(),
        userEmail,
      )
      ..email = userEmail;

    final CheckoutResponse response = await Config.paystackPlugin.checkout(
      context,
      method: CheckoutMethod.card,
      fullscreen: true,
      charge: charge,
    );

    if (response.status == true) {
      await _verifyOnServer(
        response.reference,
        context: context,
        amount: price,
        isForFood: isForFood,
        isWalletTop: isWalletTop,
      );
    } else {
      debugPrint('error');
      CustomSnackBarService.showErrorSnackBar(
        'An Error Occurred Please Try Again!',
      );
    }
  }

  Future<void> chargeBank({
    required int price,
    required BuildContext context,
    required String userEmail,
    bool isForFood = false,
    required bool isWalletTop,
  }) async {
    final Charge charge = Charge()
      ..amount = (price * 100).toInt()
      ..reference = _getReference()
      ..accessCode = await createAccessCode(
        secretKey,
        _getReference(),
        (price * 100).toInt(),
        userEmail,
      )
      ..email = userEmail;

    final CheckoutResponse response = await Config.paystackPlugin.checkout(
      context,
      method: CheckoutMethod.bank,
      fullscreen: true,
      charge: charge,
    );

    if (response.status == true) {
      await _verifyOnServer(
        response.reference,
        context: context,
        amount: price,
        isForFood: isForFood,
        isWalletTop: isWalletTop,
      );
    } else {
      debugPrint('error');
      throw Exception('An Error Occurred Please Try Again!');
    }
  }

  // Future<void> useFlutterWave(BuildContext context, int amount) async {
  //   final UserDetailsModel user = await authenticationRepo.getUser();
  //   final String txRef =
  //       'REF-${DateTime.now().millisecondsSinceEpoch}-${user.email}_';

  //   Flutterwave flutterwave = Flutterwave.forUIPayment(
  //     context: context,
  //     encryptionKey: encrptionKeyFlutterWave,
  //     publicKey: publicKeyFlutterWave,
  //     currency: currency,
  //     amount: amount.toString(),
  //     email: user.email,
  //     fullName: user.fullName,
  //     txRef: txRef,
  //     isDebugMode: true,
  //     phoneNumber: user.phoneNumber.toString(),
  //     acceptCardPayment: true,
  //     acceptUSSDPayment: false,
  //     acceptAccountPayment: false,
  //   );

  //   try {
  //     final ChargeResponse response =
  //         await flutterwave.initializeForUiPayments();
  //     // ignore: unnecessary_null_comparison
  //     if (response == null) {
  //       throw 'Transcation not completed!';
  //     } else {
  //       final bool isSuccessful =
  //           checkPaymentIsSuccessful(response, '$amount', txRef);
  //       if (isSuccessful) {
  //         CustomSnackBarService.showSuccessSnackBar('Payment SucessFull');
  //         final PaymentModel paymentModel = PaymentModel(
  //           id: const Uuid().v1(),
  //           amount: amount,
  //           dateTime: DateTime.now(),
  //           message: 'Wallet Top up',
  //         );

  //         await merchantRepo.deductUserWallet(amount);
  //         await merchantRepo.addPaymentHistory(paymentModel);

  //         CustomNavigationService().goBack();
  //       } else {
  //         // check message
  //         print(response.message);

  //         // check status
  //         print(response.status);

  //         // check processor error
  //         print(response.data!.processorResponse);

  //         CustomSnackBarService.showErrorSnackBar('Error Occured In Payment');
  //         CustomNavigationService().goBack();

  //         throw response.message ?? 'An Error Occured!';
  //       }
  //     }
  //   } catch (e, s) {
  //     debugPrint(e.toString());
  //     debugPrint(s.toString());
  //     CustomSnackBarService.showErrorSnackBar('Error: ${e.toString()}');
  //   }
  // }

  bool checkPaymentIsSuccessful(
    ChargeResponse response,
    String amount,
    String txref,
  ) {
    return response.data!.status == FlutterwaveConstants.SUCCESSFUL &&
        response.data!.currency == currency &&
        response.data!.amount == amount &&
        response.data!.txRef == txref;
  }
}
