import 'package:flutter/material.dart';
import '/Configs/router.dart';
import '../../Configs/constant.dart';
import '../../Controllers/auth_controller.dart';

class DrawerComponent extends StatelessWidget {
  final double appBarHeight;

  const DrawerComponent({super.key, required this.appBarHeight});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          child: Drawer(
            backgroundColor: primaryColor,
            width: constraints.maxWidth * 0.25,
            child: ListView(
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.white))),
                  height: appBarHeight,
                  child: const DrawerHeader(
                    child: Text(
                      'Menu',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // ListTile(
                //   contentPadding: const EdgeInsets.all(5),
                //   title: const Column(
                //     children: [
                //       Icon(
                //         Icons.home,
                //         color: Colors.white,
                //       ),
                //       Text(
                //         'Home',
                //         textAlign: TextAlign.center,
                //         style: TextStyle(color: Colors.white),
                //       )
                //     ],
                //   ),
                //   onTap: () {
                //     Navigator.pushNamedAndRemoveUntil(context, WaterRoute.home, (route) => false);
                //   },
                // ),
                // const SizedBox(
                //   height: 20,
                // ),
                ListTile(
                  contentPadding: const EdgeInsets.all(5),
                  title: const Column(
                    children: [
                      Icon(
                        Icons.equalizer,
                        color: Colors.white,
                      ),
                      Text(
                        'Giám sát mạng lưới cấp nước',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(context, RouteApp.monitorPressure, (route) => false);
                  },
                ),

                const SizedBox(height: 20),
                ListTile(
                  contentPadding: EdgeInsets.all(5),
                  title: const Column(
                    children: [
                      Icon(
                        Icons.area_chart,
                        color: Colors.white,
                      ),
                      Text(
                        'Biều đồ sản lượng tháng',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(context, RouteApp.monthlyOutput, (route) => false);
                  },
                ),
                const SizedBox(height: 20),
                ListTile(
                  contentPadding: EdgeInsets.all(5),
                  title: const Column(
                    children: [
                      Icon(
                        Icons.stacked_bar_chart,
                        color: Colors.white,
                      ),
                      Text(
                        'Giám sát chất lượng nước',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(context, RouteApp.monitorQuality, (route) => false);
                  },
                ),
                const SizedBox(height: 20),
                ListTile(
                  contentPadding: EdgeInsets.all(5),
                  title: const Column(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      Text(
                        'Thoát',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  onTap: () async {
                    final authController = AuthController();
                    await authController.logout();

                    if (!context.mounted) return;
                    Navigator.pushNamedAndRemoveUntil(context, RouteApp.login, (route) => false);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}