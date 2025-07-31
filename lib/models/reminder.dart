enum ReminderType {
  vet,
  vaccination,
  feeding,
  medication,
  grooming,
  other,
}

class Reminder {
  final int id;
  final int petId;
  final String title;
  final String description;
  final ReminderType type;
  final DateTime dateTime;
  final bool isCompleted;
  final bool isRepeating;
  final int? repeatInterval; // Days between repeats

  Reminder({
    required this.id,
    required this.petId,
    required this.title,
    required this.description,
    required this.type,
    required this.dateTime,
    this.isCompleted = false,
    this.isRepeating = false,
    this.repeatInterval,
  });

  Reminder copyWith({
    int? id,
    int? petId,
    String? title,
    String? description,
    ReminderType? type,
    DateTime? dateTime,
    bool? isCompleted,
    bool? isRepeating,
    int? repeatInterval,
  }) {
    return Reminder(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      dateTime: dateTime ?? this.dateTime,
      isCompleted: isCompleted ?? this.isCompleted,
      isRepeating: isRepeating ?? this.isRepeating,
      repeatInterval: repeatInterval ?? this.repeatInterval,
    );
  }

  String get typeDisplayName {
    switch (type) {
      case ReminderType.vet:
        return 'Vet Appointment';
      case ReminderType.vaccination:
        return 'Vaccination';
      case ReminderType.feeding:
        return 'Feeding';
      case ReminderType.medication:
        return 'Medication';
      case ReminderType.grooming:
        return 'Grooming';
      case ReminderType.other:
        return 'Other';
    }
  }
}
