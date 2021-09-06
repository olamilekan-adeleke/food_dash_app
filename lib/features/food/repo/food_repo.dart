import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_dash_app/cores/utils/currency_formater.dart';
import 'package:food_dash_app/cores/utils/snack_bar_service.dart';
import 'package:food_dash_app/features/auth/model/user_details_model.dart';
import 'package:food_dash_app/features/auth/repo/auth_repo.dart';
import 'package:food_dash_app/features/food/model/cart_model.dart';
import 'package:food_dash_app/features/food/model/food_product_model.dart';
import 'package:food_dash_app/features/food/model/market_item_model.dart';
import 'package:food_dash_app/features/food/model/merchant_model.dart';
import 'package:food_dash_app/features/food/model/order_model.dart';
import 'package:food_dash_app/features/food/model/paymaent_history.dart';
import 'package:food_dash_app/features/food/repo/local_database_repo.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

class MerchantRepo {
  static AuthenticationRepo authenticationRepo =
      GetIt.instance<AuthenticationRepo>();
  static LocaldatabaseRepo localdatabaseRepo =
      GetIt.instance<LocaldatabaseRepo>();
  static final CollectionReference<Map<String, dynamic>> foodCollectionRef =
      FirebaseFirestore.instance.collection('food_items');
  static final CollectionReference<Map<String, dynamic>>
      restaurantCollectionRef =
      FirebaseFirestore.instance.collection('restaurants');
  static final CollectionReference<Map<String, dynamic>> userCollectionRef =
      FirebaseFirestore.instance.collection('users');
  static final CollectionReference<Map<String, dynamic>> orderCollectionRef =
      FirebaseFirestore.instance.collection('orders');
  static final CollectionReference<Map<String, dynamic>> riderCollectionRef =
      FirebaseFirestore.instance.collection('riders');

  static final CollectionReference<Map<String, dynamic>>
      constantsCollectionRef =
      FirebaseFirestore.instance.collection('constants');

  static final CollectionReference<Map<String, dynamic>> marketRef =
      FirebaseFirestore.instance.collection('market');

  final int limit = 7;

  Future<List<MerchantModel>> getMerchant({MerchantModel? lastMerchant}) async {
    final List<MerchantModel> merchants = <MerchantModel>[];

    Query<Map<String, dynamic>> query = restaurantCollectionRef
        .orderBy('name')
        .orderBy('number_of_ratings')
        .limit(limit);

    if (lastMerchant != null) {
      query = query.startAfter(
        <dynamic>[lastMerchant.name, lastMerchant.numberOfRating],
      );
    }

    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get(
      const GetOptions(source: Source.server),
    );

    merchants.addAll(
      querySnapshot.docs.map(
        (QueryDocumentSnapshot<Map<String, dynamic>> data) =>
            MerchantModel.fromMap(data.data(), data.id),
      ),
    );

    return merchants;
  }

  Future<List<FoodProductModel>> getFoodProduct(String merchantId,
      {FoodProductModel? lastFoodProduct}) async {
    final List<FoodProductModel> merchants = <FoodProductModel>[];

    Query<Map<String, dynamic>> query = foodCollectionRef
        .where('fast_food_id', isEqualTo: merchantId)
        .orderBy('name')
        .limit(limit);

    if (lastFoodProduct != null) {
      query = query.startAfter(
        <String>[lastFoodProduct.name],
      );
    }

    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get(
      const GetOptions(source: Source.server),
    );

    merchants.addAll(
      querySnapshot.docs.map(
        (QueryDocumentSnapshot<Map<String, dynamic>> data) {
          return FoodProductModel.fromMap(data.data(), data.id);
        },
      ),
    );

    return merchants;
  }

  Future<List<MarketItemModel>> getMarketItem(
      MarketItemModel? lastMarketItme) async {
    final List<MarketItemModel> marketItems = <MarketItemModel>[];

    Query<Map<String, dynamic>> query = marketRef.orderBy('id').limit(limit);

    if (lastMarketItme != null) {
      query = query.startAfter(
        <String>[lastMarketItme.id],
      );
    }

    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get(
      const GetOptions(source: Source.server),
    );

    marketItems.addAll(
      querySnapshot.docs.map(
        (QueryDocumentSnapshot<Map<String, dynamic>> data) {
          return MarketItemModel.fromMap(data.data());
        },
      ),
    );

    return marketItems;
  }

