import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_dash_app/features/auth/repo/auth_repo.dart';
import 'package:food_dash_app/features/food/model/cart_model.dart';
import 'package:food_dash_app/features/food/model/food_product_model.dart';
import 'package:food_dash_app/features/food/model/merchant_model.dart';
import 'package:get_it/get_it.dart';

class MerchantRepo {
  static AuthenticationRepo authenticationRepo =
      GetIt.instance<AuthenticationRepo>();
  static final CollectionReference<Map<String, dynamic>> foodCollectionRef =
      FirebaseFirestore.instance.collection('food');
  static final CollectionReference<Map<String, dynamic>> userCollectionRef =
      FirebaseFirestore.instance.collection('users');
  final int limit = 10;

  Future<List<MerchantModel>> getMerchant({MerchantModel? lastMerchant}) async {
    final List<MerchantModel> merchants = <MerchantModel>[];

    Query<Map<String, dynamic>> query = foodCollectionRef
        .orderBy('name')
        .orderBy('number_of_ratings')
        .limit(limit);

    if (lastMerchant != null) {
      query = query.startAfter(
        <dynamic>[lastMerchant.name, lastMerchant.numberOfRating],
      );
    }

    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();

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
        .doc(merchantId)
        .collection('products')
        .orderBy('name')
        .limit(limit);

    if (lastFoodProduct != null) {
      query = query.startAfter(
        <String>[lastFoodProduct.name],
      );
    }

    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();

    merchants.addAll(
      querySnapshot.docs.map(
        (QueryDocumentSnapshot<Map<String, dynamic>> data) =>
            FoodProductModel.fromMap(data.data(), data.id),
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
    final String? userId = authenticationRepo.getUserUid();

    await userCollectionRef
        .doc(userId)
        .collection('cart')
        .doc()
        .set(foodProductModel.toMap());
  }

  Future<void> updateCartItem(FoodProductModel foodProductModel) async {
    final String? userId = authenticationRepo.getUserUid();

    await userCollectionRef
        .doc(userId)
        .collection('cart')
        .doc(foodProductModel.id)
        .update(foodProductModel.toMap());
  }

  Future<void> removeFromCart(String foodProductId) async {
    final String? userId = authenticationRepo.getUserUid();

    await userCollectionRef
        .doc(userId)
        .collection('cart')
        .doc(foodProductId)
        .delete();
  }

  Future<List<CartModel>> getCart() async {
    final List<CartModel> cartList = <CartModel>[];
    final String? userUid = authenticationRepo.getUserUid();

    final Query<Map<String, dynamic>> query =
        userCollectionRef.doc(userUid).collection('cart').orderBy('name');

    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();

    cartList.addAll(
      querySnapshot.docs.map(
        (QueryDocumentSnapshot<Map<String, dynamic>> data) =>
            CartModel.fromMap(data.data(), data.id),
      ),
    );

    return cartList;
  }

  Future<List<FoodProductModel>> getFavourites() async {
    final List<FoodProductModel> cartList = <FoodProductModel>[];
    final String? userUid = authenticationRepo.getUserUid();

    final Query<Map<String, dynamic>> query =
        userCollectionRef.doc(userUid).collection('favourites').orderBy('name');

    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();

    cartList.addAll(
      querySnapshot.docs.map(
        (QueryDocumentSnapshot<Map<String, dynamic>> data) =>
            FoodProductModel.fromMap(data.data(), data.id),
      ),
    );

    return cartList;
  }
}
