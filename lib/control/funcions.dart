import 'package:final_project_course/control/constants.dart';
import 'package:flutter/material.dart';

void pushPage(BuildContext ctx, Widget page){
  Navigator.push(
      ctx,
      MaterialPageRoute(
          builder: (context) => page));
}
void pushReplacementPage(BuildContext ctx, Widget page){
  Navigator.pushReplacement(
      ctx,
      MaterialPageRoute(
          builder: (context) => page));
}


void dialog(BuildContext context,String title,Widget content){
  showDialog(
      context: context,
      barrierColor: black.withOpacity(0.5),
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar:  TextButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(blue.withOpacity(0.2))),
              onPressed: (){
            Navigator.pop(context);
          }, child:  Text('Ok',style: TextStyle(color: orange,fontSize: 22),)),
          body: content,
        ),
      )
  );
}
