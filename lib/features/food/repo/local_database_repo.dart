import 'package:food_dash_app/cores/utils/config.dart';
import 'package:food_dash_app/features/auth/model/user_details_model.dart';
import 'package:food_dash_app/features/food/model/cart_model.dart';
import 'package:hive/hive.dart';

class LocaldatabaseRepo {
  static const String userDataBoxName = 'user_data';

  Future<void> saveUserDataToLocalDB(Map<String, dynamic> data) async {
    final Box<Map<String, dynamic>> userBox = Hive.box(Config.userDataBox);
    await userBox.put(userDataBoxName, data);
  }

  Future<UserDetailsModel> getUserDataFromLocalDB() async {
    final Box<Map<String, dynamic>> _userBox = Hive.box(Config.userDataBox);
    final Map<String, dynamic>? _userData = _userBox.get(userDataBoxName);

    return UserDetailsModel.fromMap(_userData!);
  }

  Future<void> saveItemToCart(CartModel cart) async {
    final Box<Map<String, dynamic>> cartBox = Hive.box(Config.cartDataBox);
    final Map<String, dynamic> data = cart.toMap();
    data.remove('timestamp');
    await cartBox.put(cart.name, data);
  }

  Future<List<CartModel>> getAllItemInCart() async {
    final Box<Map<String, dynamic>> cartBox = Hive.box(Config.cartDataBox);
    final List<CartModel> cartList = cartBox.values
        .map((Map<String, dynamic> data) =>
            CartModel.fromMap(data, data['id'] as String))
        .toList();

    return cartList;
  }

  Future<void> updateCartItem(int index, CartModel cart) async {
    final Box<Map<String, dynamic>> cartBox = Hive.box(Config.cartDataBox);

    final Map<String, dynamic> data = cart.toMap();
    data.remove('timestamp');

    cartBox.putAt(index, data);
  }

  Future<void> deleteCartItem(int index) async {
    final Box<Map<String, dynamic>> cartBox = Hive.box(Config.cartDataBox);

    cartBox.deleteAt(index);
  }

  Future<void> clearCartItem() async {
    final Box<Map<String, dynamic>> cartBox = Hive.box(Config.cartDataBox);

    cartBox.deleteAll(cartBox.keys);
  }
}
