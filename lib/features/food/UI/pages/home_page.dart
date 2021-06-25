import 'package:flutter/material.dart';
import 'package:food_dash_app/cores/components/custom_button.dart';
import 'package:food_dash_app/features/auth/repo/auth_repo.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Center(child: Text('Home Page')),
          const SizedBox(height: 20),
          CustomButton(
            text: 'LogOut',
            onTap: () {
              AuthenticationRepo().signOut();
            },
          ),
        ],
      ),
    );
  }
}
