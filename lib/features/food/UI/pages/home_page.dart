import 'package:flutter/material.dart';
import 'package:food_dash_app/cores/components/custom_button.dart';
import 'package:food_dash_app/cores/components/custom_scaffold_widget.dart';
import 'package:food_dash_app/cores/components/custom_text_widget.dart';
import 'package:food_dash_app/cores/constants/font_size.dart';
import 'package:food_dash_app/features/auth/repo/auth_repo.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const CustomTextWidget(
                text: '   Are You Hungry..?',
                fontWeight: FontWeight.bold,
                fontSize: kfsSuperLarge,
              ),
              CustomButton.smallSized(
                height: 28,
                width: 60,
                text: 'LogOut',
                textSize: kfsVeryTiny,
                textFontWeight: FontWeight.w300,
                onTap: () => AuthenticationRepo().signOut(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
