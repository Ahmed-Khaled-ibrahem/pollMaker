import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../control/classes.dart';
import '../control/constants.dart';
import '../control/funcions.dart';
import '../control/layout.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../control/lorem_text_privacy_policy.dart';

GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late FirebaseAuth auth;
  late FirebaseFunctions functions;
  final databaseReference = FirebaseDatabase.instance.ref();
  bool isCheck = false;

  late UserData userData;

  Future<void> createAccount(email, password) async {
    await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .catchError((e) {
      print(e.toString());
      EasyLoading.showError(e.toString().substring(e.toString().indexOf(' ')));
    });

    print('Firebase account created');

    userData = UserData(
        email: email,
        name: fullNameController.text.trim(),
        uid: auth.currentUser?.uid.toString() ?? "null Uid");

    databaseReference.child("Users").child(userData.uid).set({
      'FullName': userData.name,
      'Email': userData.email,
      'Score': '0',
      'Experience': '0',
      'Balance': '0',
      'votedPolls': ['none'],
      'ownerPolls': ['none'],
    });


    EasyLoading.dismiss();

    Navigator.pop(context);
    EasyLoading.showSuccess('the Account is created successfully');
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
      title: "Sign Up",
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: Form(
            key: signupFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
                InputField(
                    headerText: "Fullname",
                    hintTexti: "Fullname",
                    controller: fullNameController,
                  icon: const Icon(Icons.person),
                ),
                const SizedBox(
                  height: 10,
                ),
                InputField(
                  headerText: "Email",
                  hintTexti: "name@example.com",
                  controller: emailController,
                  icon: const Icon(Icons.email),
                ),
                const SizedBox(
                  height: 10,
                ),
                InputFieldPassword(
                  headerText: "Password",
                  hintTexti: "At least 6 Charecter",
                  controller: passwordController,
                ),
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
                      Row(
                        children:  [
                          Text('I agree with', style: TextStyle(color: black,
                              fontSize: 16),),
                          TextButton(
                            style: ButtonStyle(foregroundColor: MaterialStateProperty.all(blue)),
                            onPressed: (){
                              dialog(context,'Terms and policy',
                                  const SingleChildScrollView(
                                    child: Text(privacyAndPolicy,style: TextStyle(fontSize: 12),),
                                  )
                              );
                            },
                            child: const Text('Terms and Policy'),)

                        ],
                      ),

                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    if (signupFormKey.currentState!.validate()) {
                      if (isCheck) {
                        EasyLoading.show(status: 'Creating account...');
                        createAccount(emailController.text.trim(),
                            passwordController.text)
                            .onError((error, stackTrace) => null);
                      }
                      else {
                        EasyLoading.showInfo(
                            'you should agree with terms and policy');
                      }
                    }
                  },
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.07,
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                        color: blue,
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10))),
                    child: Center(
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: whiteshade),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
