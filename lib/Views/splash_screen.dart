import 'package:flutter/material.dart';
import '/Controllers/auth_controller.dart';
import '../Configs/constant.dart';
import '../Configs/router.dart';


class SplashScreen extends StatefulWidget {


  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController authController = AuthController();

  @override
  void initState() {

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoginStatus(context);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.white,
      child: const Center(
        child: Image(
          image: AssetImage(imageLogo),
          width: 250,
        ),
      ),
    );
  }

  void _checkLoginStatus(BuildContext context) async {

    bool checkToken = await authController.checkToken();
    if (!context.mounted) return;

    if (checkToken) {
      Navigator.pushNamedAndRemoveUntil(context, RouteApp.home, (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, RouteApp.login, (route) => false);
    }
  }
}

