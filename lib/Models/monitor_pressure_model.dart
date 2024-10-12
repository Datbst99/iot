class MonitorPressureModel {
  int id;
  String? measuringPoint;
  String? updateTime;
  String? status;
  String? pressure;
  String? waterFlow;
  String? dailyOutput;
  String? total;

//<editor-fold desc="Data Methods">
  MonitorPressureModel({
    required this.id,
    this.measuringPoint,
    this.updateTime,
    this.status,
    this.pressure,
    this.waterFlow,
    this.dailyOutput,
    this.total,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MonitorPressureModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          measuringPoint == other.measuringPoint &&
          updateTime == other.updateTime &&
          status == other.status &&
          pressure == other.pressure &&
          waterFlow == other.waterFlow &&
          dailyOutput == other.dailyOutput &&
          total == other.total);

  @override
  int get hashCode =>
      id.hashCode ^
      measuringPoint.hashCode ^
      updateTime.hashCode ^
      status.hashCode ^
      pressure.hashCode ^
      waterFlow.hashCode ^
      dailyOutput.hashCode ^
      total.hashCode;

  @override
  String toString() {
    return 'MonitorPressureModel{ id: $id, measuringPoint: $measuringPoint, updateTime: $updateTime, status: $status, pressure: $pressure, waterFlow: $waterFlow, dailyOutput: $dailyOutput, total: $total,}';
  }

  MonitorPressureModel copyWith({
    int? id,
    String? measuringPoint,
    String? updateTime,
    String? status,
    String? pressure,
    String? waterFlow,
    String? dailyOutput,
    String? total,
  }) {
    return MonitorPressureModel(
      id: id ?? this.id,
      measuringPoint: measuringPoint ?? this.measuringPoint,
      updateTime: updateTime ?? this.updateTime,
      status: status ?? this.status,
      pressure: pressure ?? this.pressure,
      waterFlow: waterFlow ?? this.waterFlow,
      dailyOutput: dailyOutput ?? this.dailyOutput,
      total: total ?? this.total,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'measuringPoint': this.measuringPoint,
      'updateTime': this.updateTime,
      'status': this.status,
      'pressure': this.pressure,
      'waterFlow': this.waterFlow,
      'dailyOutput': this.dailyOutput,
      'total': this.total,
    };
  }

  factory MonitorPressureModel.fromMap(Map<String, dynamic> map) {
    return MonitorPressureModel(
      id: map['id'] as int,
      measuringPoint: map['measuringPoint'] as String,
      updateTime: map['updateTime'] as String,
      status: map['status'] as String,
      pressure: map['pressure'] as String,
      waterFlow: map['waterFlow'] as String,
      dailyOutput: map['dailyOutput'] as String,
      total: map['total'] as String,
    );
  }

//</editor-fold>
}