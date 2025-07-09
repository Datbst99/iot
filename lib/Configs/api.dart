
class GenerateApi {

  static String domain = "http://192.168.56.1/";
  static String login = "api/app/login";
  static String checkLogin = "api/app/check-login";
  static String pressure = 'api/app/monitor-pressure';
  static String pressureDetail = 'api/app/monitor-pressure/detail';
  static String outputChart = 'api/app/output-chart';
  static String sensor = 'api/app/sensor';

  static String monitorQuality = 'api/app/quantity-monitoring';
  static String monitorQualityDetail = 'api/app/quantity-monitoring/detail';


  static final Map<String, String> _paths = {
    'login': login,
    'checkLogin': checkLogin,
    'pressure': pressure,
    'outputChart': outputChart,
    'monitorQuality': monitorQuality,
    'sensor': sensor,
    'pressureDetail': pressureDetail,
    'monitorQualityDetail': monitorQualityDetail,
  };

  static Uri getPath(String name, [String? params]) {
    String path = _paths[name] ?? "";
    String param = params ?? "";
    return Uri.parse(domain + path + param);
  }

}