  Future<List<FoodProductModel>> getTopFoodProduct({
    FoodProductModel? lastFoodProduct,
  }) async {
    final List<FoodProductModel> merchants = <FoodProductModel>[];

    Query<Map<String, dynamic>> query =
        foodCollectionRef.orderBy('likes_count', descending: true).limit(limit);

    if (lastFoodProduct != null) {
      query = query.startAfter(
        <String>[lastFoodProduct.name],
      );
    }

    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get(
      const GetOptions(source: Source.server),
    );

    merchants.addAll(
      querySnapshot.docs.map(
        (QueryDocumentSnapshot<Map<String, dynamic>> data) {
          return FoodProductModel.fromMap(data.data(), data.id);
        },
      ),
    );

    return merchants;
  }

  Future<void> addToFavourite(FoodProductModel foodProductModel) async {
    final String? userId = authenticationRepo.getUserUid();

    await userCollectionRef
        .doc(userId)
        .collection('favourites')
        .doc(foodProductModel.id)
        .set(foodProductModel.toMap());
  }

  Future<void> removeFromFavourite(String foodProductId) async {
    final String? userId = authenticationRepo.getUserUid();

    await userCollectionRef
        .doc(userId)
        .collection('favourites')
        .doc(foodProductId)
        .delete();
  }

  Future<void> addToCart(CartModel foodProductModel) async {
    try {
      await localdatabaseRepo.saveItemToCart(foodProductModel);
    } catch (e, s) {
      debugPrint(s.toString());
      throw Exception(e.toString());
    }
  }

  Future<void> addToCartMarket(CartModel foodProductModel) async {
    try {
      await localdatabaseRepo.saveMarketItemToCart(foodProductModel);
    } catch (e, s) {
      debugPrint(s.toString());
      throw Exception(e.toString());
    }
  }

  Future<void> updateCartItem(CartModel foodProductModel, int index) async {
    try {
      await localdatabaseRepo.updateCartItem(foodProductModel);
    } catch (e, s) {
      debugPrint(s.toString());
      throw Exception(e.toString());
    }
  }

  Future<void> updateMarketCartItem(
      CartModel foodProductModel, int index) async {
    try {
      await localdatabaseRepo.updateMarketCartItem(foodProductModel);
    } catch (e, s) {
      debugPrint(s.toString());
      throw Exception(e.toString());
    }
  }

  Future<void> removeFromCart(int index) async {
    try {
      await localdatabaseRepo.deleteCartItem(index);
    } catch (e, s) {
      debugPrint(s.toString());
      throw Exception(e.toString());
    }
  }

  Future<void> removeMarketFromCart(int index) async {
    try {
      await localdatabaseRepo.deleteMarketCartItem(index);
    } catch (e, s) {
      debugPrint(s.toString());
      throw Exception(e.toString());
    }
  }

  Future<List<CartModel>> getCart() async {
    final List<CartModel> cartList = <CartModel>[];

    try {
      await localdatabaseRepo.getAllItemInCart();
    } catch (e, s) {
      debugPrint(s.toString());
      throw Exception(e.toString());
    }

    return cartList;
  }

  Future<List<CartModel>> getMarketCart() async {
    final List<CartModel> cartList = <CartModel>[];

    try {
      await localdatabaseRepo.getAllMarketItemInCart();
    } catch (e, s) {
      debugPrint(s.toString());
      throw Exception(e.toString());
    }

    return cartList;
  }

