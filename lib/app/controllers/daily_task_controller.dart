import 'package:get/get.dart';
import 'package:todo_app/app/models/daily_task.dart';
import 'package:todo_app/app/models/userdata.dart';

class DailyTasKController extends GetxController {
  RxList<DailyTask> dailytasks = <DailyTask>[
    DailyTask(title: 'Work Out', isChecked: false),
    DailyTask(title: 'Daily Meeting', isChecked: false),
    DailyTask(title: 'Reading a Book', isChecked: false),
    DailyTask(title: 'Class', isChecked: false),
    DailyTask(title: 'Tution', isChecked: false),
    DailyTask(title: 'Dinner', isChecked: false),
  ].obs;

  toogleIsChecked(int index) {
    dailytasks[index] = dailytasks[index].toggleChecked();
    update();
  }

  void addDailyTask(DailyTask dtask){
    dailytasks.add(dtask);
  }

  void removeDailyTask(DailyTask dtask){
   dailytasks.remove(dtask);
  }

  updateDailyTasksBasedOnUserData(UserData userData){
    dailytasks=userData.dailytasks;
    update();
  }
}