import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '/Views/Components/layout_component.dart';

import '../../Configs/constant.dart';
import '../../Configs/router.dart';
import '../../Controllers/monitor_quality_controller.dart';
import '../Components/card_shadow_component.dart';
import '../Components/icon_status_component.dart';
import '../Components/show_error_component.dart';

class MonitorQualityScreen extends StatefulWidget {
  const MonitorQualityScreen({super.key});

  @override
  State<MonitorQualityScreen> createState() => _MonitorQualityScreenState();
}

class _MonitorQualityScreenState extends State<MonitorQualityScreen> {
  final monitorQualityController = MonitorQualityController();


  @override
  void initState() {
    monitorQualityController.getMonitorPressures();
    monitorQualityController.loopGetData(() => monitorQualityController.getMonitorPressures());
    super.initState();
  }

  @override
  void dispose() {
    monitorQualityController.cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutComponent(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
        child: Column(
          children: [
            const Text(
              "GIÁM SÁT CHẤT LƯỢNG NƯỚC",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            CardShadow(
              padding: const EdgeInsets.all(5),
              child: ListenableBuilder(
                listenable: monitorQualityController,
                builder: (context, child) {
                  if(monitorQualityController.errorMessage != null){
                    return ShowErrorComponent(text: monitorQualityController.errorMessage.toString(), height: 200,);
                  }

                  return Table(
                    children: [
                      TableRow(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 1.0, color: borderColor),
                          ),
                        ),
                        children: _buildColumns(),
                      ),
                      if (monitorQualityController.monitorQualities.isEmpty)
                        ..._buildShimmerRows()
                      else
                        for (var i = 0; i < monitorQualityController.monitorQualities.length; i++)
                          TableRow(
                            decoration: BoxDecoration(
                              border: const Border(
                                bottom: BorderSide(width: 1.0, color: borderColor),
                              ),
                              color: i % 2 == 0 ? const Color(0xffe0f7fa) : Colors.white,
                            ),
                            children: [
                              TableCell(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      RouteApp.monitorQualityDetail,
                                      arguments: monitorQualityController.monitorQualities[i].id,
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(bottom: 10, top: 10, right: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        IconStatusComponent(status: monitorQualityController.monitorQualities[i].status!),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          monitorQualityController.monitorQualities[i].quality_criteria!,
                                          style: const TextStyle(
                                            color: textColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              _buildCell(monitorQualityController.monitorQualities[i].update_time!, textAlign: TextAlign.center),
                              _buildCell(monitorQualityController.monitorQualities[i].ntu!, textAlign: TextAlign.center),
                              _buildCell(monitorQualityController.monitorQualities[i].ph!, textAlign: TextAlign.center),
                              _buildCell(monitorQualityController.monitorQualities[i].mgl!, textAlign: TextAlign.center),
                            ],
                          ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  List<TableRow> _buildShimmerRows() {
    return List.generate(
      3, // Số lượng dòng shimmer
      (index) => TableRow(
        children: [
          TableCell(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[200]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 40,
                margin: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                color: Colors.white,
              ),
            ),
          ),
          TableCell(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[200]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 40,
                margin: const EdgeInsets.fromLTRB(3, 3, 0, 0),
                color: Colors.white,
              ),
            ),
          ),
          TableCell(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[200]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 40,
                margin: const EdgeInsets.fromLTRB(3, 3, 0, 0),
                color: Colors.white,
              ),
            ),
          ),
          TableCell(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[200]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 40,
                margin: const EdgeInsets.fromLTRB(3, 3, 0, 0),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<Widget> _buildColumns() {
  return [
    _buildCell('Điểm đo', textAlign: TextAlign.center, fontWeight: FontWeight.bold),
    _buildCell('Thời gian', textAlign: TextAlign.center, fontWeight: FontWeight.bold),
    _buildCell('Độ đục', textAlign: TextAlign.center, fontWeight: FontWeight.bold),
    _buildCell('Độ PH', textAlign: TextAlign.center, fontWeight: FontWeight.bold),
    _buildCell('Clo dư', textAlign: TextAlign.center, fontWeight: FontWeight.bold),
  ];
}

TableCell _buildCell(String label, {TextAlign? textAlign, FontWeight? fontWeight}) {
  return TableCell(
    child: Container(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: fontWeight ?? FontWeight.w400,
          color: textColor,
        ),
        textAlign: textAlign,
      ),
    ),
  );
}
