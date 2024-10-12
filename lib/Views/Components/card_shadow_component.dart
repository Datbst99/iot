import 'package:flutter/material.dart';

class CardShadow extends StatelessWidget {
  final Widget child;
  final double? width;
  final EdgeInsets? padding;
  const CardShadow(
      {super.key, required this.child, this.width = double.infinity, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding ?? EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Màu trắng với độ mờ
            spreadRadius: 0, // Bán kính lan tỏa của shadow
            blurRadius: 5, // Bán kính mờ của shadow
            offset: const Offset(0, 5), // Độ dịch chuyển của shadow
          ),
        ],
      ),
      clipBehavior: Clip.none,
      child: child,
    );
  }
}
