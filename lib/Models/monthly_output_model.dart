
class MonthlyOutputModel {
  String date;
  double quantity;

//<editor-fold desc="Data Methods">
  MonthlyOutputModel({
    required this.date,
    required this.quantity,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is MonthlyOutputModel && runtimeType == other.runtimeType && date == other.date && quantity == other.quantity);

  @override
  int get hashCode => date.hashCode ^ quantity.hashCode;

  @override
  String toString() {
    return 'MonthlyOutputModel{ date: $date, quantity: $quantity,}';
  }

  MonthlyOutputModel copyWith({
    String? date,
    double? quantity,
  }) {
    return MonthlyOutputModel(
      date: date ?? this.date,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': this.date,
      'quantity': this.quantity,
    };
  }

  factory MonthlyOutputModel.fromMap(Map<String, dynamic> map) {
    return MonthlyOutputModel(
      date: map['date'] as String,
      quantity: (map['quantity'] as num).toDouble(),
    );
  }

//</editor-fold>
}