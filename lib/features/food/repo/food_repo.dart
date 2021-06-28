import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_dash_app/features/food/model/food_product_model.dart';
import 'package:food_dash_app/features/food/model/merchant_model.dart';

class MerchantRepo {
  static final CollectionReference<Map<String, dynamic>> foodCollectionRef =
      FirebaseFirestore.instance.collection('food');
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
}
