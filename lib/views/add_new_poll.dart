import 'package:final_project_course/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../control/classes.dart';
import '../control/constants.dart';
import '../control/layout.dart';

GlobalKey<FormState> addPollFormKey = GlobalKey<FormState>();


class AddPollScreen extends StatefulWidget {
  AddPollScreen({Key? key}) : super(key: key);

  TextEditingController questionController = TextEditingController();
  List<TextEditingController> answerControllers =
      List.generate(4, (index) => TextEditingController());
  int answerType = 0;
  int payType = 0;

  @override
  _AddPollScreenState createState() => _AddPollScreenState();
}

class _AddPollScreenState extends State<AddPollScreen> {
  @override
  Widget build(BuildContext context) {
    return defualtPageDesign(
      title: 'Add Poll',
      navigation: TextButton(
          onPressed: () {
            if(widget.payType == 0 && int.parse(userData.balance)<10){
              EasyLoading.showInfo('not enough money on your balance');
              return;
            }
            if(widget.payType == 1 && int.parse(userData.score)<100){
              EasyLoading.showInfo('not enough Points on your account');
              return;
            }
            if (addPollFormKey.currentState!.validate()) {
              PollData pollData = PollData(
                question: widget.questionController.text,
                answerType: widget.answerType == 0 ? 'yesOrNo' : 'MCQ',
                owner: userData.uid,
                ownerName: userData.name,
                active: true,
                id: DateTime.now().millisecondsSinceEpoch.toString() + userData.uid.substring(1,7),
                answers: List.generate(
                    widget.answerType == 0 ? 2 : widget.answerControllers.length
                    , (index) => widget.answerControllers[index].text),
                voting: List.filled( widget.answerType == 0 ? 2 : widget.answerControllers.length, '0'),
                voters: ['none']
              );

              if(widget.payType == 0){
                databaseReference.child("Users").child(userData.uid).update({
                  'Balance': (int.parse(userData.balance)-10).toString(),
                });
              }
              else{
                databaseReference.child("Users").child(userData.uid).update({
                  'Score': (int.parse(userData.score)-100).toString(),
                });
              }

              EasyLoading.show(status: 'Creating new poll ...');
              databaseReference.child("Polls").child(pollData.id).set({
                'question': pollData.question,
                'answerType': pollData.answerType,
                'owner': pollData.owner,
                'active': pollData.active,
                'answers': pollData.answers,
                'voting': pollData.voting,
                'ownerName': pollData.ownerName,
                'voters': pollData.voters
              });
              EasyLoading.dismiss();
              Navigator.pop(context);
              EasyLoading.showSuccess('the new poll added successfully');
            }

          },
          style: ButtonStyle(foregroundColor: MaterialStateProperty.all(orange)
              // elevation: MaterialStateProperty.all(0),
              //fixedSize: MaterialStateProperty.all(const Size(180, 40)),
              //backgroundColor: MaterialStateProperty.all(orange)
              ),
          child: const Text(
            'Publish',
            style: TextStyle(
              fontSize: 16,
            ),
          )),
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: Form(
            key: addPollFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                InputField(
                  headerText: "Question",
                  hintTexti: "Question",
                  controller: widget.questionController,
                  icon: const Icon(Icons.question_mark),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: const [
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Answer Type',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: ToggleSwitch(
                    minWidth: 150.0,
                    cornerRadius: 20.0,
                    activeBgColors: [
                      [teal],
                      [teal]
                    ],
                    activeFgColor: white,
                    inactiveBgColor: grayshade,
                    inactiveFgColor: white,
                    initialLabelIndex: widget.answerType,
                    totalSwitches: 2,
                    labels: const ['Yes or No Question', 'MCQ'],
                    radiusStyle: true,
                    onToggle: (index) {
                      setState(() {
                        widget.answerType = index ?? 0;
                      });

                      print('switched to: $index');
                    },
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: widget.answerType == 0
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Card(
                              color: Colors.green,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text('The answers now is Just Yes or No',
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: white,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center),
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            children: [
                              ListView.separated(
                                separatorBuilder: (_, __) {
                                  return const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Divider(
                                      thickness: 2,
                                    ),
                                  );
                                },
                                primary: false,
                                shrinkWrap: true,
                                itemCount: widget.answerControllers.length,
                                itemBuilder: (ctx, index) {
                                  return Column(
                                    children: [
                                      InputField(
                                        headerText: "Answer ${index + 1}",
                                        hintTexti: "Answer ${index + 1}",
                                        controller:
                                            widget.answerControllers[index],
                                        icon: const Icon(Icons.question_answer),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                        style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                                const CircleBorder()),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    orange)),
                                        onPressed: () {
                                          setState(() {
                                            if (widget
                                                    .answerControllers.length !=
                                                2) {
                                              widget.answerControllers
                                                  .removeLast();
                                            } else {
                                              EasyLoading.showToast(
                                                  "can't be less than two");
                                            }
                                          });
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.remove,
                                            size: 30,
                                          ),
                                        )),
                                    ElevatedButton(
                                        style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                                const CircleBorder()),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.green)),
                                        onPressed: () {
                                          setState(() {
                                            if (widget
                                                    .answerControllers.length !=
                                                6) {
                                              widget.answerControllers
                                                  .add(TextEditingController());
                                            } else {
                                              EasyLoading.showToast(
                                                  "Upgrade to premium if you want more than 10 answers");
                                            }
                                          });
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.add,
                                            size: 30,
                                          ),
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                ),
                Center(
                  child: ToggleSwitch(
                    minWidth: 150.0,
                    cornerRadius: 20.0,
                    activeBgColors: [
                      [teal],
                      [teal]
                    ],
                    activeFgColor: white,
                    inactiveBgColor: grayshade,
                    inactiveFgColor: white,
                    initialLabelIndex: widget.payType,
                    totalSwitches: 2,
                    labels: const ['Balance', 'Points'],
                    radiusStyle: true,
                    onToggle: (index) {
                      setState(() {
                        widget.payType = index ?? 0;
                      });
                      print('switched to: $index');
                    },
                  ),
                ),
                AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: widget.payType == 0
                        ? Center(
                            key: const Key('center1'),
                            child: Padding(
                              padding: const EdgeInsets.all(30),
                              child: Text(
                                  'Your balance is ' +
                                      userData.balance +
                                      '\$ \n10\$ is needed ',
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: black,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                            ),
                          )
                        : Center(
                            key: const Key('center2'),
                            child: Padding(
                              padding: const EdgeInsets.all(30),
                              child: Text(
                                  'Your Points is ' +
                                      userData.score +
                                      '\$ \n100 point is needed ',
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: black,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                            ),
                          )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
