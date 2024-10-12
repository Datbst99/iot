class MonitorQualityModel {
  String id;
  String? quality_criteria;
  String? update_time;
  String? status;
  String? unit;
  String? measured_value;

//<editor-fold desc="Data Methods">
  MonitorQualityModel({
    required this.id,
    this.quality_criteria,
    this.update_time,
    this.status,
    this.unit,
    this.measured_value,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MonitorQualityModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          quality_criteria == other.quality_criteria &&
          update_time == other.update_time &&
          status == other.status &&
          unit == other.unit &&
          measured_value == other.measured_value);

  @override
  int get hashCode => id.hashCode ^ quality_criteria.hashCode ^ update_time.hashCode ^ status.hashCode ^ unit.hashCode ^ measured_value.hashCode;

  @override
  String toString() {
    return 'MonitorQualityModel{' +
        ' id: $id,' +
        ' quality_criteria: $quality_criteria,' +
        ' update_time: $update_time,' +
        ' status: $status,' +
        ' unit: $unit,' +
        ' measured_value: $measured_value,' +
        '}';
  }

  MonitorQualityModel copyWith({
    String? id,
    String? quality_criteria,
    String? update_time,
    String? status,
    String? unit,
    String? measured_value,
  }) {
    return MonitorQualityModel(
      id: id ?? this.id,
      quality_criteria: quality_criteria ?? this.quality_criteria,
      update_time: update_time ?? this.update_time,
      status: status ?? this.status,
      unit: unit ?? this.unit,
      measured_value: measured_value ?? this.measured_value,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'quality_criteria': this.quality_criteria,
      'update_time': this.update_time,
      'status': this.status,
      'unit': this.unit,
      'measured_value': this.measured_value,
    };
  }

  factory MonitorQualityModel.fromMap(Map<String, dynamic> map) {
    return MonitorQualityModel(
      id: map['id'] as String,
      quality_criteria: map['quality_criteria'] as String,
      update_time: map['update_time'] as String,
      status: map['status'] as String,
      unit: map['unit'] as String,
      measured_value: map['measured_value'] as String,
    );
  }

//</editor-fold>
}