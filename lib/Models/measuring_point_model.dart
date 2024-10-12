
class MeasuringPointModel {
    int id;
    String sensor_id;
    String? name;

//<editor-fold desc="Data Methods">
  MeasuringPointModel({
    required this.id,
    required this.sensor_id,
    this.name,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MeasuringPointModel && runtimeType == other.runtimeType && id == other.id && sensor_id == other.sensor_id && name == other.name);

  @override
  int get hashCode => id.hashCode ^ sensor_id.hashCode ^ name.hashCode;

  @override
  String toString() {
    return 'MeasuringPointModel{ id: $id, sensor_id: $sensor_id, name: $name,}';
  }

  MeasuringPointModel copyWith({
    int? id,
    String? sensor_id,
    String? name,
  }) {
    return MeasuringPointModel(
      id: id ?? this.id,
      sensor_id: sensor_id ?? this.sensor_id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'sensor_id': this.sensor_id,
      'name': this.name,
    };
  }

  factory MeasuringPointModel.fromMap(Map<String, dynamic> map) {
    return MeasuringPointModel(
      id: map['id'] as int,
      sensor_id: map['sensor_id'] as String,
      name: map['name'] as String,
    );
  }

//</editor-fold>
}