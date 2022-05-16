import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

class UserData {
  UserData({
    required this.name,
    required this.email,
    required this.uid,
    //required this.password,
    this.score = '0',
    this.experience = '0',
    this.balance = '0',
    this.votedPolls,
    this.ownerPolls,
  });

  String name;
  String email;
  String uid;

  //String password;
  String score;
  String experience;
  String balance;
  List<String>? votedPolls;
  List<String>? ownerPolls;

  void printAllData(){
    print("name : " +name);
    print("Email : " +email);
    print("Uid : " +uid);
    print("Score : " + score);
    print("Exp : " +experience);
    print("balance : " +balance);
    print("voted polls : " + votedPolls.toString());
    print("ownerPolls : " +ownerPolls.toString());
  }
}

class PollData {
  PollData({
    required this.question,
    required this.answerType,
    required this.id,
    required this.owner,
    required this.ownerName,
    this.answers,
    this.voting,
    this.voters,
    this.active = true,
  });

  String question;
  String answerType; // yesOrNo , MCQ
  String id;
  List<String>? answers;
  String owner;
  String ownerName;
  bool active;
  List<String>? voting;
  List<String>? voters;
}



class InputField extends StatelessWidget {
  String headerText;
  String hintTexti;
  TextEditingController controller;
  Widget icon;

  InputField(
      {Key? key,
      required this.headerText,
      required this.hintTexti,
      required this.controller,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 10,
          ),
          child: Text(
            headerText,
            style: TextStyle(
                color: black, fontSize: 22, fontWeight: FontWeight.w500),
          ),
        ),
        Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              color: teal.withOpacity(0.2),
              // border: Border.all(
              //   width: 1,
              // ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: controller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Text cannot be empty';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: hintTexti, border: InputBorder.none, icon: icon),
              ),
            )),
      ],
    );
  }
}

class InputFieldPassword extends StatefulWidget {
  String headerText;
  String hintTexti;
  TextEditingController controller;


  InputFieldPassword(
      {Key? key,
      required this.headerText,
      required this.hintTexti,
      required this.controller})
      : super(key: key);

  @override
  State<InputFieldPassword> createState() => _InputFieldPasswordState();
}

class _InputFieldPasswordState extends State<InputFieldPassword> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 10,
          ),
          child: Text(
            widget.headerText,
            style: TextStyle(
                color: black, fontSize: 22, fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
            color: teal.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
              onChanged: (val) {
                setState(() {
              });},
              controller: widget.controller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password';
                }
                return null;
              },
              obscureText: _visible,
              decoration: InputDecoration(
                icon: const Icon(Icons.password),
                hintText: widget.hintTexti,
                border: InputBorder.none,
                suffixIcon: IconButton(
                    icon: Icon(
                        _visible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _visible = !_visible;
                      });
                    }),
                counterText: 'Password length :  '+widget.controller.text.length.toString(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
