import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_dash_app/cores/components/custom_scaffold_widget.dart';
import 'package:food_dash_app/cores/components/custom_text_widget.dart';
import 'package:food_dash_app/cores/utils/sizer_utils.dart';
import 'package:food_dash_app/features/food/UI/widgets/favourite_food_list_widet.dart';
import 'package:food_dash_app/features/food/UI/widgets/header_widget.dart';
import 'package:food_dash_app/features/food/bloc/merchant_bloc/merchant_bloc.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: sizerSp(10)),
        child: RefreshIndicator(
          onRefresh: () async => BlocProvider.of<MerchantBloc>(context)
              .add(GetFavouritesItemEvents()),
          child: ListView(
            children: <Widget>[
              SizedBox(height: sizerSp(10)),
              const HeaderWidget(iconData: Icons.menu, title: 'Favourites'),
              SizedBox(height: sizerSp(20)),
              CustomTextWidget(
                text: 'Favourites Food',
                fontSize: sizerSp(14),
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: sizerSp(5)),
              const FavouriteFoodListWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
