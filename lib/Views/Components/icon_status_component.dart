import 'dart:async';

import 'package:flutter/material.dart';

class IconStatusComponent extends StatefulWidget {

  final String status;
  IconStatusComponent({super.key, required this.status});

  @override
  _IconStatusComponentState createState() => _IconStatusComponentState();
}

class _IconStatusComponentState extends State<IconStatusComponent> {
  Color _color = Colors.green;
  bool _isGreen = true;

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    if(widget.status == 'inactive'){
      _color = Colors.orange;
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {

        setState(() {
          _color = _isGreen ? Colors.grey : Colors.green;
          _isGreen = !_isGreen;
        });
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15,
      height: 15,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutQuint,
        decoration: BoxDecoration(
          color: _color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}