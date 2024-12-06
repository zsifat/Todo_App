import 'package:get/get.dart';
import 'package:todo_app/app/models/task.dart';

import 'daily_task.dart';

class UserData {
  String name;
  String email;
  String profession;
  RxList<DailyTask> dailytasks;
  RxList<Task> priorityTasks;

  UserData({
    required this.name,
    required this.email,
    this.profession='Student',
    required this.dailytasks,
    required this.priorityTasks,
  });

  // Convert UserData to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'profession':profession,
      'dailytasks': dailytasks.map((task) => task.toMap()).toList(),
      'priorityTasks': priorityTasks.map((task) => task.toMap()).toList(),
    };
  }
  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      name: map['name'],
      email: map['email'],
      profession: map['profession'] ?? 'Student',
      dailytasks: (map['dailytasks'] as List<dynamic>)
          .map((taskMap) {
        if (taskMap is Map<String, bool>) {
          return DailyTask.fromMap(taskMap);  // Map to DailyTask
        } else {
          return DailyTask.fromMap({});  // Return empty map if data is corrupted
        }
      }).toList().obs,
      priorityTasks: (map['priorityTasks'] as List<dynamic>)
          .map((taskMap) {
        if (taskMap is Map<String, dynamic>) {
          return Task.fromMap(taskMap);  // Map to Task
        } else {
          return Task.fromMap({});  // Return empty map if data is corrupted
        }
      })
          .toList()
          .obs,
    );
  }


}
