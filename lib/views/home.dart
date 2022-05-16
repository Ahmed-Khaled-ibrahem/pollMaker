import 'dart:async';
import 'dart:math';
import 'package:final_project_course/control/classes.dart';
import 'package:final_project_course/control/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../control/funcions.dart';
import '../control/layout.dart';
import 'add_new_poll.dart';
import 'history.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen( {Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<PollData> pollDataList = List.generate(0, (index) => PollData(
      question: '',
      answerType: '',
      owner: '',
      ownerName: '',
      id: '',
  ));

  int hiddenCardItems = 0;
  @override
  void initState() {
    super.initState();
    hiddenCardItems = 0;

    databaseReference.child('Polls').once().then((event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.value != null) {
        Map userRealTime = dataSnapshot.value as Map;
        pollDataList.clear();
        userRealTime.forEach((key, value) {
          Map pollMap = value as Map;
          pollDataList.add(
              PollData(
                  question: pollMap['question'],
                  answerType: pollMap['answerType'],
                  owner: pollMap['owner'],
                  ownerName: pollMap['ownerName'],
                  active: pollMap['active'],
                  id: key,
                  answers: List.from(pollMap['answers']),
                  voting:  List.from(pollMap['voting']),
                  voters: List.from(pollMap['voters'])
              ));
          setState(() {

          });
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    hiddenCardItems = 0;
    return WillPopScope(
      onWillPop: () => exitDialog(context),
      child: defualtPageDesign(
        title: 'Poll Maker',
        actions: [
          IconButton(
              onPressed: () {
                pushPage(context,  HistoryScreen(pollDataList));
              },
              icon: const Icon(Icons.history)),
          IconButton(
              onPressed: () {
                writeRememberMe(false);
                pushReplacementPage(context, LoginScreen());
              },
              icon: const Icon(Icons.logout)),
        ],
        actionButton: FloatingActionButton(
          onPressed: () {
            pushPage(context, AddPollScreen());
          },
          backgroundColor: orange,
          child: Icon(
            Icons.add,
            color: white,
            size: 30,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 180,
              child: SmartRefresher(
                onRefresh: () async {

                    databaseReference.child('Users').child(userData.uid).once().then((event) {
                      final dataSnapshot = event.snapshot;
                      if (dataSnapshot.value != null) {
                        Map userRealTime = dataSnapshot.value as Map;

                        userData = UserData(
                            name: userRealTime['FullName'],
                            email: userRealTime['Email'],
                            uid: userData.uid,
                            balance: userRealTime['Balance'],
                            experience: userRealTime["Experience"],
                            score:  userRealTime['Score'] ,
                            ownerPolls: List<String>.from(userRealTime['ownerPolls']),
                            votedPolls: List<String>.from(userRealTime['votedPolls'])
                        );
                        userData.printAllData();
                        _refreshController.refreshCompleted();
                        setState(() {
                        });
                      }
                    });

                    databaseReference.child('Polls').once().then((event) {
                      final dataSnapshot = event.snapshot;
                      if (dataSnapshot.value != null) {
                        Map userRealTime = dataSnapshot.value as Map;
                        pollDataList.clear();

                       userRealTime.forEach((key, value) {
                         Map pollMap = value as Map;
                         pollDataList.add(
                             PollData(
                             question: pollMap['question'],
                             answerType: pollMap['answerType'],
                             owner: pollMap['owner'],
                             ownerName: pollMap['ownerName'],
                             active: pollMap['active'],
                             id: key,
                             answers: List.from(pollMap['answers']),
                             voting:  List.from(pollMap['voting']),
                               voters: List.from(pollMap['voters'])
                         ));
                       });
                        _refreshController.refreshCompleted();
                        setState(() {
                        });
                      }
                    });

                },
                controller: _refreshController,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            dialog(context, 'Balance', const balanceCard(300));
                          },
                          child: Column(
                            children:  [
                              const Icon(Icons.money),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text('Balance'),
                              Text(
                                userData.balance+'\$',
                                //'kty',
                                style: const TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.w200),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            dialog(context, 'Score', const ScoreCard());
                          },
                          child: Column(
                            children:  [
                              const Icon(Icons.sports_score),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text('Score'),
                               Text(
                                userData.score,
                                style: const TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.w200),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            dialog(context, 'Experience', const ExperianceCard());
                          },
                          child: Column(
                            children:  [
                              const Icon(Icons.local_fire_department_sharp),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text("Experience"),
                               Text(
                                userData.experience,
                                style: const TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.w200),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Text('      Hi, ' + userData.name,style: const TextStyle(fontSize: 18),),
                    const Padding(
                      padding: EdgeInsets.only(right: 20, left: 20),
                      child: Divider(height: 10),
                    ),
                    Text('       '+userData.email,style: const TextStyle(fontSize: 15),),
                  ],
                ),
              ),
            ),
            Expanded(
              child: pollDataList.isEmpty? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset('assets/lottie/question.json', height: 150,width: 150,),
                  const Text('There is no questions in current time',style: TextStyle(fontSize: 18),),
                ],
              ):Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView.separated(
                    primary: true,
                    itemCount: pollDataList.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext ctx, int index) {
                      if( pollDataList[index].voters!.contains(userData.uid) ){
                        hiddenCardItems++;
                        if(hiddenCardItems == pollDataList.length){
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Lottie.asset('assets/lottie/question.json', height: 150,width: 150,),
                              const Text('You answered on all questions',style: TextStyle(fontSize: 18),),
                            ],
                          );
                        }
                        return Container();
                      }
                      return CardDesign(pollDataList,index);
                    },
                    separatorBuilder: (_, __) {
                      return const SizedBox(
                        height: 10,
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  writeRememberMe(val) async {
    final prefs = await SharedPreferences.getInstance(); //remove
    await prefs.setBool('rememberMe', val);
  }

  Future<bool> exitDialog(BuildContext context,
      {title, content, yes, no}) async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title ?? 'Are you Sure'),
            content: Text(content ?? 'you want Exit ?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(no ?? 'No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  yes ?? 'Yes',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }
}

class CardDesign extends StatefulWidget {
  CardDesign( List<PollData> this.pollDataList, int this.index, {Key? key}) : super(key: key);

  var random = Random();
  late Color color = cardColors[random.nextInt(cardColors.length)];
  List<PollData> pollDataList;
  int index;


  @override
  _CardDesignState createState() => _CardDesignState();
}

class _CardDesignState extends State<CardDesign> {

  bool done = false;
  int c = -1;

  @override
  Widget build(BuildContext context) {
    c = -1;
    return Card(
      elevation: 3,
      shadowColor: widget.color,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(35),
          bottomLeft: Radius.circular(35),
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      color: white,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.pollDataList[widget.index].question,
              style: TextStyle(
                  fontSize: 22,
                  color: widget.color,
                  fontWeight: FontWeight.w400),
            ),
             Text(
              'Owner : '+ widget.pollDataList[widget.index].ownerName,
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black45,
                  fontWeight: FontWeight.w900),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: double.infinity,
              child: widget.pollDataList[widget.index].answerType == 'MCQ'? AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder:
                    (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: done?  Center(child: Icon(Icons.done_outline_outlined,size: 40,color: black,),): Wrap(
                  spacing: 20,
                  alignment: WrapAlignment.center,
                  children: List.generate(widget.pollDataList[widget.index].answers!.length, (index) => ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(widget.color)),
                    onPressed: () {
                      widget.pollDataList[widget.index].voters?.add(userData.uid);
                      widget.pollDataList[widget.index].voting?[index] = (int.parse(widget.pollDataList[widget.index].voting![index]) + 1 ).toString();
                      databaseReference.child("Polls").child(widget.pollDataList[widget.index].id).update({
                        'voters': widget.pollDataList[widget.index].voters,
                        'voting': widget.pollDataList[widget.index].voting,
                      });

                      databaseReference.child("Users").child(userData.uid).update({
                        'Score': (int.parse(userData.score)+10).toString(),
                        'Experience': (int.parse(userData.experience)+1).toString(),
                      });
                      setState(() {
                        done = true;
                      });
                    },
                    child:  Text(widget.pollDataList[widget.index].answers![index]))
                )),
              ):
               AnimatedSwitcher(
                 duration: const Duration(milliseconds: 200),
                 transitionBuilder:
                     (Widget child, Animation<double> animation) {
                   return ScaleTransition(scale: animation, child: child);
                 },
                 child: done?  Center(child: Icon(Icons.done_outline_outlined,size: 40,color: black,),):Wrap(
                  spacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(widget.color)),
                        onPressed: () {
                          widget.pollDataList[widget.index].voters?.add(userData.uid);
                          widget.pollDataList[widget.index].voting?[1] = (int.parse(widget.pollDataList[widget.index].voting![1]) + 1 ).toString();

                          databaseReference.child("Polls").child(widget.pollDataList[widget.index].id).update({
                            'voters': widget.pollDataList[widget.index].voters,
                            'voting': widget.pollDataList[widget.index].voting,
                          });
                          setState(() {
                            done = true;
                          });
                        },
                        child: const Text('Yes')),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(widget.color)),

                        onPressed: () {
                          widget.pollDataList[widget.index].voters?.add(userData.uid);
                          widget.pollDataList[widget.index].voting?[0] = (int.parse(widget.pollDataList[widget.index].voting![0]) + 1 ).toString();
                          databaseReference.child("Polls").child(widget.pollDataList[widget.index].id).update({
                            'voters': widget.pollDataList[widget.index].voters,
                            'voting': widget.pollDataList[widget.index].voting,
                          });
                          setState(() {
                            done = true;
                          });

                        },
                        child: const Text('No')),
                  ],
              ),
               ),
            ),
          ],
        ),
      ),
    );
  }
}


