import 'package:flutter/material.dart';

class CustomScaffoldWidget extends StatelessWidget {
  const CustomScaffoldWidget({
    Key? key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
  }) : super(key: key);

  final Widget body;
  final Widget? floatingActionButton;
  final AppBar? appBar;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar,
        backgroundColor: Colors.white,
        body: body,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
