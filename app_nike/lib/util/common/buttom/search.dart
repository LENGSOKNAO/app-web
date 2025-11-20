import 'package:app_nike/core/assets/image_png.dart';
import 'package:app_nike/util/constants/route.dart';
import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: TextButton(
        onPressed: () {
          Navigator.of(context).pushNamed(searchRoute);
        },
        child: Image.asset(ImagePng.search),
      ),
    );
  }
}
