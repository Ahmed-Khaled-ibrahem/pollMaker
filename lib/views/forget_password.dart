import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';
import '../control/classes.dart';
import '../control/constants.dart';
import '../control/layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';


GlobalKey<FormState> forgetPassFormKey = GlobalKey<FormState>();
TextEditingController emailController = TextEditingController();
final databaseReference = FirebaseDatabase.instance.ref();


class ForgetPassScreen extends StatefulWidget {
  const ForgetPassScreen({Key? key}) : super(key: key);

  @override
  _ForgetPassScreenState createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  late FirebaseAuth auth;

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
  }

  Future<void> sendReset(email) async {
    await auth.sendPasswordResetEmail(email: email).catchError((e){
      EasyLoading.showError(e.toString().substring(e.toString().indexOf(' ')));
      return;
    });

  }

  @override
  Widget build(BuildContext context) {
    return defualtPageDesign(
      title: 'Reset Password',
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: Form(
            key: forgetPassFormKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Lottie.asset('assets/lottie/password.json',width: 200)
                    )),
                InputField(
                  headerText: "Email",
                  hintTexti: "Enter your email",
                  controller: emailController,
                  icon: const Icon(Icons.email),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    if (forgetPassFormKey.currentState!.validate()) {
                      EasyLoading.show(status: 'Checking...');
                      sendReset(emailController.text.trim()).onError((error, stackTrace) => '');
                    }
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
                        "Send Reset",
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




