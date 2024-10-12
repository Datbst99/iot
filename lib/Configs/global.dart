
import '../Models/measuring_point_model.dart';

String? globalToken;
String? globalFactoryName;
List<MeasuringPointModel>? measuringPoint;

num roundUpToNearest(num number) {
  if (number <= 0) return 0;

  // Xác định bước làm tròn dựa trên kích thước của số
  int step;
  if (number <= 5) {
    step = 5;
  } else if (number <= 10) {
    step = 10;
  } else if (number <= 100) {
    step = 50;
  }else if (number <= 200) {
    step = 200;
  } else if (number <= 1000) {
    step = 500;
  } else {
    step = 5000;
  }

  return ((number + step - 1) ~/ step) * step;
}

List<int> divideNumber(int target) {
  List<int> result = [];
  if(target < 5) {
    for (int i = 0; i < 5; i++) {
      result.add(i);
    }
  } else if(target < 10) {
    int step = target ~/ 2;
    for (int i = 0; i < 5; i++) {
      result.add(i * step);
    }
  } else {
    int step = target ~/ 5;
    for (int i = 0; i < 5; i++) {
      result.add(i * step);
    }
  }



  result.add(target);

  return result;
}