class KeyValueModel {
  final int key;
  final double value;

//<editor-fold desc="Data Methods">
  const KeyValueModel({
    required this.key,
    required this.value,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is KeyValueModel && runtimeType == other.runtimeType && key == other.key && value == other.value);

  @override
  int get hashCode => key.hashCode ^ value.hashCode;

  @override
  String toString() {
    return 'KeyValueModel{ key: $key, value: $value,}';
  }

  KeyValueModel copyWith({
    int? key,
    double? value,
  }) {
    return KeyValueModel(
      key: key ?? this.key,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': this.key,
      'value': this.value,
    };
  }

  factory KeyValueModel.fromMap(Map<String, dynamic> map) {
    return KeyValueModel(
      key: (map['key'] as num).toInt(),
      value:(map['value'] as num).toDouble(),
    );
  }

//</editor-fold>
}