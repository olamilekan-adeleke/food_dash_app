import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:food_dash_app/features/auth/model/user_details_model.dart';
import 'package:food_dash_app/features/food/model/cart_model.dart';
// import 'package:hive/hive.dart';

import 'package:get_storage/get_storage.dart';

class LocaldatabaseRepo {
  static const String userDataBoxName = 'user_data';
  static const String cartName = 'cart';
  static const String marketName = 'market';
  static final GetStorage box = GetStorage('box');
  static final ValueNotifier<List<CartModel>> cartList =
      ValueNotifier<List<CartModel>>(<CartModel>[]);

      static final ValueNotifier<List<CartModel>> marketCartList =
      ValueNotifier<List<CartModel>>(<CartModel>[]);
  static final ValueNotifier<UserDetailsModel?> userDetail =
      ValueNotifier<UserDetailsModel?>(null);

      ValueNotifier<bool> showFood = ValueNotifier<bool>(true);

  Future<void> saveUserDataToLocalDB(Map<String, dynamic> data) async {
    await box.write(userDataBoxName, data);
  }

  Future<void> deleteUserDataToLocalDB() async {
    await box.remove(userDataBoxName);
    userDetail.value = null;
  }

  Future<void> updateAddress(String address) async {
    UserDetailsModel? userDetails = await getUserDataFromLocalDB();
    userDetails = userDetails!.copyWith(address: address);

    await saveUserDataToLocalDB(userDetails.toMapForLocalDb());
  }

  Future<UserDetailsModel?> getUserDataFromLocalDB() async {
    final Map<String, dynamic>? _userData =
        box.read(userDataBoxName) as Map<String, dynamic>?;

    if (_userData == null) {
      return null;
    }

    return UserDetailsModel.fromMap(_userData);
  }

  Future<List<CartModel>> getAllItemInCart() async {
    List<CartModel> _cartList = <CartModel>[];
    final List<dynamic> _cartListMap = box.read(cartName) ?? <dynamic>[];

    // _cartListMap ??= <List<Object>>[];

    // ignore: join_return_with_assignment

    if (_cartListMap.isNotEmpty) {
      _cartList = _cartListMap
          .map((dynamic data) => CartModel.fromMap(
                data as Map<String, dynamic>,
                data['id'] as String,
              ))
          .toList();
    }

    return _cartList;
  }

  Future<List<CartModel>> getAllMarketItemInCart() async {
    List<CartModel> _cartList = <CartModel>[];
    final List<dynamic> _cartListMap = box.read(marketName) ?? <dynamic>[];

    // _cartListMap ??= <List<Object>>[];

    // ignore: join_return_with_assignment

    if (_cartListMap.isNotEmpty) {
      _cartList = _cartListMap
          .map((dynamic data) => CartModel.fromMap(
                data as Map<String, dynamic>,
                data['id'] as String,
              ))
          .toList();
    }

    return _cartList;
  }

  Future<void> saveItemToCart(CartModel cart) async {
    final Map<String, dynamic> data = cart.toMapForLocalDb();
    data.remove('timestamp');

    final List<CartModel> _cartList = await getAllItemInCart();
    _cartList.add(cart);

    final List<Map<String, dynamic>> _cartListMap =
        _cartList.map((CartModel cart) => cart.toMapForLocalDb()).toList();

    await box.write(cartName, _cartListMap);
  }

   Future<void> saveMarketItemToCart(CartModel cart) async {
    final Map<String, dynamic> data = cart.toMapForLocalDb();
    data.remove('timestamp');

    final List<CartModel> _cartList = await getAllMarketItemInCart();
    _cartList.add(cart);

    final List<Map<String, dynamic>> _cartListMap =
        _cartList.map((CartModel cart) => cart.toMapForLocalDb()).toList();

    await box.write(marketName, _cartListMap);
  }


