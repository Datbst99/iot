
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/Models/monthly_output_model.dart';
import '/Views/Components/month_picker_component.dart';

import '../../Configs/constant.dart';
import '../../Configs/global.dart';
import '../../Controllers/monthly_output_controller.dart';
import '../Components/card_shadow_component.dart';
import '../Components/dropdown_component.dart';
import '../Components/layout_component.dart';
import '../Components/shimmer_pressure_chart.dart';
import '../Components/show_error_component.dart';

class MonthlyOutputScreen extends StatefulWidget {
  const MonthlyOutputScreen({super.key});

  @override
  State<MonthlyOutputScreen> createState() => _MonthlyOutputScreenState();
}

class _MonthlyOutputScreenState extends State<MonthlyOutputScreen> {

  final monthlyOutputController = MonthlyOutputController();
  String date = DateFormat("yyyy-MM").format(DateTime.now());
  String? selectItem = measuringPoint?.first.sensor_id;
  List<DropdownMenuItem<String>> items = measuringPoint!.map((e) => DropdownMenuItem<String>(
    value: e.sensor_id,
    child: Text(
      e.name!,
      style: const TextStyle(
        fontSize: 14,
      ),
    ),
  )).toList();

  @override
  void initState() {
    monthlyOutputController.getMonthlyOutput(selectItem, date, loading: true);
    monthlyOutputController.loopGetData(() => monthlyOutputController.getMonthlyOutput(selectItem, date));
    super.initState();
  }

  @override
  void dispose() {
    monthlyOutputController.cancelTimer();
    super.dispose();
  }

  void handleValueChanged(String? newValue) {
    if (newValue != null) {
      selectItem = newValue;
      _resetCallApi();
    }
  }

  void _handleChangeMonth(DateTime? newValue) {
    if(newValue != null){
      date = DateFormat("yyyy-MM").format(newValue);
      _resetCallApi();
    }
  }

  void _resetCallApi(){
    monthlyOutputController.cancelTimer();
    monthlyOutputController.getMonthlyOutput(selectItem, date, loading: true);
    monthlyOutputController.loopGetData(() => monthlyOutputController.getMonthlyOutput(selectItem, date));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutComponent(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
        child: Column(
          children: [
            const Text(
              "BIỂU ĐỒ GIÁM SÁT SẢN LƯỢNG NƯỚC TRONG THÁNG",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
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
                        selectValue: selectItem,
                        items: items,
                        onChange: handleValueChanged,
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    Expanded(
                      flex: 1,
                      child: MonthPickerComponent(onChange: _handleChangeMonth),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CardShadow(
              padding: const EdgeInsets.all(5),
              child: ListenableBuilder(
                listenable: monthlyOutputController,
                builder: (context, child) {
                  if(monthlyOutputController.errorMessage != null){
                    return ShowErrorComponent(text: monthlyOutputController.errorMessage.toString(), height: 200,);
                  }

                  if(monthlyOutputController.monthlyOutputs.isEmpty){
                    return const ShimmerPressureChart();
                  }

                  return MonthlyOutputChart(monthlyOutputs: monthlyOutputController.monthlyOutputs, yieldMaxChart: monthlyOutputController.yieldMaxChart,);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MonthlyOutputChart extends StatefulWidget {
  final List<MonthlyOutputModel> monthlyOutputs;
  final double yieldMaxChart;

  const MonthlyOutputChart({super.key, required this.monthlyOutputs, required this.yieldMaxChart});

  @override
  State<MonthlyOutputChart> createState() => _MonthlyOutputChartState();
}

class _MonthlyOutputChartState extends State<MonthlyOutputChart> {

  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {

    List<String> days = widget.monthlyOutputs.map((e) {
      return e.date;
    }).toList();

    double widthDefault = MediaQuery.of(context).size.width - 40;
    double minColumn = 23;
    double sizeWidthColumn = widthDefault / days.length;
    double widthChart = widthDefault;
    double widthColumn = 16;
    if(minColumn < sizeWidthColumn){
      widthChart = sizeWidthColumn * days.length;
      widthColumn = sizeWidthColumn - 10;
    } else {
      widthChart = minColumn * days.length;
      widthColumn = minColumn - 10;
    }

    double maxChart = 0;
    List<BarChartGroupData> _generateData = widget.monthlyOutputs.asMap().entries.map((entry) {
      int index = entry.key;
      double quantity = entry.value.quantity;
      if (maxChart < quantity) {
        maxChart = quantity;
      }
      return makeGroupData(index, quantity, widthColumn, isTouched: index == touchedIndex);
    }).toList();

    maxChart = roundUpToNearest(maxChart).toDouble();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        height: 350,
        width: widthChart,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 10, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 40),
                child: Text("Sản lượng tháng: ${widget.yieldMaxChart} m3" ),
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
      double y, double widthColumn,
      {
        bool isTouched = false,
        Color? barColor,
        double width = 22,
        List<int> showTooltips = const [],
      }
      ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: primaryColor,
          borderRadius: BorderRadius.zero,
          width: widthColumn,
          borderSide: BorderSide(color: primaryColor, width: 2.0),
        ),
      ],
        showingTooltipIndicators: showTooltips
      // showingTooltipIndicators:
    );
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