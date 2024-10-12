
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/Configs/global.dart';
import 'package:http/http.dart' as http;
import '/Models/measuring_point_model.dart';

import '../Configs/api.dart';
import '../Configs/constant.dart';

class AuthController {
  static final AuthController _instance = AuthController._internal();

  factory AuthController() {
    return _instance;
  }

  AuthController._internal();

  bool _isLoading = false;
  String? _message;

  bool get isLoading => _isLoading;
  String? get message => _message;

  Future<void> login(String username, String password) async {
    _isLoading = true;

    Map<String, String> headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'username': username,
      'password': password,
    });
    try {
      final response = await http
          .post(GenerateApi.getPath('login'), body: body, headers: headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        _isLoading = false;
        return;
      }

      final responseData = jsonDecode(response.body);
      if (!responseData['success'] || responseData['token'] == null) {
        _message = responseData['message'] ?? 'Lỗi không xác đinh. Vui lòng liên hệ admin!';
        _isLoading = false;
        return;
      }

      globalToken = responseData['token'];
      globalFactoryName = responseData['info']?['name'];

      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString(keyStorageToken, globalToken!);
      preferences.setString(keyStorageFactoryName, globalFactoryName!);

      await getMeasuringPoint();
    } catch (e) {
      print("==========================");
      print(e);
      _isLoading = false;
      _message = "Lỗi không xác đinh. Vui lòng liên hệ admin?!!!";
    }
  }


  Future<bool> checkToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    globalToken ??= preferences.getString(keyStorageToken);

    if (globalToken != null) {
      try {
        Map<String, String> headers = {'Content-Type': 'application/json', 'Authorization' : 'Bearer $globalToken' };

        final response = await http.get(
          GenerateApi.getPath('checkLogin'),
          headers: headers,
        ).timeout(const Duration(seconds: 10));

        final responseData = jsonDecode(response.body);

        if (response.statusCode != 200 || !responseData['success']) {
          throw Exception("Invalid!");
        }

        globalFactoryName = responseData['info']?['name'];
        preferences.setString(keyStorageFactoryName, globalFactoryName!);

        await getMeasuringPoint();
        return true;
      } catch (e) {
        globalToken = null;
        globalFactoryName = null;
        preferences.remove(keyStorageFactoryName);
        preferences.remove(keyStorageToken);
      }
    }

    return false;
  }

  Future<void> getMeasuringPoint() async {

    try {
      Map<String, String> headers = {'Content-Type': 'application/json', 'Authorization' : 'Bearer $globalToken' };
      final response = await http.get(
        GenerateApi.getPath('sensor'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      final responseData = jsonDecode(response.body);

      if (response.statusCode != 200 || !responseData['success']) {
        throw Exception("Invalid!");
      }

      final List<dynamic> dataJson = responseData['data'];
      measuringPoint = dataJson.map((e) => MeasuringPointModel.fromMap(e)).toList();
    } catch (e) {
      return;
    }
  }

  Future<void> logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    globalToken = null;
    globalFactoryName = null;
    preferences.remove(keyStorageFactoryName);
    preferences.remove(keyStorageToken);
  }
}