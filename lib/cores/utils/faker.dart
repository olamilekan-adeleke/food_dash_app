import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_dash_app/features/food/model/market_item_model.dart';
import 'package:uuid/uuid.dart';
import 'package:faker/faker.dart';

class FakeMarketPlace {
  static final CollectionReference marketRef =
      FirebaseFirestore.instance.collection('market');

  Future<void> addMarketItem(MarketItemModel marketItem) async {
    await marketRef.doc(marketItem.id).set(marketItem.toMap());
  }

  Future<void> init() async {
    for (int i = 0; i < 100; i++) {
      final Faker faker = Faker();

      final MarketItemModel marketItem = MarketItemModel(
        id: Uuid().v1(),
        name: faker.lorem.words(2).join(' '),
        description: faker.lorem.sentences(3).join(' '),
        images: <String>[
          faker.image.image(
            width: 500,
            height: 500,
            keywords: <String>['shop', 'market', 'item', 'shopping'],
            random: true,
          ),
          faker.image.image(
            width: 500,
            height: 500,
            keywords: <String>['shop', 'market', 'item', 'shopping'],
            random: true,
          ),
          faker.image.image(
            width: 500,
            height: 500,
            keywords: <String>['shop', 'market', 'item', 'shopping'],
            random: true,
          ),
        ],
        category: 'market',
        price: faker.randomGenerator.integer(10000),
      );

      await addMarketItem(marketItem);
      log('added $i');
    }
  }
}
