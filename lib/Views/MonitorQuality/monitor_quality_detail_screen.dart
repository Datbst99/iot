import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Configs/constant.dart';
import '../../Configs/global.dart';
import '../../Controllers/monitor_pressure_controller.dart';
import '../../Controllers/monitor_quality_controller.dart';
import '../../Models/key_value_model.dart';
import '../Components/card_shadow_component.dart';
import '../Components/date_picker_component.dart';
import '../Components/shimmer_pressure_chart.dart';
import '../Components/show_error_component.dart';

class MonitorQualityDetailScreen extends StatefulWidget {
  final int id;
  const MonitorQualityDetailScreen({super.key, required this.id});

  @override
  State<MonitorQualityDetailScreen> createState() => _MonitorQualityDetailScreenState();
}

class _MonitorQualityDetailScreenState extends State<MonitorQualityDetailScreen> {
  final monitorQualityController = MonitorQualityController();
  String date = DateFormat("yyyy-MM-dd").format(DateTime.now());

  @override
  void initState() {
    monitorQualityController.getMonitorQualityDetail(widget.id.toString(), date);
    super.initState();
  }

  @override
  void dispose() {
    monitorQualityController.cancelTimer();
    super.dispose();
  }

  void _handleChangeDate(DateTime? newValue) {
    date = DateFormat("yyyy-MM-dd").format(newValue!);
    _resetCallApi();
  }

  void _resetCallApi() {
    monitorQualityController.cancelTimer();
    monitorQualityController.getMonitorQualityDetail(widget.id.toString(), date, loading: true);
    monitorQualityController.loopGetData(() => monitorQualityController.getMonitorQualityDetail(widget.id.toString(), date));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NHÀ MÁY NƯỚC ${globalFactoryName?.toUpperCase()}"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Màu trắng với độ mờ
                      spreadRadius: 0, // Bán kính lan tỏa của shadow
                      blurRadius: 5, // Bán kính mờ của shadow
                      offset: const Offset(0, 2), // Độ dịch chuyển của shadow
                    ),
                  ],
                ),
                child: SizedBox(height: 35, child: DatePickerComponent(onChange: _handleChangeDate)),
              ),
              ListenableBuilder(
                listenable: monitorQualityController,
                builder: (context, child) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "ĐỘ ĐỤC (NTU)",
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CardShadow(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                        child: monitorQualityController.unitNTU.isEmpty
                            ? (monitorQualityController.errorMessage != null
                                ? ShowErrorComponent(
                                    text: monitorQualityController.errorMessage.toString(),
                                  )
                                : const ShimmerPressureChart())
                            : LineChartComponent(keyValues: monitorQualityController.unitNTU, mainAxisX: monitorQualityController.mainX),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Text(
                        "ĐỘ PH (PH)",
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CardShadow(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: monitorQualityController.unitPH.isEmpty
                            ? (monitorQualityController.errorMessage != null
                                ? ShowErrorComponent(
                                    text: monitorQualityController.errorMessage.toString(),
                                  )
                                : const ShimmerPressureChart())
                            : LineChartComponent(keyValues: monitorQualityController.unitPH, mainAxisX: monitorQualityController.mainX),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Text(
                        "CLO Dư",
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CardShadow(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: monitorQualityController.unitMG.isEmpty
                            ? (monitorQualityController.errorMessage != null
                                ? ShowErrorComponent(
                                    text: monitorQualityController.errorMessage.toString(),
                                  )
                                : const ShimmerPressureChart())
                            : LineChartComponent(keyValues: monitorQualityController.unitMG, mainAxisX: monitorQualityController.mainX),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LineChartComponent extends StatelessWidget {
  final List<KeyValueModel> keyValues;
  final List<KeyValueModel> mainAxisX;

  LineChartComponent({super.key, required this.keyValues, required this.mainAxisX});

  final List<Color> gradientColors = [
    primaryColor,
    primaryColorDeep,
  ];

  @override
  Widget build(BuildContext context) {
    double widthDefault = MediaQuery.of(context).size.width - 40;
    int countItem = keyValues.length;

    double widthChart = widthDefault;

    if (countItem > widthChart) {
      widthChart = countItem.toDouble();
    }

    double maxX = 0;
    double maxY = 0;
    List<FlSpot> spots = keyValues.map((entry) {
      int index = entry.key;
      double quantity = entry.value;

      if (maxX < entry.key) {
        maxX = (entry.key).toDouble();
      }

      if (maxY < quantity) {
        maxY = quantity;
      }

      return FlSpot(index.toDouble(), quantity);
    }).toList();
    maxY = maxY.ceil().toDouble();

    List<int> titleLefts = divideNumber(maxY.toInt());

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        height: 300,
        padding: const EdgeInsets.only(top: 10, left: 5),
        width: widthChart,
        child: LineChart(LineChartData(
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              fitInsideVertically: true,
              fitInsideHorizontally: true,
              maxContentWidth: 100,
              getTooltipColor: (touchedSpot) => Colors.black,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((LineBarSpot touchedSpot) {
                  const textStyle = TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  );
                  return LineTooltipItem(
                    touchedSpot.y.toStringAsFixed(2),
                    textStyle,
                  );
                }).toList();
              },
            ),
            handleBuiltInTouches: true,
            getTouchLineStart: (data, index) => 0,
          ),
          gridData: FlGridData(
            show: false,
            drawVerticalLine: true,
            horizontalInterval: 1,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return const FlLine(
                color: primaryColor,
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return const FlLine(
                color: primaryColor,
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) => bottomTitleWidgets(value, meta),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) => leftTitleWidgets(value, meta, titleLefts),
                reservedSize: 40,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d)),
          ),
          minX: 0,
          minY: 0,
          maxX: maxX,
          maxY: maxY,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              gradient: LinearGradient(
                colors: gradientColors,
              ),
              barWidth: 5,
              isStrokeCapRound: true,
              dotData: const FlDotData(
                show: false,
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    KeyValueModel? keyValueModel;
    try {
      keyValueModel = mainAxisX.firstWhere((element) => element.key == value.toInt());
    } catch (e) {
      keyValueModel = null;
    }

    // Trả về widget tương ứng
    Widget text;
    if (keyValueModel != null) {
      int convert = keyValueModel.value.toInt();
      text = Text('${convert}:00', style: style);
    } else {
      text = const Text('', style: style);
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta, List<int> titleLefts) {
    const style = TextStyle(
      fontSize: 14,
    );
    String text = '';
    int convert = value.toInt();
    if (titleLefts.indexOf(convert) != -1) {
      text = '$convert';
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }
}
