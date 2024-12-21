import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/app/models/task.dart';
import 'package:todo_app/app/ui_helper/colors.dart';

import '../controllers/daily_task_controller.dart';
import '../controllers/task_controller.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  final customColors = const CustomColors();
  final TaskController taskController = Get.find<TaskController>();
  final DailyTasKController dailyTasKController =
      Get.find<DailyTasKController>();

  List<Task> sortedTask(DateTime selectedDay) {
    if (taskController.tasks.isNotEmpty) {
      List<Task> sortedTaskList = taskController.tasks
          .where(
            (Task task) => task.deadline.isAfter(selectedDay),
          )
          .toList();
      return sortedTaskList;
    } else {
      return <Task>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Task> sortedTaskList = sortedTask(_selectedDay);

    return SafeArea(
      child: Scaffold(
        body: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TableCalendar(
                    rowHeight: 40,
                    calendarStyle: CalendarStyle(
                        todayTextStyle: const TextStyle(color: Colors.black),
                        todayDecoration:
                            const BoxDecoration(color: Colors.transparent),
                        selectedDecoration: BoxDecoration(
                            color: customColors.secondaryColor,
                            shape: BoxShape.circle)),
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    focusedDay: _focusedDay,
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31)),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: sortedTaskList.length,
                    itemBuilder: (context, index) {
                      double progress = taskController.calculateProgress(
                          taskController.tasks[index].todos!);
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Colors.black12.withOpacity(0.05))),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat('MMM d, yy')
                                        .format(sortedTaskList[index].deadline),
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.withOpacity(0.6)),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    sortedTaskList[index].title,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        color: customColors.secondaryColor),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(sortedTaskList[index].description),
                                ],
                              ),
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                // Outer circle (outline)
                                Container(
                                  height: 42.5,
                                  width: 42.5,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.grey
                                          .withOpacity(0.3), // Border color
                                      width: 6.0, // Border thickness
                                    ),
                                  ),
                                ),
                                // Circular Progress Indicator
                                CircularProgressIndicator(
                                  value: progress,
                                  strokeWidth:
                                      6.0, // Thickness of the progress line
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Colors.blue),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            )),
      ),
    );
  }
}
