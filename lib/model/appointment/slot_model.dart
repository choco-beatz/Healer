class SlotModel {
  final String day;
  final bool isActive;
  final List<Slot> timeSlots;

  SlotModel({
    required this.day,
    required this.isActive,
    required this.timeSlots,
  });

  factory SlotModel.fromJson(Map<String, dynamic> json) {
    return SlotModel(
      day: json['day'],
      isActive: json['isActive'] ?? false,
      timeSlots: (json['timeSlots'] as List?)
              ?.map((timeSlot) => timeSlot != null
                  ? Slot.fromJson(timeSlot as Map<String, dynamic>)
                  : null)
              .whereType<Slot>()
              .toList() ??
          [],
    );
  }
}


class Slot {
  final String startTime;
  final String endTime;
  final int amount;

  Slot({
    required this.startTime,
    required this.endTime,
    required this.amount,
  });

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      startTime: json['startTime'],
      endTime: json['endTime'],
      amount: json['amount'],
    );
  }
}
