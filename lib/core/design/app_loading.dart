import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CupertinoActivityIndicator(radius: 35,color: Theme.of(context).primaryColor,));
  }
}
