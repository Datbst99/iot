import 'package:flutter/material.dart';
import '/Configs/global.dart';
import '/Views/Components/drawer_component.dart';

import '../../Configs/constant.dart';

class LayoutComponent extends StatefulWidget {
  final Widget body;

  const LayoutComponent({super.key, required this.body});

  @override
  State<LayoutComponent> createState() => _LayoutComponentState();
}

class _LayoutComponentState extends State<LayoutComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NHÀ MÁY NƯỚC ${globalFactoryName?.toUpperCase()}"),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: widget.body,
      ),
      drawer: DrawerComponent(appBarHeight: AppBar().preferredSize.height),
    );
  }
}
