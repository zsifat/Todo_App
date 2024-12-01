import 'dart:ui';

import 'package:get/get.dart';

class Task{
  final String title;
  final List<Color> colors;
  final DateTime deadline;
  final DateTime startDate;
  final String description;
  final RxMap<String,bool>? todos;

  int remainingMonths = 0;
  int remainingDays = 0;
  int remainingHours = 0;

  Task({required this.title,required this.colors,required this.deadline,required this.startDate,required this.description,required this.todos});

  Map<String,dynamic>toMap(){
    return {
      'title': title,
      'colors': colors.map((color) =>color.value,).toList(),
      'deadline': deadline.toIso8601String(),
      'startdate':startDate.toIso8601String(),
      'description':description,
      'todos': todos?.map((key, value) => MapEntry(key, value)),
    };
  }
  
  factory Task.fromMap(Map<String, dynamic> map){
    return Task(
        title:map['title'],
        colors: List<Color>.from(map['colors'].map((colorValue)=>Color(colorValue))),
        deadline: DateTime.parse(map['deadline']),
        startDate: DateTime.parse(map['startdate']),
        description: map['description'],
        todos: _parseTodos(map['todos'])// Return an empty map if todos is null or not in the expected format
    );
  }

  static RxMap<String, bool> _parseTodos(dynamic todosData) {
    if (todosData is Map<String, dynamic>) {
      return RxMap<String, bool>.from(todosData.map((key, value) => MapEntry(key, value as bool)));
    } else {
      return RxMap<String, bool>();  // Return an empty map if the type is incorrect
    }
  }


}