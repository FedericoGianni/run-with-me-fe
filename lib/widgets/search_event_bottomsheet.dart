import 'package:flutter/material.dart';

class SearchEventBottomSheet extends StatelessWidget {
  const SearchEventBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.2,
    );
  }
}
