class MonitorQualityModel {
  int id;
  String? quality_criteria;
  String? ph;
  String? ntu;
  String? mgl;
  String? update_time;
  String? status;

//<editor-fold desc="Data Methods">
  MonitorQualityModel({
    required this.id,
    this.quality_criteria,
    this.ph,
    this.ntu,
    this.mgl,
    this.update_time,
    this.status,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MonitorQualityModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          quality_criteria == other.quality_criteria &&
          ph == other.ph &&
          ntu == other.ntu &&
          mgl == other.mgl &&
          update_time == other.update_time &&
          status == other.status);

  @override
  int get hashCode => id.hashCode ^ quality_criteria.hashCode ^ ph.hashCode ^ ntu.hashCode ^ mgl.hashCode ^ update_time.hashCode ^ status.hashCode;

  @override
  String toString() {
    return 'MonitorQualityModel{' +
        ' id: $id,' +
        ' quality_criteria: $quality_criteria,' +
        ' ph: $ph,' +
        ' ntu: $ntu,' +
        ' mgl: $mgl,' +
        ' update_time: $update_time,' +
        ' status: $status,' +
        '}';
  }

  MonitorQualityModel copyWith({
    int? id,
    String? quality_criteria,
    String? ph,
    String? ntu,
    String? mgl,
    String? update_time,
    String? status,
  }) {
    return MonitorQualityModel(
      id: id ?? this.id,
      quality_criteria: quality_criteria ?? this.quality_criteria,
      ph: ph ?? this.ph,
      ntu: ntu ?? this.ntu,
      mgl: mgl ?? this.mgl,
      update_time: update_time ?? this.update_time,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'quality_criteria': this.quality_criteria,
      'ph': this.ph,
      'ntu': this.ntu,
      'mgl': this.mgl,
      'update_time': this.update_time,
      'status': this.status,
    };
  }

  factory MonitorQualityModel.fromMap(Map<String, dynamic> map) {
    return MonitorQualityModel(
      id: map['id'] as int,
      quality_criteria: map['quality_criteria'] as String,
      ph: map['ph'] as String,
      ntu: map['ntu'] as String,
      mgl: map['mgl'] as String,
      update_time: map['update_time'] as String,
      status: map['status'] as String,
    );
  }

//</editor-fold>
}