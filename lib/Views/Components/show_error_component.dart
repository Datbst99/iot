import 'package:flutter/material.dart';

class ShowErrorComponent extends StatelessWidget {
  final String text;
  double? width;
  double? height;
  ShowErrorComponent({super.key, required this.text, this.width,  this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 0,
      height: height ?? 300,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(color: Colors.red, fontSize: 18),
        ),
      ),
    );
  }
}
