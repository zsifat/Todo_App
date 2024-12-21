import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/app/controllers/daily_task_controller.dart';
import 'package:todo_app/app/controllers/darkmode_controller.dart';
import 'package:todo_app/app/models/daily_task.dart';
import 'package:todo_app/app/models/task.dart';
import 'package:todo_app/app/ui_helper/colors.dart';

import '../controllers/task_controller.dart';
import '../controllers/usercontroller.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  Task? task = Get.arguments;

  final CustomColors customcolors = const CustomColors();

  DateTime endDate = DateTime.now();
  DateTime startDate = DateTime.now();

  Future<bool?> _selectDate(BuildContext context) async {
    DateTime? pickeddate = await showDatePicker(
        context: context,
        initialDate: endDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2030));
    if (pickeddate != null) {
      endDate = pickeddate;
      print(endDate);
      return true;
    } else {
      return null;
    }
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  List<TextEditingController> todoControllers = <TextEditingController>[];

  bool prioritychoosen = true;

  void _addTodo(int todoindex) {
    if (todoControllers.any(
      (element) {
        return element.text.isEmpty;
      },
    )) {
      Get.showSnackbar(GetSnackBar(
        title: 'Alert',
        message: 'Fill all the todo fields to add new field',
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(10),
        borderRadius: 15,
        backgroundColor: customcolors.lightBlue4,
        barBlur: 10,
        dismissDirection: DismissDirection.vertical,
        snackPosition: SnackPosition.TOP,
      ));
    } else {
      var todocontroller = TextEditingController();
      todoControllers.add(todocontroller);
    }
  }

  void _removeTodo(index) {
    if (index != 0) {
      todoControllers.removeAt(index);
    } else {
      todoControllers[0].clear();
    }
  }

  Color generateRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(56),
      random.nextInt(56),
      random.nextInt(56) + 100,
    );
  }

  RxMap<String, bool> _generateTodos() {
    RxMap<String, bool> todomap = <String, bool>{}.obs;
    for (var todo in todoControllers) {
      if (todo.text.isNotEmpty) {
        todomap[todo.text] = false;
      }
    }
    return todomap;
  }

  DailyTask _createDailyTask() {
    return DailyTask(title: titleController.text);
  }

  Task _createPriorityTask() {
    RxMap<String, bool> todomap = _generateTodos();
    return Task(
        title: titleController.text,
        colors: [generateRandomColor(), generateRandomColor()],
        deadline: endDate,
        startDate: startDate,
        description: descController.text,
        todos: todomap);
  }

  bool isSaved = false;
  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    if (task != null) {
      task != null ? endDate = task!.deadline : endDate;
      startDate = task!.startDate;
      task != null
          ? titleController.text = task!.title
          : titleController.text = '';
      task != null
          ? descController.text = task!.description
          : descController.text = '';
      for (var todo in task!.todos!.keys) {
        TextEditingController todocontroller = TextEditingController();
        todoControllers.add(todocontroller);
      }
      for (var element in todoControllers) {
        element.text =
            task!.todos!.keys.toList()[todoControllers.indexOf(element)];
      }
    } else {
      final todocontroller = TextEditingController();
      todoControllers.add(todocontroller);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TaskController taskController = Get.find<TaskController>();
    final DailyTasKController dailyTasKController =
        Get.find<DailyTasKController>();
    final UserController userController = Get.find<UserController>();
    final themeController = Get.find<DarkModeController>();

    int? taskIndex =
        task == null ? null : taskController.tasks.indexOf(Get.arguments);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            decoration: BoxDecoration(
              color: customcolors.secondaryColor,
            ),
          ),
          Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Text(
                task == null ? 'Add Task' : 'Edit Task',
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    height: 755,
                    padding:
                        const EdgeInsets.only(left: 30, top: 30, right: 30),
                    decoration: BoxDecoration(
                        color: themeController.isDarkMode.value
                            ? Colors.black
                            : Colors.white,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50))),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Start',
                                      style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: customcolors.secondaryColor),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          color: customcolors.secondaryColor
                                              .withOpacity(0.4),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          DateFormat('MMM d y')
                                              .format(startDate),
                                          style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Ends',
                                      style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: customcolors.secondaryColor),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    prioritychoosen
                                        ? InkWell(
                                            onTap: () async {
                                              bool? check =
                                                  await _selectDate(context);
                                              if (check == true) {
                                                setState(() {});
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.calendar_today,
                                                  color: customcolors
                                                      .secondaryColor,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  DateFormat('MMM d y')
                                                      .format(endDate),
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_today,
                                                color: customcolors
                                                    .secondaryColor
                                                    .withOpacity(0.4),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                DateFormat('MMM d y')
                                                    .format(DateTime.now()),
                                                style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Title',
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: customcolors.secondaryColor),
                          ),
                          TextField(
                            controller: titleController,
                            autocorrect: false,
                            enableSuggestions: false,
                            decoration: InputDecoration(
                                hintText: 'Title here',
                                hintStyle: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                                border: InputBorder.none),
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                            ),
                            autofocus: task == null ? true : false,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Category',
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: customcolors.secondaryColor),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      prioritychoosen = true;
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 160,
                                    decoration: BoxDecoration(
                                        color: prioritychoosen
                                            ? customcolors.secondaryColor
                                            : Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Text(
                                        'Prioriy Task',
                                        style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: !prioritychoosen
                                                ? customcolors.secondaryColor
                                                : Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      prioritychoosen = false;
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 160,
                                    decoration: BoxDecoration(
                                        color: !prioritychoosen
                                            ? customcolors.secondaryColor
                                            : Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Text(
                                        'Daily Task',
                                        style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: prioritychoosen
                                                ? customcolors.secondaryColor
                                                : Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Description',
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: customcolors.secondaryColor),
                          ),
                          TextField(
                            controller: descController,
                            autocorrect: false,
                            enableSuggestions: false,
                            decoration: InputDecoration(
                                hintText: 'Description here',
                                hintStyle: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                                border: InputBorder.none),
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                            ),
                            maxLines: 5,
                            minLines: 5,
                            textInputAction: TextInputAction.done,
                            autofocus: task == null ? true : false,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          !prioritychoosen
                              ? const SizedBox.shrink()
                              : Text(
                                  'To Do list',
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: customcolors.secondaryColor),
                                ),
                          !prioritychoosen
                              ? const SizedBox.shrink()
                              : ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: todoControllers.length,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: todoControllers[index],
                                            autocorrect: false,
                                            enableSuggestions: false,
                                            decoration: InputDecoration(
                                                hintText: 'Add new to do',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey.shade500,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                border: InputBorder.none),
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                            ),
                                            autofocus: true,
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _removeTodo(index);
                                              });
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: customcolors.lightBlue5,
                                            ))
                                      ],
                                    );
                                  },
                                ),
                          !prioritychoosen
                              ? const SizedBox.shrink()
                              : const SizedBox(
                                  height: 15,
                                ),
                          !prioritychoosen
                              ? const SizedBox.shrink()
                              : InkWell(
                                  onTap: () {
                                    _addTodo(todoControllers.length - 1);
                                    setState(() {});
                                  },
                                  child: Container(
                                    height: 50,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: customcolors.secondaryColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Text(
                                        'Add To do',
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () => Get.back(),
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        border: const Border.fromBorderSide(
                                            BorderSide(width: 1)),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Text(
                                        'Cancel',
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    if (prioritychoosen &&
                                        (titleController.text.isNotEmpty ||
                                            descController.text.isNotEmpty)) {
                                      Task prioritytask = _createPriorityTask();
                                      if (task != null) {
                                        taskController.updateTask(
                                            taskIndex!, prioritytask);
                                        Get.offNamed('/detailsscreen',
                                            arguments: taskIndex);
                                      } else {
                                        taskController.addTask(prioritytask);
                                        Get.back();
                                      }
                                      userController.uploadData(userId);
                                      isSaved = true;
                                    } else if (!prioritychoosen &&
                                        titleController.text.isNotEmpty) {
                                      DailyTask dtask = _createDailyTask();
                                      dailyTasKController.addDailyTask(dtask);
                                      Get.back();
                                      userController.uploadData(userId);
                                    } else {
                                      Get.showSnackbar(GetSnackBar(
                                        title: 'Alert',
                                        message:
                                            'Title or Description must be inserted.',
                                        duration: const Duration(seconds: 2),
                                        margin: const EdgeInsets.all(10),
                                        borderRadius: 15,
                                        backgroundColor:
                                            customcolors.lightBlue4,
                                        barBlur: 10,
                                        dismissDirection:
                                            DismissDirection.vertical,
                                        snackPosition: SnackPosition.TOP,
                                      ));
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: customcolors.secondaryColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Text(
                                        task == null ? 'Save' : 'Update',
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
