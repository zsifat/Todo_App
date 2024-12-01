import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:todo_app/app/controllers/daily_task_controller.dart';
import 'package:todo_app/app/controllers/task_controller.dart';
import 'package:todo_app/app/models/daily_task.dart';
import 'package:todo_app/app/models/task.dart';
import 'package:todo_app/app/models/userdata.dart';


class UserController extends GetxController{

  Rx<UserData> userData=UserData(
    name: 'User',
    email: '',
    dailytasks: <DailyTask>[].obs,
    priorityTasks: <Task>[].obs,).obs;


  uploadData(String userID) async{
    await FirebaseFirestore.instance.collection('users').doc(userID).set(userData.value.toMap());
    print('Data Synced');
  }

  getuserData(String userID) async{
    DocumentSnapshot userDoc= await FirebaseFirestore.instance.collection('users').doc(userID).get();
    try{
      if(userDoc.exists){
        var data=userDoc.data() as Map<String,dynamic>;
        userData.value=UserData.fromMap(data);
        update();
      }
    }catch(e){print('error: $e');}

  }


  fetchData() async{
    User? user=FirebaseAuth.instance.currentUser;
    String userId=FirebaseAuth.instance.currentUser!.uid;
    if(user!=null){
      userData.value.name=user.displayName ?? 'User';
      userData.value.email=user.email ?? '';
      await getuserData(userId);
      update();
    }
  }


  resetUserData(){
    userData.value.name='User';
    userData.value.profession='';
    userData.value.email='';
    userData.value.dailytasks=<DailyTask>[].obs;
    userData.value.priorityTasks=<Task>[].obs;
    update();

  }

}

