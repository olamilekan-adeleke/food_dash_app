import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SearchScreen'),
      ),
      body: Center(
        child: Container(
          child: Text('SearchScreen'),
        ),
      ),
    );
  }
}
