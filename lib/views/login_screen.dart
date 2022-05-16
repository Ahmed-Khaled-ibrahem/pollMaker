import 'dart:async';
import 'package:final_project_course/views/signup.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../control/classes.dart';
import '../control/constants.dart';
import '../control/funcions.dart';
import '../control/layout.dart';
import 'forget_password.dart';
import 'home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';


GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
TextEditingController userNameController = TextEditingController();
TextEditingController passWordController = TextEditingController();
late UserData userData;
final databaseReference = FirebaseDatabase.instance.ref();


class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late FirebaseAuth auth;
  late FirebaseFunctions functions;
  bool isCheck = false;

  Future<void> signIn(username, password) async {
    await auth
        .signInWithEmailAndPassword(email: username, password: password)
        .catchError((e) {
      EasyLoading.showError(e.toString().substring(e.toString().indexOf(' ')));
    });

    print('Firebase signed in');
    readUserdata();
  }

  void readUserdata() {
    databaseReference
        .child('Users')
        .child(auth.currentUser?.uid ?? "none")
        .once()
        .then((event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.value != null) {
        Map userRealTime = dataSnapshot.value as Map;

        userData = UserData(
            name: userRealTime['FullName'],
            email: userRealTime['Email'],
            uid: auth.currentUser?.uid ?? 'none',
            balance: userRealTime['Balance'],
            experience: userRealTime["Experience"],
            score: userRealTime['Score'],
            ownerPolls: List<String>.from(userRealTime['ownerPolls']),
            votedPolls: List<String>.from(userRealTime['votedPolls']));
        userData.printAllData();

        EasyLoading.dismiss();

        writeRememberMe(isCheck);
        writeUid(userData.uid);

        pushReplacementPage(context, const HomeScreen());
      }
    });
  }

  writeRememberMe(val) async {
    final prefs = await SharedPreferences.getInstance(); //remove
    await prefs.setBool('rememberMe', val);
  }

  writeUid(val) async {
    final prefs = await SharedPreferences.getInstance(); //remove
    await prefs.setString('uid', val);
  }

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    functions = FirebaseFunctions.instance;
  }

  @override
  Widget build(BuildContext context) {
    return defualtPageDesign(
      title: 'Poll Maker',
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: Form(
            key: loginFormKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Image.asset(
                    "assets/images/poll_icon.png",
                    width: 120,
                  ),
                )),
                Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                        fontSize: 30,
                        color: black,
                        fontWeight: FontWeight.bold),
                  ),
                )),
                InputField(
                  headerText: "Email",
                  hintTexti: "enter your email",
                  controller: userNameController,
                  icon: const Icon(Icons.email),
                ),
                const SizedBox(
                  height: 10,
                ),
                InputFieldPassword(
                  headerText: "Password",
                  hintTexti: "At least 8 Charecter",
                  controller: passWordController,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                              value: isCheck,
                              checkColor: whiteshade, // color of tick Mark
                              activeColor: blue,
                              onChanged: (val) {
                                setState(() {
                                  isCheck = val!;
                                });
                              }),
                          Text.rich(
                            TextSpan(
                              text: "Remember me",
                              style: TextStyle(
                                  color: grayshade.withOpacity(0.8),
                                  fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 20),
                      child: InkWell(
                        onTap: () {
                          pushPage(context,const ForgetPassScreen());
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                              color: blue.withOpacity(0.7),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    if (loginFormKey.currentState!.validate()) {
                      EasyLoading.show(status: 'Singing...');
                      signIn(userNameController.text.trim(),
                              passWordController.text)
                          .onError((error, stackTrace) => null);
                    }
                    print("Sign in clicked");
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.07,
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                        color: blue,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Center(
                      child: Text(
                        "Sign in",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: whiteshade),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Don't already Have an account?",
                        style: TextStyle(color: blue, fontSize: 16),
                      ),
                      TextButton(
                          onPressed: () {
                            pushPage(context, SignUp());
                          },
                          child: const Text('Sign Up')),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
