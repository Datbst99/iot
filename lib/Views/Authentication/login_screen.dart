import 'package:flutter/material.dart';
import '/Configs/global.dart';
import '/Configs/router.dart';
import 'package:animate_do/animate_do.dart';
import '/Controllers/auth_controller.dart';

import '../../Configs/constant.dart';
import '../Components/button.dart';
import '../Components/popup_notification.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AuthController authController = AuthController();

  Future<void> _login(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      await authController.login(_usernameController.text, _passwordController.text);
      if (!context.mounted) return;

      if (globalToken != null) {
        Navigator.pushNamedAndRemoveUntil(
            context, RouteApp.home, (route) => false);
      } else {
        showErrorDiaLog(context, "Thông báo", authController.message!);
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor,
            primaryColorDeep,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 500),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: whiteColor.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeInDown(
                      duration: const Duration(milliseconds: zoomMilliseconds),
                      child: const Text(
                        "Đăng nhập",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            color: textColor),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ZoomIn(
                      duration: const Duration(milliseconds: zoomMilliseconds),
                      child: TextFormField(
                        controller: _usernameController,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: 'Tên đăng nhập',
                          labelText: 'Tên đăng nhập',
                          contentPadding:
                          const EdgeInsets.fromLTRB(20, 15, 20, 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Vui lòng nhập tên đăng nhập";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    ZoomIn(
                      duration: const Duration(milliseconds: zoomMilliseconds),
                      child: TextFormField(
                        controller: _passwordController,
                        autofocus: false,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: 'Mật khẩu',
                          labelText: 'Mật khẩu',
                          contentPadding:
                          const EdgeInsets.fromLTRB(20, 15, 20, 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              semanticLabel: _obscureText
                                  ? 'show password'
                                  : 'hide password',
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Vui lòng nhập mật khẩu";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeInUp(
                      duration: const Duration(milliseconds: zoomMilliseconds),
                      child: MyElevatedButton(
                        width: MediaQuery.of(context).size.width / 2,
                        onPressed: authController.isLoading ? null : ()  {
                          setState(() {});
                          _login(context);
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: authController.isLoading
                            ? const SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2.0,
                          ),
                        )
                            : const Text(
                          'Đăng nhập',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

