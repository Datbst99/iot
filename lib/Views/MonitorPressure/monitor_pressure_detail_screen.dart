import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '/Controllers/auth_controller.dart';
import '/Views/Components/card_shadow_component.dart';
import '/Views/Components/dropdown_component.dart';
import '../../Configs/constant.dart';
import '../../Configs/global.dart';
import '../../Controllers/monitor_pressure_controller.dart';
import '../../Models/key_value_model.dart';
import '../Components/date_picker_component.dart';
import '../Components/shimmer_pressure_chart.dart';
import '../Components/show_error_component.dart';

class MonitorPressureDetailScreen extends StatefulWidget {
  final int id;

  const MonitorPressureDetailScreen({super.key, required this.id});

  @override
  State<MonitorPressureDetailScreen> createState() => _MonitorPressureDetailScreenState();
}

class _MonitorPressureDetailScreenState extends State<MonitorPressureDetailScreen> {
  final monitorPressureController = MonitorPressureController();
  final authController = AuthController();

  String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String? selectItem;
  List<DropdownMenuItem<String>> items = measuringPoint!
      .map((e) => DropdownMenuItem<String>(

            value: e.id.toString(),
            child: Text(
              e.name!,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ))
      .toList();

  @override
  void initState() {
    selectItem = widget.id.toString();
    monitorPressureController.getMonitorPressureDetail(widget.id.toString(), date);
    if (selectItem != null) {
      _resetCallApi();
    }
    super.initState();
  }

  @override
  void dispose() {
    monitorPressureController.cancelTimer();
    super.dispose();
  }

  void _handleChangeDate(DateTime? newValue) {
    date = DateFormat("yyyy-MM-dd").format(newValue!);
    _resetCallApi();
  }

  void handleValueChanged(String? newValue) {
    if (newValue != null) {
      selectItem = newValue;
      _resetCallApi();
    }
  }

  void _resetCallApi() {
    monitorPressureController.cancelTimer();
    monitorPressureController.getMonitorPressureDetail(selectItem!, date, loading: true);
    monitorPressureController.loopGetData(() => monitorPressureController.getMonitorPressureDetail(selectItem!, date));
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
                child: SizedBox(
                  height: 35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: DropdownComponent(
                          selectValue: widget.id.toString(),
                          items: items,
                          onChange: handleValueChanged,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        flex: 1,
                        child: DatePickerComponent(onChange: _handleChangeDate),
                      )
                    ],
                  ),
                ),
              ),
              ListenableBuilder(
                listenable: monitorPressureController,
                builder: (context, child) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "ÁP LỰC NƯỚC (bar)",
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CardShadow(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                        child: monitorPressureController.pressures.isEmpty
                            ? (monitorPressureController.errorMessage != null
                                ? ShowErrorComponent(
                                    text: monitorPressureController.errorMessage.toString(),
                                  )
                                : const ShimmerPressureChart())
                            : PressureChart(pressures: monitorPressureController.pressures, mainAxisX: monitorPressureController.mainX),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Text(
                        "LƯU LƯỢNG NƯỚC (m3/h)",
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CardShadow(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: monitorPressureController.dailyOutputs.isEmpty
                            ? (monitorPressureController.errorMessage != null
                                ? ShowErrorComponent(
                                    text: monitorPressureController.errorMessage.toString(),
                                  )
                                : const ShimmerPressureChart())
                            : WaterFlowChart(waterFlows: monitorPressureController.waterFlows, mainAxisX: monitorPressureController.mainX),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Text(
                        "SẢN LƯỢNG (m3)",
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CardShadow(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: monitorPressureController.dailyOutputs.isEmpty
                              ? (monitorPressureController.errorMessage != null
                                  ? ShowErrorComponent(
                                      text: monitorPressureController.errorMessage.toString(),
                                    )
                                  : const ShimmerPressureChart())
                              : DailyOutputChart(
                                  dailyOutputs: monitorPressureController.dailyOutputs,
                                  totalM3: monitorPressureController.totalM3,
                                )),
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

class DailyOutputChart extends StatefulWidget {
  final List<KeyValueModel> dailyOutputs;
  final double totalM3;
  const DailyOutputChart({super.key, required this.dailyOutputs, this.totalM3 = 0});

  @override
  State<DailyOutputChart> createState() => _DailyOutputChartState();
}

class _DailyOutputChartState extends State<DailyOutputChart> {
  int touchedIndex = -1;

  Widget build(BuildContext context) {
    List<String> days = widget.dailyOutputs.map((e) {
      return e.key.toString();
    }).toList();

    double widthDefault = MediaQuery.of(context).size.width - 40;
    double minColumn = 23;
    double sizeWidthColumn = widthDefault / days.length;
    double widthChart = widthDefault;
    double widthColumn = 16;
    if (minColumn < sizeWidthColumn) {
      widthChart = sizeWidthColumn * days.length;
      widthColumn = sizeWidthColumn - 10;
    } else {
      widthChart = minColumn * days.length;
      widthColumn = minColumn - 10;
    }

    double maxChart = 0;
    List<BarChartGroupData> _generateData = widget.dailyOutputs.asMap().entries.map((entry) {
      int index = entry.key;
      double quantity = entry.value.value;
      if (maxChart < quantity) {
        maxChart = quantity;
      }
      return makeGroupData(index, quantity, widthColumn, isTouched: index == touchedIndex);
    }).toList();

    maxChart = roundUpToNearest(maxChart).toDouble();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        height: 300,
        width: widthChart,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 10, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 30),
                child: Text("Sản lượng ngày: ${widget.totalM3} m3" ),
              ),
              Expanded(
                child: BarChart(
                  BarChartData(
                    maxY: maxChart,
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                          fitInsideHorizontally: true,
                          fitInsideVertically: true,
                          getTooltipColor: (_) => Colors.black,
                          tooltipHorizontalAlignment: FLHorizontalAlignment.right,
                          tooltipMargin: -5,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              (rod.toY).toString(),
                              textAlign: TextAlign.left,
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            );
                          }),
                      touchCallback: (FlTouchEvent event, barTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions || barTouchResponse == null || barTouchResponse.spot == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                        });
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) => getTitles(value, meta, days),
                          reservedSize: 38,
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          reservedSize: 40,
                          showTitles: true,
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    barGroups: _generateData,
                    gridData: const FlGridData(show: true),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y,
    double widthColumn, {
    bool isTouched = false,
    Color? barColor,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
        x: x,
        barRods: [
          BarChartRodData(
            toY: y,
            color: primaryColor,
            borderRadius: BorderRadius.zero,
            width: widthColumn,
            borderSide: const BorderSide(color: primaryColor, width: 2.0),
          ),
        ],
        showingTooltipIndicators: showTooltips);
  }

  Widget getTitles(double value, TitleMeta meta, List<String> days) {
    const style = TextStyle(
      color: textColor,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    Widget text = Text(
      days[value.toInt()],
      style: style,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 15,
      child: text,
    );
  }
}

class PressureChart extends StatelessWidget {
  final List<KeyValueModel> pressures;
  final List<KeyValueModel> mainAxisX;

  PressureChart({super.key, required this.pressures, required this.mainAxisX});

  final List<Color> gradientColors = [
    primaryColor,
    primaryColorDeep,
  ];

  @override
  Widget build(BuildContext context) {
    double widthDefault = MediaQuery.of(context).size.width - 40;
    int countItem = pressures.length;

    double widthChart = widthDefault;

    if (countItem > widthChart) {
      widthChart = countItem.toDouble();
    }

    double maxX = 0;
    double maxY = 0;
    List<FlSpot> spots = pressures.map((entry) {
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
        child: LineChart(
          LineChartData(
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
          ),
        ),
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

class WaterFlowChart extends StatelessWidget {
  final List<KeyValueModel> waterFlows;
  final List<KeyValueModel> mainAxisX;

  WaterFlowChart({super.key, required this.waterFlows, required this.mainAxisX});

  final List<Color> gradientColors = [
    primaryColor,
    primaryColorDeep,
  ];

  @override
  Widget build(BuildContext context) {
    double widthDefault = MediaQuery.of(context).size.width - 40;
    int countItem = waterFlows.length;

    double widthChart = widthDefault;

    if (countItem > widthChart) {
      widthChart = countItem.toDouble();
    }

    double maxX = 0;
    double maxY = 0;
    List<FlSpot> spots = waterFlows.map((entry) {
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
        child: LineChart(
          LineChartData(
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
          ),
        ),
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
