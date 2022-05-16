import 'package:final_project_course/views/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'control/classes.dart';
import 'control/constants.dart';
import 'control/funcions.dart';
import 'views/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  final bool rememberMe = prefs.getBool('rememberMe') ?? false;
  final String uid = prefs.getString('uid') ?? "none";
  bool login  = true;

  if(uid != 'none' && rememberMe){
      databaseReference.child('Users').child(uid).once().then((event) {
        final dataSnapshot = event.snapshot;
        if (dataSnapshot.value != null) {
          Map userRealTime = dataSnapshot.value as Map;

          userData = UserData(
              name: userRealTime['FullName'],
              email: userRealTime['Email'],
              uid: uid,
              balance: userRealTime['Balance'],
              experience: userRealTime["Experience"],
              score:  userRealTime['Score'] ,
              ownerPolls: List<String>.from(userRealTime['ownerPolls']),
              votedPolls: List<String>.from(userRealTime['votedPolls'])
          );
          userData.printAllData();
          login = false;
          runApp( MyApp(login) );
        }
      });
  }
  else{
    runApp( MyApp(login) );
  }

  EasyLoading.instance
    ..displayDuration = const Duration(seconds: 3)
    ..indicatorType = EasyLoadingIndicatorType.dualRing
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = orange
    ..backgroundColor = black.withOpacity(0.6)
    ..indicatorColor = orange
    ..textColor = orange
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;

  // EasyLoading.show(status: 'loading...');
  // EasyLoading.showProgress(0.3, status: 'downloading...');
  // EasyLoading.showSuccess('Great Success!');
  // EasyLoading.showError('Failed with Error');
  // EasyLoading.showInfo('Useful Information.');
  // EasyLoading.showToast('Toast');
  // EasyLoading.dismiss();

  SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(
    //systemNavigationBarColor: blue, // navigation bar color
    statusBarColor: black, // status bar color
  ));
}

class MyApp extends StatelessWidget {
   MyApp(this.rememberMe,{Key? key}) : super(key: key);

  final bool rememberMe;

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      title: 'Poll Maker',
      home:   rememberMe?   LoginScreen() : const HomeScreen(),
    );
  }

}

// snack bar
// ScaffoldMessenger.of(context).showSnackBar(
// const SnackBar(content: Text('Processing Data')),
// );

// databaseReference.child('polls').remove();
