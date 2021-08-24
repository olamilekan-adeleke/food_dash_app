import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:food_dash_app/cores/constants/color.dart';
import 'package:food_dash_app/features/food/UI/pages/cart_page.dart';
import 'package:food_dash_app/features/food/UI/pages/favourite_screen.dart';
import 'package:food_dash_app/features/food/UI/pages/home_page.dart';
import 'package:food_dash_app/features/food/UI/pages/wallet_page.dart';
import 'package:food_dash_app/features/market/view/screens/market_hoem_screen.dart';

class HomeTabScreen extends StatelessWidget {
  const HomeTabScreen({Key? key}) : super(key: key);
  static final ValueNotifier<int> _pageIndex = ValueNotifier<int>(2);
  static const List<Widget> _pages = <Widget>[
    WalletScreen(),
    FavouriteScreen(),
    HomePage(),
    MarketHomeScreen(),
    CartPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<int>(
        valueListenable: _pageIndex,
        builder: (BuildContext context, int index, Widget? child) {
          return IndexedStack(
            index: index,
            children: _pages,
          );
        },
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: 2,
        backgroundColor: Colors.transparent,
        animationDuration: const Duration(milliseconds: 350),
        buttonBackgroundColor: kcPrimaryColor.withOpacity(0.7),
        items: <Widget>[
          Icon(Icons.account_balance_wallet_rounded,
              size: 25, color: Colors.grey[600]),
          Icon(Icons.favorite_outlined, size: 25, color: Colors.grey[600]),
          Icon(Icons.fastfood_outlined, size: 25, color: Colors.grey[600]),
          Icon(Icons.shopping_bag_outlined, size: 25, color: Colors.grey[600]),
          Icon(Icons.shopping_cart, size: 25, color: Colors.grey[600]),
        ],
        onTap: (int index) => _pageIndex.value = index,
      ),
    );
  }
}