class ExperianceCard extends StatelessWidget {
  const ExperianceCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Lottie.asset(
              'assets/lottie/experiance.json',
              width: 200,repeat: false
          ),
          const SizedBox(height: 20,),
          const Text(
            'Your experience increases the more questions you answer, so be careful to answer correctly and impartially'
              ,textAlign: TextAlign.center,style: TextStyle(fontSize: 20),),
        ],
      ),
    );
  }
}

class ScoreCard extends StatelessWidget {
  const ScoreCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Lottie.asset(
              'assets/lottie/score.json',
              width: 200,repeat: false
          ),
          const SizedBox(height: 30,),
          const Text(
            'Answer the questions often so that the amount of your collection of points increases \nyou can use them instead of money to create polls'
            , textAlign: TextAlign.center,style: TextStyle(fontSize: 20),),
        ],
      ),
    );
  }
}

class balanceCard extends StatelessWidget {
  const balanceCard(this.balance,{Key? key}) : super(key: key);

  final balance;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Lottie.asset(
            'assets/lottie/balance.json',
            width: 200
          ),

          const Text(
              'Now Easily you can add money to your account using virtual balance pocket'
          , textAlign: TextAlign.center,style: TextStyle(fontSize: 25),),
          const Text('\nTap on charge to add 10\$ to your account',style: TextStyle(fontSize: 20),),
          const SizedBox(height: 30,),
          TextButton(
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(const Size(100,100)),
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  shape: MaterialStateProperty.all(const CircleBorder())),
              onPressed: (){
                Navigator.pop(context);
                EasyLoading.showSuccess('10\$ added successfully to your account\n\nRefresh to see updates');

                userData.balance = (int.parse(userData.balance) + 10).toString();

                databaseReference.child("Users").child(userData.uid).update({
                  'Balance': userData.balance,
                });

          }, child: const Text('Charge',style: TextStyle(fontSize: 25,color: Colors.white),))
        ],
      ),
    );
  }
}
