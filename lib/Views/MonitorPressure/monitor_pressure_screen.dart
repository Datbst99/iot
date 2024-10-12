import 'package:flutter/material.dart';
import '/Configs/router.dart';
import '/Controllers/monitor_pressure_controller.dart';
import '/Views/Components/icon_status_component.dart';
import '/Views/Components/layout_component.dart';
import 'package:shimmer/shimmer.dart';
import '../../Configs/constant.dart';
import '../Components/card_shadow_component.dart';

class MonitorPressureScreen extends StatefulWidget {
  MonitorPressureScreen({super.key});

  @override
  State<MonitorPressureScreen> createState() => _MonitorPressureScreenState();
}

class _MonitorPressureScreenState extends State<MonitorPressureScreen> {
  final monitorPressureController = MonitorPressureController();
  @override
  void initState() {
    monitorPressureController.getMonitorPressures();
    monitorPressureController.loopGetData(() => monitorPressureController.getMonitorPressures());
    super.initState();
  }

  @override
  void dispose() {
    monitorPressureController.cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int i = 0;


    return LayoutComponent(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
        child: Column(
          children: [
            const Text(
              "GIÁM SÁT ÁP LỰC NƯỚC",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 20,
            ),
            CardShadow(
              padding: const EdgeInsets.all(5),
              child: ListenableBuilder(
                listenable: monitorPressureController,
                builder: (context, child) {
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
                      if (monitorPressureController.monitorPressures.isEmpty)
                        ..._buildShimmerRows()
                      else
                        for (var i = 0; i < monitorPressureController.monitorPressures.length; i++)
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
                                      RouteApp.monitorPressureDetail,
                                      arguments: monitorPressureController.monitorPressures[i].id,
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(bottom: 10, top: 10, right: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          monitorPressureController.monitorPressures[i].measuringPoint!,
                                          style: const TextStyle(
                                            color: textColor,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        IconStatusComponent(status: monitorPressureController.monitorPressures[i].status!),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              _buildCell(monitorPressureController.monitorPressures[i].updateTime!, textAlign: TextAlign.start),
                              _buildCell(monitorPressureController.monitorPressures[i].pressure!, textAlign: TextAlign.center),
                              _buildCell(monitorPressureController.monitorPressures[i].waterFlow!, textAlign: TextAlign.center),
                              _buildCell(monitorPressureController.monitorPressures[i].dailyOutput!, textAlign: TextAlign.center),
                              _buildCell(monitorPressureController.monitorPressures[i].total!, textAlign: TextAlign.center),
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
      5, // Số lượng dòng shimmer
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
    _buildCell('Điểm đo', textAlign: TextAlign.start, fontWeight: FontWeight.bold),
    _buildCell('Thời gian', textAlign: TextAlign.start, fontWeight: FontWeight.bold),
    _buildCell('P(bar)', textAlign: TextAlign.center, fontWeight: FontWeight.bold),
    _buildCell('Q(m3/h)', textAlign: TextAlign.center, fontWeight: FontWeight.bold),
    _buildCell('Qn(m3)', textAlign: TextAlign.center, fontWeight: FontWeight.bold),
    _buildCell('∑Q(m3)', textAlign: TextAlign.center, fontWeight: FontWeight.bold),
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