  Future<void> updateCartItem(CartModel cart) async {
    final Map<String, dynamic> data = cart.toMapForLocalDb();
    data.remove('timestamp');

    final List<CartModel> _cartList = await getAllItemInCart();
    final int index =
        _cartList.indexWhere((CartModel cartModel) => cartModel.id == cart.id);

    _cartList[index] = cart;

    final List<Map<String, dynamic>> _cartListMap =
        _cartList.map((CartModel cart) => cart.toMapForLocalDb()).toList();

    await box.write(cartName, _cartListMap);
  }

  Future<void> updateMarketCartItem(CartModel cart) async {
    final Map<String, dynamic> data = cart.toMapForLocalDb();
    data.remove('timestamp');

    final List<CartModel> _cartList = await getAllMarketItemInCart();
    final int index =
        _cartList.indexWhere((CartModel cartModel) => cartModel.id == cart.id);

    _cartList[index] = cart;

    final List<Map<String, dynamic>> _cartListMap =
        _cartList.map((CartModel cart) => cart.toMapForLocalDb()).toList();

    await box.write(marketName, _cartListMap);
  }


  Future<void> deleteCartItem(int index) async {
    final List<CartModel> _cartList = await getAllItemInCart();

    _cartList.removeAt(index);

    final List<Map<String, dynamic>> _cartListMap =
        _cartList.map((CartModel cart) => cart.toMapForLocalDb()).toList();

    await box.write(cartName, _cartListMap);
  }

  Future<void> deleteMarketCartItem(int index) async {
    final List<CartModel> _cartList = await getAllMarketItemInCart();

    _cartList.removeAt(index);

    final List<Map<String, dynamic>> _cartListMap =
        _cartList.map((CartModel cart) => cart.toMapForLocalDb()).toList();

    await box.write(marketName, _cartListMap);
  }

  Future<void> clearCartItem() async {
    await box.write(cartName, <Map<String, dynamic>>[]);
  }

  Future<void> clearMarketCartItem() async {
    await box.write(marketName, <Map<String, dynamic>>[]);
  }

  Future<void> setListener() async {
    cartList.value = await getAllItemInCart();

    box.listenKey(cartName, (dynamic cartListMap) {
      List<Map<String, dynamic>> _cartListMap = <Map<String, dynamic>>[];

      _cartListMap = cartListMap as List<Map<String, dynamic>>;

      cartList.value = _cartListMap
          .map((Map<String, dynamic> data) =>
              CartModel.fromMap(data, data['id'] as String))
          .toList();
      log(_cartListMap.toString());
    });
  }

  Future<void> setListenerMarket() async {
    marketCartList.value = await getAllMarketItemInCart();

    box.listenKey(marketName, (dynamic cartListMap) {
      List<Map<String, dynamic>> _cartListMap = <Map<String, dynamic>>[];

      _cartListMap = cartListMap as List<Map<String, dynamic>>;

      marketCartList.value = _cartListMap
          .map((Map<String, dynamic> data) =>
              CartModel.fromMap(data, data['id'] as String))
          .toList();
      log(_cartListMap.toString());
    });
  }


  Future<void> setListenerForUserData() async {
    userDetail.value = await getUserDataFromLocalDB();

    box.listenKey(userDataBoxName, (dynamic userdata) {
      Map<String, dynamic>? _userDataInMap;

      if (userdata != null) {
        _userDataInMap = userdata as Map<String, dynamic>?;

        userDetail.value = _userDataInMap == null
            ? null
            : UserDetailsModel.fromMap(_userDataInMap);
      }
    });
  }

  Future<int> getTotalCartItemPrice() async {
    int totalPrice = 0;

    final List<CartModel> allCartList = await getAllItemInCart();

    allCartList.toList().forEach((CartModel cartItem) {
      totalPrice += cartItem.price;
    });

    return totalPrice;
  }

   Future<int> getTotalMarketCartItemPrice() async {
    int totalPrice = 0;

    final List<CartModel> allCartList = await getAllMarketItemInCart();

    allCartList.toList().forEach((CartModel cartItem) {
      totalPrice += cartItem.price;
    });

    return totalPrice;
  }
}
