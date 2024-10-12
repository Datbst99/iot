
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '/Configs/api.dart';
import '/Configs/global.dart';
import 'package:http/http.dart' as http;
import '/Models/key_value_model.dart';
import '/Models/monitor_quality_model.dart';


class MonitorQualityController with ChangeNotifier {
  Timer? _timer;

  String? _errorMessage;
  List<MonitorQualityModel> _monitorQualities = [];


  List<KeyValueModel> unitNTU = [];
  List<KeyValueModel> unitPH = [];
  List<KeyValueModel> unitMG = [];
  List<KeyValueModel> mainX = [];

  String? get errorMessage => _errorMessage;
  List<MonitorQualityModel> get monitorQualities => _monitorQualities;

  void loopGetData(Function() fetchDataCallback) async {
    _timer = Timer.periodic(const Duration(minutes: 5), (timer) async {

      await fetchDataCallback();
    });
  }

  Future<void> getMonitorPressures() async{
    try {
      Map<String, String> headers = {'Content-Type': 'application/json', 'Authorization' : 'Bearer $globalToken' };
      final response = await http.get(GenerateApi.getPath('monitorQuality'), headers: headers).timeout(const Duration(seconds: 10));

      if(response.statusCode != 200) {
        throw Exception("Failed to load data");
      }

      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if(jsonResponse['success'] == true) {
        final List<dynamic> dataJson = jsonResponse['data'];
        _monitorQualities = dataJson.map((e) => MonitorQualityModel.fromMap(e)).toList();

        if(_monitorQualities.isEmpty){
          _errorMessage = "Không có dữ liệu";
        }
      }
    }catch (e) {
      _errorMessage = "Không có dữ liệu";
      _timer?.cancel();
    }

    notifyListeners();
  }

  Future<void> getMonitorQualityDetail(String? date, {bool loading = false}) async {

    try {

      if(loading){
        _errorMessage = null;
        unitNTU = [];
        unitPH = [];
        unitMG = [];
        mainX = [];

        notifyListeners();
      }

      Map<String, String> headers = {'Content-Type': 'application/json', 'Authorization' : 'Bearer $globalToken' };
      String params = "?date=$date";

      final response = await http.get(GenerateApi.getPath('monitorQualityDetail', params), headers: headers).timeout(const Duration(seconds: 30));

      if(response.statusCode != 200) {
        throw Exception("Failed to load data");
      }

      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if(jsonResponse['success'] == true) {
        unitNTU = (jsonResponse['data']["ntu"] as List)
            .map((data) => KeyValueModel.fromMap(data))
            .toList();

        unitPH = (jsonResponse['data']["ph"] as List)
            .map((data) => KeyValueModel.fromMap(data))
            .toList();

        unitMG = (jsonResponse['data']["mg/l"] as List)
            .map((data) => KeyValueModel.fromMap(data))
            .toList();

        mainX = (jsonResponse['data']['main_x'] as List)
            .map((data) => KeyValueModel.fromMap(data))
            .toList();

        if(unitNTU.isEmpty || unitPH.isEmpty || unitMG.isEmpty || mainX.isEmpty){
          _errorMessage = "Không có dữ liệu";
        }
      } else {
        _errorMessage = "Không có dữ liệu";
      }
    }catch (e) {
      _errorMessage = "Không có dữ liệu";
      _timer?.cancel();

    }
    notifyListeners();
  }

  void cancelTimer(){
    _errorMessage = null;
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}