  Future<List<FoodProductModel>> getFavourites() async {
    final List<FoodProductModel> cartList = <FoodProductModel>[];
    final String? userUid = authenticationRepo.getUserUid();

    final Query<Map<String, dynamic>> query =
        userCollectionRef.doc(userUid).collection('favourites').orderBy('name');

    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get(
      const GetOptions(source: Source.server),
    );

    cartList.addAll(
      querySnapshot.docs.map(
        (QueryDocumentSnapshot<Map<String, dynamic>> data) =>
            FoodProductModel.fromMap(data.data(), data.id),
      ),
    );

    return cartList;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> userWalletStream() async* {
    final String? userUid = authenticationRepo.getUserUid();

    yield* userCollectionRef.doc(userUid).snapshots();
  }

  Future<String> sendOrder(int deliveryFee) async {
    final String id = const Uuid().v1();
    int totalPrice = 0;
    List<CartModel> items = <CartModel>[];
    String type = 'food';

    final UserDetailsModel? userDetails =
        await localdatabaseRepo.getUserDataFromLocalDB();

    if (localdatabaseRepo.showFood.value) {
      totalPrice = await localdatabaseRepo.getTotalCartItemPrice();
      items = await localdatabaseRepo.getAllItemInCart();
      type = 'food';
    } else {
      totalPrice = await localdatabaseRepo.getTotalMarketCartItemPrice();
      items = await localdatabaseRepo.getAllMarketItemInCart();
      type = 'market';
    }

    final OrderModel order = OrderModel(
      id: id,
      items: items,
      userDetails: userDetails!,
      timestamp: Timestamp.now(),
      deliveryFee: deliveryFee,
      type: type,
      itemsFee: totalPrice,
    );

    await orderCollectionRef.doc(id).set(order.toMap());
    return id;
  }

  Future<void> deductUserWallet(int amount) async {
    final String? userUid = authenticationRepo.getUserUid();
    final int deliveryFee = await getDeliveryFee();

    await userCollectionRef.doc(userUid).update(
      <String, dynamic>{
        'wallet_balance': FieldValue.increment((amount + deliveryFee)),
      },
    );
  }

  Future<void> checkUserWalletBalance() async {
    final String? userUid = authenticationRepo.getUserUid();
    int totalPrice = 0;

    if (localdatabaseRepo.showFood.value) {
      totalPrice = await localdatabaseRepo.getTotalCartItemPrice();
    } else {
      totalPrice = await localdatabaseRepo.getTotalMarketCartItemPrice();
    }

    final PaymentModel paymentModel = PaymentModel(
      id: const Uuid().v1(),
      amount: totalPrice,
      dateTime: DateTime.now(),
      message: 'Payment for food',
      paying: false,
    );

    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await userCollectionRef
            .doc(userUid)
            .get(const GetOptions(source: Source.server));

    final UserDetailsModel userDetails =
        UserDetailsModel.fromMap(documentSnapshot.data());

    if (userDetails.walletBalance!.toInt() > totalPrice) {
      await deductUserWallet(-totalPrice);
      await addPaymentHistory(paymentModel);
    } else {
      throw Exception(
        'Wallet Balance is too low. \nAvaliable Balance: '
        '\u20A6 ${currencyFormatter(userDetails.walletBalance!.toInt())}',
      );
    }
  }

  Future<String> makePayment(String password, int deliveryFee) async {
    String id = '';

    try {
      final bool isAuthenticated =
          await authenticationRepo.authenticateUser(password);

      if (isAuthenticated) {
        await checkUserWalletBalance();

        id = await sendOrder(deliveryFee);

        if (localdatabaseRepo.showFood.value) {
          await localdatabaseRepo.clearCartItem();
        } else {
          await localdatabaseRepo.clearMarketCartItem();
        }

        CustomSnackBarService.showSuccessSnackBar(
            'Paymennt Successful, Order has been placed!');
      } else {
        CustomSnackBarService.showErrorSnackBar(
            'Opps, An Error Occured, Please Try Again!');
        throw Exception('Opps, An Error Occured, Please Try Again!');
      }
    } catch (err, s) {
      debugPrint(err.toString());
      debugPrint(s.toString());

      CustomSnackBarService.showErrorSnackBar(
        err.toString(),
        duration: const Duration(seconds: 2),
      );
      throw Exception(err.toString());
    }

    return id;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> orderSteam(String id) async* {
    yield* orderCollectionRef.doc(id).snapshots();
  }

  Future<void> rateRider(String orderId, String riderId, double rating) async {
    final WriteBatch writeBatch = FirebaseFirestore.instance.batch();
    double averageRating;

    try {
      final DocumentSnapshot<Map<String, dynamic>> orderDocumentSnapshot =
          await orderCollectionRef
              .doc(orderId)
              .get(const GetOptions(source: Source.server));

      final OrderModel order =
          OrderModel.fromMap(orderDocumentSnapshot.data()!);

      if (order.hasRated!) {
        throw Exception('Rider Has Already Been Rated By You!');
      }

      log(riderId);
      final DocumentSnapshot<Map<String, dynamic>> riderDocumentSnapshot =
          await riderCollectionRef
              .doc(riderId)
              .get(const GetOptions(source: Source.server));

      final double riderAverageRating =
          double.parse(riderDocumentSnapshot.data()!['rating'].toString());

      if (riderAverageRating == 0) {
        averageRating = rating;
      } else {
        averageRating = (riderAverageRating + rating) / 2;
      }

      writeBatch.update(
        orderCollectionRef.doc(orderId),
        <String, dynamic>{'has_rated': true},
      );

      writeBatch.update(
        riderCollectionRef.doc(riderId),
        <String, dynamic>{'rating': averageRating},
      );

      await writeBatch.commit();
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      throw Exception(e.toString());
    }
  }

  Future<void> addPaymentHistory(PaymentModel paymentModel) async {
    final String? userId = authenticationRepo.getUserUid();

    try {
      await userCollectionRef
          .doc(userId)
          .collection('payment_history')
          .doc(paymentModel.id)
          .set(paymentModel.toMap());
    } on Exception catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      throw Exception(e.toString());
    }
  }

  Future<List<FoodProductModel>> search(String query,
      {FoodProductModel? foodProduct}) async {
    List<FoodProductModel> foods;

    final Query<Map<String, dynamic>> _query = foodCollectionRef
        .where('search_key', arrayContains: query)
        .orderBy('fast_food_id', descending: true)
        .limit(limit);

    try {
      if (foodProduct != null) {
        _query.startAfter(<String>[foodProduct.fastFoodId]);
      }

      final QuerySnapshot<Map<String, dynamic>> queryDocumentSnapshot =
          await _query.get();

      foods = queryDocumentSnapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> e) =>
              FoodProductModel.fromMap(e.data(), e.id))
          .toList();
    } on Exception catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      throw Exception(e.toString());
    }

    return foods;
  }

  Future<List<MarketItemModel>> searchMarket(String query,
      {MarketItemModel? marketItem}) async {
    List<MarketItemModel> items;

    final Query<Map<String, dynamic>> _query = marketRef
        .where('search_key', arrayContains: query)
        .orderBy('name')
        .limit(limit);

    try {
      if (marketItem != null) {
        _query.startAfter(<String>[marketItem.name]);
      }

      final QuerySnapshot<Map<String, dynamic>> queryDocumentSnapshot =
          await _query.get();

      items = queryDocumentSnapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> e) =>
              MarketItemModel.fromMap(e.data()))
          .toList();
    } on Exception catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      throw Exception(e.toString());
    }

    return items;
  }

  Future<int> getDeliveryFee() async {
    final UserDetailsModel userDetails = await authenticationRepo.getUser();
    final String? region = userDetails.region?.split('-')[1].trim() ?? null;
    final String? location = userDetails.region?.split('-')[0].trim() ?? null;

    if (region == null || location == null) {
      throw 'Location Not Found! \nPlease Select a location.';
    }

    log(userDetails.region!);

    final DocumentSnapshot<Map<String, dynamic>> data =
        await constantsCollectionRef.doc('delivery_prices').get();

    log(data.data().toString());
    final Map<String, dynamic> allRegionPriceMap =
        data.data() as Map<String, dynamic>;

    final Map<String, dynamic> regionPriceMap = allRegionPriceMap[region];
    final int locationPriceFormRegion = regionPriceMap[location] as int;

    return locationPriceFormRegion;
  }

  Future<void> completeOrder(String id, bool status) async {
    await orderCollectionRef
        .doc(id)
        .update(<String, dynamic>{'pay_status': status ? 'confrim' : 'cancel'});
  }
}
