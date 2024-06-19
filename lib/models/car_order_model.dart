class CarWashOrder {
  final String id;
  final String date;
  final String time;
  final String washType;
  final String carType;
  final int totalCost;

  CarWashOrder({
    required this.id,
    required this.date,
    required this.time,
    required this.washType,
    required this.carType,
    required this.totalCost,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'time': time,
      'washType': washType,
      'carType': carType,
      'totalCost': totalCost,
    };
  }
}
