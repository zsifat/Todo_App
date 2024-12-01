class DailyTask{
  final String title;
  final bool isChecked;

  DailyTask({required this.title,this.isChecked=false});
  DailyTask toggleChecked() {
    return DailyTask(title: title, isChecked: !isChecked);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isChecked': isChecked,
    };
  }

  // Convert a Firestore Map to a DailyTask object
  factory DailyTask.fromMap(Map<String, dynamic> map) {
    return DailyTask(
      title: map['title'],
      isChecked: map['isChecked'] ?? false,
    );
  }
}